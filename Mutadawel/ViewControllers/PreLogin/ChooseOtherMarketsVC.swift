//
//  ChooseOtherMarketsVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 24/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ChooseMarketDelegate {
    func setChooseMarket(markets: [Int])
}

class ChooseOtherMarketsVC: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var chooseOtherMarketTableView: UITableView!
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var selectAllBgView: UIView!
    @IBOutlet weak var selectAllLbl: UILabel!
    @IBOutlet weak var selectAllImg: UIImageView!
    @IBOutlet weak var selectAllBtn: UIButton!

    var selectedIndexPath = [Int]()
    var isAll = false
    var marketList = [MarketModel]()
    var delegate:ChooseMarketDelegate!
    var filteredMarketList = [MarketModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print_debug(object: marketList)
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
        
       // self.chooseMarket()
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
        self.backBtn.rotateBackImage()
        if sharedAppdelegate.appLanguage == .Arabic{
            self.searchTextField.textAlignment = .right
        }else{
            self.searchTextField.textAlignment = .left
        }
        self.searchTextField.delegate = self
        self.chooseOtherMarketTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.navigationTitle.text = CHOOSE_OTHET_MARKET.localized
        self.continueBtn.setTitle(DONE.localized, for: UIControlState.normal)
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        
        self.filteredMarketList = self.marketList
        self.chooseOtherMarketTableView.delegate = self
        self.chooseOtherMarketTableView.dataSource = self

        for (key ,Val) in self.marketList.enumerated(){
            if let is_selected = Val.is_selected{
                if is_selected.localizedLowercase == "yes".localizedLowercase {
                    self.selectedIndexPath.append(key)
                }
            }
        }
        self.chooseOtherMarketTableView.reloadData()
        
    }
    
    
    func showNodata(){
        
        if self.filteredMarketList.isEmpty{
            self.chooseOtherMarketTableView.backgroundView = makeLbl(view: self.view, msg: data_not_available.localized)
            self.chooseOtherMarketTableView.backgroundView?.isHidden = false
        }else{
            self.chooseOtherMarketTableView.backgroundView?.isHidden = true
        }
    }

    
    
    private func chooseMarket(){
        
        var params = JSONDictionary()
        
        
        params["userId"] = CurrentUser.user_id
        
        var id = ""
        
        if self.isAll{
            
            for res in self.marketList{
                
                 let _id = res.id ?? ""
                    
                    if id == ""{
                        
                        id = _id
                    }
                    else{
                        
                        id = "\(id),\(_id)"
                    }
            }
        }else{
            
            for res in self.selectedIndexPath{
                
                 let _id = self.marketList[res].id ?? ""
                    
                    if id == ""{
                        
                        id = _id
                    }
                    else{
                        
                        id = "\(id),\(_id)"
                    }

        }
    }
        
        
        print_debug(object: id)
        
        params["marketId"] = id
        
        print_debug(object: params)
        
        showLoader()
        
        chooseMarketAPI(params: params) { (success, msg, data) in
            
            print_debug(object: data)
            
            hideLoader()
            
            if success{
                
                userDefaults.set("yes", forKey: UserDefaultsKeys.is_market_selected)

                if self.selectedIndexPath.count == 1{
                    
                        if let market = self.marketList[self.selectedIndexPath.first!].name{
                            
                            if market.localizedLowercase == FOREX_MARKET.localizedLowercase{
                                
                                let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChooseCurrencyID") as! ChooseCurrencyVC
                                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                                
                            }else{
                                
                                let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChooseIndexesID") as! ChooseIndexesVC
                                obj.isCurrency = false
                                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                            }
                        }
                }else{
                    
                    for res in self.selectedIndexPath{
                        
                        if let market = self.marketList[res].name{
                            
                            if market.localizedLowercase == FOREX_MARKET.localizedLowercase{
                                
                                let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChooseIndexesID") as! ChooseIndexesVC
                                obj.isCurrency = true
                                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                                break
                            }
                        }else{
                            
                            if res == self.selectedIndexPath.last{
                                
                                let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChooseIndexesID") as! ChooseIndexesVC
                                obj.isCurrency = false
                                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                                break
                            }
                        }
                    }
                }

            }else{
                showToastWithMessage(msg: msg)
            }
        }
    }

    //MARK:- IBActions  
    //MARK:- ====================================

    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        
        self.searchTextField.text = ""
        self.filteredMarketList = self.marketList
        self.chooseOtherMarketTableView.reloadData()

        if self.selectedIndexPath.isEmpty{
            
            showToastWithMessage(msg: Please_select_atleast_one_market.localized)
            
        }else{
            
            self.chooseMarket()
        }
        
    }
    
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        self.delegate.setChooseMarket(markets: self.selectedIndexPath)
            _ = self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func selectAllBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
           
            self.selectedIndexPath.removeAll()
            
            self.isAll = true

            for (key,_) in self.marketList.enumerated(){
                self.selectedIndexPath.append(key)
                self.selectAllLbl.text = DESELECT_ALL.localized
            }
        }else{
            self.selectAllLbl.text = SELECT_ALL.localized
            self.isAll = false
            self.selectedIndexPath.removeAll()
        }
        self.chooseOtherMarketTableView.reloadData()
    }

}


extension ChooseOtherMarketsVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMarketList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseMarketCell", for: indexPath) as! ChooseMarketCell
        
            let data = self.filteredMarketList[indexPath.row]
        cell.populateData(marketInfo: data,isAll: self.isAll ? true : false,selectedIndex: self.selectedIndexPath,index: indexPath.row)
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isAll = false
        
        if (self.selectedIndexPath.contains(indexPath.row)){
            let indexs = self.selectedIndexPath.filter({ ($0 != indexPath.row)})
            self.selectedIndexPath = indexs
            if self.selectedIndexPath.count < self.marketList.count {
                self.selectAllBtn.isSelected = false
                self.selectAllLbl.text = "Select All"
            }
            
        }else{
            self.selectedIndexPath.append(indexPath.row)
            
            if self.selectedIndexPath.count == self.marketList.count{
                
                self.selectAllBtn.isSelected = true
                self.selectAllLbl.text = "Deselect All"
                
                
            }
        }
        self.chooseOtherMarketTableView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return self.chooseOtherMarketTableView.layer.bounds.height / 2.5
        
    }
}


extension ChooseOtherMarketsVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var search = ""
        
        if string.isEmpty
        {
            search = String(textField.text!.characters.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        
        print_debug(object: search)
        
        let arr = self.marketList.filter { (value : MarketModel) -> Bool in
            
            guard let name = value.name else{
                return false
            }
            
            return "\(name)".localizedLowercase.contains(search.localizedLowercase)
        }
        
        if search.count > 0
        {
            self.filteredMarketList.removeAll(keepingCapacity: true)
            self.filteredMarketList = arr
            self.showNodata()
        }
        else
        {
            self.filteredMarketList = self.marketList
        }
        self.chooseOtherMarketTableView.reloadData()
        return true
    }
    
    
    
}

