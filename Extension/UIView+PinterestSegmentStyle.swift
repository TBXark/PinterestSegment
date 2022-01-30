//
//  UIView+PinterestSegmentStyle.swift
//  PinterestSegment
//
//  Created by Mariya Pankova on 30.01.2022.
//

extension UIView {
    public func setRadius(from style: PinterestSegmentStyle) {
        clipsToBounds = true
        switch style.radius {
        case .rounded:
            layer.cornerRadius = frame.height / 2
        case .roundedText:
            layer.cornerRadius = (style.titleFont.lineHeight + style.titlePendingVertical) / 2
        case let .exact(value):
            layer.cornerRadius = value
        }
    }
}
