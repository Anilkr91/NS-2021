//
//  CustomPayTVC.swift
//  NeoFitness
//
//  Created by Sai Ram on 19/01/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import UIKit

protocol customPayDelegate: class {
    func didCustomPay(amount: String)
}

class CustomPayTVC: UITableViewController {

    @IBOutlet weak var payTextField: UITextField!
    weak var delegate: customPayDelegate?
    
    var phoneNumber = ""
    var name = ""
    var emailAddress = ""
    var dateOfBirth = ""
    var gender = ""
    
    var cityId:Int = 0
    var packageId:Int = 0
    var offerAmount:Int = 0
    var amount: Int = 0
    var packageAmount: Int = 0
    var branchId = ""
    var parser = XMLParser()
    var currentParsingElement = String()
    
    var Name = String()
    var BranchId = String()
    var Amount = String()
    var gstArray: [Tax] = []
    var isloggedIn = false
    var ErrorMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gstArray.count == 0 {
            self.TaxApi(branchId: Int(branchId)!)
        }
        
        if packageAmount <= 0 {
         self.payTextField.text = "\(amount)"
        } else {
          self.payTextField.text = "\(packageAmount)"
        }
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @IBAction func buyTapped(_ sender: Any) {
        
        let payAmount = Int(payTextField.text!) ?? 0
        
//         initiatePayment(pay: 1)
        
        if (payAmount < packageAmount) {
            showErrorAlert(message: "Cannot pay less than the Rs\(packageAmount)")

        } else if payAmount == 0 {
            showErrorAlert(message: "Cannot pay less than the Rs\(packageAmount)")
        
        } else {
            
            if UserDefaults.standard.bool(forKey: "currentUser") == true {
                self.isloggedIn = true
                self.phoneNumber = UserDefaults.standard.string(forKey: "CustomerContactNo") ?? ""
               // self.phoneNumber = "9976589540"
                self.name = UserDefaults.standard.string(forKey: "FirstName") ?? ""
                self.emailAddress = UserDefaults.standard.string(forKey: "UserName") ?? ""
                }
            
            initiatePayment(pay: payAmount)
//            initiatePayment(pay: 1)
        }
    }
    
    func initiatePayment(pay: Int) {
        
        PayUServiceHelper.sharedManager()?.getPayment(self, "\(emailAddress)", "\(phoneNumber)", "\(name)", "\(pay)", randomString(length: 10), didComplete: { (dict, error) in
            var bool: Bool?
           
            if let error = error {
                print(error)
                 let payuDict = PayUResponse(json: dict as! [String : Any])
                 let meCode = MeCodePayU(json: dict as! [String : Any])
                
                if payuDict.status == "success" {
                    bool = true
                } else if payuDict.status == "success" {
                    bool = false
                }
                
                if self.isloggedIn == true {
                    self.renewPackageCall(transactionStatus: false, transActionId: "\(payuDict.paymentId)", payUAmount: pay, Tkey: meCode.TKey, mId: meCode.MID)
                        
                } else {
                    self.NewEnquiryCall(transactionStatus: false, transActionId: "\(payuDict.paymentId)", payUAmount: pay, Tkey: meCode.TKey, mId: meCode.MID)
                    self.showErrorAlert(message: error.localizedDescription)
                               
                }
                
//                self.NewEnquiryCall(transactionStatus: false, transActionId: payuDict.paymentId, payUAmount: pay, Tkey: meCode.TKey, mId: meCode.MID)
//                self.showErrorAlert(message: error.localizedDescription)
           
            } else {
                
                print(dict)
                let result = dict?["result"] as! [String : Any]
                
                let payuDict = PayUResponse(json: result)
               
                print(payuDict.paymentId)
                print(payuDict.status)
                print(payuDict.pg_TYPE)
                print(payuDict.bankcode)
               
                
                 var mCode = result["meCode"] as! String
                mCode.insert("\"", at: mCode.endIndex)
                mCode.insert("}", at: mCode.endIndex)
                                  
                let dict = self.convertToDictionary(text: mCode)!
                let meCode = MeCodePayU(json: dict)
                print(meCode.MID)
                print(meCode.TKey)
                
                if payuDict.status == "success" {
                   bool = true
                } else if payuDict.status == "success" {
                   bool = false
                }
                
                if self.isloggedIn == true {
                    self.renewPackageCall(transactionStatus: true, transActionId: "\(payuDict.paymentId)", payUAmount: pay, Tkey: meCode.TKey, mId: meCode.MID)
                 } else {
                   self.NewEnquiryCall(transactionStatus: true, transActionId: "\(payuDict.paymentId)", payUAmount: pay, Tkey: meCode.TKey, mId: meCode.MID)
                }
            }
        }) { (error) in
            print(error.debugDescription)
            
            if self.isloggedIn == true {
                    self.renewPackageCall(transactionStatus: false, transActionId: self.randomString(length: 10), payUAmount: pay, Tkey: "0", mId: "0")
                } else {
                    self.NewEnquiryCall(transactionStatus: false, transActionId: self.randomString(length: 10), payUAmount: pay, Tkey: "0", mId: "0")
                    self.showErrorAlert(message: error?.localizedDescription ?? "")
                
                }
            
//            self.NewEnquiryCall(transactionStatus: false, transActionId: self.randomString(length: 10), payUAmount: pay, Tkey: "0", mId: "0")
//            self.showErrorAlert(message: error?.localizedDescription ?? "")
//
//            (transactionStatus: false, transActionId: self.randomString(length: 10), name: "\(self.name)", packageId: "12345678")
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    func showSucessAlert(message: String) {
        
        let alert = UIAlertController(title: "NEO", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
     func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "NEO", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.payTextField.text = "\(self.amount)"
        })
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func successAlert(message: String) {
        let alert = UIAlertController(title: "NEO", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(ok)
       
       
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    
    func renewPackageCall(transactionStatus: Bool,  transActionId: String, payUAmount: Int, Tkey: String, mId: String) {
        
        let userName =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        let password =  UserDefaults.standard.string(forKey: "Pass") ?? ""
        let memberID =   UserDefaults.standard.string(forKey: "MemberID") ?? ""
       // let BranchID = self.branchId
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
        
//
        
        let params =  "strXMLs=<NeoFitnes><Credential><UserName>\(userName)</UserName><Password>\(password)</Password></Credential><RenewalPackage><paymentdetails> <customerId>\(memberID)</customerId><PaymentType>\(paymentType)</PaymentType><BankName>\(bankName)</BankName><BankTransactionId>\(transactionId)</BankTransactionId><CardHolderName>\(name)</CardHolderName><PackageId>\(packageId)</PackageId><PackageAmount>\(packageAmount)</PackageAmount><TotalAmount>\(packageAmount)</TotalAmount><Discount>\(discount)</Discount><NetAmount>\(netAmount)</NetAmount><PaidAmount>\(paidAmount)</PaidAmount><TaxAmount>\(taxAmount)</TaxAmount><Balance>\(balanceAmount)</Balance><BankTransactionStatus>\(transactionStatus)</BankTransactionStatus><TKey>\(Tkey)</TKey><MID>\(mId)</MID></paymentdetails><taxdetails><tax><TaxName>GST-SGST-9%</TaxName><Amount>\(self.gstArray[0].Amount)</Amount><TaxAmount>\(computedSgst)</TaxAmount></tax><tax><TaxName>GST-CGST-9%</TaxName><Amount>\(self.gstArray[1].Amount)</Amount><TaxAmount>\(computedCgst)</TaxAmount></tax></taxdetails></RenewalPackage></NeoFitnes>"
        let data = params.data(using: .utf8, allowLossyConversion: true)
        
        print(params)
        
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/InsertRenewalPackageFromCustomer"
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
    
    
    
    func NewEnquiryCall(transactionStatus: Bool,  transActionId: String, payUAmount: Int, Tkey: String, mId: String) {
        
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
        
        let params =  "strXMLs=<NeoFitnes><InquiryType><Customer><FirstName>\(name)</FirstName><Gender>\(gender)</Gender><DOB>\(dateOfBirth)</DOB><ContactNo>\(phoneNumber)</ContactNo><EmailId>\(emailAddress)</EmailId><BranchId>\(BranchID)</BranchId></Customer><paymentdetails><PaymentType>\(paymentType)</PaymentType><BankName>\(bankName)</BankName><BankTransactionId>\(transactionId)</BankTransactionId><CardHolderName>\(name)</CardHolderName><PackageId>\(packageId)</PackageId><PackageAmount>\(packageAmount)</PackageAmount><TotalAmount>\(packageAmount)</TotalAmount><Discount>\(discount)</Discount><NetAmount>\(netAmount)</NetAmount><PaidAmount>\(paidAmount)</PaidAmount><TaxAmount>\(taxAmount)</TaxAmount><Balance>\(balanceAmount)</Balance><BankTransactionStatus>\(transactionStatus)</BankTransactionStatus><TKey>\(Tkey)</TKey><MID>\(mId)</MID></paymentdetails><taxdetails><tax><TaxName>GST-SGST-9%</TaxName><Amount>\(self.gstArray[0].Amount)</Amount><TaxAmount>\(computedSgst)</TaxAmount></tax><tax><TaxName>GST-CGST-9%</TaxName><Amount>\(self.gstArray[1].Amount)</Amount><TaxAmount>\(computedCgst)</TaxAmount></tax></taxdetails></InquiryType></NeoFitnes>"
        let data = params.data(using: .utf8, allowLossyConversion: true)
        
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/InsertInqueryFromCustomer"
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
    
    
    func responseDict() -> [String: Any] {
        
       let result =  [
                "addedon": "2020-02-23 12:26:04",
                "additionalCharges": "",
                "additional_param": "",
                "address1": "",
                "address2": "",
                "amount": "1.00",
                "amount_split": "{\"PAYU\":\"1.00\"}",
                "bankcode": "VISA",
                "baseUrl": "<null>",
                "calledStatus":  0,
                "cardToken": "",
                "card_merchant_param" :"<null>",
                "card_type": "",
                "cardhash": "",
                "firstname": "Anil",
                "furl": "<null>",
                "hash": "953f650f4c7bc32747c667dcfa991368a5075540269b16dfb416c83683e7afa60edf6c58ff90f8feb0b28e01810ab706994e88defc18c86ddc73dc44a0d42e25",
                "id": "<null>",
                "isConsentPayment": 0,
                "key": "fC38x6HU",
                "lastname": "",
                "meCode": "{\"MID\":\"hdfc_89050047\",\"TKey\":\"BQ5aLqlmre0kzYvLgD\\/Ij\\/qFkUD9EHoAtwFvUg0MyNfIX5OrShsUd7Or9Tixwk6aQ5TskqEA94S7JGnp7tyPrpIKJypQdjrCDu8phF4CEIE1FFIYXnKl3",
                "merchantid": "<null>",
                //"mihpayid" : 9907132935,
                "mode": "DC",
                "name_on_card": "payu",
                "net_amount_debit": 1,
                "offer_availed": "",
                "offer_failure_reason": "",
                "offer_key": "",
                "offer_type": "",
                "paisa_mecode": "",
                "paymentId": 304354340,
                "payment_source": "<null>",
                "payuMoneyId": 304354340,
                "pg_TYPE": "HdfcCYBER",
                "pg_ref_no": "",
                //"phone": 9968365956,
                "postBackParamId": 228897864,
                "postUrl": "https://www.payumoney.com/mobileapp/payumoney/success.php",
                "productinfo": "Package",
                "retryCount": 0,
                ] as [String : Any]
        
                return result
        
        
    }
       
       func convertToDictionary(text: String) -> [String: Any]? {
           
           print(text)
           
           if let data = text.data(using: .utf8) {
               do {
                   return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
               } catch {
                   print(error.localizedDescription)
               }
           }
           return nil
       }
}


extension CustomPayTVC: XMLParserDelegate {
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentParsingElement = elementName
        if elementName == "BranchWiseTax" {
            Name = String()
            BranchId = String()
            Amount = String()
            
        } else if elementName == "NeoFitness" {
            ErrorMessage = String()
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
            if elementName == "BranchWiseTax" {
               let tax = Tax(Name: Name, BranchId: BranchId, Amount: Amount)
               self.gstArray.append(tax)
       }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if currentParsingElement == "Name" {
            Name += foundedChar
//
        } else if currentParsingElement == "Amount" {
            Amount += foundedChar

        } else if currentParsingElement == "BranchId" {
            BranchId += foundedChar
        
        } else if currentParsingElement == "Message" {
            ErrorMessage += foundedChar
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        DispatchQueue.main.async {
            
            if self.ErrorMessage.isEmpty == false {
                self.successAlert(message: self.ErrorMessage)
                self.ErrorMessage = ""
            
            }
            
            if self.gstArray.count > 0 {
                
            } else {
                self.TaxApi(branchId: Int(self.branchId)!)
            }

        }
    }
}



struct PayUResponse {
    
    var paymentId: Int
    var pg_TYPE: String
    var status: String
    var bankcode: String
    
    init(json: [String: Any]) {
    
        self.paymentId = json["paymentId"] as! Int
        self.pg_TYPE = json["pg_TYPE"] as! String
        self.status = json["status"] as! String
        self.bankcode = json["bankcode"] as! String
    }
}

struct MeCodePayU {
    var MID: String
    var TKey: String
    
    init(json: [String: Any]) {
        
        self.MID = json["MID"] as! String
        self.TKey = json["TKey"] as! String
    }
}



