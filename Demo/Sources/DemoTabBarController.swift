//
//  DemoTabBarController.swift
//  PinterestSegmentDemo
//

import SwiftUI
import UIKit

/// Demo shell shared by every component demo: a `UITabBarController` with
/// one tab for the UIKit implementation and one for the SwiftUI one.
final class DemoTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let uikitTab = UINavigationController(rootViewController: UIKitDemoViewController())
        uikitTab.tabBarItem = UITabBarItem(title: "UIKit", image: UIImage(systemName: "hammer"), tag: 0)

        let hostingController = UIHostingController(rootView: SwiftUIDemoView())
        let swiftUITab = UINavigationController(rootViewController: hostingController)
        swiftUITab.tabBarItem = UITabBarItem(title: "SwiftUI", image: UIImage(systemName: "swift"), tag: 1)

        viewControllers = [uikitTab, swiftUITab]
    }
}
