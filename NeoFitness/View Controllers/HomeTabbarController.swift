//
//  HomeTabbarController.swift
//  NeoFitness
//
//  Created by Sai Ram on 30/11/19.
//  Copyright © 2019 dmondo. All rights reserved.
//

import UIKit

class HomeTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        // Do any additional setup after loading the view.
        
        if UserDefaults.standard.bool(forKey: "currentUser") == true {
                  self.tabBar.isUserInteractionEnabled = true
                 
                  return

              } else {
                  self.tabBar.isUserInteractionEnabled = true
                  return
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.tabBar.isHidden = false
    }
    
    func showLogin() {
        
        if self.revealViewController() != nil {
                     
            let revealVC = self.revealViewController()
            let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.setViewControllers([vc], animated: true)
            revealVC?.setFront(navigationController, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
                
        }
    }
}

extension HomeTabbarController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
        if tabBarController.selectedIndex == 1 {
           if UserDefaults.standard.bool(forKey: "currentUser") == true {
             self.tabBarController?.selectedViewController = viewController
            
           } else {
                
                self.showLogin()
                return
            }
            
        } else if tabBarController.selectedIndex == 2 {
           if UserDefaults.standard.bool(forKey: "currentUser") == true {
             self.tabBarController?.selectedViewController = viewController
            
           } else {
                self.showLogin()
                return
            
            }
            
        } else if tabBarController.selectedIndex == 3 {
           if UserDefaults.standard.bool(forKey: "currentUser") == true {
                self.tabBarController?.selectedViewController = viewController
            
           } else {
                self.showLogin()
                return
            }
            
        } else if tabBarController.selectedIndex == 4 {
           if UserDefaults.standard.bool(forKey: "currentUser") == true {
                 self.tabBarController?.selectedViewController = viewController
            
           } else {
                self.showLogin()
                return
            
            }
            
        }
    }
}
