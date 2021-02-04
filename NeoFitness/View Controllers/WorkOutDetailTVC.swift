//
//  WorkOutDetailTVC.swift
//  NeoFitness
//
//  Created by Sai Ram on 26/01/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import UIKit
import Kingfisher

class WorkOutDetailTVC: UITableViewController {

    @IBOutlet weak var wdImageView: UIImageView!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var benefits: UILabel!
    
    var workout: WorkOut?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        
        if let workout = workout {
            
            let Url = URL(string: "\(NDefaults.imageBaseUrl)\(workout.WorkOutImage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            wdImageView?.kf.setImage(with: Url)
            workoutLabel.text = workout.Name
            aboutLabel.text = workout.About
            benefits.text = workout.Benefits
            self.navigationItem.title = workout.Name
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


extension WorkOutDetailTVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 200
        } else {
            return UITableView.automaticDimension
        }
    }
}
