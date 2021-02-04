//
//  PackageListingTVC.swift
//  NeoFitness
//
//  Created by Sai Ram on 01/02/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import UIKit
import FSPagerView


protocol packageDelegate: class {
    func didSelectPackage(package: Package)
}

class PackageListingTVC: UITableViewController {

    var packages = [Package]()
    
    var PackageId = String()
    var BranchName = String()
    var PackageName = String()
    var Amount = String()
    var PackageTenure = String()
    var PackageTenureType = String()
    var Session = String()
    var OfferAmount = String()
    var PkgMinAmount = String()
    var OfferImage = String()
    var FromDate = String()
    var ToDate = String()
    var Desc = String()
    var DiscountPercent = String()
    var TermsCondition = String()
     var ErrorMessage = String()
    
    var branchId: Int?
    
    var parser = XMLParser()
    var currentParsingElement = String()
    
    weak var delegate: packageDelegate?
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var amoutLabel: UILabel!
    @IBOutlet weak var packageMinLabel: UILabel!
    @IBOutlet weak var numberofclassesLabel: UILabel!
    
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = AppNavigationTitle.selectpackage
        
        if let branchId = branchId {
            self.makePostCall(branchId: branchId, CityId: 0)
        }
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.hidesBackButton = true

    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if let delegate = delegate {
             delegate.didSelectPackage(package: packages[pagerView.currentIndex])
            self.navigationController?.popViewController(animated: true)
           
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
          return 200
        } else {
        return 80
        }
       
    }
    
    
    func showErrorAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func makePostCall(branchId: Int, CityId: Int) {
        
        self.packages.removeAll()
        
        let params =  "strXml=<NeoFitnes><Branch><BranchId>\(branchId)</BranchId><PackageId>\(CityId)</PackageId></Branch></NeoFitnes>"
        let data = params.data(using: .utf8, allowLossyConversion: true)
        
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetAllMobilePackages"
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
                
                print("package====>",str)
                
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

extension PackageListingTVC: FSPagerViewDataSource,FSPagerViewDelegate {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.packages.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        let Url = URL(string: "\(NDefaults.imageBaseUrl)\(packages[index].offerImage)")
        cell.imageView?.kf.setImage(with: Url)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        // cell.textLabel?.text = index.description+index.description
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        if packages.count > 0 {
//            let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "PackageDetailViewController") as! PackageDetailViewController
//            vc.packages = packages[index]
//            vc.cityId = Int(self.defaultCityId)!
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        } else {
//
//            self.showErrorAlert(title: "NEO", message: "Select locations for the packages")
//        }
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        print(pagerView.currentIndex)
        
        aboutLabel.text = self.packages[pagerView.currentIndex].description
        termsLabel.text = self.packages[pagerView.currentIndex].termsCondition
        amoutLabel.text = self.packages[pagerView.currentIndex].amount
        packageMinLabel.text = self.packages[pagerView.currentIndex].offerAmount
        numberofclassesLabel.text = self.packages[pagerView.currentIndex].session
         self.navigationItem.title = self.packages[pagerView.currentIndex].packageName
        
    }
}

extension PackageListingTVC: XMLParserDelegate {
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentParsingElement = elementName
        
        if elementName == "BranchWithPackage" {
            
            PackageId = String()
            BranchName = String()
            PackageName = String()
            Amount = String()
            PackageTenure = String()
            PackageTenureType = String()
            Session = String()
            OfferAmount = String()
            OfferImage = String()
            FromDate = String()
            ToDate = String()
            Desc = String()
            DiscountPercent = String()
            TermsCondition = String()
            PkgMinAmount = String()
            
        } else if elementName == "NeoFitness" {
            ErrorMessage = String()
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "BranchWithPackage" {
            
            let package = Package(packageId: PackageId, branchName: BranchName, packageName: PackageName, amount: Amount, packageTenure: PackageTenure, packageTenureType: PackageTenureType, session: Session, offerAmount: OfferAmount, offerImage: OfferImage, fromDate: FromDate, toDate: ToDate, description: Desc, discountPercent: DiscountPercent, termsCondition: TermsCondition, PkgMinAmount: PkgMinAmount)
           
            print(package)
            self.packages.append(package)
            
        } else if elementName == "AllBranchNameList" {
            
            //            let location = Location(cityId: CityId, cityName: CityName, cityImage: CityImage)
            //            print("=======",location)
            //            self.LocationArray.append(location)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        if (!foundedChar.isEmpty) {
            
            if currentParsingElement == "PackageId" {
                PackageId += foundedChar
            }
            else if currentParsingElement == "BranchName" {
                BranchName += foundedChar
                
            } else if currentParsingElement == "PackageName" {
                PackageName += foundedChar
                
            } else if currentParsingElement == "Amount" {
                print("amount == >",foundedChar)
                Amount += foundedChar
                
            } else if currentParsingElement == "PackageTenure" {
                PackageTenure += foundedChar
                
            } else if currentParsingElement == "PackageTenureType" {
                PackageTenureType += foundedChar
                
            }  else if currentParsingElement == "Session" {
                Session += foundedChar
                
            }  else if currentParsingElement == "OfferAmount" {
            
                OfferAmount += foundedChar
                
            } else if currentParsingElement == "OfferImage" {
                OfferImage += foundedChar
                
            } else if currentParsingElement == "FromDate" {
                FromDate += foundedChar
                
            } else if currentParsingElement == "ToDate" {
                ToDate += foundedChar
                
            } else if currentParsingElement == "Description" {
                Desc += foundedChar
                
            } else if currentParsingElement == "DiscountPercent" {
                DiscountPercent += foundedChar
                
            } else if currentParsingElement == "TermsCondition" {
                TermsCondition += foundedChar
                
            } else if currentParsingElement == "Message" {
                ErrorMessage += foundedChar
                
            } else if currentParsingElement == "PkgMinAmount" {
                PkgMinAmount += foundedChar
                
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        DispatchQueue.main.async {
            
            if self.ErrorMessage.isEmpty == false {
                self.showErrorAlert(title: "NEO", message: self.ErrorMessage)
                self.ErrorMessage = String()
                
            } else {
                
                DispatchQueue.main.async {
                    
                    if self.packages.count > 0 {
                        
                        self.aboutLabel.text = self.packages[0].description
                        self.termsLabel.text = self.packages[0].termsCondition
                        self.amoutLabel.text = self.packages[0].amount
                        self.packageMinLabel.text = self.packages[0].offerAmount
                        self.numberofclassesLabel.text = self.packages[0].session
                        self.navigationItem.title = self.packages[0].packageName
                    }
                    
                    self.pagerView.reloadData()
                    self.tableView.reloadData()
                }
            }
        }
    }
}
