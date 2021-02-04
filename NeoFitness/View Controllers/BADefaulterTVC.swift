//
//  BADefaulterTVC.swift
//  NeoFitness
//
//  Created by mac on 04/04/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import UIKit

class BADefaulterTVC: UITableViewCell {
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var categoryTypeLabel: UILabel!
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var membershipStartDatelabel: UILabel!
    @IBOutlet weak var membershipExpiryLabel: UILabel!
    @IBOutlet weak var attendenceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
