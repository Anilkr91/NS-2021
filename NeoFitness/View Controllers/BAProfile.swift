//
//  BAProfile.swift
//  NeoFitness
//
//  Created by mac on 29/03/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import Foundation
import UIKit

class BAProfile: UIViewController {
    
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var gymNameLabel: UILabel!
    @IBOutlet weak var userRoleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image =  UIImage(named: "Default-568h@2x.png")
        //self.view.contentMode = .scaleAspectFill
        //self.view.backgroundColor = UIColor(patternImage: image!)
        
     
        let backgroundImageView = UIImageView(image: image)
       // let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        backgroundImageView.frame =  view.frame
        backgroundImageView.contentMode = .scaleAspectFit
        
       // view.clipsToBounds = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
       
       
        
        let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        let role =  UserDefaults.standard.string(forKey: "FirstName") ?? ""
        let gymName =  UserDefaults.standard.string(forKey: "GymName") ?? ""
        
        DispatchQueue.main.async {[weak self] in
            self?.userInfoLabel.text = "USER INFO"
            self?.userNameLabel.text = userName
            self?.gymNameLabel.text = gymName
            self?.userRoleLabel.text = role
        }
    }
}
