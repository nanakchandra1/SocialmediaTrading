//
//  ChooseMarketVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 08/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseMarketVC: MutadawelBaseVC {
    
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var chooseMarketTableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var selectAllBgView: UIView!
    @IBOutlet weak var selectAllLbl: UILabel!
    @IBOutlet weak var selectAllImg: UIImageView!
    @IBOutlet weak var selectAllBtn: UIButton!

    
    var selectedIndex = [Int]()
    var marketList = [MarketModel]()
    var openMode : Int = 0
    var isAll = false
    var isfirstSelected = false
    var filteredMarketList = [MarketModel]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialSetup()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    func initialSetup(){
        self.searchTextField.delegate = self
        
        self.chooseMarketTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.nextBtn.setTitle(NEXT.localized, for: UIControlState.normal)
        self.navigationTitle.text = CHOOSE_MARKET.localized
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.chooseMarketTableView.delegate = self
        self.chooseMarketTableView.dataSource = self
        self.searchTextField.placeholder = SEARCH.localized
        if sharedAppdelegate.appLanguage == .Arabic{
            self.searchTextField.textAlignment = .right
        }else{
            self.searchTextField.textAlignment = .left
        }

        self.backBtn.rotateBackImage()
        if sharedAppdelegate.appLanguage == .Arabic{
            self.backBtn.setImage(#imageLiteral(resourceName: "ic_following_back").imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }else{
            self.backBtn.setImage(#imageLiteral(resourceName: "ic_following_back"), for: .normal)
        }
        
        
        getMarketList()
//        let data : JSONDictionary = ["lastVisitedScreen": lastVisitedScreen.market.rawValue as AnyObject]
//        UserData.sharedInstance.saveJSONDataToUserDefault(data: data)
        
        if self.openMode == 1 {
            
            let homePage = homeStoryboard.instantiateViewController(withIdentifier: "HomeID") as! HomeVC
            
            self.navigationController?.viewControllers = [homePage,self]
            
        }

     }
   
    
    func getMarketList(){
        
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id! 
        showLoader()

        getMarketListAPI(params: params) { (success, msg, data) in
            
            print_debug(object: data)
            
            hideLoader()
            
            if success{
                
                for res in data!{
                    
                    let market = MarketModel(with: res)
                    self.marketList.append(market)
                }
                
                self.filteredMarketList = self.marketList

                for (key ,Val) in self.marketList.enumerated(){
                    
                    if let is_selected = Val.is_selected{
                        
                        if is_selected.localizedLowercase == "yes".localizedLowercase {
                            
                            self.selectedIndex.append(key)
                            
                        }
                    }
                }
                
                if self.selectedIndex.count == self.marketList.count{
                    self.selectAllBtn.isSelected = true
                    self.selectAllLbl.text = DESELECT_ALL.localized
                }

            }else{
                showToastWithMessage(msg: msg)
            }
            self.chooseMarketTableView.reloadData()
            print_debug(object: data)
        }
        
    }
    
    
    
    private func chooseMarket(){
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id ?? ""
        
        var id = ""
        
        if self.isAll{
            
            for res in self.marketList{
                
                if let _id = res.id{
                    
                    if id == ""{
                        
                        id = _id
                        
                    }else{
                        
                        id = "\(id),\(_id)"
                    }
                }
            }
        }else{
            
            for res in self.selectedIndex{
                
                if let _id = self.marketList[res].id{
                    
                    if id == ""{
                        
                        id = _id
                        
                    }else{
                        
                        id = "\(id),\(_id)"
                    }
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
                
                if self.selectedIndex.count == 1{
                    if let market = self.marketList[self.selectedIndex.first!].name{
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
                    for res in self.selectedIndex{
                        
                        if let market = self.marketList[res].name{
                            
                            if market.localizedLowercase == FOREX_MARKET.localizedLowercase{
                                
                                let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChooseIndexesID") as! ChooseIndexesVC
                                obj.isCurrency = true
                                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                                break
                            }
                        }else{
                            
                            if res == self.selectedIndex.last{
                                
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
    
    
    func showNodata(){
        
        if self.filteredMarketList.isEmpty{
            self.chooseMarketTableView.backgroundView = makeLbl(view: self.view, msg: data_not_available.localized)
            self.chooseMarketTableView.backgroundView?.isHidden = false
        }else{
            self.chooseMarketTableView.backgroundView?.isHidden = true
        }
    }

    
    @IBAction func selectAllBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            self.selectedIndex.removeAll()
            
            self.isAll = true
            
            for (key,_) in self.marketList.enumerated(){
                self.selectedIndex.append(key)
                self.selectAllLbl.text = DESELECT_ALL.localized
            }
        }else{
            self.selectAllLbl.text = SELECT_ALL.localized
            self.isAll = false
            self.selectedIndex.removeAll()
        }
        self.chooseMarketTableView.reloadData()
    }

    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        
        if !selectedIndex.isEmpty{
            self.chooseMarket()
        }else{
            showToastWithMessage(msg: Please_select_atleast_one_market.localized)
        }
    }
}


//MARK:- Tableview delegaet datasource
//MARK:- ===========================================================

extension ChooseMarketVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredMarketList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseMarketCell", for: indexPath) as! ChooseMarketCell
            
        let data = self.filteredMarketList[indexPath.row]
        
        cell.populateData(marketInfo: data,isAll: false ,selectedIndex: self.selectedIndex,index: indexPath.row)
            
        return cell
            
            
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
            if (self.selectedIndex.contains(indexPath.row)){
                
                let indexs = self.selectedIndex.filter({ ($0 != indexPath.row)})
                
                self.selectedIndex = indexs
                
            }else{
                
                self.selectedIndex.append(indexPath.row)
                
            }
        
        if self.selectedIndex.count == self.marketList.count{
            self.selectAllBtn.isSelected = true
            self.selectAllLbl.text = DESELECT_ALL.localized
        }else{
            self.selectAllBtn.isSelected = false
            self.selectAllLbl.text = SELECT_ALL.localized
            
        }

        self.chooseMarketTableView.reloadData()
            
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
            return 200
            
    }
    
}



extension ChooseMarketVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var search = ""
        
        if string.isEmpty{
            
            search = String(textField.text!.characters.dropLast())
            
        }else{
            
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
        self.chooseMarketTableView.reloadData()
        return true
    }
    
    
    
}

//MARK:- Tble view cell class

class ChooseMarketCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var symbolImg: UIImageView!
    @IBOutlet weak var marketNameLbl: UILabel!
    @IBOutlet weak var nextArrowImg: UIImageView!
    @IBOutlet weak var tickBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func populateData(marketInfo: MarketModel, isAll: Bool,selectedIndex: [Int],index: Int){
        
        
        //self.symbolImg?.image = UIImage(named: "ic_choose_market_forex")
        
        if let img = marketInfo.image{
            
            let imageUrl = URL(string: img)
            self.symbolImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_choose_market_forex"))
            
        }

        
        if let name = marketInfo.name{
                
                self.marketNameLbl.text = name
            }
        
        if sharedAppdelegate.appLanguage == .Arabic{
            self.nextArrowImg.image = #imageLiteral(resourceName: "ic_settings_backarrow")
        }else{
            
            self.nextArrowImg.image = #imageLiteral(resourceName: "ic_settings_nextarrow")
        }

        
        if isAll{
            self.tickBtn.setImage(ButtonImg.selectedCircle, for: UIControlState.normal)
        }else{
            if selectedIndex.contains(index){
                self.tickBtn.setImage(ButtonImg.selectedCircle, for: UIControlState.normal)
            }else{
                self.tickBtn.setImage(ButtonImg.deSelectedCircle, for: UIControlState.normal)
            }
        }
    }
}



//MARK:- Choose market delegate method
//MARK:- ========================

extension ChooseMarketVC: ChooseMarketDelegate{

    func setChooseMarket(markets: [Int]) {
        self.selectedIndex  = markets
        self.chooseMarketTableView.reloadData()
        print_debug(object: self.selectedIndex)
    }

}

class OtherMarketCell: UITableViewCell {
    
    @IBOutlet weak var otherMarketNameLbl: UILabel!
    @IBOutlet weak var nextArrowImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
