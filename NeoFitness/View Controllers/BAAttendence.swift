//
//  BAAttendence.swift
//  NeoFitness
//
//  Created by mac on 29/03/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import Foundation
import UIKit

class BAAttendence: UIViewController {
    
    var parser = XMLParser()
    var currentParsingElement = String()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    
    var tag = -1
    var selectedDate: Date?
    var popupVC:NoCreditViewController?
      
    var startDate = ""
    var endDate = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDashoard()
        self.tableView.tableFooterView = UIView()
        self.countLabel.text = "Count: 0"
    }
    
//    @IBAction func showDatePicker(_ sender: UIButton) {
//           self.tag = sender.tag
//           datePicker = UIDatePicker.init()
//           datePicker.backgroundColor = UIColor.white
//
//           datePicker.autoresizingMask = .flexibleWidth
//           datePicker.datePickerMode = .date
//           datePicker.maximumDate = Date()
//
//           datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
//           datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
//           self.view.addSubview(datePicker)
//
//           toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
//           toolBar.barStyle = .blackTranslucent
//           toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
//           toolBar.sizeToFit()
//           self.view.addSubview(toolBar)
//       }
//
//       @objc func dateChanged(_ sender: UIDatePicker?) {
//
//           if let date = sender?.date {
//               self.selectedDate = date
//               //self.setDate(date: date)
//
//           }
//       }
//
//       @objc func onDoneButtonClick() {
//           toolBar.removeFromSuperview()
//           datePicker.removeFromSuperview()
//           self.setDate(date: self.selectedDate ?? Date())
//       }
//
//       func setDate(date: Date) {
//           self.setDateParam(date: date)
//           let dateFormatter = DateFormatter()
//           dateFormatter.dateFormat = "dd-MM-yyyy"
//
//           if self.tag == 1 {
//              self.startDateButton.titleLabel?.text = "Start Date: \(self.startDate)"
//
//           } else if self.tag == 2 {
//               self.endDateButton.titleLabel?.text = "End Date: \(self.endDate)"
//
//           } else {
//               self.startDateButton.setTitle("Start Date: \(dateFormatter.string(from: date))", for: UIControl.State())
//               self.endDateButton.setTitle("End Date: \(dateFormatter.string(from: date))", for: UIControl.State())
//           }
//           self.getDashoard()
//       }
//
//       func setDateParam(date: Date) {
//           let dateFormatter = DateFormatter()
//           dateFormatter.dateFormat = "yyyy-MM-dd"
//
//           if self.tag == 1 {
//               self.startDate = dateFormatter.string(from: date)
//
//           } else if self.tag == 2 {
//               self.endDate = dateFormatter.string(from: date)
//
//           } else {
//               self.startDate = dateFormatter.string(from: date)
//               self.endDate = dateFormatter.string(from: date)
//           }
//       }
       
    
    
    func getDashoard() {
        
        
      let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
      let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
      let branchId =    UserDefaults.standard.string(forKey: "BranchId") ?? ""
         
      let params =  "strXml=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential><Last3DaysAttendance><Attendance><BranchId>\(branchId)</BranchId></Attendance></Last3DaysAttendance></NeoFitnes>"
      let data = params.data(using: .utf8, allowLossyConversion: true)
            
           // let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetAllBranchWiseGroupClasses"
            let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetLast3DaysAttendanceReport"
            guard let todosURL = URL(string: todosEndpoint) else {
                print("Error: cannot create URL")
                return
            }
            
            var request = URLRequest(url: todosURL)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) {
                (data, response, error) in
                guard error == nil else {
                    print("error calling POST on /todos/1")
                    print(error!)
                    return
                }
                guard let responseData = data else {
                    
                    print("Error: did not receive data")
                    return
                }
                
                print(responseData.debugDescription)
                // parse the result as JSON, since that's what the API provides
                do {
                    
                    let dict = try XMLReader.dictionary(forXMLData: responseData)
                    let str =  dict["string"]
                    print(str)
                    let txt = (str as AnyObject).value(forKey: "text") as! String
                    let txtdata = txt.data(using: .utf8)
                    
                    self.parser = XMLParser(data: txtdata!)
                    self.parser.delegate = self
                    self.parser.parse()
                    
                } catch  {
                    print(error.localizedDescription)
                    print("error parsing response from POST on /todos")
    //                DispatchQueue.main.async {
    //                    self.showErrorAlert(title: "Neo", message: error.localizedDescription)
    //                }
                                  
                    return
                }
            }
            task.resume()
        }
}


extension BAAttendence: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentParsingElement = elementName
        
        if elementName == "PackageWiseCollectionReport" {
            
//            PackageId = String()
//            BranchId = String()
//            PackageName = String()
//            PackageTenure = String()
//            PackageCount = String()
//            PackageCollection = String()
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "PackageWiseCollectionReport" {
//            let package = PackageCollections(PackageId: PackageId, BranchId: BranchId, PackageName: PackageName, PackageTenure: PackageTenure, PackageCount: PackageCount, PackageCollection: PackageCollection)
//            self.packageCollection.append(package)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        if (!foundedChar.isEmpty) {
                       
            if currentParsingElement == "PackageId" {
               // PackageId += foundedChar
            }
            else if currentParsingElement == "BranchId" {
               // BranchId += foundedChar

            } else if currentParsingElement == "PackageName" {
                //PackageName += foundedChar

            } else if currentParsingElement == "PackageTenure" {
                //PackageTenure += foundedChar

            } else if currentParsingElement == "PackageCount" {
               // PackageCount += foundedChar

            } else if currentParsingElement == "PackageCollection" {
                //PackageCollection += foundedChar
                           
            }
        }
    }
    
    
    func parserDidEndDocument(_ parser: XMLParser) {

        DispatchQueue.main.async {
        
//            if self.packageCollection.count == 0 {
//                print("no data")
//            }
           // self.tableView.reloadData()
        }
    }
    
    func NoDataPopUp() {
        popupVC = NoCreditViewController(nibName: "NoCreditViewController", bundle: nil)
        
        if let popupVC = popupVC {
            
            popupVC.view.center = self.view.center
            popupVC.noCreditButton.addTarget(self, action: #selector(dismissPopupActionTapped(_:)), for: .touchUpInside)
            self.view.addSubview(popupVC.view)
        }
    }
    
    @objc func dismissPopupActionTapped(_ sender :UIButton) {
          if let popupVC = popupVC {
              popupVC.view.removeFromSuperview()
          }
    }
    
    
}


//extension BAAttendence: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //return self.packageCollection.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "BABaseTVCell", for: indexPath) as! BABaseTVCell
//        cell.headerLabel.text = "Package Name:"
//        cell.headerDataLabel.text = self.packageCollection[indexPath.row].PackageName
//        cell.subDetailOneLabel.text = "Tenure: \t \t \t \t \t \t \t \t \(self.packageCollection[indexPath.row].PackageTenure)"
//        cell.subDetailTwoLabel.text = "Package Sold: \t \t \t \t \t \t \t \(self.packageCollection[indexPath.row].PackageCount)"
//        return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 125
//    }
//}
