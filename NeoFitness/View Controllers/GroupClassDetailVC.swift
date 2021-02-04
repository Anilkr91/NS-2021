//
//  GroupClassDetailVC.swift
//  NeoFitness
//
//  Created by Sai Ram on 18/01/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import UIKit
import Kingfisher

class GroupClassDetailVC: UIViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var classImageView: UIImageView!
    @IBOutlet weak var tableVew: UITableView!
   // var groupClasses: [Classes]?
    var groupclass: Classes?
    var classesDetail = [ClassDetail]()
   // var imageUrl = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableVew.delegate = self
        tableVew.dataSource = self
        
//        for gc in self.groupClasses.enumerated() {
                
        let startTime = groupclass?.detail?.StartTime.components(separatedBy: ",") ?? []
        let endTime = groupclass?.detail?.EndTime.components(separatedBy: ",") ?? []
        let trainer = groupclass?.detail?.Trainer.components(separatedBy: ",") ?? []
        let trainerName = groupclass?.detail?.TrainerName.components(separatedBy: ",") ?? []
        let vanue = groupclass?.detail?.Vanue.components(separatedBy: ",") ?? []
          
        for index in 0..<startTime.count-1 {
            let classDetail = ClassDetail(Trainer: trainer [index], TrainerName: trainerName [index], StartTime: startTime[index], EndTime: endTime [index], Vanue: vanue [index])
           self.classesDetail.append(classDetail)
        }
        
        let url = URL(string: "\(NDefaults.imageBaseUrl)\(groupclass?.GroupClassImage ?? "")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            if let url = url {
                classImageView.kf.setImage(with: url)
        }
        self.title = groupclass?.Name
        self.tableVew.tableFooterView = UIView(frame: .zero)
    }
    
    func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension GroupClassDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classesDetail.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupClassDetailCell
        cell.startTimeLabel.text = "Start Time - \(classesDetail[indexPath.row].StartTime)"
        cell.endTimeLabel.text = "End Time - \(classesDetail[indexPath.row].EndTime)"
        cell.venueLabel.text = "Venue - \(classesDetail[indexPath.row].Vanue)"
        let string = groupclass?.Name
        let components = string?.components(separatedBy: " ")
        cell.trainerLabel.text = "Trainer - \(components?.last ?? "")"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
