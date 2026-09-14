//
//  PinterestSegmentStyle.swift
//  PinterestSegment
//
//  Created by Tbxark on 06/12/2016.
//  Copyright © 2016 Tbxark. All rights reserved.
//

import UIKit

/// The visual configuration of a `PinterestSegment`.
///
/// `PinterestSegmentStyle` is a value type. Mutating a style that has already
/// been assigned to a control does not automatically reload the control, e.g.
/// `segment.style.titleFont = font` will not trigger a reload, but
/// `segment.style = newStyle` will. Call `PinterestSegment.reloadData()`
/// to apply in-place mutations manually.
public struct PinterestSegmentStyle: Equatable {

    public var indicatorColor = UIColor(white: 0.95, alpha: 1)
    public var titleMargin: CGFloat = 16
    public var titlePendingHorizontal: CGFloat = 14
    public var titlePendingVertical: CGFloat = 14
    public var titleFont = UIFont.boldSystemFont(ofSize: 14)
    public var normalTitleColor = UIColor.lightGray
    public var selectedTitleColor = UIColor.darkGray
    public var selectedBorderColor = UIColor.clear
    public var normalBorderColor = UIColor.clear
    public var minimumWidth: CGFloat?
    public init() {}

    public static func == (lhs: PinterestSegmentStyle, rhs: PinterestSegmentStyle) -> Bool {
        return lhs.indicatorColor == rhs.indicatorColor
            && lhs.titleMargin == rhs.titleMargin
            && lhs.titlePendingHorizontal == rhs.titlePendingHorizontal
            && lhs.titlePendingVertical == rhs.titlePendingVertical
            && lhs.titleFont == rhs.titleFont
            && lhs.normalTitleColor == rhs.normalTitleColor
            && lhs.selectedTitleColor == rhs.selectedTitleColor
            && lhs.selectedBorderColor == rhs.selectedBorderColor
            && lhs.normalBorderColor == rhs.normalBorderColor
            && lhs.minimumWidth == rhs.minimumWidth
    }
}
