//
//  workOutTableViewCell.swift
//  NeoFitness
//
//  Created by Sai Ram on 23/11/19.
//  Copyright © 2019 dmondo. All rights reserved.
//

import UIKit
import Kingfisher

protocol WorkOutProtocol: class {
    func didSelectWorkout(row: Int)
}

class workOutTableViewCell: UITableViewCell {

    @IBOutlet weak var workOutCollectionView: UICollectionView!
   // @IBOutlet weak var collectionheightConstraint: NSLayoutConstraint!
    
    var height: CGFloat = 0.0
    var itemHeight: CGFloat = 0.0
    var imagesArray:[WorkOut] = []
     weak var delegate: WorkOutProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        workOutCollectionView.delegate = self
        workOutCollectionView.dataSource = self
        self.workOutCollectionView.reloadData()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupClassData(carousels: [WorkOut]) {
        self.imagesArray.removeAll()
        self.imagesArray = carousels
        
        DispatchQueue.main.async {
            self.workOutCollectionView.reloadData()
            self.layoutIfNeeded()
            self.setNeedsLayout()
            self.height = self.workOutCollectionView.contentSize.height
        }
    }
}

extension workOutTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = round(Double(self.imagesArray.count / 2))
        //self.collectionheightConstraint.constant = CGFloat(count) * self.itemHeight
        //self.height = self.collectionheightConstraint.constant
        return imagesArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classCollectionViewCell", for: indexPath) as! classCollectionViewCell
        //URL(string: "\(NDefaults.imageBaseUrl)\(packages[index].offerImage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        
        let image = UIImage(named: "workout_placeholder.jpg")
        let url = URL(string: "\(NDefaults.imageBaseUrl)\(self.imagesArray[indexPath.row].WorkOutImage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        cell.classImageView.kf.setImage(with: url, placeholder: image)
        cell.classNameLabel.text = self.imagesArray[indexPath.row].Name
        cell.classImageView.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.didSelectWorkout(row: indexPath.row)
        }
    }
}


extension workOutTableViewCell: UICollectionViewDelegateFlowLayout {
    
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 10)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 2
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
        let widthPerItem = availableWidth / itemsPerRow
        print("========", CGSize(width: widthPerItem, height: widthPerItem))
        self.itemHeight = widthPerItem
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
