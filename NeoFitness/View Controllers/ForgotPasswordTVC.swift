//
//  ForgotPasswordTVC.swift
//  NeoFitness
//
//  Created by Sai Ram on 12/01/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import UIKit

class ForgotPasswordTVC: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @objc var email: String?
    var ErrorMessage = String()
    var parser = XMLParser()
    var currentParsingElement = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        if let email = email {
           emailTextField.text = email
        }
    }

    @IBAction func resetPassword(_ sender: Any) {
        
        if emailTextField.text!.isEmpty {
           self.showErrorAler(message: "Please fill email")
            
        } else {
            let message = "Dear user you can change and retrieve your password by log in at www.rightsoft.in or mail us. \nThanks \n Team Neo fitnes."
            self.goToHome(message: message)
//            self.ForgotPasswordCall(email: emailTextField.text!)
        }
    }
    
    func goToHome( message: String) {
        
        let alert = UIAlertController(title: "NEO" , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { action in
            self.navigationController?.popViewController(animated: true)
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func ForgotPasswordCall(email: String) {
        
        let isUserID = false
        let params =  "forgotpass=<NeoFitnes><Users><Email>\(email)</Email><isUserID>\(isUserID)</isUserID></Users></NeoFitnes>"
        let data = params.data(using: .utf8, allowLossyConversion: true)
        
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/ForgetPassword"
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
    
    func goToLoginAlert( message: String) {
        
        let alert = UIAlertController(title: "NEO" , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Login", style: UIAlertAction.Style.destructive, handler: { action in
            self.navigationController?.popViewController(animated: true)
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ForgotPasswordTVC: XMLParserDelegate {
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentParsingElement = elementName
        if elementName == "NeoFitness" {
            ErrorMessage = String()
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if currentParsingElement == "Message" {
            ErrorMessage += foundedChar
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        DispatchQueue.main.async {
            if self.ErrorMessage.isEmpty == false {
                self.goToLoginAlert(message: self.ErrorMessage)
                self.ErrorMessage = String()
            }
        }
    }
}

//public static final String PAYUMONEY_Key = "fC38x6HU";
//public static final String PAYUMONEY_Salt = "e6zHrnjijY";
//public static final String PAYUMONEY_MID = "6821433";
//public static final String PAYUMONEY_SURL = "https://www.payumoney.com/mobileapp/payumoney/success.php";
//public static final String PAYUMONEY_FURL = "https://www.payumoney.com/mobileapp/payumoney/failure.php";
