//
//  CarouselTableViewCell.swift
//  NeoFitness
//
//  Created by Sai Ram on 23/11/19.
//  Copyright © 2019 dmondo. All rights reserved.
//

import UIKit
import FSPagerView

struct carouselViewData {
    let image: UIImage
    let title: String
    let description: String
    
}

class CarouselTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            //self.pagerView.itemSize = CGSize(width: self.contentView.frame.size.width, height: 225)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pagerView.automaticSlidingInterval = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


