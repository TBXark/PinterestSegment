//
//  UIKitDemoViewController.swift
//  PinterestSegmentDemo
//

import PinterestSegment
import UIKit

final class UIKitDemoViewController: UIViewController {

    private let statusLabel = UILabel()

    private let defaultSegment = PinterestSegment(frame: .zero)
    private let iconSegment = PinterestSegment(frame: .zero)
    private let customSegment = PinterestSegment(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "PinterestSegment"
        view.backgroundColor = .systemBackground

        configureSegments()
        configureLayout()
    }

    private func configureSegments() {
        var plainStyle = PinterestSegmentStyle()
        plainStyle.titleFont = .systemFont(ofSize: 14, weight: .semibold)

        defaultSegment.style = plainStyle
        defaultSegment.titles = DemoData.titles
        defaultSegment.valueChange = { [weak self] index in
            self?.log("Default -> \(index)")
        }

        iconSegment.style = plainStyle
        iconSegment.setRichTextTitles(zip(DemoData.iconTitles, DemoData.iconSymbolNames).map(iconTitleElement))
        iconSegment.valueChange = { [weak self] index in
            self?.log("Icon -> \(index)")
        }

        var customStyle = PinterestSegmentStyle()
        customStyle.titleFont = .systemFont(ofSize: 14, weight: .bold)
        customStyle.indicatorColor = .systemBlue
        customStyle.normalTitleColor = .systemGray
        customStyle.selectedTitleColor = .white
        customStyle.selectedBorderColor = .systemBlue
        customStyle.minimumWidth = 64

        customSegment.style = customStyle
        customSegment.titles = ["New", "Popular", "Following"]
        customSegment.valueChange = { [weak self] index in
            self?.log("Custom -> \(index)")
        }
    }

    private func iconTitleElement(title: String, symbolName: String) -> PinterestSegment.TitleElement {
        let symbol = UIImage(systemName: symbolName)
        return PinterestSegment.TitleElement(
            title: title,
            selectedImage: symbol?.withTintColor(.darkGray, renderingMode: .alwaysOriginal),
            normalImage: symbol?.withTintColor(.lightGray, renderingMode: .alwaysOriginal))
    }

    private func configureLayout() {
        let contentView = UIView()

        let sections: [(header: String, segment: PinterestSegment)] = [
            ("Default", defaultSegment),
            ("Rich text", iconSegment),
            ("Customization", customSegment),
        ]

        let stack = UIStackView(
            arrangedSubviews: sections.flatMap { section -> [UIView] in
                let header = UILabel()
                header.text = section.header
                header.font = .preferredFont(forTextStyle: .headline)
                return [header, makeSegment(section.segment)]
            })
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        statusLabel.text = "Tap a segment"
        statusLabel.font = .preferredFont(forTextStyle: .footnote)
        statusLabel.textColor = .secondaryLabel
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusLabel)

        let contentGuide = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            statusLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 24),
            statusLabel.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            contentGuide.bottomAnchor.constraint(equalTo: statusLabel.bottomAnchor),
        ])

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }

    private func makeSegment(_ segment: PinterestSegment) -> UIView {
        let height: CGFloat = segment === iconSegment ? 44 : 40
        segment.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segment.heightAnchor.constraint(equalToConstant: height)
        ])
        return segment
    }

    private func log(_ text: String) {
        statusLabel.text = text
    }
}
