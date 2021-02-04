//
//  BAHome.swift
//  NeoFitness
//
//  Created by mac on 29/03/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import Foundation
import UIKit


class BAHome: UIViewController {
    
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var attendanceView: UIView!
    @IBOutlet weak var enquiryView: UIView!
    @IBOutlet weak var expiryView: UIView!
    @IBOutlet weak var activeView: UIView!
    
    @IBOutlet weak var shiftView: UIView!
    @IBOutlet weak var membershipView: UIView!
    @IBOutlet weak var genderAttendance: UIView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var workoutView: UIView!
    @IBOutlet weak var dietView: UIView!
    @IBOutlet weak var fitnessAssesment: UIView!
    @IBOutlet weak var medicalAssesment: UIView!
    
    @IBOutlet weak var colelcrionsLAbel: UILabel!
    @IBOutlet weak var collectionDataLabel: UILabel!
    @IBOutlet weak var attendenceLabel: UILabel!
    @IBOutlet weak var enquiryLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var attendenceDataLabel: UILabel!
    @IBOutlet weak var enquiryDataLabel: UILabel!
    @IBOutlet weak var expiryDataLabel: UILabel!
    @IBOutlet weak var activeDataLabel: UILabel!
    
     @IBOutlet weak var shiftLabel: UILabel!
     @IBOutlet weak var membershipLabel: UILabel!
     @IBOutlet weak var shiftDataLabel: UILabel!
     @IBOutlet weak var membershipDataLabel: UILabel!
    
    @IBOutlet weak var genderattendenceLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var genderattendenceDataLabel: UILabel!
    @IBOutlet weak var balanceDataLabel: UILabel!
    
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var dietLabel: UILabel!
    @IBOutlet weak var workoutDataLabel: UILabel!
    @IBOutlet weak var dietDataLabel: UILabel!
    
    @IBOutlet weak var fitnessLabel: UILabel!
    @IBOutlet weak var medicalassesmentLabel: UILabel!
    @IBOutlet weak var fitnessDataLabel: UILabel!
    @IBOutlet weak var medicalDataLabel: UILabel!
    
    @IBOutlet weak var hamburgerMenuButton: UIBarButtonItem!
    @IBOutlet weak var hamburgerButton: UIButton!
    
    var parser = XMLParser()
    var currentParsingElement = String()
    
    var BranchId = String()
    var TodaysCollection = String()
    var TodaysAttendance = String()
    var TodaysInquiry = String()
    var TodaysBalance = String()
    var TodaysCustomerExpiry = String()
    var TodaysActiveMembers = String()
    
    var MaleCount = String()
    var FemaleCount = String()
    var TotalGenderCount = String()
    
    
    var MorningAttendance = String()
    var AfternoonAttendance = String()
    var EveningAttendance = String()
    
    var PaymentCollection = String()
    
    var PackageAmount = String()
    var TotalAmount = String()
    var Discount = String()
    var NetAmount = String()
    var PaidAmount = String()
    var Balance = String()
    
    var PendingDeitCard = String()
    var RenewalDeitCard = String()

    var PendingMedicalAssessment = String()
    var RenewalMedicalAssessment = String()
    
    var PendingWorkoutCard = String()
    var RenewalWorkoutCard = String()
    
    var PendingCustomerAssessment = String()
    var RenewalCustomerAssessment = String()
    
    var dashboard = Dashboard()
    var genderWiseMembership = GenderWiseMembership()
    var genderWiseAttendence = GenderWiseAttendence()
    var paymentCollected = PaymentCollected()
    var balanceCollection = BalanceCollection()
    
    var deitCard = DeitCard()
    var medicalAssessment = MedicalAssessment()
    var workoutCard = WorkoutCard()
    var fitnessAssesmnt = FitnessAssesment()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
//        let logoutBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
//       self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
       
        self.getDashoard()
        self.genderWiseJoinedDashboardData()
        self.genderWiseAttendenceDashboardData()
        self.getCollectionDashboardData()
        self.getBalanceDashboardData()
        self.getMedicalDashboardData()
        self.getDietDashboardData()
        self.getWorkoutDashboardData()
        self.getFitnessDashboardData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // self.revealViewController().revealToggle(self)
         self.setupHamburgerMenu()
    }
    
    @objc private func handleEditBtn() {
        print("clicked on Edit btn")
       if self.revealViewController() != nil {
            self.hamburgerMenuButton.target = revealViewController()
            self.hamburgerMenuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
//    @IBAction func toggleButton(_ sender: Any) {
//        if self.revealViewController() != nil {
//            self.hamburgerMenuButton.target = revealViewController()
//            self.hamburgerMenuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
//    }
    
    func setupHamburgerMenu() {
        print("frgrg")
        if self.revealViewController() != nil {
            self.hamburgerMenuButton.target = revealViewController()
            self.hamburgerMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func getFitnessDashboardData() {
        
        let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
        let branchId =    UserDefaults.standard.string(forKey: "BranchId") ?? ""

        let params =  "strXml=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential><CustomerAssessment><Assessment><BranchId>\(branchId)</BranchId><StartDate>2016-04-04</StartDate></Assessment></CustomerAssessment></NeoFitnes>"
        
        let data = params.data(using: .utf8, allowLossyConversion: true)
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetPendingCustomerAssessmentReport"
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
    
    
    
    
    func getMedicalDashboardData() {
        
        let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
        let branchId =    UserDefaults.standard.string(forKey: "BranchId") ?? ""

        let params =  "strXml=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential><PendingMedicalAssessment><PathLabCustomerTestDetails><BranchId>\(branchId)</BranchId><StartDate>2016-04-04</StartDate></PathLabCustomerTestDetails></PendingMedicalAssessment></NeoFitnes>"
        
        let data = params.data(using: .utf8, allowLossyConversion: true)
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetPendingMedicalAssessmentReport"
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
    
    
    func getDietDashboardData() {
        
        let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
        let branchId =    UserDefaults.standard.string(forKey: "BranchId") ?? ""

        let params =  "strXml=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential><DietCard><Diet><BranchId>\(branchId)</BranchId><StartDate>2016-04-04</StartDate></Diet></DietCard></NeoFitnes>"
        
        let data = params.data(using: .utf8, allowLossyConversion: true)
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetPendingDeitCardReport"
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
    
    
    func getWorkoutDashboardData() {

        
        let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
        let branchId =    UserDefaults.standard.string(forKey: "BranchId") ?? ""

        let params =  "strXml=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential><WorkoutCard><Workout><BranchId>\(branchId)</BranchId><StartDate>2016-04-04</StartDate></Workout></WorkoutCard></NeoFitnes>"
        
        let data = params.data(using: .utf8, allowLossyConversion: true)
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetPendingWorkoutCardReport"
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
    
    
    func getBalanceDashboardData() {

        
                let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
                let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
                let branchId =    UserDefaults.standard.string(forKey: "BranchId") ?? ""

                let params =  "strXml=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential><BalanceCollection><Balance><BranchId>\(branchId)</BranchId><StartDate>2016-04-04</StartDate></Balance></BalanceCollection></NeoFitnes>"

                let data = params.data(using: .utf8, allowLossyConversion: true)
                let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetBalanceCollectionReport"
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
    
    
    
    func getCollectionDashboardData() {
      
            
                let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
                let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
                let branchId =    UserDefaults.standard.string(forKey: "BranchId") ?? ""
                      
                let params =  "strXml=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential><PaymentCollection><Payment><BranchId>\(branchId)</BranchId><StartDate>2016-04-04</StartDate><EndDate>2020-04-04</EndDate></Payment></PaymentCollection></NeoFitnes>"
               
                let data = params.data(using: .utf8, allowLossyConversion: true)
                let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetPaymentCollectionReport"
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
    
    func genderWiseAttendenceDashboardData() {
        
            let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
            let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
            let branchId =    UserDefaults.standard.string(forKey: "BranchId") ?? ""
                  
            let params =  "strXml=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential><CustomersAttendanceGenderWiseReport><CustomersAttendanceGenderWise><BranchId>\(branchId)</BranchId><StartDate>2016-04-04</StartDate><EndDate>2020-04-04</EndDate></CustomersAttendanceGenderWise></CustomersAttendanceGenderWiseReport></NeoFitnes>"
           
            let data = params.data(using: .utf8, allowLossyConversion: true)
            let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetCustomersAttendanceGenderWiseReport"
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
    
    
    func genderWiseJoinedDashboardData() {
        
            let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
            let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
            let branchId =    UserDefaults.standard.string(forKey: "BranchId") ?? ""
                  
            let params =  "strXml=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential><CustomersGenderWiseJoined><CustomersGenderWise><BranchId>\(branchId)</BranchId><StartDate>2016-04-04</StartDate><EndDate>2020-04-04</EndDate></CustomersGenderWise></CustomersGenderWiseJoined></NeoFitnes>"
           
            let data = params.data(using: .utf8, allowLossyConversion: true)
            let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetCustomersGenderWiseJoinedReport"
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
    
    func getDashoard() {
        
        let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
              
        let params =  "strXml=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential></NeoFitnes>"
       
        let data = params.data(using: .utf8, allowLossyConversion: true)
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetXMLForDashBoardReport"
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


extension BAHome: XMLParserDelegate {
    

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentParsingElement = elementName
        
        if elementName == "DashBoard" {
                   
                BranchId = String()
                TodaysCollection = String()
                TodaysAttendance = String()
                TodaysInquiry = String()
                TodaysBalance = String()
                TodaysCustomerExpiry = String()
                TodaysActiveMembers = String()
        
        } else if elementName == "CustomersGenderWiseJoinedReport" {
            MaleCount = String()
            FemaleCount = String()
            TotalGenderCount = String()
        
        } else if elementName == "CustomersAttendanceGenderWiseReport" {
            
            MorningAttendance = String()
            AfternoonAttendance = String()
            EveningAttendance = String()
            MaleCount = String()
            FemaleCount = String()
            
        } else if elementName == "PaymentCollectionReport" {
             PaymentCollection = String()
        
        }else if elementName == "BalanceCollectionReport" {
            PackageAmount = String()
            TotalAmount = String()
            Discount = String()
            NetAmount = String()
            PaidAmount = String()
            Balance = String()
            
        } else if elementName == "PendingDeitCardReport" {
            PendingDeitCard = String()
            RenewalDeitCard = String()

        } else if elementName == "PendingWorkoutCardReport" {
            PendingWorkoutCard = String()
            RenewalWorkoutCard = String()
            
        } else if elementName == "PendingMedicalAssessmentReport" {
            
            PendingMedicalAssessment = String()
            RenewalMedicalAssessment = String()
            
        } else if elementName == "PendingCustomerAssessment" {
            PendingCustomerAssessment = String()
            RenewalCustomerAssessment = String()
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "DashBoard" {
            self.dashboard = Dashboard(BranchId: BranchId, TodaysCollection: TodaysCollection, TodaysAttendance: TodaysAttendance, TodaysInquiry: TodaysInquiry, TodaysBalance: TodaysBalance, TodaysCustomerExpiry: TodaysCustomerExpiry, TodaysActiveMembers: TodaysActiveMembers)

        } else if elementName == "CustomersGenderWiseJoinedReport" {
            self.genderWiseMembership = GenderWiseMembership(MaleCount: MaleCount, FemaleCount: FemaleCount, TotalGenderCount: TotalGenderCount)
        
        } else if elementName == "CustomersAttendanceGenderWiseReport" {
            self.genderWiseAttendence = GenderWiseAttendence(MorningAttendance: MorningAttendance, AfternoonAttendance: AfternoonAttendance, EveningAttendance: EveningAttendance, MaleCount: MaleCount, FemaleCount: FemaleCount)
            
        } else if elementName == "PaymentCollectionReport" {
            self.paymentCollected = PaymentCollected(PaymentCollection: PaymentCollection)
            
        } else if elementName == "BalanceCollectionReport" {
            self.balanceCollection = BalanceCollection(PackageAmount: PackageAmount, TotalAmount: TotalAmount, Discount: Discount, NetAmount: NetAmount, PaidAmount: PaidAmount, Balance: Balance)
        
        } else if elementName == "PendingDeitCardReport" {
            self.deitCard = DeitCard(PendingDeitCard: PendingDeitCard, RenewalDeitCard: RenewalDeitCard)
       
        } else if elementName == "PendingWorkoutCardReport" {
            self.workoutCard = WorkoutCard(PendingWorkoutCard: PendingWorkoutCard, RenewalWorkoutCard: RenewalWorkoutCard)
       
        } else if elementName == "PendingMedicalAssessmentReport" {
            self.medicalAssessment = MedicalAssessment(PendingMedicalAssessment: PendingMedicalAssessment, RenewalMedicalAssessment: RenewalMedicalAssessment)
            
        } else if elementName == "PendingCustomerAssessment" {
            self.fitnessAssesmnt = FitnessAssesment(PendingCustomerAssessment: PendingCustomerAssessment, RenewalCustomerAssessment: RenewalCustomerAssessment)
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            if (!foundedChar.isEmpty) {
                           
                if currentParsingElement == "TodaysCollection" {
                    TodaysCollection += foundedChar
                }
                else if currentParsingElement == "BranchId" {
                    BranchId += foundedChar

                } else if currentParsingElement == "TodaysAttendance" {
                    TodaysAttendance += foundedChar

                } else if currentParsingElement == "TodaysInquiry" {
                    TodaysInquiry += foundedChar

                } else if currentParsingElement == "TodaysBalance" {
                    TodaysBalance += foundedChar

                } else if currentParsingElement == "TodaysCustomerExpiry" {
                    TodaysCustomerExpiry += foundedChar
                               
                } else if currentParsingElement == "TodaysActiveMembers" {
                    TodaysActiveMembers += foundedChar
                               
                } else if currentParsingElement == "MaleCount" {
                     MaleCount += foundedChar
                    
                } else if currentParsingElement == "FemaleCount" {
                     FemaleCount += foundedChar
                    
                } else if currentParsingElement == "TotalGenderCount" {
                     TotalGenderCount += foundedChar
                    
                } else if currentParsingElement == "MorningAttendance" {
                     MorningAttendance += foundedChar
                    
                } else if currentParsingElement == "AfternoonAttendance" {
                     AfternoonAttendance += foundedChar
                    
                } else if currentParsingElement == "EveningAttendance" {
                     EveningAttendance += foundedChar
                    
                } else if currentParsingElement == "PaymentCollection" {
                     PaymentCollection += foundedChar
               
                } else if currentParsingElement == "PackageAmount" {
                     PackageAmount += foundedChar
               
                } else if currentParsingElement == "TotalAmount" {
                     TotalAmount += foundedChar
                
                } else if currentParsingElement == "Discount" {
                     Discount += foundedChar
                
                } else if currentParsingElement == "NetAmount" {
                     NetAmount += foundedChar
                
                } else if currentParsingElement == "PaidAmount" {
                     PaidAmount += foundedChar
                
                } else if currentParsingElement == "Balance" {
                     Balance += foundedChar
                
                } else if currentParsingElement == "PendingDeitCard" {
                     PendingDeitCard += foundedChar
                
                } else if currentParsingElement == "RenewalDeitCard" {
                     RenewalDeitCard += foundedChar
                
                } else if currentParsingElement == "PendingWorkoutCard" {
                     PendingWorkoutCard += foundedChar
                
                } else if currentParsingElement == "RenewalWorkoutCard" {
                     RenewalWorkoutCard += foundedChar
                
                } else if currentParsingElement == "PendingMedicalAssessment" {
                     PendingMedicalAssessment += foundedChar
               
                } else if currentParsingElement == "RenewalMedicalAssessment" {
                     RenewalMedicalAssessment += foundedChar
                
                } else if currentParsingElement == "PendingCustomerAssessment" {
                     PendingCustomerAssessment += foundedChar
                
                } else if currentParsingElement == "RenewalCustomerAssessment" {
                     RenewalCustomerAssessment += foundedChar
                
                }
            }
        }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        DispatchQueue.main.async {[weak self] in
            
            self?.fitnessDataLabel.text = "P: \(self?.fitnessAssesmnt.PendingCustomerAssessment ?? "") R: \(self?.fitnessAssesmnt.RenewalCustomerAssessment ?? "")"
            self?.medicalDataLabel.text = "P: \(self?.medicalAssessment.PendingMedicalAssessment ?? "") R: \(self?.medicalAssessment.RenewalMedicalAssessment ?? "")"
            self?.dietDataLabel.text = "P: \(self?.deitCard.PendingDeitCard ?? "") R: \(self?.deitCard.RenewalDeitCard ?? "")"
            self?.workoutDataLabel.text = "P: \(self?.workoutCard.PendingWorkoutCard ?? "") R: \(self?.workoutCard.RenewalWorkoutCard ?? "")"
            self?.balanceDataLabel.text = "\(self?.balanceCollection.Balance ?? "")"
            self?.attendenceDataLabel.text = "\(self?.dashboard.TodaysAttendance ?? "") Today"
            self?.enquiryDataLabel.text = "\(self?.dashboard.TodaysInquiry ?? "") Today"
            self?.expiryDataLabel.text = "\(self?.dashboard.TodaysCustomerExpiry ?? "") Today"
            self?.activeDataLabel.text = "\(self?.dashboard.TodaysActiveMembers ?? "") Today"
            self?.membershipDataLabel.text = "Male: \(self?.genderWiseMembership.MaleCount ?? "") Female: \(self?.genderWiseMembership.FemaleCount ?? "")"
            self?.genderattendenceDataLabel.text = "Male: \(self?.genderWiseAttendence.MaleCount ?? "") Female: \(self?.genderWiseAttendence.FemaleCount ?? "")"
            self?.collectionDataLabel.text = "\(self?.paymentCollected.PaymentCollection ?? "")"
            self?.shiftDataLabel.text = "M: \(self?.genderWiseAttendence.MorningAttendance ?? "") A: \(self?.genderWiseAttendence.AfternoonAttendance ?? "") E: \(self?.genderWiseAttendence.EveningAttendance ?? "")"
        }
    }
}

extension BAHome: SWRevealViewControllerDelegate {
   
}

struct Dashboard {
    
    var BranchId:String = ""
    var TodaysCollection:String = ""
    var TodaysAttendance:String = ""
    var TodaysInquiry:String = ""
    var TodaysBalance:String = ""
    var TodaysCustomerExpiry:String = ""
    var TodaysActiveMembers:String = ""
    
}

struct GenderWiseMembership {
 
    var MaleCount = ""
    var FemaleCount = ""
    var TotalGenderCount = ""
}

struct GenderWiseAttendence {
 
    var MorningAttendance = ""
    var AfternoonAttendance = ""
    var EveningAttendance = ""
    var MaleCount = ""
    var FemaleCount = ""
   
}

struct PaymentCollected {
    var PaymentCollection = ""
   
}

struct BalanceCollection {
    var PackageAmount = ""
    var TotalAmount = ""
    var Discount = ""
    var NetAmount = ""
    var PaidAmount = ""
    var Balance = ""
}

struct DeitCard {
    var PendingDeitCard = ""
    var RenewalDeitCard = ""
}

struct MedicalAssessment {
    var PendingMedicalAssessment = ""
    var RenewalMedicalAssessment = ""
}

struct WorkoutCard {
    var PendingWorkoutCard = ""
    var RenewalWorkoutCard = ""
}

struct FitnessAssesment {
    
    var PendingCustomerAssessment = ""
    var RenewalCustomerAssessment = ""
   
}

