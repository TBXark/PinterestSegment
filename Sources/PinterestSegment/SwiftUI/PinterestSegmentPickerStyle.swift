//
//  PinterestSegmentPickerStyle.swift
//  PinterestSegment
//
//  Created by Tbxark on 06/12/2016.
//  Copyright © 2016 Tbxark. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
extension PinterestSegmentPicker {

    /// The visual configuration of a `PinterestSegmentPicker`.
    ///
    /// Defaults use adaptive system colors, so the control supports light
    /// and dark mode out of the box. Assign a whole new style to change the
    /// appearance, e.g. `PinterestSegmentPicker(selection: $selection,
    /// titles: titles, style: style)`.
    public struct Style {
        /// Fill color of the sliding capsule.
        public var indicatorColor: Color = Color.primary.opacity(0.1)
        /// Spacing between two neighboring items.
        public var titleMargin: CGFloat = 16
        /// Horizontal padding inside a capsule-shaped item.
        public var titlePaddingHorizontal: CGFloat = 14
        /// Vertical padding inside a capsule-shaped item.
        public var titlePaddingVertical: CGFloat = 7
        /// Spacing between an item icon and its title.
        public var iconSpacing: CGFloat = 6
        /// Title font. Defaults to a dynamic type style so the control
        /// scales with the user's preferred text size.
        public var titleFont: Font = .body.bold()
        /// Minimum width of an item, useful for very short titles.
        public var minimumWidth: CGFloat?
        public var normalTitleColor: Color = .secondary
        public var selectedTitleColor: Color = .primary
        /// Draws a 2pt capsule border around the sliding indicator.
        public var selectedBorderColor: Color = .clear
        /// Draws a 2pt capsule border around every unselected item.
        public var normalBorderColor: Color = .clear
        /// Animation used when the capsule slides to another item.
        public var animation: Animation = .easeInOut(duration: 0.2)

        public init() {}
    }
}
