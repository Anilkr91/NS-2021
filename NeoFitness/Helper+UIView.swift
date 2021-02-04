//
//  Helper+UIView.swift
//  NeoFitness
//
//  Created by Sai Ram on 13/10/19.
//  Copyright © 2019 dmondo. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

@IBDesignable
class DesignableView: UIView {

}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

//
//struct userDefaults {
//
//    static func setBranchId(branchId: String) {
//           print(branchId)
//           let defults = UserDefaults.standard
//           defults.set(branchId, forKey: "selectedBranchId")
//           defults.synchronize()
//
//       }
//
//      static func getbranchId() -> String? {
//            let defults = UserDefaults.standard
//           let value: String = defults.string(forKey: "selectedBranchId") ?? ""
//
//            print(value)
//           return value
//
//
//       }
//}


extension DefaultsKeys {

    static var branchId = DefaultsKey<String?>("selectedBranchId")
    
}


class LoginUtils {
    
    class func setBranchId(id: String) {
        Defaults[.branchId] = id
    }
    
    class func getBranchId() -> String? {
        if let id = Defaults[.branchId] {
            return id
        }
        return nil
    }
}
