//
//  RegistrationTableViewController.swift
//  NeoFitness
//
//  Created by Sai Ram on 13/10/19.
//  Copyright © 2019 dmondo. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController {

    lazy var datePicker = UIDatePicker()
    lazy var genderPicker = UIPickerView()
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var genderTextField: UITextField!
    
    var isEmailVerified = -1
    
    let genderArray = ["Male", "Female"]
    var expectedJoiningDate: String?
    var nextFollowUpDate: String?
    var parser = XMLParser()
    var currentParsingElement = String()
    var ErrorMessage = String()
    @objc var cityId:Int = 0
    @objc var packageId:Int = 0
    @objc var offerAmount:Int = 0
    @objc var amount: Int = 0
    @objc var packageAmount: Int = 0
    @objc var branchId: Int = 0
    
    var packages = [Package]()
    
    
//    var PackageId = String()
//    var BranchName = String()
//    var PackageName = String()
////    var Amount = String()
//    var PackageTenure = String()
//    var PackageTenureType = String()
//    var Session = String()
//    var OfferAmount = String()
//    var PkgMinAmount = String()
//    var OfferImage = String()
//    var FromDate = String()
//    var ToDate = String()
//    var Desc = String()
//    var DiscountPercent = String()
//    var TermsCondition = String()
    
    
    var Name = String()
    var BranchId = String()
    var Amount = String()
    var gstArray: [Tax] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackgroundImage()
        self.setupView()
        
        if branchId == 0 {
            return
        } else {
            self.TaxApi(branchId: branchId)
        }
        
    }
    

    // MARK: - Table view data sourceBhardwaj3780
    func setupView() {
        self.showDatePicker()
        self.showGenderPicker()
        self.loginButton.cornerRadius = 13
//        self.loginButton.addTarget(self, action: #selector(packageDetail), for: .touchUpInside)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       self.navigationController?.isNavigationBarHidden = false
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateOfBirth.inputAccessoryView = toolbar
        dateOfBirth.inputView = datePicker
        
    }
    
    func showGenderPicker() {
       
        genderPicker.dataSource = self
        genderPicker.delegate = self
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneGenderPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        genderTextField.inputAccessoryView = toolbar
        genderTextField.inputView = genderPicker
        
    }
    
    @objc func doneGenderPicker(){
        genderTextField.text = genderArray[0]
        self.view.endEditing(true)
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateOfBirth.text = formatter.string(from: datePicker.date)
    
        expectedJoiningDate = formatter.string(from: Date())
        nextFollowUpDate = formatter.string(from: Date())
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func setupBackgroundImage() {
        let backgroundImage = UIImage(named: "background")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
       
        print(emailAddressTextField.text!)
        
        if packageId == 0 {
            self.showPackageAlert(message: "Please select any package to complete registration.")
            return
        }
        
        if isEmailVerified == 0 {
            
            if phoneNumberTextField.text!.isEmpty {
                self.showErrorAler(message: "please fill phoneNumber")
                
            } else if phoneNumberTextField.text!.count > 10 {
               self.showErrorAler(message: "maximum 10 digit limit allowed")
            
            } else if phoneNumberTextField.text!.count < 10 {
            self.showErrorAler(message: "please fill minimum 10 digit ")
            
            } else if nameTextField.text!.isEmpty {
                self.showErrorAler(message: "please fill name")
            
            } else if dateOfBirth.text!.isEmpty {
                self.showErrorAler(message: "please fill DOB")
        
            } else if genderTextField.text!.isEmpty {
                self.showErrorAler(message: "please fill gender")
            
            } else {
              //initiatePayment()
                
            let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CustomPayTVC") as! CustomPayTVC
            
                
//                if packageAmount == 0 {
//                    
//                if offerAmount == 0 {
//                        vc.packageAmount = amount
//                } else {
//                       vc.packageAmount = offerAmount
//                }
//            }
              
           
            vc.packageAmount = packageAmount
            vc.phoneNumber = phoneNumberTextField.text!
            vc.name = nameTextField.text!
            vc.emailAddress = emailAddressTextField.text!
            vc.dateOfBirth = dateOfBirth.text!
            vc.gender = genderTextField.text!
            vc.cityId = cityId
            vc.packageId = packageId
            vc.offerAmount = offerAmount
            vc.amount = amount
            vc.branchId = "\(branchId)"
            vc.gstArray = self.gstArray
        
            self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        } else {
            
            if emailAddressTextField.text!.isEmpty {
                self.showErrorAler(message: "please fill email")
                
            }
            
            if isValidEmail(email: emailAddressTextField.text!) == false {
                self.showErrorAler(message: "Enter valid email")
            
            } else {
                self.verifyEmailAddress(email: emailAddressTextField.text!)
            }
        }
    }
    
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showErrorAler(message: String) {
        
        let alert = UIAlertController(title: "NEO", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func showPackageAlert(message: String) {
        
        let alert = UIAlertController(title: "NEO", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
//            let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "PackageListingTVC") as! PackageListingTVC
//            self.navigationController?.pushViewController(vc, animated: true)
            self.showLocationView(branchId: nil, cityId: nil)
        })
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func showExistingEmail(message: String) {
        
        let alert = UIAlertController(title: "NEO", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func goToLoginAlert( message: String) {
        
        let alert = UIAlertController(title: "NEO" , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Login", style: UIAlertAction.Style.destructive, handler: { action in
            self.navigationController?.popViewController(animated: true)
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showLocationView(branchId: Int?, cityId: Int?) {
        
        let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LocationTableViewController") as! LocationTableViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.branchId = branchId
        vc.cityId = cityId
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    
    
    func initiatePayment() {
        
        PayUServiceHelper.sharedManager()?.getPayment(self, "\(emailAddressTextField.text!)", "\(phoneNumberTextField.text!)", "\(nameTextField.text!)", "1000", randomString(length: 10), didComplete: { (dict, error) in
            if let error = error {
                print(error)
            
            } else {
                //self.NewEnquiryCall(transactionStatus: true, transActionId: self.randomString(length: 10), name: "\(self.nameTextField.text!)", packageId: "12345678")
            }
        }) { (error) in
            print(error.debugDescription)
        }
    }
    
    
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    func NewEnquiryCall(transactionStatus: Bool,  transActionId: String, payUAmount: Int, packageId: String) {
        
        
        let BranchID = self.branchId
        let paymentType = "PayUMoney"
        let bankName = "PayUMoney"
        let transactionId = transActionId
        let packageAmount = amount
        let discount = amount - offerAmount
        let netAmount = amount - offerAmount
        let paidAmount = payUAmount
        let balanceAmount = amount - payUAmount
        let transactionStatus = transactionStatus
        
        let computedSgst = payUAmount + (payUAmount * Int((self.gstArray[0].Amount))! / 100)
        let computedCgst = payUAmount + (payUAmount * Int((self.gstArray[1].Amount))! / 100)
        let taxAmount = computedSgst + computedCgst
        
        let params =  "strXMLs=<NeoFitnes><InquiryType><Customer><FirstName>\(nameTextField.text!)</FirstName><Gender>\(genderTextField.text!)</Gender><DOB>\(dateOfBirth.text!)</DOB><ContactNo>\(phoneNumberTextField.text!)</ContactNo><EmailId>\(emailAddressTextField.text!)</EmailId>\(BranchID)</BranchId></Customer><paymentdetails><PaymentType>\(paymentType)</PaymentType><BankName>\(bankName)</BankName>\(transactionId)</BankTransactionId><CardHolderName>\(nameTextField.text!)</CardHolderName><PackageId>\(packageId)</PackageId><PackageAmount>\(packageAmount)</PackageAmount><TotalAmount>\(packageAmount)</TotalAmount><Discount>\(discount)</Discount><NetAmount>\(netAmount)</NetAmount><PaidAmount>\(paidAmount)</PaidAmount><TaxAmount>\(taxAmount)</TaxAmount><Balance>\(balanceAmount)</Balance><BankTransactionStaus>\(transactionStatus)</BankTransactionStaus></paymentdetails><taxdetails><tax><TaxName>GST-SGST-9%</TaxName><Amount>\(self.gstArray[0].Amount)</Amount><TaxAmount>\(computedSgst)</TaxAmount></tax><tax><TaxName>GST-CGST-9%</TaxName><Amount>\(self.gstArray[1].Amount)</Amount><TaxAmount>\(computedCgst)</TaxAmount></tax></taxdetails></InquiryType></NeoFitnes>"
        let data = params.data(using: .utf8, allowLossyConversion: true)
        
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/InsertInquery"
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 7
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if isEmailVerified == -1 {
            
            if indexPath.row == 0 {
                return 160
                
            } else if indexPath.row == 1 {
                return 70
                
            } else if indexPath.row == 2 {
                return 0
            }
            else if indexPath.row == 3 {
                return 0
            }
            else if indexPath.row == 4 {
                return 0
            }
            else if indexPath.row == 5 {
                return 0
            
            } else if indexPath.row == 6 {
                return 60
           
            } else if indexPath.row == 7 {
                return 60
            
            } else {
                return 0
            }
            
        } else {
        
            if indexPath.row == 0 {
                return 160
            
            } else if indexPath.row == 1 {
                return 70
            
            } else if indexPath.row == 2 {
                return 80
            }
            else if indexPath.row == 3 {
                return 70
        }
            else if indexPath.row == 4 {
                return 70
        }
            else if indexPath.row == 5 {
                return 70
        }
            else if indexPath.row == 6 {
                return 60
            
            }else if indexPath.row == 7 {
              return 70
            
            }
            
            else {
                return 0
            }
    }
}
    
    func verifyEmailAddress(email: String) {
        
        let params =  "strXml=<NeoFitnes><ExistsEmail><EmailId>\(email)</EmailId></ExistsEmail></NeoFitnes>"
        let data = params.data(using: .utf8, allowLossyConversion: true)
        
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetExistsEmailID"
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
    
    func TaxApi(branchId: Int) {
        
        let params =  "strXml=<NeoFitnes><BranchWiseTax><BranchId>\(branchId)</BranchId></BranchWiseTax></NeoFitnes>"
        let data = params.data(using: .utf8, allowLossyConversion: true)
        
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetBranchWiseMobileTaxs"
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


extension RegistrationTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        genderTextField.text = genderArray[row]
        self.view.endEditing(true)
    }
}

extension RegistrationTableViewController: XMLParserDelegate {
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentParsingElement = elementName
        if elementName == "NeoFitness" {
            ErrorMessage = String()
            
        } else if elementName == "BranchWiseTax" {
            Name = String()
            BranchId = String()
            Amount = String()
            
        }
        
//        else if elementName == "BranchWithPackage" {
//
//                     PackageId = String()
//                     BranchName = String()
//                     PackageName = String()
//                     Amount = String()
//                     PackageTenure = String()
//                     PackageTenureType = String()
//                     Session = String()
//                     OfferAmount = String()
//                     OfferImage = String()
//                     FromDate = String()
//                     ToDate = String()
//                     Desc = String()
//                     DiscountPercent = String()
//                     TermsCondition = String()
//                     PkgMinAmount = String()
//
//        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
       
        if elementName == "BranchWiseTax" {
            
            let tax = Tax(Name: Name, BranchId: BranchId, Amount: Amount)
            self.gstArray.append(tax)
        
        }
        
//        else if elementName == "BranchWithPackage" {
//
//            let package = Package(packageId: PackageId, branchName: BranchName, packageName: PackageName, amount: Amount, packageTenure: PackageTenure, packageTenureType: PackageTenureType, session: Session, offerAmount: OfferAmount, offerImage: OfferImage, fromDate: FromDate, toDate: ToDate, description: Desc, discountPercent: DiscountPercent, termsCondition: TermsCondition, PkgMinAmount: PkgMinAmount)
//            self.packages.append(package)
//
//        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if currentParsingElement == "Message" {
            ErrorMessage += foundedChar
            
        } else if currentParsingElement == "Name" {
            Name += foundedChar
        
        } else if currentParsingElement == "Amount" {
            Amount += foundedChar
            
        
        } else if currentParsingElement == "BranchId" {
            BranchId += foundedChar
            
        } else if currentParsingElement == "result" {
            if foundedChar == "False" {
               isEmailVerified = 0
                
            } else {
               isEmailVerified = 1
            }
        }
        
//        else if currentParsingElement == "PackageId" {
//                           PackageId += foundedChar
//                       }
//                       else if currentParsingElement == "BranchName" {
//                           BranchName += foundedChar
//
//                       } else if currentParsingElement == "PackageName" {
//                           PackageName += foundedChar
//
//                       } else if currentParsingElement == "Amount" {
//                           Amount += foundedChar
//
//                       } else if currentParsingElement == "PackageTenure" {
//                           PackageTenure += foundedChar
//
//                       } else if currentParsingElement == "PackageTenureType" {
//                           PackageTenureType += foundedChar
//
//                       }  else if currentParsingElement == "Session" {
//                           Session += foundedChar
//
//                       }  else if currentParsingElement == "OfferAmount" {
//                           OfferAmount += foundedChar
//
//                       } else if currentParsingElement == "OfferImage" {
//                           OfferImage += foundedChar
//
//                       } else if currentParsingElement == "FromDate" {
//                           FromDate += foundedChar
//
//                       } else if currentParsingElement == "ToDate" {
//                           ToDate += foundedChar
//
//                       } else if currentParsingElement == "Description" {
//                           Desc += foundedChar
//
//                       } else if currentParsingElement == "DiscountPercent" {
//                           DiscountPercent += foundedChar
//
//                       } else if currentParsingElement == "TermsCondition" {
//                           TermsCondition += foundedChar
//
//            }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        DispatchQueue.main.async {
            print(self.gstArray)
            
            if self.ErrorMessage.isEmpty == false {
            self.goToLoginAlert(message: self.ErrorMessage)
            self.ErrorMessage = String()
        }
        
        if self.isEmailVerified == 0 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else if self.isEmailVerified == 1 {
            self.showExistingEmail(message: "You already have account. Please Login")
            
        }
    }
  }
}

struct Enquiry {
    var Name = String()
    var nameTextField  = String()
    var emailAddress  = String()
    var dateOfBirth = String()
    var genderTextField = String()
}


struct Tax {
    
    var Name:String = ""
    var BranchId:String = ""
    var Amount:String = ""
}



extension RegistrationTableViewController: locationDelegate {
    func didSelectLocation(location: Location) {
        print("location", location)
        self.showLocationView(branchId: 0, cityId: Int(location.cityId)!)
    }
    
    func didSelectSubLocation(location: SubLocation) {
        print("sublocation", location)
        self.branchId = Int(location.branchId)!
        let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PackageListingTVC") as! PackageListingTVC
        vc.branchId = Int(location.branchId)!
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RegistrationTableViewController: packageDelegate {
    func didSelectPackage(package: Package) {
        
        self.TaxApi(branchId: branchId)
        
        self.packageId = Int(package.packageId) ?? 0
        self.offerAmount = Int(package.offerAmount) ?? 0
        self.amount = Int(package.amount) ?? 0
        self.packageAmount = Int(package.PkgMinAmount) ?? 0
//        self.branchId = Int(package.bra)
        isEmailVerified = 0
        self.tableView.reloadData()
        
    }
}
