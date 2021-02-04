//
//  ShopProductsTableViewCell.swift
//  NeoFitness
//
//  Created by Sai Ram on 03/02/21.
//  Copyright © 2021 dmondo. All rights reserved.
//

import UIKit

protocol shopProductProtocol: class {
    func didSelectProduct(index: Int)
    //func didSelectClassType(row: Int)
}

class ShopProductsTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var productPriceLabel: UILabel!
//    @IBOutlet weak var productNameLabel: UILabel!
//    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    weak var delegate: shopProductProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupClassData() {
        DispatchQueue.main.async {
            self.productCollectionView.reloadData()
        }
    }
}

extension ShopProductsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopProductCollectionViewCell", for: indexPath) as! shopProductCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.didSelectProduct(index: indexPath.row)
        }
    }
}

extension ShopProductsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight: CGFloat = 200.0
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
}

