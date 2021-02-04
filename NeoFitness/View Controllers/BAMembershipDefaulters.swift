//
//  BAMembershipDefaulters.swift
//  NeoFitness
//
//  Created by mac on 29/03/20.
//  Copyright © 2020 dmondo. All rights reserved.
//


import Foundation
import UIKit

class BAMembershipDefaulters: UIViewController {
    
    var parser = XMLParser()
    var currentParsingElement = String()
    
    var CustomerName = String()
    var ContactNo = String()
    var ReferredBy = String()
       
    var PackageName = String()
    var BranchId = String()
      
    var MembershipStartDate = String()
    var MembershipExpiryDate = String()
    var LastAttendanceDate = String()
    
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var tag = -1
    var selectedDate: Date?
    var popupVC:NoCreditViewController?
       
    var startDate = ""
    var endDate = ""
    
    var membershipDefaulter = [MembershipDefaulter]()
     @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
     @IBOutlet weak var countLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setDate(date: selectedDate ?? Date())
        self.tableView.tableFooterView = UIView()
        
    }
    
      @IBAction func showDatePicker(_ sender: UIButton) {
              self.tag = sender.tag
              datePicker = UIDatePicker.init()
              datePicker.backgroundColor = UIColor.white

              datePicker.autoresizingMask = .flexibleWidth
              datePicker.datePickerMode = .date
              datePicker.maximumDate = Date()

              datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
              datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
              self.view.addSubview(datePicker)

              toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
              toolBar.barStyle = .blackTranslucent
              toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
              toolBar.sizeToFit()
              self.view.addSubview(toolBar)
          }

          @objc func dateChanged(_ sender: UIDatePicker?) {
             
              if let date = sender?.date {
                  self.selectedDate = date
                  //self.setDate(date: date)
                  
              }
          }

          @objc func onDoneButtonClick() {
              toolBar.removeFromSuperview()
              datePicker.removeFromSuperview()
              self.setDate(date: self.selectedDate ?? Date())
          }
          
          func setDate(date: Date) {
              self.setDateParam(date: date)
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "dd-MM-yyyy"
              
              if self.tag == 1 {
                 self.startDateButton.titleLabel?.text = "Start Date: \(self.startDate)"
              
              } else if self.tag == 2 {
                  self.endDateButton.titleLabel?.text = "End Date: \(self.endDate)"
                  
              } else {
                  self.startDateButton.setTitle("Start Date: \(dateFormatter.string(from: date))", for: UIControl.State())
                  self.endDateButton.setTitle("End Date: \(dateFormatter.string(from: date))", for: UIControl.State())
              }
              self.getDashoard()
          }
          
          func setDateParam(date: Date) {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MMM-dd"
              
              if self.tag == 1 {
                  self.startDate = dateFormatter.string(from: date)
                     
              } else if self.tag == 2 {
                  self.endDate = dateFormatter.string(from: date)
                        
              } else {
                  self.startDate = dateFormatter.string(from: date)
                  self.endDate = dateFormatter.string(from: date)
              }
          }
    
    func dateString(dateString: String) -> String {
           
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
           let dateFromString = dateFormatter.date(from: dateString)
           dateFormatter.dateFormat = "dd-MMM-yyyy"
           let datenew = dateFormatter.string(from: dateFromString!)
           return datenew
       }
    
    func getDashoard() {
            
        let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
        let branchId =    UserDefaults.standard.string(forKey: "BranchId") ?? ""
               
        let params =  "strXml=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential><CustomerMembershipExpiry><MembershipExpiry><BranchId>\(branchId)</BranchId><StartDate>\(startDate)</StartDate><EndDate>\(endDate)</EndDate><PackageCategoryId>0</PackageCategoryId></MembershipExpiry></CustomerMembershipExpiry></NeoFitnes>"
    
        let data = params.data(using: .utf8, allowLossyConversion: true)
            
           // let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetAllBranchWiseGroupClasses"
            let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetListOfCustomerMembershipDefaulters"
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
   
                    return
                }
            }
            task.resume()
        }
}


extension BAMembershipDefaulters: XMLParserDelegate {


    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentParsingElement = elementName
        
        if elementName == "CustomerMembershipExpiry" {
            
            CustomerName = String()
            ContactNo = String()
            ReferredBy = String()
                  
            PackageName = String()
            BranchId = String()
                 
            MembershipStartDate = String()
            MembershipExpiryDate = String()
            LastAttendanceDate = String()
            
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "CustomerMembershipExpiry" {
            
            let defaulter = MembershipDefaulter(CustomerName: CustomerName, ContactNo: ContactNo, ReferredBy: ReferredBy, PackageName: PackageName, BranchId: BranchId, MembershipStartDate: MembershipStartDate, MembershipExpiryDate: MembershipExpiryDate, LastAttendanceDate: LastAttendanceDate)
            self.membershipDefaulter.append(defaulter)
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            if (!foundedChar.isEmpty) {
              
                if currentParsingElement == "CustomerName" {
                    CustomerName += foundedChar
                }
                else if currentParsingElement == "ContactNo" {
                    ContactNo += foundedChar

                } else if currentParsingElement == "ReferredBy" {
                    ReferredBy += foundedChar

                } else if currentParsingElement == "PackageName" {
                    PackageName += foundedChar

                } else if currentParsingElement == "BranchId" {
                    BranchId += foundedChar

                } else if currentParsingElement == "MembershipStartDate" {
                    MembershipStartDate += foundedChar
                               
                } else if currentParsingElement == "MembershipExpiryDate" {
                    MembershipExpiryDate += foundedChar
                               
                } else if currentParsingElement == "LastAttendanceDate" {
                    LastAttendanceDate += foundedChar
                               
                }
            }
        }
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        DispatchQueue.main.async {
        
            if self.membershipDefaulter.count == 0 {
                self.NoDataPopUp()
            }
            self.tableView.reloadData()
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
//BADefaulterTVC

extension BAMembershipDefaulters: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.countLabel.text = "Count: \(membershipDefaulter.count)"
        return membershipDefaulter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BADefaulterTVC", for: indexPath) as! BADefaulterTVC
        
        cell.customerNameLabel.text = "Customer Name: \t \t \t \t \t \(membershipDefaulter[indexPath.row].CustomerName)"
        cell.contactNumberLabel.text = "Contact No: \t\t\t\t\t \t \(membershipDefaulter[indexPath.row].ContactNo)"
        cell.categoryTypeLabel.text = "Category Type: \t\t\t\t \t \(membershipDefaulter[indexPath.row].ReferredBy)"
        cell.packageLabel.text = "Package: \t\t\t \(membershipDefaulter[indexPath.row].PackageName)"
        cell.membershipStartDatelabel.text = "Start Date: \t\t\t\t\t\t \(self.dateString(dateString:membershipDefaulter[indexPath.row].MembershipStartDate))"
        cell.membershipExpiryLabel.text = "End Date: \t\t\t\t\t\t \(self.dateString(dateString: membershipDefaulter[indexPath.row].MembershipExpiryDate))"
        cell.attendenceLabel.text = "Last Attendance \t\t\t\t\t\(self.dateString(dateString:membershipDefaulter[indexPath.row].LastAttendanceDate))"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


struct MembershipDefaulter {
        
    var CustomerName:String = ""
    var ContactNo:String = ""
    var ReferredBy:String = ""
    
    var PackageName:String = ""
    var BranchId:String = ""
   
    var MembershipStartDate:String = ""
    var MembershipExpiryDate:String = ""
    var LastAttendanceDate:String = ""

}
