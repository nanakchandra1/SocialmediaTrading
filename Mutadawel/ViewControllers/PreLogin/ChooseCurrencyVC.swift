//
//  ChooseCurrencyVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 31/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseCurrencyVC: UIViewController {
    
    

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var chooseIndexesTableView: UITableView!
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var selectAllBgView: UIView!
    @IBOutlet weak var selectAllLbl: UILabel!
    @IBOutlet weak var selectAllImg: UIImageView!
    @IBOutlet weak var selectAllBtn: UIButton!
    
   // var selectedCurrencyIndexPath = [Int]()
    
    var selectedCurrencyId = [Int]()
    var isAll = false
    var currncyListArray = [CurrencyModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        var tapGasture =  UITapGestureRecognizer()
        tapGasture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification:Notification!) -> Void in
            
            self.view.addGestureRecognizer(tapGasture)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil,
                                               
                                               queue: OperationQueue.main) {_ in
                                                
                                                self.view.removeGestureRecognizer(tapGasture)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismissKeyboard(_sender: AnyObject)
    {
        self.view.endEditing(true)
    }
    
    
    func initialSetup(){
        
//        let data : JSONDictionary = ["lastVisitedScreen": lastVisitedScreen.currency.rawValue as AnyObject]
//        UserData.sharedInstance.saveJSONDataToUserDefault(data: data)

        self.chooseIndexesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        if sharedAppdelegate.appLanguage == .Arabic{
            self.searchTextField.textAlignment = .right
        }else{
            self.searchTextField.textAlignment = .left
        }
        self.chooseIndexesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.searchTextField.delegate = self
        self.navigationTitle.text = CHOOSE_CURRENCIES.localized
        self.continueBtn.setTitle(NEXT.localized, for: UIControlState.normal)
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.chooseIndexesTableView.delegate = self
        self.chooseIndexesTableView.dataSource = self
        self.continueBtn.setTitle(NEXT.localized, for: UIControlState.normal)
        self.selectAllBtn.setTitle(SELECT_ALL.localized, for: UIControlState.normal)
        self.searchTextField.placeholder = SEARCH.localized
        self.selectAllLbl.text = SELECT_ALL.localized
        self.getcurrencyList()
        self.backBtn.rotateBackImage()
        
       
    }
    
    func showNodata(){
        if self.currncyListArray.isEmpty{
            self.chooseIndexesTableView.backgroundView = makeLbl(view: self.view, msg: data_not_available.localized)
            self.chooseIndexesTableView.backgroundView?.isHidden = false
        }else{
            self.chooseIndexesTableView.backgroundView?.isHidden = true
        }
        
    }

    
    func getcurrencyList(){
        
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id!
        showLoader()
        
        getStock_currncy_ListAPI(params: params, url: EndPoint.getCurrencyuListURL) { (success, msg, data) in
            print_debug(object: data)
            hideLoader()
            
            if success{
                
                self.currncyListArray = data!.map({ (currency) -> CurrencyModel in
                    CurrencyModel(withData: currency)
                })
                
                let currency = self.currncyListArray.filter({$0.is_selected.lowercased() == "yes"})
                
                for res in currency{

                    self.selectedCurrencyId.append(Int(res.currency_id)!)

                }
                
                if self.selectedCurrencyId.count == self.currncyListArray.count{
                    
                    self.selectAllBtn.isSelected = true
                    self.selectAllLbl.text = DESELECT_ALL.localized
                    
                }
                print_debug(object: data!)
                self.chooseIndexesTableView.reloadData()
                
            }else{
                
                showToastWithMessage(msg: msg)
            }
            self.showNodata()

        }
    }

    
    func searchCurrency(offset: Int, text: String){
        
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id!
        params["searchText"] = text
        params["page_number"] = offset 

        getStock_currncy_ListAPI(params: params, url: EndPoint.currencySearchURL) { (success, msg, data) in
            if success{
                
                self.currncyListArray = data!.map({ (currency) -> CurrencyModel in
                    CurrencyModel(withData: currency)
                })

            }else{
                
                self.currncyListArray.removeAll()
                
            }
            self.showNodata()
            self.chooseIndexesTableView.reloadData()

        }
    }
    
    private func chooseCurrency(info: [CurrencyModel]){
        
        print_debug(object: info)
        
        var params = JSONDictionary()
        
        let id = self.makeId(info: info)
        
            params["currencyIds"] = id
        
            params["userId"] = CurrentUser.user_id
        
        print_debug(object: params)
        
        showLoader()
        chooseCurrencyListAPI(params: params,url: EndPoint.chooseCurrencyuListURL) { (success, msg, data) in
            print_debug(object: data)
            hideLoader()
            if success{
                userDefaults.set("yes", forKey: UserDefaultsKeys.is_currency_selected)

                    let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChoosePeopleID") as! ChoosePeopleVC
                    self.navigationController?.pushViewController(obj, animated: true)

            }else{
                showToastWithMessage(msg: msg)
            }
        }
    }
    
    
    func makeId(info: [CurrencyModel]) -> String{
        
        var id = ""
        
        if self.isAll{
            
            for res in info{
                
                 let _id = res.currency_id ?? ""
                    
                    if id.isEmpty{
                        
                        id = _id
                        
                    }else{
                        
                        id = "\(id),\(_id)"
                    }
            }
            }else{
            for s_id in self.selectedCurrencyId{
                print_debug(object: s_id)
                id = "\(id),\(s_id)"
                
            }

            }
        print_debug(object: id)

        return id
    }
    
    
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        
            self.chooseCurrency(info: self.currncyListArray)
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
            _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectAllBtnTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
            if sender.isSelected{
                
                self.selectedCurrencyId.removeAll()
                
                self.isAll = true
                
                for (_,Val) in self.currncyListArray.enumerated(){
                    

                    self.selectedCurrencyId.append(Int(Val.currency_id)!)

                    self.selectAllLbl.text = DESELECT_ALL.localized
                }
            }else{
                
                self.selectAllLbl.text = SELECT_ALL.localized
                self.isAll = false
                self.selectedCurrencyId.removeAll()
            }
            
        self.chooseIndexesTableView.reloadData()
    }
    
}


extension ChooseCurrencyVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.currncyListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCurrencyCell", for: indexPath) as! ChooseCurrencyCell
        
            let data = self.currncyListArray[indexPath.row]
           // cell.populateView(index: indexPath.row, userInfo: data, selectedIndexPath: self.selectedCurrencyIndexPath, isAll: self.isAll ? true : false)
        cell.populateViewWithCurrencyId(userInfo: data, selectedCurrencyId: self.selectedCurrencyId, isAll:  self.isAll ? true : false)
               return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isAll = false

//        if (self.selectedCurrencyIndexPath.contains(indexPath.row)){
//            let indexs = self.selectedCurrencyIndexPath.filter({ ($0 != indexPath.row)})
//            self.selectedCurrencyIndexPath = indexs
//            if self.selectedCurrencyIndexPath.count < self.currncyListArray.count {
//                self.selectAllBtn.isSelected = false
//                self.selectAllLbl.text = "Select All"
//            }
//        }else{
//            self.selectedCurrencyIndexPath.append(indexPath.row)
//            
//            if self.selectedCurrencyIndexPath.count == self.currncyListArray.count{
//                
//                self.selectAllBtn.isSelected = true
//                self.selectAllLbl.text = "Deselect All"
//            }
//        }
        let id = Int(self.currncyListArray[indexPath.row].currency_id)
        
        if (self.selectedCurrencyId.contains(id!)){
            
            let indexs = self.selectedCurrencyId.filter({ ($0 != id)})
            
            self.selectedCurrencyId = indexs
            if self.selectedCurrencyId.count < self.currncyListArray.count {
                self.selectAllBtn.isSelected = false
                self.selectAllLbl.text = SELECT_ALL.localized
            }
            
        }else{
            self.selectedCurrencyId.append(id!)
            if self.selectedCurrencyId.count == self.currncyListArray.count{
                self.selectAllBtn.isSelected = true
                self.selectAllLbl.text = DESELECT_ALL.localized
            }
        }

        
        self.chooseIndexesTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 70
    }
}
//MARK:- Textfield delegate methods


extension ChooseCurrencyVC: UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        print_debug(object: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !(textField.text?.isEmpty)!{
            let str = textField.text!
            self.searchCurrency(offset: 1, text: str)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delayWithSeconds(0.1) {
            if !(textField.text?.isEmpty)!{
                let str = textField.text!
                if str.characters.count >= 3{
                    self.searchCurrency(offset: 1, text: str)
                }
            }else{
                self.getcurrencyList()
            }
        }
        return true
    }
}


//MARK:- Tble view cell class

class ChooseCurrencyCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var selectedImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLbl.text = NAME.localized
    }
    
    
    func populateViewWithCurrencyId(userInfo: CurrencyModel,selectedCurrencyId: [Int],isAll: Bool){
        
            self.nameLbl.text = userInfo.symbol
        
            let followers = userInfo.follower ?? ""
        
        self.followersCountLbl.text = followers + " " + FOLLOWERS.localized
        
        if !isAll{
            
            let currency_id = Int(userInfo.currency_id)

            if selectedCurrencyId.contains(currency_id!){
                
                self.selectedImg.image = UIImage(named: "ic_choose_indexes_eclipseselect")
                
            }else{
                
                self.selectedImg.image = UIImage(named: "ic_choose_indexes_eclipsedeselect")
                
            }
        }else{
            
            self.selectedImg.image = UIImage(named: "ic_choose_indexes_eclipseselect")
        }
    }
    
}
