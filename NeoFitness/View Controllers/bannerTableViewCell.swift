//
//  bannerTableViewCell.swift
//  NeoFitness
//
//  Created by mac on 22/03/20.
//  Copyright © 2020 dmondo. All rights reserved.
//


import UIKit
import FSPagerView

class bannerTableViewCell: UITableViewCell {
    
    var adArray = ["ad1.jpeg", "ad2.jpeg"]
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
        pagerView.delegate = self
        pagerView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension bannerTableViewCell: FSPagerViewDataSource,FSPagerViewDelegate {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return adArray.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        

        cell.imageView?.image =  UIImage(named: adArray[index])
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
       
    }
}
