//
//  SearchVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 02/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    
    //MARK:- IBOutlets
    //MARK:- =============================
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var searchTableView: UITableView!
    
    
    var searchList = JSONDictionary()
    var forecastArray = [ForecastPostDetailModel]()
    var stockArray = [AllStockListModel]()
    var currencyArray = [CurrencyModel]()
    var peopleArray = [UsersModel]()

    
    //MARK:- View life cycle
    //MARK:- =============================
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.initialViewSetup()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification:Notification!) -> Void in
            
            self.view.addGestureRecognizer(tapGesture)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { _ in
            
            self.view.removeGestureRecognizer(tapGesture)
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK:- Methods
    //MARK:- =============================

    func dismissKeyboard(_sender: AnyObject){
        
        self.view.endEditing(true)
        
    }

    
    func initialViewSetup(){
        
        self.searchTextField.delegate = self
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTextField.becomeFirstResponder()
        if sharedAppdelegate.appLanguage == .Arabic{
            self.searchTextField.textAlignment = .right
        }else{
            self.searchTextField.textAlignment = .left
        }
        self.searchTextField.placeholder = Search_Forecast.localized
        
        let xib = UINib(nibName: "PostInfoCell", bundle: nil)
        
        self.searchTableView.register(xib, forCellReuseIdentifier: "PostInfoCell")
        
        self.searchTableView.register(UINib(nibName: "GeneralPostInfoCell", bundle: nil), forCellReuseIdentifier: "GeneralPostInfoCell")
        
        self.searchTableView.register(UINib(nibName: "PostInfoCondtnForexCell", bundle: nil), forCellReuseIdentifier: "PostInfoCondtnForexCell")
        
        self.searchTableView.register(UINib(nibName: "PostInfoCondtnStockCell", bundle: nil), forCellReuseIdentifier: "PostInfoCondtnStockCell")
        
        self.searchTableView.register(UINib(nibName: "PostInfoCondtnForexTwoCell", bundle: nil), forCellReuseIdentifier: "PostInfoCondtnForexTwoCell")

        self.searchTableView.estimatedRowHeight = 50
        
    }
    
    
    func search(offset: Int, text: String){
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id!
        params["searchText"] = text
        params["page_number"] = offset 
        
        search_ListAPI(params: params) { (success, msg, data) in
            if success{
                
                if let value = data {
                    
                    let forecast_data = value["forecast_data"].arrayValue
                    let stock_data = value["stock_data"].arrayValue
                    let currency_data = value["currency_data"].arrayValue
                    let user_data = value["user_data"].arrayValue
                    
                    self.forecastArray = forecast_data.map({ (post) -> ForecastPostDetailModel in
                        ForecastPostDetailModel(with: post)
                    })
                    self.stockArray = stock_data.map({ (stock) -> AllStockListModel in
                        AllStockListModel(with: stock)
                    })
                    self.currencyArray = currency_data.map({ (currency) -> CurrencyModel in
                        CurrencyModel(withData: currency)
                    })
                    self.peopleArray = user_data.map({ (user) -> UsersModel in
                        UsersModel(withData: user)
                    })
                    
                }
                self.searchTableView.reloadData()
            }
        }
    }

    //MARK:- IBActions
    //MARK:- =============================
    @IBAction func backBtnTapped(_ sender: UIButton) {
        sharedAppdelegate.nvc.popViewController(animated: true)
    }

}



extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0: return self.forecastArray.count
        case 1: return self.stockArray.count
        case 2: return self.currencyArray.count
        case 3: return self.peopleArray.count
   
        default: return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch indexPath.section {
            
        case 0:
            
            
            let data = self.forecastArray[indexPath.row]
            let post_type = data.post_type ?? ""
            
            switch post_type {
                
            case Status.one:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralPostInfoCell", for: indexPath) as! GeneralPostInfoCell
                
                cell.viewHeightCostant.constant = 0
                cell.bottomView.isHidden = true
                
                cell.userProfileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
                
                cell.populateView(index: indexPath, info: data)
                
                cell.lestSideView.backgroundColor = UIColor.white
                cell.commentValue.urlLinkTapHandler = { label, url, range in
                    NSLog("URL \(url) tapped")
                    openUrlLink(url)
                }

                return cell
                
            case Status.two:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCell", for: indexPath) as! PostInfoCell
                
                cell.viewHeightConstant.constant = 0
                cell.bottomView.isHidden = true

                cell.setupView()
                
                cell.userProfileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
                
                cell.populateView(index: indexPath, info: data)
                
                cell.lestSideView.backgroundColor = UIColor.white
                cell.commentValue.urlLinkTapHandler = { label, url, range in
                    NSLog("URL \(url) tapped")
                    openUrlLink(url)
                }

                return cell
                
            case Status.three:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCondtnForexCell", for: indexPath) as! PostInfoCondtnForexCell
                
                cell.setupView()
                
                //cell.likersViewHeight.constant = 0
                cell.bottomView.isHidden = true

                cell.userProfileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
                
                
                cell.populateView(index: indexPath, info: data)
                
                cell.lestSideView.backgroundColor = UIColor.white
                cell.commentValue.urlLinkTapHandler = { label, url, range in
                    NSLog("URL \(url) tapped")
                    openUrlLink(url)
                }

                return cell
                
            case Status.four:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCondtnStockCell", for: indexPath) as! PostInfoCondtnStockCell
                
                cell.setupView()
                
                //cell.seperatorView.isHidden = true
                cell.viewHeightCostant.constant = 0
                cell.bottomView.isHidden = true

                cell.userProfileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
                
                cell.populateView(index: indexPath, info: data)
                
                cell.lestSideView.backgroundColor = UIColor.white
                cell.commentValue.urlLinkTapHandler = { label, url, range in
                    NSLog("URL \(url) tapped")
                    openUrlLink(url)
                }

                return cell
                
            case Status.five:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCondtnForexTwoCell", for: indexPath) as! PostInfoCondtnForexTwoCell
                //cell.setupView()
                
                //cell.seperatorView.isHidden = true
                cell.viewHeightCostant.constant = 0
                cell.bottomView.isHidden = true

                cell.userProfileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
                
                cell.populateView(index: indexPath, info: data)
                
                cell.lestSideView.backgroundColor = UIColor.white
                cell.commentValue.urlLinkTapHandler = { label, url, range in
                    NSLog("URL \(url) tapped")
                   openUrlLink(url)
                }

                return cell
            default:
                fatalError()
            }
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseIndexesCell", for: indexPath) as! ChooseIndexesCell
            
            cell.selectedImg.isHidden = true
            
            cell.populateViewWithStockId(userInfo: self.stockArray[indexPath.row], selectedStockId: [], isAll: false)
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCurrencyCell", for: indexPath) as! ChooseCurrencyCell
            
            cell.selectedImg.isHidden = true
            
            cell.populateViewWithCurrencyId(userInfo: self.currencyArray[indexPath.row], selectedCurrencyId: [], isAll: false)
            return cell
            
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosePeopleCell", for: indexPath) as! ChoosePeopleCell
            cell.followBtn.isHidden = true
            cell.setLayout()
            cell.populateView(index: indexPath, userInfo: self.peopleArray[indexPath.row], selectedIndexPath: [], choosePeopleState: ChoosePeopleState.Choose)
            
            return cell
            
        default: return UITableViewCell()
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)

        if indexPath.section == 0{
        
            let data = self.forecastArray[indexPath.row]
            let post_type = data.post_type ?? ""
            
            switch post_type{
                
            case Status.one:
                
                let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "GeneralPostID") as! GeneralPostVC
                popUp.info = data
                popUp.postDetailType = .Search
                popUp.modalPresentationStyle = .overCurrentContext
                sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
                
            case Status.two:
                
                let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ForecastStockID") as! ForecastStockVC
                popUp.info = data
                popUp.postDetailType = .Search
                popUp.modalPresentationStyle = .overCurrentContext
                sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
                
            case Status.three:
                let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ForecastForexID") as! ForecastForexVC
                popUp.info = data
                popUp.postDetailType = .Search
                popUp.modalPresentationStyle = .overCurrentContext
                sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
                
            case Status.four:
                
                let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ConditionStockID") as! ConditionStockVC
                popUp.info = data
                popUp.postDetailType = .Search
                popUp.modalPresentationStyle = .overCurrentContext
                sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
                
            case Status.five:
                
                let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ConditionForecastForexID") as! ConditionForecastForexVC
                popUp.info = data
                popUp.postDetailType = .Search
                popUp.modalPresentationStyle = .overCurrentContext
                sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
                
            default:
                fatalError()
            }
            
        }else if indexPath.section == 3{
            
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
            if let userId = self.peopleArray[indexPath.row].user_id{
                obj.userID = userId
            }
            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:return UITableViewAutomaticDimension

        case 1,2,3: return 60

        default:return UITableViewAutomaticDimension
        }
    }
    
    
  //MARK:- Target methods
    
    func userProfileTapped(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.searchTableView) else{return}
        
        let data = self.forecastArray[indexPath.row]
        
        if let userId = data.user_id{
            
                if userId == currentUserId(){
                    
                    let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
                    sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                    
                }else{
                    
                    let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
                    obj.userID = userId
                    sharedAppdelegate.nvc.pushViewController(obj, animated: true)
            }
        }
    }
}

//MARK:- Textfield delegate methods

extension SearchVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print_debug(object: textField.text)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !(textField.text?.isEmpty)!{
            let str = textField.text!
            self.search(offset: 1, text: str)
        }
        return true
    }
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delayWithSeconds(0.1) {
            
            if !(textField.text?.isEmpty)!{
                
                let str = textField.text!
                
                if str.characters.count >= 3{
                    
                    self.search(offset: 1, text: str)
                    
                }else{
                    
                    self.forecastArray.removeAll()
                    self.stockArray.removeAll()
                    self.currencyArray.removeAll()
                    self.peopleArray.removeAll()
                    self.searchTableView.reloadData()
                }
            }else{
                
                self.forecastArray.removeAll()
                self.stockArray.removeAll()
                self.currencyArray.removeAll()
                self.peopleArray.removeAll()
                self.searchTableView.reloadData()
                
        }
    }
        return true
    }
    
    
}
