//
//  ViewController.swift
//  HeroHelper
//
//  Created by E5000855 on 29/06/24.
//

import UIKit
import Firebase
import GoogleSignIn

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let healthFAQViewController = UINavigationController(rootViewController: HealthFAQViewController())
        healthFAQViewController.tabBarItem = UITabBarItem(title: "Health FAQs", image: UIImage(systemName: "heart.text.square"), tag: 0)

        let equipmentTipsViewController = UINavigationController(rootViewController: EquipmentTipsViewController())
        equipmentTipsViewController.tabBarItem = UITabBarItem(title: "Equipment Tips", image: UIImage(systemName: "wrench.and.screwdriver"), tag: 1)

        viewControllers = [healthFAQViewController, equipmentTipsViewController]
    }
}

