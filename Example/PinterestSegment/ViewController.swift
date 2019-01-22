//
//  ViewController.swift
//  PinterestSegment
//
//  Created by TBXark on 02/01/2018.
//  Copyright (c) 2018 TBXark. All rights reserved.
//

import UIKit
import PinterestSegment

class ViewController: UIViewController {

    @IBOutlet weak var ibSegment: PinterestSegment!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceBuilderExample()
        
        basicCustomExample()
        
        advancedExample()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController
{
    func interfaceBuilderExample()
    {
        //create a new segment with Interface Builder
        ibSegment.titles = ["Storybord", "Everything", "Geek", "Humor", "Art", "Food", "Home", "DIY", "Wemoent' Style", "Man's Style", "Beauty", "Travel"]
    }
    
    func basicCustomExample()
    {
        //create a new segment with code
        let w = view.frame.width
        let s = PinterestSegment(frame: CGRect(x: 20, y: 40, width: w - 40, height: 40), titles: ["Everything", "Geek", "Humor", "Art", "Food", "Home", "DIY", "Wemoent' Style", "Man's Style", "Beauty", "Travel"])
        s.style.titleFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 5))
        view.addSubview(s)
    }
    
    func advancedExample()
    {
        //an advanced example using image decorators
        let image = UIImage(imageLiteralResourceName: "mobile-24").withColor(.lightGray)!
        let coloredImage = image.withColor(.red)!
        let titles = ["This", "Example", "Is", "Advanced"]
        let selectedImages = [coloredImage, coloredImage, coloredImage, coloredImage]
        let normalImages = [image, image, image, image]
        var advancedStyle = PinterestSegmentStyle()
        advancedStyle.titleFont = UIFont.systemFont(ofSize: 13, weight: .black)
        advancedStyle.normalTitleColor = .lightGray
        advancedStyle.normalBorderColor = .lightGray
        advancedStyle.selectedTitleColor = .red
        advancedStyle.selectedBorderColor = .red
        advancedStyle.titlePendingVertical = 23
        advancedStyle.indicatorColor = .clear
        
        let s2 = PinterestSegment(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 60))
        view.addSubview(s2)
        s2.style = advancedStyle
        s2.setTitles(titles, selectedImages: selectedImages, normalImages: normalImages)
    }
}


//a helper extension to get a new image with a color for example sake
extension UIImage{
    func withColor(_ color: UIColor) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        guard let context = UIGraphicsGetCurrentContext(),
            let cgImage = self.cgImage else
        {
            return nil
        }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1, y: -1)
        context.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: cgImage)
        color.setFill()
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }

}
