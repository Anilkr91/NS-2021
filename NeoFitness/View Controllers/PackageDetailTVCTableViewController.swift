//
//  PackageDetailTVCTableViewController.swift
//  NeoFitness
//
//  Created by Sai Ram on 20/10/19.
//  Copyright © 2019 dmondo. All rights reserved.
//

import UIKit

class PackageDetailTVCTableViewController: UITableViewController {

    @IBOutlet weak var pkgImageView: UIImageView!
    @IBOutlet weak var sessionNameLabel: UILabel!
    @IBOutlet weak var sessionDescriptionLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var benefitsLabel: UILabel!
    @IBOutlet weak var bookClassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.title = AppNavigationTitle.packageDetail
        self.bookClassButton.cornerRadius = 20
         self.navigationController?.isNavigationBarHidden = false
        self.bookClassButton.addTarget(self, action: #selector(bookClassButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @objc func bookClassButtonTapped() {
        print("bookclass")
        //self.performSegue(withIdentifier: "showHomeSegue", sender: self)
    }
    
}

extension PackageDetailTVCTableViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
