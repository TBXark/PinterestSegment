//
//  UILabel+TitleIcon.swift
//  PinterestSegment
//
//  Created by Tbxark on 06/12/2016.
//  Copyright © 2016 Tbxark. All rights reserved.
//

import UIKit

extension UILabel {
    /// Prepends `image` to the label text as a text attachment.
    @objc public func addToLeft(image: UIImage?) {
        let mutableAttributedString = NSMutableAttributedString()
        if let image = image {
            let attachment = NSTextAttachment()
            attachment.image = image
            var size = image.size
            if size.height > bounds.height {
                size.height = bounds.height
                size.width = size.height * bounds.width / bounds.height
            }

            attachment.bounds = CGRect(
                x: 0, y: (self.font.capHeight - size.height) / 2, width: size.width, height: size.height)
            let attachmentStr = NSAttributedString(attachment: attachment)
            mutableAttributedString.append(attachmentStr)
        }
        if let text = self.text {
            let textString = NSAttributedString(
                string: text, attributes: [.font: self.font as UIFont, .foregroundColor: self.textColor as UIColor])
            mutableAttributedString.append(textString)
        }
        self.attributedText = mutableAttributedString
    }
}
