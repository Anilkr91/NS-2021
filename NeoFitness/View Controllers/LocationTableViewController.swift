//
//  LocationTableViewController.swift
//  NeoFitness
//
//  Created by Sai Ram on 01/12/19.
//  Copyright © 2019 dmondo. All rights reserved.
//

import UIKit
import Kingfisher

protocol locationDelegate: class {
    func didSelectLocation(location: Location)
    func didSelectSubLocation(location: SubLocation)
}

class LocationTableViewController: UIViewController {
    
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    // Location
    var CityId = String()
    var CityName = String()
    var CityImage = String()
    
    // subLocation
    var BranchId = String()
    var BCityId = String()
    var BranchName = String()
    var B2IsOnBoard = String()
    var BranchLogo = String()
    
    var ErrorMessage = String()
    
    
    var currentParsingElement = String()
    var LocationArray: [Location] = []
    var SubLocationArray: [SubLocation] = []
    var parser = XMLParser()
    weak var delegate: locationDelegate?
    
    var branchId: Int?
    var cityId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.delegate = self
        locationTableView.dataSource = self
        
        if let cityId = cityId {
             makePostCall(branchId: 0, CityId: cityId)
        
        } else {
            makePostCall(branchId: 0, CityId: 0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func makePostCall(branchId: Int, CityId: Int) {
        
        self.LocationArray.removeAll()
        self.SubLocationArray.removeAll()
        
        let params =  "strXml=<NeoFitnes><AllBranch><BranchId>\(branchId)</BranchId><CityId>\(CityId)</CityId></AllBranch></NeoFitnes>"
        let data = params.data(using: .utf8, allowLossyConversion: true)

        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetAllBranchNameList"
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


extension LocationTableViewController: XMLParserDelegate {
    
    
func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    
    currentParsingElement = elementName
    
    if let cityId = cityId {
       // makePostCall(branchId: 0, CityId: cityId)
        
        if elementName == "AllBranchNameList" {
            
            BranchId = String()
            BCityId = String()
            BranchName = String()
            B2IsOnBoard = String()
            BranchLogo = String()

        }
        
    } else {
        if elementName == "AllBranchNameList" {
            CityId = String()
            CityName = String()
            CityImage = String()
        }
    }
}
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "AllBranchNameList" {
            
            if let cityId = cityId {
                
                let subLocation = SubLocation(branchId: BranchId, cityId: BCityId, BranchName: BranchName, branchLogo: BranchLogo, isOnBoard: B2IsOnBoard)
                self.SubLocationArray.append(subLocation)
                
            } else {
                let location = Location(cityId: CityId, cityName: CityName, cityImage: CityImage)
                self.LocationArray.append(location)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if let cityId = cityId {
            
            if (!foundedChar.isEmpty) {
                if currentParsingElement == "BranchId" {
                    BranchId += foundedChar
                }
                else if currentParsingElement == "BranchName" {
                    BranchName += foundedChar
                
                } else if currentParsingElement == "IsOnBoard" {
                    B2IsOnBoard += foundedChar
                
                } else if currentParsingElement == "CityId" {
                    BCityId += foundedChar
                    
                } else if currentParsingElement == "BranchLogo" {
                    BranchLogo += foundedChar
                    
                } else if currentParsingElement == "Message" {
                    ErrorMessage += foundedChar
                    
                }
            }
            
    } else {
            if (!foundedChar.isEmpty) {
                if currentParsingElement == "CityId" {
                    CityId += foundedChar
                }
                else if currentParsingElement == "CityName" {
                    CityName += foundedChar
                }
                else if currentParsingElement == "CityImage" {
                    CityImage += foundedChar
                } else if currentParsingElement == "Message" {
                    ErrorMessage += foundedChar
                    
                }
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        DispatchQueue.main.async {
            
            if let cityId = self.cityId {
                
                if self.SubLocationArray.count > 0 {
                    self.SubLocationArray = self.SubLocationArray.sorted(by: <)
                    self.locationTableView.reloadData()
                    
                } else {
                  self.showErrorAlert(title: "NEO", message: "Dear User at present this centre is not online we will be on-board very soon. if any query do mail us at contactus@neofitnes.com")
                }
    
        } else {
                print(self.LocationArray.count)
                
                if self.LocationArray.count > 0 {
                    self.LocationArray = self.LocationArray.sorted(by: <)
                    self.locationTableView.reloadData()
                    
                } else {
                    self.showErrorAlert(title: "NEO", message: "Records Not Founds!")
                    
                }
                
            }
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            
           self.dismiss(animated: true, completion: nil)
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension LocationTableViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if let cityId = cityId {
            
            if SubLocationArray.count < 6 {
                self.tableViewHeightConstraint.constant = CGFloat(50 * SubLocationArray.count)
                
            } else {
                self.tableViewHeightConstraint.constant = CGFloat(50 * 11)
            }
            return SubLocationArray.count
            
         } else {
           
            if LocationArray.count < 6 {
                self.tableViewHeightConstraint.constant = CGFloat(50 * LocationArray.count)
                
            } else {
                self.tableViewHeightConstraint.constant = CGFloat(50 * 11)
            }
            return LocationArray.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationTableViewCell
        
        if let cityId = cityId {
            cell.imgView.image =  UIImage(named: "logo.png")
            cell.locationLabel.text = SubLocationArray[indexPath.row].BranchName
            return cell
            
        } else {
            cell.imgView.image = UIImage(named: "logo.png")
            cell.locationLabel.text = LocationArray[indexPath.row].cityName
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = delegate {
           
            self.dismiss(animated: true) {
                
                if let cityId = self.cityId {
                    delegate.didSelectSubLocation(location: self.SubLocationArray[indexPath.row])
               
                } else {
                    delegate.didSelectLocation(location: self.LocationArray[indexPath.row])
                
                }
            }
        }
    }
}

struct Location: Comparable {
    static func < (lhs: Location, rhs: Location) -> Bool {
     return lhs.cityName < rhs.cityName
    }
    
    var cityId:String = ""
    var cityName:String = ""
    var cityImage:String = ""
}


struct SubLocation: Comparable {
    static func < (lhs: SubLocation, rhs: SubLocation) -> Bool {
         return lhs.BranchName < rhs.BranchName
    }
    
    var branchId:String = ""
    var cityId:String = ""
    var BranchName:String = ""
    var branchLogo:String = ""
    var isOnBoard:String = ""
    
}
