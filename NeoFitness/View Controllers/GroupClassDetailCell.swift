//
//  GroupClassDetailCell.swift
//  NeoFitness
//
//  Created by Sai Ram on 18/01/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import UIKit

class GroupClassDetailCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var trainerLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
