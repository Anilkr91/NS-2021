//
//  PackageDetailViewController.swift
//  NeoFitness
//
//  Created by Sai Ram on 11/01/20.
//  Copyright © 2020 dmondo. All rights reserved.
//

import UIKit
import Kingfisher

class PackageDetailViewController: UITableViewController {
    
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var packageDurationLabel: UILabel!
    @IBOutlet weak var packageTenureLabel: UILabel!
    @IBOutlet weak var numberOfClassesLabel: UILabel!
    @IBOutlet weak var packageAmountLabel: UILabel!
    @IBOutlet weak var aboutPackageLAbel: UILabel!
    @IBOutlet weak var TermsConditionLabel: UILabel!
    @IBOutlet weak var buyPackageButton: UIButton!
    @IBOutlet weak var packageMinimumAmount: UILabel!
    
    var packages: Package?
    var cityId: Int = 0
    var branchId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 200
        } else {
             return UITableView.automaticDimension
        }
        
          
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func setupUI() {
        
        if let package = packages {
         
        print(package)
            
        packageNameLabel.text = package.packageName
        
        if package.toDate == "" && package.fromDate == "" {
            packageDurationLabel.text = "0 - 0"
        } else {
            packageDurationLabel.text = "\(package.toDate) -\(package.fromDate)"
        }
        packageTenureLabel.text = "\(package.packageTenure) \(package.packageTenureType)"
        numberOfClassesLabel.text = "\(package.session) class"
        packageAmountLabel.text = "₹\(package.offerAmount)"
        aboutPackageLAbel.text = package.description
        TermsConditionLabel.text = package.termsCondition
        packageMinimumAmount.text = "₹\(package.PkgMinAmount)"
            
        let Url = URL(string: "\(NDefaults.imageBaseUrl)\(package.offerImage)")
        packageImageView?.kf.setImage(with: Url)
            
        self.navigationItem.title = package.packageName
            
        }
    }
    
    
    @IBAction func buyPackageTapped(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "currentUser") == true {
//
//             let userBranchId =  UserDefaults.standard.string(forKey: "BranchId")
//            let intBranchId = Int(userBranchId!)!
//            let selectdBranchid = self.branchId
//            if intBranchId != selectdBranchid {
//                self.showAlert(message: "Dear user you are the member of Neo fitness.. you are buying a package of neo fitness. do you want to continue")
//
//            } else {
            
//            let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "showRegistration") as! RegistrationTableViewController
//
//            if let packages = packages {
//                vc.cityId = cityId
//                vc.packageId = Int(packages.packageId)!
//                vc.amount = Int(packages.amount)!
//                vc.offerAmount = Int(packages.offerAmount)!
//                vc.packageAmount = Int(packages.offerAmount)!
//                vc.branchId = self.branchId
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
                
            self.goToCustomPay()
//         }
//
        } else {
            let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.cityId = Int32(cityId)
            vc.packageId = Int32(packages!.packageId)!
            vc.offerAmount = Int32(packages!.offerAmount) ?? 0
            vc.amount = Int32(packages!.amount) ?? 0
            vc.branchId = Int32(self.branchId)
            if let packages = packages {
        
                if (packages.PkgMinAmount.isEmpty) {
                    vc.pkgMinAmount = Int32(Int(packages.offerAmount) ?? 0)
        
                    } else if (packages.offerAmount.isEmpty) {
                    vc.pkgMinAmount = Int32(Int(packages.amount) ?? 0)
        
                    } else {
                    vc.pkgMinAmount = Int32(Int(packages.PkgMinAmount) ?? 0)
                
                }
        
            }
        
            self.navigationController?.pushViewController(vc, animated: true)
            
    }
        
//        if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
//            [self goToHome];
//
//        } else {
//            [self goToLogin];
//        }
        
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

}
    
    
//    func showAlert(message: String) {
//
//            let alert = UIAlertController(title: "NEO", message: message, preferredStyle: .alert)
//
//            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
//                self.goToCustomPay()
//            })
//            alert.addAction(ok)
//            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
//            })
//            alert.addAction(cancel)
//            DispatchQueue.main.async(execute: {
//                self.present(alert, animated: true)
//            })
//        }
    
    
    func goToCustomPay() {

        let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomPayTVC") as! CustomPayTVC
        
        vc.cityId = Int(cityId)
         vc.packageId = Int(packages!.packageId)!
         vc.offerAmount = Int(packages!.offerAmount) ?? 0
         vc.amount = Int(packages!.amount) ?? 0
//         vc.branchId = Int(self.branchId)
        
//        vc.packageAmount = packageAmount
//        vc.phoneNumber = phoneNumberTextField.text!
//        vc.name = nameTextField.text!
//        vc.emailAddress = emailAddressTextField.text!
//        vc.dateOfBirth = dateOfBirth.text!
//        vc.gender = genderTextField.text!
        
        if let packages = packages {


        vc.cityId = cityId
            vc.packageId = Int(packages.packageId)!
            vc.offerAmount = Int(packages.offerAmount) ?? 0
            vc.amount = Int(packages.amount) ?? 0
            vc.branchId = "\(branchId)"

            if (packages.PkgMinAmount.isEmpty) {
                vc.packageAmount = Int(packages.offerAmount) ?? 0

            } else if (packages.offerAmount.isEmpty) {
                vc.packageAmount = Int(packages.amount) ?? 0

            } else {
                vc.packageAmount = Int(packages.PkgMinAmount) ?? 0
            }
         self.navigationController?.pushViewController(vc, animated: true)

    }
        
        vc.cityId = cityId
        vc.packageId = Int(packages!.packageId)!
        vc.offerAmount = Int(packages!.offerAmount) ?? 0
        vc.amount = Int(packages!.amount) ?? 0
        vc.branchId = "\(branchId)"
        
        if (packages?.PkgMinAmount.isEmpty)! {
            vc.packageAmount = Int(packages!.offerAmount) ?? 0

        } else if (packages?.offerAmount.isEmpty)! {
            vc.packageAmount = Int(packages!.amount) ?? 0
        }
    }
}
    
    
    
//    func initiatePayment() {
//        activityIndicator.startActivityIndicatorOn(view)
//        let successfullySet = setupPaymentParams()
//        if !successfullySet {
//            self.activityIndicator.stopActivityIndicator()
//            return
//        }
//
//        fetchHashes(withParams: paymentParams!) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                self.fetchPaymentOptions(withParams: self.paymentParams!, completion: { [weak self] result in
//                    guard let self = self else { return }
//                    self.activityIndicator.stopActivityIndicator()
//
//                    switch result {
//                    case .success:
//                        DispatchQueue.main.async {
//                            let checkoutVC = self.storyboard!.instantiateViewController(withIdentifier: "ChoosePaymentOptionVC") as! ChoosePaymentOptionVC
//                            checkoutVC.allUpiPaymentOptions = self.availablePaymentOptions
//                            checkoutVC.paymentParams = self.paymentParams
//                            self.setupPayUCallbackHandlers()
//                            self.navigationController?.pushViewController(checkoutVC, animated: true)
//                        }
//
//                    case .failure(let error):
//                        Helper.showAlert(error.description, onController: self)
//                    }
//                })
//            case .failure(let error):
//                self.activityIndicator.stopActivityIndicator()
//                print("Unable to fetch hashes: \(error)")
//                Helper.showAlert(error.description, onController: self)
//            }
//        }
//
//    }
//}

// payuMoney
//extension PackageDetailViewController {
//
//    func setupPayUCallbackHandlers() {
//        setupPaymentCompletionHandler()
//        setupOnEnteringVPAHandler()
//        setupBackpressHandler()
//    }
//
//    func setupPaymentParams() -> Bool {
//        PayUUPICore.shared.logLevel = .error
//        PayUUPICore.shared.environment = .mobiletest
//        do {
//            paymentParams = try PayUPaymentParams(
//                merchantKey: PayUUPICore.shared.environment == .production ? "smsplus" : "obScKz", //Your merchant key for the current environment
//                transactionId: randomString(length: 6), //Your unique ID for this trasaction
//                amount: self.amountTextField.text ?? "1", //Amount of transaction
//                productInfo: "iPhone", // Description of the product
//                firstName: "Vipin", // First name of the user
//                email: "johnappleseed@apple.com", // Email of the useer
//                //User defined parameters.
//                //You can save additional details with each txn if you need them for your business logic.
//                //You will get these details back in payment response and transaction verify API
//                //Like, you can add SKUs for which payment is made.
//                udf1: "",
//                //You can keep all udf fields blank if you do not have any requirement to save your custom txn specific data at PayU's end
//                udf2: "",
//                udf3: "",
//                udf4: "",
//                udf5: "")
//            paymentParams?.userCredentials = "smsplus:myUserEmail@payu.in" // "merchantKey:user'sUniqueIdentifier"
//            paymentParams?.surl = "https://payu.herokuapp.com/ios_success" // Success URL. Not used but required due to mandatory check in API.
//            paymentParams?.furl = "https://payu.herokuapp.com/ios_failure" // Failure URL. Not used but required due to mandatory check in API.
//            paymentParams?.phoneNumber = mobileTextField.text ?? "9123456789" // "10 digit phone number here"
//            return true
//        } catch let error as PayUError {
//            Helper.showAlert("Could not create post params due to: \(error.description)", onController: self)
//            return false
//        } catch {
//            Helper.showAlert("Could not create post params due to: \(error.localizedDescription)", onController: self)
//            return false
//        }
//    }
//
//
//    func fetchHashes(withParams params: PayUPaymentParams,
//                     completion: @escaping(Result<Bool, SampleAppError> )->()) {
//
//        APIManager().getHashes(params: paymentParams!) {[weak self] (hashes, error) in
//            guard let self = self else { return }
//
//            if let error = error {
//                completion(.failure(error))
//            }
//
//            if let hashes = hashes {
//                print(hashes)
//                self.paymentParams?.hashes = self.getPayUHashesModel(fromHashes: hashes)
//
//                completion(.success(true))
//
//            } else {
//                completion(.failure(.error(SampleAppError.hashError)))
//            }
//        }
//    }
//
//    func fetchPaymentOptions(withParams params: PayUPaymentParams,
//                             completion: @escaping( (Result<Bool, SampleAppError>)->() )) {
//
//        PayUAPI.getUPIPaymentOptions(withPaymentParams: self.paymentParams!, completion: { [weak self] result in
//            switch result {
//            case .success(let paymentOptions):
//                self?.availablePaymentOptions = paymentOptions
//                completion(.success(true))
//            case .failure(let payuError):
//                print(payuError)
//                completion(.failure(.error(payuError.description)))
//            }
//        })
//
//    }
//
//    // MARK: - Helper
//    func randomString(length: Int) -> String {
//        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        return String((0..<length).map{ _ in letters.randomElement()! })
//    }
//
//
//    func handleAPI(result: Result<PayUPureS2SModel, PayUError>) {
//        switch result {
//        case .success(let model):
//            print(model)
//        case .failure(let err):
//            print("Error: \(err.description)")
//        }
//    }
//
//    func getPayUHashesModel(fromHashes hashes: Hashes) -> PayUHashes{
//        var payuHashes = PayUHashes()
//        payuHashes.paymentOptionsHash = hashes.paymentOptionsHash
//        payuHashes.paymentHash = hashes.paymentHash
//        payuHashes.validateVPAHash = hashes.validateVPAHash
//
//        return payuHashes
//    }
//
//}
