//
//  BABaseTVCell.swift
//  NeoFitness
//
//  Created by mac on 02/04/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import UIKit

class BABaseTVCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerDataLabel: UILabel!
    
    @IBOutlet weak var subDetailOneLabel: UILabel!
    @IBOutlet weak var subDetailTwoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
