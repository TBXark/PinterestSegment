//
//  PinterestSegmentPicker.swift
//  PinterestSegment
//
//  Created by Tbxark on 06/12/2016.
//  Copyright © 2016 Tbxark. All rights reserved.
//

import Combine
import SwiftUI

/// A native SwiftUI segmented control with the Pinterest-style sliding
/// capsule indicator: the selected title is revealed by a colored pill that
/// slides between items while the unselected titles stay in place.
///
/// ```swift
/// struct ContentView: View {
///     @State private var selection = 0
///     var body: some View {
///         PinterestSegmentPicker(selection: $selection,
///                                titles: ["Everything", "Geek", "Humor"])
///             .frame(height: 40)
///     }
/// }
/// ```
@available(iOS 13.0, *)
public struct PinterestSegmentPicker: View {

    /// One selectable entry of a `PinterestSegmentPicker`.
    ///
    /// `icon` is rendered as a template image, so it is tinted with the
    /// title color of the row it appears in.
    public struct Item {
        public var title: String
        public var icon: Image?

        public init(title: String, icon: Image? = nil) {
            self.title = title
            self.icon = icon
        }
    }

    private static let coordinateSpaceName = "PinterestSegmentPickerContent"

    @Binding private var selection: Int
    private var items: [Item]
    private var style: Style
    private var onSelectionChange: ((Int) -> Void)?

    /// Mirrors `selection` inside an animated transaction so the capsule
    /// slides for both interactive and programmatic selection changes.
    @State private var indicatorIndex = 0
    @State private var appeared = false
    @State private var itemFrames: [Int: CGRect] = [:]

    public init(
        selection: Binding<Int>,
        titles: [String],
        style: Style = Style(),
        onSelectionChange: ((Int) -> Void)? = nil
    ) {
        self.init(
            selection: selection,
            items: titles.map { Item(title: $0) },
            style: style,
            onSelectionChange: onSelectionChange)
    }

    public init(
        selection: Binding<Int>,
        items: [Item],
        style: Style = Style(),
        onSelectionChange: ((Int) -> Void)? = nil
    ) {
        self._selection = selection
        self.items = items
        self.style = style
        self.onSelectionChange = onSelectionChange
    }

    public var body: some View {
        Group {
            if #available(iOS 14.0, *) {
                autoScrollingContent
            } else {
                content
            }
        }
        .onAppear {
            indicatorIndex = selection
            appeared = true
        }
        .onReceive(Just(selection).removeDuplicates()) { value in
            guard appeared, value != indicatorIndex else { return }
            withAnimation(style.animation) {
                indicatorIndex = value
            }
        }
    }

    @available(iOS 14.0, *)
    private var autoScrollingContent: some View {
        ScrollViewReader { proxy in
            content
                .pickerOnChange(of: selection) { newValue in
                    withAnimation(style.animation) {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
        }
    }

    private var content: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ZStack(alignment: .topLeading) {
                normalRow
                indicator
                selectedRow
                    .mask(indicatorMask)
                    .pickerAccessibilityHidden()
            }
            .coordinateSpace(name: Self.coordinateSpaceName)
            .padding(.horizontal, style.titleMargin)
            .frame(maxHeight: .infinity, alignment: Alignment(horizontal: .leading, vertical: .center))
            .onPreferenceChange(ItemFramesPreferenceKey.self) { frames in
                itemFrames = frames
            }
        }
    }

    // MARK: - Rows

    private var normalRow: some View {
        HStack(spacing: style.titleMargin) {
            ForEach(items.indices, id: \.self) { index in
                itemLabel(items[index], color: style.normalTitleColor)
                    .overlay(capsuleBorder(style.normalBorderColor))
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ItemFramesPreferenceKey.self,
                                value: [index: geometry.frame(in: .named(Self.coordinateSpaceName))])
                        }
                    )
                    .accessibilityElement(children: .ignore)
                    .pickerAccessibilityLabel(items[index].title)
                    .pickerAccessibilityAddTraits(index == selection ? [.isButton, .isSelected] : [.isButton])
                    .onTapGesture {
                        select(index)
                    }
            }
        }
    }

    private var selectedRow: some View {
        HStack(spacing: style.titleMargin) {
            ForEach(items.indices, id: \.self) { index in
                itemLabel(items[index], color: style.selectedTitleColor)
            }
        }
    }

    private func itemLabel(_ item: Item, color: Color) -> some View {
        HStack(spacing: style.iconSpacing) {
            if let icon = item.icon {
                icon
            }
            Text(item.title)
        }
        .font(style.titleFont)
        .foregroundColor(color)
        .lineLimit(1)
        .padding(.horizontal, style.titlePaddingHorizontal)
        .padding(.vertical, style.titlePaddingVertical)
        .frame(minWidth: style.minimumWidth)
        .contentShape(Rectangle())
    }

    // MARK: - Indicator

    private var indicatorFrame: CGRect {
        itemFrames[indicatorIndex] ?? .zero
    }

    @ViewBuilder
    private var indicator: some View {
        if indicatorFrame.width > 0 {
            Capsule()
                .fill(style.indicatorColor)
                .overlay(capsuleBorder(style.selectedBorderColor))
                .frame(width: indicatorFrame.width, height: indicatorFrame.height)
                .position(x: indicatorFrame.midX, y: indicatorFrame.midY)
                .pickerAccessibilityHidden()
        }
    }

    /// Reveals the selected row only inside the moving capsule.
    private var indicatorMask: some View {
        GeometryReader { _ in
            Capsule()
                .frame(width: indicatorFrame.width, height: indicatorFrame.height)
                .position(x: indicatorFrame.midX, y: indicatorFrame.midY)
        }
    }

    @ViewBuilder
    private func capsuleBorder(_ color: Color) -> some View {
        if color != .clear {
            Capsule()
                .strokeBorder(color, lineWidth: 2)
        }
    }

    // MARK: - Interaction

    private func select(_ index: Int) {
        guard items.indices.contains(index), index != selection else { return }
        withAnimation(style.animation) {
            selection = index
            indicatorIndex = index
        }
        onSelectionChange?(index)
    }
}

private struct ItemFramesPreferenceKey: PreferenceKey {
    static let defaultValue: [Int: CGRect] = [:]

    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
    }
}

@available(iOS 14.0, *)
extension View {
    @ViewBuilder
    fileprivate func pickerOnChange<V: Equatable>(of value: V, perform: @escaping (V) -> Void) -> some View {
        if #available(iOS 17.0, *) {
            onChange(of: value) { _, newValue in
                perform(newValue)
            }
        } else {
            legacyPickerOnChange(of: value, perform: perform)
        }
    }

    // Marking this helper deprecated keeps the iOS 17 SDK from warning
    // about the deprecated `onChange(of:perform:)` overload it wraps.
    @available(iOS, introduced: 14.0, deprecated: 17.0)
    fileprivate func legacyPickerOnChange<V: Equatable>(of value: V, perform: @escaping (V) -> Void) -> some View {
        onChange(of: value, perform: perform)
    }
}

// Accessibility modifiers renamed in iOS 14; these helpers pick the right
// overload per OS version.
extension View {
    @ViewBuilder
    fileprivate func pickerAccessibilityHidden() -> some View {
        if #available(iOS 14.0, *) {
            accessibilityHidden(true)
        } else {
            legacyAccessibility(hidden: true)
        }
    }

    @ViewBuilder
    fileprivate func pickerAccessibilityLabel(_ title: String) -> some View {
        if #available(iOS 14.0, *) {
            accessibilityLabel(Text(title))
        } else {
            legacyAccessibility(label: Text(title))
        }
    }

    @ViewBuilder
    fileprivate func pickerAccessibilityAddTraits(_ traits: AccessibilityTraits) -> some View {
        if #available(iOS 14.0, *) {
            accessibilityAddTraits(traits)
        } else {
            legacyAccessibility(addTraits: traits)
        }
    }
}

// Marked deprecated so the SDK does not warn about the deprecated iOS 13
// accessibility overloads used inside.
@available(iOS, introduced: 13.0, deprecated: 14.0)
extension View {
    fileprivate func legacyAccessibility(hidden: Bool) -> some View {
        accessibility(hidden: hidden)
    }

    fileprivate func legacyAccessibility(label: Text) -> some View {
        accessibility(label: label)
    }

    fileprivate func legacyAccessibility(addTraits traits: AccessibilityTraits) -> some View {
        accessibility(addTraits: traits)
    }
}
