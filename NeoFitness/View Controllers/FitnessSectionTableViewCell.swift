//
//  FitnessSectionTableViewCell.swift
//  NeoFitness
//
//  Created by Sai Ram on 02/02/21.
//  Copyright © 2021 dmondo. All rights reserved.
//

import UIKit

class FitnessSectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var fitnessLabel: UIView!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var dietLabel: UILabel!
    @IBOutlet weak var expertAdviceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        fitnessLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
//        workoutLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
//        dietLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
//        expertAdviceLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        fitnessLabel.rotate(degrees: -90)
        workoutLabel.rotate(degrees: -90)
        dietLabel.rotate(degrees: -90)
        expertAdviceLabel.rotate(degrees: -90)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIView {
    func rotate(degrees: CGFloat) {
        rotate(radians: CGFloat.pi * degrees / 180.0)
    }
    
    func rotate(radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}
