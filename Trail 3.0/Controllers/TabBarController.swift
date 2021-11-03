//
//  TabBarController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 03/11/2021.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // tell our UITabBarController subclass to handle its own delegate methods
        self.delegate = self
    }

    // called whenever a tab button is tapped
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        if viewController is ContactListViewController {
            print("==== CONTACT LIST VIEW CONTROLLER")
        } else if viewController is MapViewController {
            print("==== MAP VIEW CONTROLLER")
        }
    }
}
