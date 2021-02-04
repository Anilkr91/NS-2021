//
//  LocationTableViewCell.swift
//  NeoFitness
//
//  Created by Sai Ram on 01/12/19.
//  Copyright © 2019 dmondo. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.borderWidth=1.0
        imgView.layer.masksToBounds = false
        imgView.layer.borderColor = UIColor.red.cgColor
        imgView.layer.cornerRadius = imgView.frame.size.height/2
        imgView.clipsToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
