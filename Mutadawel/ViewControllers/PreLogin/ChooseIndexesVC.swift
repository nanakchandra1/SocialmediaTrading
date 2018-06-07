//
//  ChooseIndexsesVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 08/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

enum ChoseOption {
    case Indexes,Currency
}

class ChooseIndexesVC: MutadawelBaseVC {
    
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
    
    var selectedStockId = [Int]()
   // var selectedStockIndexPath = [Int]()
    var isCurrency:Bool!
    var isAll = false
    var id = ""
    var stockListArray = [AllStockListModel]()
    
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
    
    func showNodata(){
        
        if self.stockListArray.isEmpty{
            self.chooseIndexesTableView.backgroundView = makeLbl(view: self.view, msg: data_not_available.localized)
            self.chooseIndexesTableView.backgroundView?.isHidden = false
        }else{
            self.chooseIndexesTableView.backgroundView?.isHidden = true
        }
        
    }

    func dismissKeyboard(_sender: AnyObject)
    {
        self.view.endEditing(true)
    }
    
    
    func initialSetup(){
        
        self.chooseIndexesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        self.backBtn.rotateBackImage()
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.searchTextField.textAlignment = .right
            
        }else{
            
            self.searchTextField.textAlignment = .left
        }
        
        self.chooseIndexesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.searchTextField.delegate = self
        self.navigationTitle.text = CHOOSE_STOCKS.localized
        self.continueBtn.setTitle(NEXT.localized, for: UIControlState.normal)
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.chooseIndexesTableView.delegate = self
        self.chooseIndexesTableView.dataSource = self
        getStockList()
        self.continueBtn.setTitle(NEXT.localized, for: UIControlState.normal)
        self.selectAllBtn.setTitle(SELECT_ALL.localized, for: UIControlState.normal)
        self.searchTextField.placeholder = SEARCH.localized
        self.selectAllLbl.text = SELECT_ALL.localized
        
        self.isAll = true
        for res in self.stockListArray{
        
            self.selectedStockId.append(res.stock_id ?? 0)
            self.selectAllLbl.text = DESELECT_ALL.localized
        }
        
        self.backBtn.rotateBackImage()
        
       
    }
    
    
    func getStockList(){
        
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id!
        showLoader()
        getStock_currncy_ListAPI(params: params, url: EndPoint.getStockListURL) { (success, msg, data) in
            print_debug(object: data)
            hideLoader()
            
            if success{
                
                self.stockListArray = data!.map({ (stock) -> AllStockListModel in
                    AllStockListModel(with: stock)
                    
                })
                
                for res in self.stockListArray{
                    
                    if let is_selected = res.is_selected{
                        
                        if is_selected.lowercased() == "yes" {
                            
                            self.selectedStockId.append(res.stock_id ?? 0)
                        }
                    }
                }
                if self.selectedStockId.count == self.stockListArray.count{
                    self.selectAllBtn.isSelected = true
                    self.selectAllLbl.text = DESELECT_ALL.localized
                }
                self.chooseIndexesTableView.reloadData()
            }else{
                showToastWithMessage(msg: msg)
            }
            self.showNodata()
        }
    }
    
    
    func searchStock(offset: Int, text: String){
        
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id ?? ""
        params["searchText"] = text
        params["page_number"] = offset
        
        getStock_currncy_ListAPI(params: params, url: EndPoint.stockSearchURL) { (success, msg, data) in
            if success{
                
                self.stockListArray = data!.map({ (stock) -> AllStockListModel in
                    AllStockListModel(with: stock)
                })
            }else{
                
            self.stockListArray.removeAll()
            }
            self.chooseIndexesTableView.reloadData()
            self.showNodata()

        }
    }

    
    private func choose_stock(info: [AllStockListModel],s_id: String){
        
        var params = JSONDictionary()
        
        let id = self.makeId(info: info, s_id: s_id)
        
        params["stockIds"] = id
        params["userId"] = CurrentUser.user_id
        
        showLoader()
        chooseCurrencyListAPI(params: params,url: EndPoint.chooseStockListURL) { (success, msg, data) in
            print_debug(object: data)
            hideLoader()
            if success{
                userDefaults.set("yes", forKey: UserDefaultsKeys.is_stock_selected)

                if self.isCurrency != nil && self.isCurrency {
                    let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChooseCurrencyID") as! ChooseCurrencyVC
                    self.navigationController?.pushViewController(obj, animated: true)

                }else{
                    let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChoosePeopleID") as! ChoosePeopleVC
                    self.navigationController?.pushViewController(obj, animated: true)
                }
            }else{
                showToastWithMessage(msg: msg)
            }
        }
    }
    
    
    func makeId(info: [AllStockListModel],s_id: String) -> String{
        
        var id = ""
        
        if self.isAll{
            
            for res in info{
                
                if let _id = res.stock_id{
                    
                    if id == ""{
                        
                        id = "\(_id)"
                    }
                    else{
                        
                        id = "\(id),\(_id)"
                    }
                }
            }
        }else{
            
//                for res in self.selectedStockIndexPath{
//                    print_debug(object: res)
//                    if let _id = info[res][s_id]{
//                        
//                        if id == ""{
//                            id = "\(_id)"
//                        }
//                        else{
//                            id = "\(id),\(_id)"
//                        }
//                    }
//                }
            for s_id in self.selectedStockId{
                print_debug(object: s_id)
                
                id = "\(id),\(s_id)"
            

            }

        }
        return id
    }
    
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        
            self.choose_stock(info: self.stockListArray,s_id: "id")
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        
            _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func selectAllBtnTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            self.selectedStockId.removeAll()
            
            self.isAll = true
            
            for res in self.stockListArray{
                
                self.selectedStockId.append(res.stock_id ?? 0)
                self.selectAllLbl.text = DESELECT_ALL.localized
            }
            
        }else{
            self.isAll = false
            
            self.selectedStockId.removeAll()

            self.selectAllLbl.text = SELECT_ALL.localized
        }
        self.chooseIndexesTableView.reloadData()
    }
    
}


extension ChooseIndexesVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.stockListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseIndexesCell", for: indexPath) as! ChooseIndexesCell
        
            let data = self.stockListArray[indexPath.row]
//            cell.populateView(index: indexPath.row, userInfo: data, selectedIndexPath: self.selectedStockIndexPath, isAll: isAll ? true : false)
        
        cell.populateViewWithStockId(userInfo: data, selectedStockId: self.selectedStockId, isAll: isAll ? true : false)
                return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.isAll = false
        let stock = self.stockListArray[indexPath.row]
        
        if (self.selectedStockId.contains(stock.stock_id)){
            
            let indexs = self.selectedStockId.filter({ ($0 != stock.stock_id)})
            
            self.selectedStockId = indexs
            
            if self.selectedStockId.count < self.stockListArray.count {
                
                self.selectAllBtn.isSelected = false
                
                self.selectAllLbl.text = "Select All"
            }
            
        }else{
            
            self.selectedStockId.append(stock.stock_id
            )
            if self.selectedStockId.count == self.stockListArray.count{
                
                self.selectAllBtn.isSelected = true
                self.selectAllLbl.text = "Deselect All"
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


extension ChooseIndexesVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print_debug(object: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !(textField.text?.isEmpty)!{
            let str = textField.text!
            self.searchStock(offset: 1, text: str)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        delayWithSeconds(0.1) {
            
            if !(textField.text?.isEmpty)!{
                
                let str = textField.text!
                
                if str.characters.count >= 3{
                    
                    self.searchStock(offset: 1, text: str)
                }
            }else{
                
                self.getStockList()
                
            }
        }
        return true
    }
    
    
}

//MARK:- Tble view cell class

class ChooseIndexesCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var selectedImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLbl.text = NAME.localized
    }
    
    
    func populateViewWithStockId(userInfo: AllStockListModel,selectedStockId: [Int],isAll: Bool){
        
        self.nameLbl.text = userInfo.name ?? ""
        
        if let followers = userInfo.follower {
            
            self.followersCountLbl.text = "\(followers) " + FOLLOWERS.localized
        }
        
        if !isAll{
            
            if selectedStockId.contains(userInfo.stock_id){
                
                self.selectedImg.image = UIImage(named: "ic_choose_indexes_eclipseselect")
                
            }else{
                
                self.selectedImg.image = UIImage(named: "ic_choose_indexes_eclipsedeselect")
            }
        }else{
            
            self.selectedImg.image = UIImage(named: "ic_choose_indexes_eclipseselect")
        }
    }

}
