//
//  HomeTableViewController.swift
//  NeoFitness
//
//  Created by Sai Ram on 20/10/19.
//  Copyright © 2019 dmondo. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyUserDefaults
import FSPagerView

struct Section {
    let header: String
    let subHeading: String
    
}

class HomeTableViewController: UITableViewController {

    @IBOutlet weak var hamburgerMenuButton: UIBarButtonItem!
    @IBOutlet weak var locationButton: UIBarButtonItem!
    
    var sectionTitle =  [Section]()
    let imageNames = [#imageLiteral(resourceName: "Image"),#imageLiteral(resourceName: "img1"),#imageLiteral(resourceName: "Image"),#imageLiteral(resourceName: "img3"),#imageLiteral(resourceName: "Image"),#imageLiteral(resourceName: "img2"),#imageLiteral(resourceName: "Image"),#imageLiteral(resourceName: "background")]
    var parser = XMLParser()
    var currentParsingElement = String()
    var packages = [Package]()
    var workouts = [WorkOut]()
    var groupClasses = [Classes]()
    var classesDetail = [ClassDetail]()
//    var LocationArray: [Location] = []
    
    var ErrorMessage = String()
    var workoutHeight: CGFloat = 0.0
    
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
    
    // WorkOut Details
    var WorkId = String()
    var BranchId = String()
    var Name = String()
    var Title = String()
    var About = String()
    var Benefits = String()
    var WorkOutImage = String()
    
    // classes
    var GymId = String()
    var DayName = String()
    var ClassName = String()
    var Sequences = String()
    var GroupClassImage = String()
    
    // classDetail
    var Trainer:String = ""
    var TrainerName:String = ""
    var StartTime:String = ""
    var EndTime:String = ""
    var Vanue:String = ""
    
    
    // jaipur
    var defaultCityId = "3446"
    var branchId = "33"
    
    // delhi
//    var defaultCityId = ""
//    var branchId = ""
    
    var dayArray = [Classes]()
    
    // Location
    var CityId = String()
    var CityName = String()
    var CityImage = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Default jaipur banch id: 33
        // Default mohali banch id: 25
        // Default jaiur city id: 3446
        
         if UserDefaults.standard.bool(forKey: "currentUser") == true {
            self.locationButton.isEnabled = false
            self.locationButton.tintColor = .lightGray
            let branchId =  UserDefaults.standard.string(forKey: "BranchId")
            
            if let branchId = branchId {
                let branch = Int(branchId)!
                self.makePostCall(branchId: branch, CityId: 0)
                self.getAllClasses(branchId: branch)
                self.getAllWorkoutCall(branchId: branch, workOutId: 0)
                //self.makeLocationCall(branchId: branch, CityId: 0)
            }
            
        } else {
            
            self.locationButton.isEnabled = true
            self.locationButton.tintColor = .blue
            
            if let branchId = LoginUtils.getBranchId() {
                let branch = Int(branchId) ?? 0
                self.makePostCall(branchId: branch, CityId: 0)
                self.getAllClasses(branchId: branch)
                self.getAllWorkoutCall(branchId: branch, workOutId: 0)
            
            } else {
                
            self.makePostCall(branchId: 33, CityId: 0)
            self.getAllClasses(branchId: 33)
            self.getAllWorkoutCall(branchId: 33, workOutId: 0)
            
            }
        }
    
        
        setupHamburgerMenu()
        sectionTitle = [Section(header: "", subHeading: ""), Section(header: "OUR CLASSES", subHeading: "CHOOSE WHAT CLASS TIME SUITS YOU"),Section(header: "SHOP NOW", subHeading: ""), Section(header: "PACKAGES", subHeading: ""), Section(header: "Fitness TV", subHeading: ""), Section(header: "Member of the Month", subHeading: ""), Section(header: "ADVERTISEMENT", subHeading: "")]
        let nib = UINib(nibName: "CustomSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = AppNavigationTitle.Home
        self.navigationController?.isNavigationBarHidden = false
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 400;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // self.navigationController?.isNavigationBarHidden = false
        // self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = false
       
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    func setupHamburgerMenu() {
        if self.revealViewController() != nil {
            
            self.hamburgerMenuButton.target = revealViewController()
            self.hamburgerMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func carouselTestData() -> [carouselViewData] {

        var carouselViewArray: [carouselViewData] = []
        let slide = carouselViewData(image: #imageLiteral(resourceName: "Image"), title: "", description: "")
        let slide1 = carouselViewData(image: #imageLiteral(resourceName: "img2"), title: "", description: "")
        let slide2 = carouselViewData(image: #imageLiteral(resourceName: "img2"), title: "", description: "")
        let slide3 = carouselViewData(image: #imageLiteral(resourceName: "img1"), title: "", description: "")

        carouselViewArray = [slide,slide1, slide2, slide3]
        return carouselViewArray
    }
    
    @IBAction func locationButtonTaped(_ sender: Any) {
        print("location")
        showLocationView(branchId: nil, cityId: nil)
       
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
}

extension HomeTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader" ) as! CustomSectionHeader
        headerView.titleLabel.text = sectionTitle[section].header
        headerView.subtitleLabel.text = sectionTitle[section].subHeading
        
//        if section == 1 {
//            headerView.backgroundColor = .red
//        } else {
//            headerView.backgroundColor = .purple
//        }
//         headerView.titleLabel.textColor = .white
//        headerView.subtitleLabel.textColor = .white
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        if section == 1  {
            return 60
        
        } else  {
            return 40
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FitnessSectionTableViewCell", for: indexPath) as! FitnessSectionTableViewCell
            //cell.pagerView.reloadData()
            return cell
            
        }
        
        if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "classTableViewCell", for: indexPath) as! classTableViewCell
            cell.delegate = self
            //            cell.setupClassData(carousels: self.carouselTestData())
            cell.setupClassData(carousels: self.dayArray)
            return cell
            
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopProductsTableViewCell", for: indexPath) as! ShopProductsTableViewCell
            cell.setupClassData()
            return cell
            
        } else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTableViewCell", for: indexPath) as! CarouselTableViewCell
            cell.pagerView.reloadData()
            return cell
            
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FitnessChannelTableViewCell", for: indexPath) as! FitnessChannelTableViewCell
            cell.fitnessCollectionView.reloadData()
            return cell
//           
       
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workOutTableViewCell", for: indexPath) as! workOutTableViewCell
            //cell.delegate = self
            cell.setupClassData(carousels: self.workouts)
//            self.workoutHeight = cell.height
//            print(self.workoutHeight)
            return cell
            
        } else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bannerTableViewCell", for: indexPath) as! bannerTableViewCell
            return cell
            
        }
        return UITableViewCell(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 || indexPath.section == 1 {
            return 300
        
        } else if indexPath.section == 3 || indexPath.section == 5 {
            return 225
        
        } else if indexPath.section == 2 || indexPath.section == 4 {
            return 250
       
        }  else if  indexPath.section == 6 {
                return 100
        }
        
        return 80
    }
    
    
    func getAllWorkoutCall(branchId: Int, workOutId: Int) {
        
        self.workouts.removeAll()
        let params =  "strXml=<NeoFitnes><WorkOut><BranchId>\(branchId)</BranchId><WorkId>\(workOutId)</WorkId></WorkOut></NeoFitnes>"
        let data = params.data(using: .utf8, allowLossyConversion: true)
        
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetAllWorkOutDetails"
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
                let txt = (str as AnyObject).value(forKey: "text") as! String
                let txtdata = txt.data(using: .utf8)
                
                self.parser = XMLParser(data: txtdata!)
                self.parser.delegate = self
                self.parser.parse()
                
            } catch  {
                print(error.localizedDescription)
                print("error parsing response from POST on /todos")
//                DispatchQueue.main.async {
//                     self.showErrorAlert(title: "Neo", message: error.localizedDescription)
//                }
               
                return
            }
        }
        task.resume()
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
                print(str)
                let txt = (str as AnyObject).value(forKey: "text") as! String
                let txtdata = txt.data(using: .utf8)
                
                self.parser = XMLParser(data: txtdata!)
                self.parser.delegate = self
                self.parser.parse()
                
            } catch  {
                print(error.localizedDescription)
                print("error parsing response from POST on /todos")
//                 DispatchQueue.main.async {
//                        self.showErrorAlert(title: "Neo", message: error.localizedDescription)
//                }
                              
                return
            }
        }
        task.resume()
    }
    
    
    func getAllClasses(branchId: Int) {
        
        self.groupClasses.removeAll()
        self.dayArray.removeAll()
        let params =  "strXml=<NeoFitnes><BranchWiseGroupClass><BranchId>\(branchId)</BranchId></BranchWiseGroupClass></NeoFitnes>"
        let data = params.data(using: .utf8, allowLossyConversion: true)
        
       // let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetAllBranchWiseGroupClasses"
        let todosEndpoint: String = "http://mobile.rightsoft.in/NeoFitnessService.asmx/GetAllBranchWiseGroupClassesTime"
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
    
    func showErrorAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}


extension HomeTableViewController: classWorkOutProtocol {
    func didSelectClassType(row: Int) {
       //return
        if dayArray.count ==  0 {
            
            let today = Date()
            let day =  today.dayOfWeek() ?? ""
            self.dayArray = groupClasses.filter{$0.DayName.lowercased() == day.lowercased()}
            
            if self.dayArray.count > 0 {
                let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "GroupClassDetailVC") as! GroupClassDetailVC
                vc.groupclass = self.dayArray[row]
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            
            } else { return }
            
        } else {
            let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GroupClassDetailVC") as! GroupClassDetailVC
            //vc.groupClasses = self.dayArray
            vc.groupclass = self.dayArray[row]
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didSelectDay(day: String) {
        self.dayArray.removeAll()
        self.dayArray = groupClasses.filter{$0.DayName.lowercased() == day.lowercased()}
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print(self.dayArray)
    }
}

extension HomeTableViewController: locationDelegate {
   
    func didSelectLocation(location: Location) {
        
        self.showLocationView(branchId: 0, cityId: Int(location.cityId)!)
        print(location.cityId)
        print(location.cityName)
    }
    
    func didSelectSubLocation(location: SubLocation) {
        
        if location.isOnBoard.lowercased() == "False".lowercased() || location.isOnBoard.lowercased() == "0".lowercased() {
//            print(location)
           self.showErrorAlert(title: "NEO", message: "Dear User at present this centre is not online we will be on-board very soon. if any query do mail us at contactus@neofitnes.com")
            return
            
        } else {
            self.locationButton.title = location.BranchName
            LoginUtils.setBranchId(id: location.branchId)
            self.branchId = location.branchId
            self.defaultCityId = location.cityId
            self.makePostCall(branchId: Int(location.branchId)!, CityId: 0)
            self.getAllClasses(branchId: Int(location.branchId)!)
            self.getAllWorkoutCall(branchId: Int(location.branchId)!, workOutId: 0)
            
        }
    }
}

extension HomeTableViewController: WorkOutProtocol {
    
    func didSelectWorkout(row: Int) {
        
        let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WorkOutDetailTVC") as! WorkOutDetailTVC
        vc.workout = self.workouts[row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension HomeTableViewController: XMLParserDelegate {
    

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
                
            } else if elementName == "WorkOut" {
                
                WorkId = String()
                BranchId = String()
                Name = String()
                Title = String()
                About = String()
                Benefits = String()
                WorkOutImage = String()
        
            } else if elementName == "GroupClass" {
                GymId = String()
                BranchId = String()
                DayName = String()
                ClassName = String()
                Name = String()
                Sequences = String()
                GroupClassImage = String()
                
        } else if elementName == "AllBranchNameList" {
            CityId = String()
            CityName = String()
            CityImage = String()
        
            } else if elementName == "Classdetails" {
                Trainer = String()
                TrainerName = String()
                StartTime = String()
                EndTime = String()
                Vanue = String()
                
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "BranchWithPackage" {

            let package = Package(packageId: PackageId, branchName: BranchName, packageName: PackageName, amount: Amount, packageTenure: PackageTenure, packageTenureType: PackageTenureType, session: Session, offerAmount: OfferAmount, offerImage: OfferImage, fromDate: FromDate, toDate: ToDate, description: Desc, discountPercent: DiscountPercent, termsCondition: TermsCondition, PkgMinAmount: PkgMinAmount)
            self.packages.append(package)

        } else if elementName == "WorkOut" {
            
            let workout = WorkOut(WorkId: WorkId, BranchId: BranchId, Name: Name, Title: Title, About: About, Benefits: Benefits, WorkOutImage: WorkOutImage)
            self.workouts.append(workout)
        
        } else if elementName == "GroupClass" {
            
            //let classe = Classes(GymId: GymId, BranchId: BranchId, DayName: DayName, ClassName: ClassName, Trainer: Trainer, StartTime: StartTime, EndTime: EndTime, Vanue: Vanue, Sequences: Sequences, Name: Name, GroupClassImage: GroupClassImage)
            let classe = Classes(GymId: GymId, BranchId: BranchId, DayName: DayName, ClassName: ClassName, Name: Name, Sequences: Sequences, GroupClassImage: GroupClassImage, detail: ClassDetail(Trainer: Trainer, TrainerName: TrainerName, StartTime: StartTime, EndTime: EndTime, Vanue: Vanue))
            print(classe)
            self.groupClasses.append(classe)
            
        } else if elementName == "AllBranchNameList" {
        
//            let location = Location(cityId: CityId, cityName: CityName, cityImage: CityImage)
//            print("=======",location)
//            self.LocationArray.append(location)
        }
        
        else if elementName == "Classdetails" {
            let classDetail = ClassDetail(Trainer: Trainer, TrainerName: TrainerName, StartTime: StartTime, EndTime: EndTime, Vanue: Vanue)
           // self.classesDetail.append(classDetail)
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
                
                } else if currentParsingElement == "WorkId" {
                    WorkId += foundedChar
                    
                } else if currentParsingElement == "BranchId" {
                    BranchId += foundedChar
                    
                } else if currentParsingElement == "Name" {
                     Name += foundedChar
                    
                } else if currentParsingElement == "Title" {
                    Title += foundedChar
                    
                } else if currentParsingElement == "About" {
                     About += foundedChar
                    
                } else if currentParsingElement == "Benefits" {
                     Benefits += foundedChar
                    
                } else if currentParsingElement == "WorkOutImage" {
                     WorkOutImage += foundedChar
               
                } else if currentParsingElement == "GymId" {
                    GymId += foundedChar
                
                } else if currentParsingElement == "DayName" {
                    DayName += foundedChar
                
                }else if currentParsingElement == "ClassName" {
                    ClassName += foundedChar
                
                } else if currentParsingElement == "Trainer" {
                    Trainer += "\(foundedChar),"
                
                } else if currentParsingElement == "TrainerName" {
                    TrainerName += "\(foundedChar),"
                
                } else if currentParsingElement == "StartTime" {
                    StartTime += "\(foundedChar),"
                
                } else if currentParsingElement == "EndTime" {
                    EndTime += "\(foundedChar),"
                
                } else if currentParsingElement == "Vanue" {
                    Vanue += "\(foundedChar),"
                
                } else if currentParsingElement == "Sequences" {
                    Sequences += foundedChar
                
                } else if currentParsingElement == "PkgMinAmount" {
                    PkgMinAmount += foundedChar
                
                } else if currentParsingElement == "CityId" {
                    CityId += foundedChar
                
                } else if currentParsingElement == "CityName" {
                    CityName += foundedChar
                
                } else if currentParsingElement == "CityImage" {
                    CityImage += foundedChar
                
                } else if currentParsingElement == "GroupClassImage" {
                   GroupClassImage += foundedChar
                    
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        DispatchQueue.main.async {
            
            if self.ErrorMessage.isEmpty == false {
                
//                if self.packages.count == 0 {
//                    // self.showErrorAlert(title: "NEO", message: "Dear User at present this centre is not online we will be on-board very soon. if any query do mail us at contactus@neofitnes.com")
//
//                } else {
                    
                print(self.ErrorMessage)
                
                if self.ErrorMessage.contains("Records Not Founds!") {
                    
                    if self.packages.count == 0 {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else if self.groupClasses.count == 0 {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else if self.workouts.count == 0 {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                } else {
                     self.showErrorAlert(title: "NEO", message: self.ErrorMessage)
                }
                   
                    self.ErrorMessage = String()
//                }
            
            } else {
            
                if self.groupClasses.count > 0 {
                    
                    print(self.groupClasses.count)
                    
                let today = Date()
                let day =  today.dayOfWeek() ?? ""
                self.dayArray = self.groupClasses.filter{$0.DayName.lowercased() == day.lowercased()}
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
                
                if self.packages.count > 0 {
                    self.locationButton.title = self.packages[0].branchName
                   DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                if self.workouts.count > 0 {
                 DispatchQueue.main.async {
                      self.tableView.reloadData()
                  }
                }
            }
        }
    }
}


extension HomeTableViewController: FSPagerViewDataSource,FSPagerViewDelegate {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.packages.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        let Url = URL(string: "\(NDefaults.imageBaseUrl)\(packages[index].offerImage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
//        cell.imageView?.kf.setImage(with: Url)
        
        let resource = ImageResource(downloadURL: Url!, cacheKey: "\(Url!)")
        cell.imageView?.kf.setImage(with: resource)
//        imageView.kf.setImage(with: resource)
        
//        cell.imageView?.kf.setImage(with: Url, placeholder: UIImage(), options: , progressBlock: <#T##DownloadProgressBlock?##DownloadProgressBlock?##(Int64, Int64) -> Void#>, completionHandler: <#T##((Result<RetrieveImageResult, KingfisherError>) -> Void)?##((Result<RetrieveImageResult, KingfisherError>) -> Void)?##(Result<RetrieveImageResult, KingfisherError>) -> Void#>)
        
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
       // cell.textLabel?.text = index.description+index.description
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if packages.count > 0 {
            let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PackageDetailViewController") as! PackageDetailViewController
            vc.packages = packages[index]
            vc.cityId = Int(self.defaultCityId)!
            vc.branchId = Int(self.branchId)!
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
           self.showErrorAlert(title: "NEO", message: "Select locations for the packages")
        }
    }
}

struct Package {
    
    var packageId:String = ""
    var branchName:String = ""
    var packageName:String = ""
    var amount:String = ""
    var packageTenure:String = ""
    
    var packageTenureType:String = ""
    var session:String = ""
    var offerAmount:String = ""
    var offerImage:String = ""
    var fromDate:String = ""
    
    var toDate:String = ""
    var description:String = ""
    var discountPercent:String = ""
    var termsCondition:String = ""
    var PkgMinAmount: String = ""
    
    var dictionary: [String: Any] {
        return ["packageId": packageId,
                "branchName": branchName,
                "packageName": packageName,
                "amount":amount,
                "packageTenure": packageTenure,
                "packageTenureType":packageTenureType,
                "session":session,
                "offerAmount":offerAmount,
                "offerImage":offerImage,
                "fromDate":fromDate,
                "toDate":toDate,
                "description":description,
                "discountPercent": discountPercent,
                "termsCondition": termsCondition,
                "PkgMinAmount": PkgMinAmount
        ]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

struct WorkOut {
    
    var WorkId:String = ""
    var BranchId:String = ""
    var Name:String = ""
    var Title:String = ""
    var About:String = ""
    var Benefits:String = ""
    var WorkOutImage:String = ""
}

struct Classes{
    
    var GymId:String = ""
    var BranchId:String = ""
    var DayName:String = ""
    var ClassName:String = ""
    var Name:String = ""
    var Sequences:String = ""
    var GroupClassImage: String = ""
    var detail: ClassDetail?
    
}

struct ClassDetail {
    var Trainer:String = ""
    var TrainerName:String = ""
    var StartTime:String = ""
    var EndTime:String = ""
    var Vanue:String = ""
    
}
