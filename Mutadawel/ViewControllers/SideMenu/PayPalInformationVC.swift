//
//  PayPalInformationVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 19/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class PayPalInformationVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var payPalInfoTableView: UITableView!
    @IBOutlet weak var popupBGView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var payPalNameTextFielf: SkyFloatingLabelTextField!
    @IBOutlet weak var addPaypalInfoLbl: TTTAttributedLabel!
    @IBOutlet weak var payPalEmailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    // var details = ["Full Name","Account Name","IBAN","Account Number"]
    var payPalInfo = PayPalInfoModel()
    let eventId = "paypal"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialViewSetUp()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if let view = touches.first?.view {
            if view == self.popupBGView && !self.popupBGView.subviews.contains(view) {
                self.popupBGView.isHidden = true
            }
        }
    }
    
    
    @IBAction func backbtnTapped(_ sender: UIButton) {
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func paypalInfoSaveBtnTapped(_ sender: UIButton) {
        
        if !self.payPalNameTextFielf.hasText{
            showToastWithMessage(msg: Enter_paypal_name.localized)
            return
        }
        if !self.payPalEmailTextField.hasText{
            showToastWithMessage(msg: Enter_paypal_email_or_mobile_number.localized)
            setEvent(eventName: FirebaseEventName.wrong_email, params: ["eventId": self.eventId as NSObject])
            
            return
        }
        
        self.savePayPalInfo()
    }
    
    
    
    func initialViewSetUp(){
        
        self.popupBGView.isHidden = true
        self.saveBtn.layer.cornerRadius = 3
        self.popupView.layer.cornerRadius = 3
        self.payPalInfoTableView.dataSource = self
        self.payPalInfoTableView.delegate = self
        self.backBtn.rotateBackImage()
        self.navigationTitle.text = PayPaltitle.localized
        self.saveBtn.setTitle(SAVE_BTN.localized, for: .normal)
        self.payPalNameTextFielf.placeholder = PayPal_Name.localized
        self.payPalNameTextFielf.selectedTitle = PayPal_Name.localized
        self.payPalNameTextFielf.title = PayPal_Name.localized
        self.payPalEmailTextField.placeholder = PayPal_Email.localized
        self.payPalEmailTextField.selectedTitle = PayPal_Email.localized
        self.payPalEmailTextField.title = PayPal_Email.localized
        self.addPaypalInfoLbl.text = Add_Paypal.localized
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.payPalNameTextFielf.textAlignment = .right
            self.payPalEmailTextField.textAlignment = .right
            self.addPaypalInfoLbl.textAlignment = .right
            
            
        }else{
            
            self.payPalNameTextFielf.textAlignment = .left
            self.payPalEmailTextField.textAlignment = .left
            self.addPaypalInfoLbl.textAlignment = .left
            
            
        }
        
        self.getPayPalInfo()
        self.getBankDetail()
        
    }
    
    
    
    func savePayPalInfo(){
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
        params["paypalName"] = self.payPalNameTextFielf.text!
        params["account"] = self.payPalEmailTextField.text!
        
        showLoader()
        
        savePayPalDetailAPI(params: params) { (success, msg, data) in
            hideLoader()
            if success{
                self.popupBGView.isHidden = true
            }
            showToastWithMessage(msg: msg)
            
        }
    }
    
    
    
    func getPayPalInfo(){
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
        getPayPalDetailAPI(params: params) { (success, msg, data) in
            
            if success{
                
                if let paypal_name = data?["paypal_name"].string{
                    
                    self.payPalNameTextFielf.text = paypal_name
                }
                
                if let account = data?["account"].stringValue{
                    
                    self.payPalEmailTextField.text = account
                    
                }
            }
        }
    }
    
    
    func getBankDetail(){
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
        showLoader()
        getBankDetailAPI(params: params) { (success, msg, data) in
            hideLoader()
            if success{
                
                self.payPalInfo = PayPalInfoModel(with: data!)
                self.payPalInfoTableView.reloadData()
            }
        }
        
    }
}


extension PayPalInformationVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 7
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UpperViewPayPalCell", for: indexPath) as? UpperViewPayPalCell else{
                fatalError("Cell not found")
            }
            cell.enterPaypalBtn.addTarget(self, action: #selector(enterPAypalBtnTapped), for: .touchUpInside)
            return cell
            
        case 1,2,4,5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PayPalDetails", for: indexPath)  as? PayPalDetails else{
                fatalError("Cell not found")
            }
            cell.detailsTxtfield.delegate = self
            
            if indexPath.row == 1{
                
                cell.detailsTxtfield.keyboardType  = .asciiCapable
                
                if let name = self.payPalInfo.holder_name{
                    
                    cell.detailsTxtfield.text = name
                    
                }else{
                    cell.detailsTxtfield.text = ""
                    
                    cell.detailsTxtfield.placeholder = Full_Name.localized
                }
            }else if indexPath.row == 2{
                
                cell.detailsTxtfield.keyboardType  = .asciiCapable
                
                if let bank_name = self.payPalInfo.bank_name{
                    
                    cell.detailsTxtfield.text = bank_name
                    
                }else{
                    cell.detailsTxtfield.text = ""
                    
                    cell.detailsTxtfield.placeholder = Account_Name.localized
                }
            }else if indexPath.row == 4{
                
                cell.detailsTxtfield.keyboardType  = .asciiCapable
                
                if let iban = self.payPalInfo.iban{
                    
                    cell.detailsTxtfield.text = iban
                    
                    
                }else{
                    cell.detailsTxtfield.text = ""
                    
                    cell.detailsTxtfield.placeholder = IBAN.localized
                }
                
            }else {
                
                cell.detailsTxtfield.keyboardType  = .numberPad
                
                if let account_number = self.payPalInfo.account_number{
                    cell.detailsTxtfield.text = account_number
                    
                }else{
                    cell.detailsTxtfield.text = ""
                    cell.detailsTxtfield.placeholder = Account_Number.localized
                }
                
                
            }
            
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCity", for: indexPath)  as? CountryCity else{
                fatalError("Cell not found")
            }
            cell.countryTxtfield.delegate = self
            cell.cityTxtfield.delegate = self
            cell.cityTxtfield.keyboardType  = .asciiCapable
            
            cell.countryBtn.addTarget(self, action: #selector(selectCountry), for: .touchUpInside)
            
            if let country = self.payPalInfo.country{
                
                cell.countryTxtfield.text = country
                
            }else{
                cell.countryTxtfield.text = ""
                
                cell.countryTxtfield.placeholder = Country.localized
            }
            if let city = self.payPalInfo.city{
                
                cell.cityTxtfield.text = city
                
            }else{
                
                cell.cityTxtfield.text = ""
                
                cell.cityTxtfield.placeholder = City.localized
                
            }
            
            
            return cell
            
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SaveBtn", for: indexPath)  as? SaveBtn else{
                fatalError("Cell not found")
            }
            cell.saveBtn.setTitle(SAVE_BTN.localized, for: .normal)
            cell.saveBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            cell.saveBtn.addTarget(self, action: #selector(saveBtnTapped), for: .touchUpInside)
            return cell
            
        default: return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 150
        case 1,2,4,5:
            return 55
            
        case 3:
            return 55
            
        case 6:
            return 85
            
            
        default: return 0
            
        }
    }
    
    
    func selectCountry(_ sender: UIButton){
        
        self.view.endEditing(true)
        let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "CountryCodeID") as! CountryCodeVC
        obj.delegate = self
        sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        
    }
    
    func saveBtnTapped(_ sender: UIButton){
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id ?? ""
        
        guard let holder_name = self.payPalInfo.holder_name , !holder_name.isEmpty else{
            showToastWithMessage(msg: Please_enter_your_full_name.localized)
            setEvent(eventName: FirebaseEventName.please_enter_name_error, params: ["eventId": self.eventId as NSObject])
            
            return
        }
        guard let bank_name = self.payPalInfo.bank_name, !bank_name.isEmpty else{
            showToastWithMessage(msg: Please_enter_your_bank_name.localized)
            setEvent(eventName: FirebaseEventName.please_enter_bank_name_error, params: ["eventId": self.eventId as NSObject])
            
            return
        }
        
        guard let country = self.payPalInfo.country, !Country.isEmpty else{
            showToastWithMessage(msg: Please_enter_your_country.localized)
            setEvent(eventName: FirebaseEventName.please_enter_country_error, params: ["eventId": self.eventId as NSObject])
            
            return
        }
        
        guard let city = self.payPalInfo.city, !city.isEmpty else{
            showToastWithMessage(msg: Please_enter_your_city.localized)
            setEvent(eventName: FirebaseEventName.please_enter_city_error, params: ["eventId": self.eventId as NSObject])
            
            return
        }
        
        guard let iban = self.payPalInfo.iban, !iban.isEmpty else{
            showToastWithMessage(msg: Please_enter_your_IBAN.localized)
            setEvent(eventName: FirebaseEventName.please_enter_ibank_error, params: ["eventId": self.eventId as NSObject])
            
            return
        }
        
        guard let account_number = self.payPalInfo.account_number, !account_number.isEmpty else{
            showToastWithMessage(msg: Please_enter_your_account_number.localized)
            setEvent(eventName: FirebaseEventName.bank_account, params: ["eventId": self.eventId as NSObject])
            
            return
        }
        
        params["name"] = holder_name
        
        params["bankName"] = bank_name
        
        params["country"] = country
        
        params["city"] = city
        
        params["iban"] = iban
        
        params["accountNumber"] = account_number
        
        
        showLoader()
        bankDetailAPI(params: params) { (success, msg, data) in
            hideLoader()
            
            if success{
                setEvent(eventName: FirebaseEventName.successful_submit, params: ["eventId": self.eventId as NSObject])
                
                sharedAppdelegate.nvc.popViewController(animated: true)
                showToastWithMessage(msg: msg)
            }
            
        }
        
        
        
        
    }
    
    
    func enterPAypalBtnTapped(_ sender: UIButton){
        
        self.popupBGView.isHidden = false
        
    }
    
    
}


extension PayPalInformationVC:UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let indexPath = textField.tableViewIndexPath(tableView: self.payPalInfoTableView) else {
            return false
        }
        
        if isValidNumber(str: string){
            
            return false
            
        }
        
        
        delayWithSeconds(0.01) {
            if indexPath.row == 1{
                
                
                self.payPalInfo.holder_name  = textField.text
                
            }else if indexPath.row == 2{
                
                
                self.payPalInfo.bank_name  = textField.text
                
            }else if indexPath.row == 3{
                
                if let countryCityCell = textField.tableViewCell() as? CountryCity{
                    
                    if textField === countryCityCell.countryTxtfield{
                        
                        self.payPalInfo.country  = textField.text
                        
                    }else{
                        
                        self.payPalInfo.city  = textField.text
                        
                    }
                    
                }
                
            }else if indexPath.row == 4{
                
                
                self.payPalInfo.iban  = textField.text
                
            }else if indexPath.row == 5{
                
                
                self.payPalInfo.account_number  = textField.text
                
            }
        }
        
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        
        switch indexPath.row {
            
            
        case 1:
            
            return newLength <= 20 // Bool
            
        case 2:
            
            return newLength <= 20 // Bool
            
        case 3:
            
            return newLength <= 15 // Bool
            
        case 4:
            
            return newLength <= 15 // Bool
            
        case 5:
            
            return newLength <= 16 // Bool
            
        default:
            return true
        }
    }
}


extension PayPalInformationVC: SetContryCodeDelegate{
    
    func setCountryCode(country_info: JSONDictionary) {
        guard let CountryEnglishName = country_info["CountryEnglishName"] else{return}
        
        self.payPalInfo.country = "\(CountryEnglishName)"
        self.payPalInfoTableView.reloadData()
    }
}


class UpperViewPayPalCell : UITableViewCell{
    
    @IBOutlet weak var payPalLogo: UIImageView!
    @IBOutlet weak var payPalInfoLbl: UILabel!
    @IBOutlet weak var personalAccntLabel: UILabel!
    @IBOutlet weak var enterPaypalBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.payPalInfoLbl.text = Enter_Paypal_Info.localized
        self.personalAccntLabel.text = Enter_Personal_Account.localized
    }
}


class PayPalDetails : UITableViewCell{
    
    @IBOutlet weak var detailsTxtfield: SkyFloatingLabelTextField!
    @IBOutlet weak var viewForTxtfield: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.detailsTxtfield.text = ""
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.detailsTxtfield.textAlignment = .right
            
        }else{
            
            self.detailsTxtfield.textAlignment = .left
            
        }
        
    }
    
}

class CountryCity : UITableViewCell{
    
    @IBOutlet weak var countryTxtfield: SkyFloatingLabelTextField!
    @IBOutlet weak var viewForCountryTxtfield: UIView!
    @IBOutlet weak var cityTxtfield: SkyFloatingLabelTextField!
    @IBOutlet weak var viewForTxtfield: UIView!
    @IBOutlet weak var countryBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.countryTxtfield.text = ""
        self.cityTxtfield.text = ""
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.countryTxtfield.textAlignment = .right
            self.cityTxtfield.textAlignment = .right
            
        }else{
            
            self.countryTxtfield.textAlignment = .left
            self.cityTxtfield.textAlignment = .left
            
        }
        
    }
    
    
}


class SaveBtn : UITableViewCell{
    
    @IBOutlet weak var saveBtn: UIButton!
    
}









