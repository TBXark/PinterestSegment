//
//  PinterestSegmentTests.swift
//  PinterestSegmentTests
//

import XCTest

@testable import PinterestSegment

/// Records `sendActions` calls. Target-action dispatch itself goes through
/// `UIApplication`, which does not exist in SwiftPM's test runner, so the
/// tests observe the calls the control makes instead of their delivery.
private final class SendActionRecordingSegment: PinterestSegment {
    var recordedEvents: [UIControl.Event] = []

    override func sendActions(for controlEvents: UIControl.Event) {
        recordedEvents.append(controlEvents)
        super.sendActions(for: controlEvents)
    }
}

final class PinterestSegmentTests: XCTestCase {

    private func makeSegment(titles: [String] = ["A", "B", "C"]) -> SendActionRecordingSegment {
        SendActionRecordingSegment(frame: CGRect(x: 0, y: 0, width: 320, height: 40), titles: titles)
    }

    private func makeImage(_ color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 8, height: 8))
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 8, height: 8))
        }
    }

    // MARK: - Selection events (issue #19: no event on init / reload)

    func testInitAndReloadDoNotSendValueChange() {
        let segment = makeSegment()
        var callbackCount = 0
        segment.valueChange = { _ in callbackCount += 1 }

        segment.titles = ["X", "Y", "Z"]
        segment.reloadData()
        segment.style = PinterestSegmentStyle()

        XCTAssertEqual(callbackCount, 0)
        XCTAssertEqual(segment.recordedEvents, [])
        XCTAssertEqual(segment.selectIndex, 0)
    }

    func testSetSelectIndexSendsValueChange() {
        let segment = makeSegment()
        var received: Int?
        segment.valueChange = { received = $0 }

        segment.setSelectIndex(index: 2, animated: false)

        XCTAssertEqual(segment.selectIndex, 2)
        XCTAssertEqual(received, 2)
        XCTAssertEqual(segment.recordedEvents, [.valueChanged])
    }

    func testSettingSameIndexDoesNotSendValueChange() {
        let segment = makeSegment()
        var callbackCount = 0
        segment.valueChange = { _ in callbackCount += 1 }

        segment.setSelectIndex(index: 0, animated: false)

        XCTAssertEqual(callbackCount, 0)
        XCTAssertEqual(segment.recordedEvents, [])
    }

    func testSetSelectIndexIgnoresOutOfRangeIndex() {
        let segment = makeSegment()

        segment.setSelectIndex(index: 7, animated: false)

        XCTAssertEqual(segment.selectIndex, 0)
    }

    // MARK: - Style property passthrough (issue: normalBorderColor getter used
    // to return selectedBorderColor)

    func testNormalBorderColorRoundTrip() {
        let segment = makeSegment()
        segment.normalBorderColor = .red
        XCTAssertEqual(segment.normalBorderColor, .red)
        segment.selectedBorderColor = .blue
        XCTAssertEqual(segment.selectedBorderColor, .blue)
        XCTAssertEqual(segment.normalBorderColor, .red)
    }

    func testIBInspectableMinimumWidthRoundTrip() {
        let segment = makeSegment()
        segment.minimumWidth = 50
        XCTAssertEqual(segment.minimumWidth, 50)
        XCTAssertEqual(segment.style.minimumWidth, 50)
        segment.minimumWidth = 0
        XCTAssertNil(segment.style.minimumWidth)
    }

    // MARK: - TitleElement equality (normalImage used to be compared
    // against selectedImage)

    func testTitleElementEquality() {
        let imageA = makeImage(.red)
        let imageB = makeImage(.blue)

        let lhs = PinterestSegment.TitleElement(title: "T", selectedImage: imageA, normalImage: imageB)
        let rhs = PinterestSegment.TitleElement(title: "T", selectedImage: imageA, normalImage: imageB)
        XCTAssertEqual(lhs, rhs)

        let swapped = PinterestSegment.TitleElement(title: "T", selectedImage: imageB, normalImage: imageA)
        XCTAssertNotEqual(lhs, swapped)

        let otherTitle = PinterestSegment.TitleElement(title: "U", selectedImage: imageA, normalImage: imageB)
        XCTAssertNotEqual(lhs, otherTitle)
    }

    // MARK: - Layout

    func testLayoutBuildsLabelsAndIndicator() {
        let segment = makeSegment(titles: ["Everything", "Geek", "Humor"])

        let scrollView = segment.subviews.compactMap { $0 as? UIScrollView }.first
        XCTAssertNotNil(scrollView)

        let labels = scrollView?.subviews.compactMap { $0 as? UILabel } ?? []
        XCTAssertEqual(labels.count, 3, "every title should exist in the normal and the selected row")

        let nonLabelViews = scrollView?.subviews.filter { !($0 is UILabel) } ?? []
        XCTAssertGreaterThanOrEqual(nonLabelViews.count, 2, "indicator and masked select content should be installed")
    }

    func testStyleAssignmentReloadsLabels() {
        let segment = makeSegment()
        var style = PinterestSegmentStyle()
        style.titleFont = UIFont.systemFont(ofSize: 20)
        segment.style = style

        let scrollView = segment.subviews.compactMap { $0 as? UIScrollView }.first
        let labels = scrollView?.subviews.compactMap { $0 as? UILabel } ?? []
        XCTAssertEqual(labels.first?.font, style.titleFont)
    }

    func testTitlesSetterPreservesSelection() {
        let segment = makeSegment()
        segment.setSelectIndex(index: 2, animated: false)
        segment.titles = ["X", "Y", "Z"]
        XCTAssertEqual(segment.selectIndex, 2)
        XCTAssertEqual(segment.titleElements.map { $0.title }, ["X", "Y", "Z"])
    }

    func testSetRichTextTitlesReplacesTitles() {
        let segment = makeSegment()
        let elements = [
            PinterestSegment.TitleElement(title: "One", selectedImage: makeImage(.red), normalImage: makeImage(.blue)),
            PinterestSegment.TitleElement(title: "Two"),
        ]

        segment.setRichTextTitles(elements)

        XCTAssertEqual(segment.titles, ["One", "Two"])
    }

    // MARK: - Label icon attachment

    func testAddToLeftPrependsAttachment() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.text = "Hello"
        label.addToLeft(image: makeImage(.red))

        let attributed = label.attributedText
        XCTAssertNotNil(attributed)
        XCTAssertTrue(attributed?.string.contains("Hello") ?? false)

        var hasAttachment = false
        attributed?.enumerateAttributes(in: NSRange(location: 0, length: attributed?.length ?? 0)) { attributes, _, _ in
            if attributes[.attachment] != nil {
                hasAttachment = true
            }
        }
        XCTAssertTrue(hasAttachment, "the icon should be attached in front of the text")
    }
}
