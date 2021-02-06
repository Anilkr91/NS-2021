//
//  FitnessChannelTableViewCell.swift
//  NeoFitness
//
//  Created by user on 04/02/21.
//  Copyright © 2021 dmondo. All rights reserved.
//

import UIKit

class FitnessChannelTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var productPriceLabel: UILabel!
//    @IBOutlet weak var productNameLabel: UILabel!
//    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var fitnessCollectionView: UICollectionView!
    weak var delegate: shopProductProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fitnessCollectionView.delegate = self
        fitnessCollectionView.dataSource = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupClassData() {
        DispatchQueue.main.async {
            self.fitnessCollectionView.reloadData()
        }
    }
}

extension FitnessChannelTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FitnessChannelCollectionViewCell", for: indexPath) as! FitnessChannelCollectionViewCell
        cell.playerView.loadVideoID("gPycVQ2S8CU")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.didSelectProduct(index: indexPath.row)
        }
    }
}

extension FitnessChannelTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width
//        let yourHeight: CGFloat = 200.0
//
        return CGSize(width: yourWidth, height: 250)
    }
}

