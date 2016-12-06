//
//  ViewController.swift
//  Demo
//
//  Created by Tbxark on 06/12/2016.
//  Copyright © 2016 Tbxark. All rights reserved.
//

import UIKit
import PinterestSegment

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = view.frame.width
        let s = PinterestSegment(frame: CGRect(x: 20, y: 200, width: w - 40, height: 40), titles: ["Everything", "Geek", "Humor", "Art", "Food", "Home", "DIY", "Wemoent' Style", "Man's Style", "Beauty", "Travel"])
        s.style.titleFont = UIFont.systemFont(ofSize: 14, weight: 5)
        view.addSubview(s)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

