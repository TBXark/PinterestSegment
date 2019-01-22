//
//  PinterestSegment.swift
//  Demo
//
//  Created by Tbxark on 06/12/2016.
//  Copyright © 2016 Tbxark. All rights reserved.
//

import UIKit

public struct PinterestSegmentStyle {

    public var indicatorColor = UIColor(white: 0.95, alpha: 1)
    public var titleMargin: CGFloat = 16
    public var titlePendingHorizontal: CGFloat = 14
    public var titlePendingVertical: CGFloat = 14
    public var titleFont = UIFont.boldSystemFont(ofSize: 14)
    public var normalTitleColor = UIColor.lightGray
    public var selectedTitleColor = UIColor.darkGray
    public var selectedBorderColor = UIColor.clear
    public var minimumWidth: CGFloat?
    public var titlePadding: CGFloat?
    public init() {}

}

protocol PinterestSegmentCustomizeDelegate
{
    func customizeSegment()
}

@IBDesignable public class PinterestSegment: UIControl {

    public var style: PinterestSegmentStyle {
        didSet {
            reloadLayout()
        }
    }
    public override var frame: CGRect {
        didSet {
            guard frame.size != oldValue.size else { return }
            reloadLayout()
        }
    }

    public override var bounds: CGRect {
        didSet {
            guard bounds.size != oldValue.size else { return }
            reloadLayout()
        }
    }

    @IBInspectable public var titles: [String] {
        didSet {
            guard oldValue != titles else { return }
            reloadData()
            setSelectIndex(index: 0, animated: true)
        }
    }
    
    private var selectedImages : [UIImage]?
    private var normalImages : [UIImage]?
    public func setTitles(_ titles : [String], selectedImages : [UIImage], normalImages: [UIImage])
    {
        self.titlePendingHorizontal = self.titlePendingVertical + (selectedImages.first?.size.width ?? 0)
        self.selectedImages = selectedImages
        self.normalImages = normalImages
        self.titles = titles
    }

    public var valueChange: ((Int) -> Void)?
    private var titleLabels: [UILabel] = []
    public private(set) var selectIndex = 0

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.bounces = true
        view.isPagingEnabled = false
        view.scrollsToTop = false
        view.isScrollEnabled = true
        view.contentInset = UIEdgeInsets.zero
        view.contentOffset = CGPoint.zero
        view.scrollsToTop = false
        return view
    }()

    private let selectContent =  UIView()
    private var indicator: UIView = {
        let ind = UIView()
        ind.layer.masksToBounds = true
        return ind
    }()
    private let selectedLabelsMaskView: UIView = {
        let cover = UIView()
        cover.layer.masksToBounds = true
        return cover
    }()

    // MARK: - life cycle
    public convenience override init(frame: CGRect) {
        self.init(frame: frame, segmentStyle: PinterestSegmentStyle(), titles: [])
    }

    public convenience init(frame: CGRect, titles: [String]) {
        self.init(frame: frame, segmentStyle: PinterestSegmentStyle(), titles: titles)
    }

    public init(frame: CGRect, segmentStyle: PinterestSegmentStyle, titles: [String]) {
        self.style = segmentStyle
        self.titles = titles
        super.init(frame: frame)
        shareInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        self.style = PinterestSegmentStyle()
        self.titles = []
        super.init(coder: aDecoder)
        shareInit()
    }

    private func shareInit() {
        addSubview(UIView())
        addSubview(scrollView)
        reloadData()
    }

    public func setSelectIndex(index: Int, animated: Bool = true) {
        setSelectIndex(index: index, animated: animated, sendAction: true)
    }

    // Target action
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let x = gesture.location(in: self).x + scrollView.contentOffset.x
        for (i, label) in titleLabels.enumerated() {
            if x >= label.frame.minX && x <= label.frame.maxX {
                setSelectIndex(index: i, animated: true)
                break
            }
        }

    }

    private func setSelectIndex(index: Int, animated: Bool, sendAction: Bool) {

        guard index != selectIndex, index >= 0, index < titleLabels.count else { return }

        let currentLabel = titleLabels[index]
        let offSetX = min(max(0, currentLabel.center.x - bounds.width / 2),
                          max(0, scrollView.contentSize.width - bounds.width))
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)

        if animated {

            UIView.animate(withDuration: 0.2, animations: {
                var rect = self.indicator.frame
                rect.origin.x = currentLabel.frame.origin.x
                rect.size.width = currentLabel.frame.size.width
                self.setIndicatorFrame(rect)
            })

        } else {
            var rect = indicator.frame
            rect.origin.x = currentLabel.frame.origin.x
            rect.size.width = currentLabel.frame.size.width
            setIndicatorFrame(rect)
        }

        selectIndex = index
        if sendAction {
            valueChange?(index)
            sendActions(for: .valueChanged)
        }
    }

    private func setIndicatorFrame(_ frame: CGRect) {
        indicator.frame = frame
        selectedLabelsMaskView.frame = frame

    }

    // Data handler

    private func reloadLayout() {
        let _selectIndex = selectIndex
        reloadData()
        setSelectIndex(index: _selectIndex, animated: false, sendAction: false)
    }
    
    private func clearData() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        selectContent.subviews.forEach { $0.removeFromSuperview() }
        if let gescs = gestureRecognizers {
            for gesc in gescs {
                removeGestureRecognizer(gesc)
            }
        }
        titleLabels.removeAll()
    }

    private func reloadData() {
        clearData()

        guard titles.count > 0  else {
            return
        }
        // Set titles
        let font  = style.titleFont
        var titleX: CGFloat = 0.0
        var titleH = font.lineHeight + 10
        if let _ = normalImages{
            titleH = titleH + style.titlePendingVertical
        }
        let titleY: CGFloat = ( bounds.height - titleH)/2
        let coverH: CGFloat = font.lineHeight + style.titlePendingVertical

        selectedLabelsMaskView.backgroundColor = UIColor.black
        scrollView.frame = bounds
        selectContent.frame = bounds
        selectContent.layer.mask = selectedLabelsMaskView.layer
        selectedLabelsMaskView.isUserInteractionEnabled = true

        let toToSize: (String) -> CGFloat = { text in
            let result =  (text as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0.0), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).width

            if let minWidth = self.style.minimumWidth, result < minWidth
            {
                return minWidth
            }
            return result
        }

        for (index, title) in titles.enumerated() {

            let titleW = toToSize(title) + style.titlePendingHorizontal * 2
            
            titleX = (titleLabels.last?.frame.maxX ?? 0 ) + style.titleMargin
            let rect = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)

            let backLabel = UILabel(frame: CGRect.zero)
            backLabel.tag = index
            backLabel.text = title
            backLabel.textColor = style.normalTitleColor
            backLabel.font = style.titleFont
            backLabel.textAlignment = .center
            backLabel.frame = rect
            
            if let normalImages = normalImages, normalImages.count > index
            {
                let normalImage = normalImages[index]
                backLabel.addToLeft(image: normalImage)
            }

            let frontLabel = UILabel(frame: CGRect.zero)
            frontLabel.tag = index
            frontLabel.text = title
            frontLabel.textColor = style.selectedTitleColor
            frontLabel.font = style.titleFont
            frontLabel.textAlignment = .center
            frontLabel.frame = rect
            if let selectedImages = selectedImages, selectedImages.count > index
            {
                let selectedImage = selectedImages[index]
                frontLabel.addToLeft(image: selectedImage)
            }

            titleLabels.append(backLabel)
            scrollView.addSubview(backLabel)
            selectContent.addSubview(frontLabel)

            if index == titles.count - 1 {
                scrollView.contentSize.width = rect.maxX + style.titleMargin
                selectContent.frame.size.width = rect.maxX + style.titleMargin
            }
        }

        // Set Cover
        indicator.layer.borderWidth = 2
        indicator.layer.borderColor = style.selectedBorderColor.cgColor
        indicator.backgroundColor = style.indicatorColor
        scrollView.addSubview(indicator)
        scrollView.addSubview(selectContent)

        let coverX = titleLabels[0].frame.origin.x
        let coverY = (bounds.size.height - coverH) / 2
        let coverW = titleLabels[0].frame.size.width

        let indRect = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        setIndicatorFrame(indRect)

        indicator.layer.cornerRadius = coverH/2
        selectedLabelsMaskView.layer.cornerRadius = coverH/2

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PinterestSegment.handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
        setSelectIndex(index: 0)

    }
}

extension PinterestSegment {

    public var titleFont: UIFont {
        get {
            return style.titleFont
        }
        set {
            style.titleFont = newValue
        }
    }

    @IBInspectable public var indicatorColor: UIColor {
        get {
            return style.indicatorColor
        }
        set {
            style.indicatorColor = newValue
        }
    }

    @IBInspectable public var titleMargin: CGFloat {
        get {
            return style.titleMargin
        }
        set {
            style.titleMargin = newValue
        }
    }

    @IBInspectable public var titlePendingHorizontal: CGFloat {
        get {
            return style.titlePendingHorizontal
        }
        set {
            style.titlePendingHorizontal = newValue
        }
    }

    @IBInspectable public var titlePendingVertical: CGFloat {
        get {
            return style.titlePendingVertical
        }
        set {
            style.titlePendingVertical = newValue
        }
    }
    
    @IBInspectable public var minimumWidth: CGFloat {
        get {
            return style.minimumWidth ?? 0
        }
        set {
            style.minimumWidth = newValue
        }
    }

    @IBInspectable public var normalTitleColor: UIColor {
        get {
            return style.normalTitleColor
        }
        set {
            style.normalTitleColor = newValue
        }
    }

    @IBInspectable public var selectedTitleColor: UIColor {
        get {
            return style.selectedTitleColor
        }
        set {
            style.selectedTitleColor = newValue
        }
    }
    
    @IBInspectable public var selectedBorderColor: UIColor {
        get {
            return style.selectedBorderColor
        }
        set {
            style.selectedBorderColor = newValue
        }
    }

}

extension UILabel
{
    @objc public func addToLeft(image: UIImage?)
    {
        if let image = image{
            let attachment = NSTextAttachment()
            attachment.image = image
            let attachString = NSAttributedString.init(attachment: attachment)
            let result = NSMutableAttributedString()
            result.append(attachString)
            if let text = text
            {
                let titleString = NSMutableAttributedString(string: text)
                let range = NSMakeRange(0,text.count)
                titleString.addAttribute(NSAttributedString.Key.baselineOffset, value: image.size.height / 4, range: range)
                result.append(titleString)
                self.text = nil
            }
            self.attributedText = result
        }
    }
}
