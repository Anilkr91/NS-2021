//
//  classTableViewCell.swift
//  NeoFitness
//
//  Created by Sai Ram on 03/11/19.
//  Copyright © 2019 dmondo. All rights reserved.
//

import UIKit

protocol classWorkOutProtocol: class {
    func didSelectDay(day: String)
    func didSelectClassType(row: Int)
}

class classTableViewCell: UITableViewCell {

    @IBOutlet weak var weekDaysSegmentControl: UISegmentedControl!
    @IBOutlet weak var classCollectionView: UICollectionView!
    weak var delegate: classWorkOutProtocol?
    
    var classes:[Classes] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        
        let today = Date()
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) else { return  }
        guard let dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: tomorrow) else { return }
        
        weekDaysSegmentControl.setTitle("Today", forSegmentAt: 0)
        weekDaysSegmentControl.setTitle(tomorrow.dayOfWeek(), forSegmentAt: 1)
        weekDaysSegmentControl.setTitle(dayAfterTomorrow.dayOfWeek(), forSegmentAt: 2)
        weekDaysSegmentControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupClassData(carousels: [Classes]) {
        self.classes.removeAll()
        self.classes = carousels

        if classes.count == 0 {
            let obj = Classes(GymId: "", BranchId: "", DayName: "", ClassName: "", Name: "", Sequences: "", GroupClassImage: "", detail: nil)
            
           // (GymId: "", BranchId: "", DayName: "", ClassName: "", Name: "", Sequences: "", GroupClassImage: "")
            //(GymId: "", BranchId: "", DayName: "", ClassName: "", Trainer: "", StartTime: "", EndTime: "", Vanue: "", Sequences: "", Name: "No Group Classes")
            self.classes.append(obj)
        }
        
        DispatchQueue.main.async {
             self.classCollectionView.reloadData()
        }
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
        
        let today = Date()
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) else { return  }
        guard let dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: tomorrow) else { return }
        
        switch (segmentedControl.selectedSegmentIndex) {
            
        case 0:
            // First segment tapped
            if let delegate = delegate {
                let today = Date()
                delegate.didSelectDay(day: today.dayOfWeek() ?? "")
            }
            
            break
        case 1:
            // Second segment tapped
            if let delegate = delegate {
                delegate.didSelectDay(day: tomorrow.dayOfWeek() ?? "")
            }
            break
            
        case 2:
            // Second segment tapped
            if let delegate = delegate {
                delegate.didSelectDay(day: dayAfterTomorrow.dayOfWeek() ?? "")
            }
        default:
            break
        }
    }
}

extension classTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classCollectionViewCell", for: indexPath) as! classCollectionViewCell

        if classes[indexPath.row].Name == "No Group Classes" {
            
            cell.classImageView.image = UIImage(named: "group_classes1.png")
            cell.classNameLabel.text = classes[indexPath.row].Name
            cell.classImageView.contentMode = .center
            return cell
            
        } else {
            
             let url = URL(string: "\(NDefaults.imageBaseUrl)\(self.classes[indexPath.row].GroupClassImage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            if let url = url {
               cell.classImageView.kf.setImage(with: url)
            }
            
            //cell.classImageView.image = #imageLiteral(resourceName: "img2")
            cell.classNameLabel.text = classes[indexPath.row].Name
            cell.classImageView.contentMode = .scaleAspectFit
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.didSelectClassType(row: indexPath.row)
        }
    }
}

extension classTableViewCell: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
    }

    fileprivate var itemsPerRow: CGFloat {
        return 1
    }

    fileprivate var interitemSpace: CGFloat {
        return 2.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
        let widthPerItem = availableWidth / 1

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
        return 8.0
    }
}
