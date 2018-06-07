//
//  ListPopUpVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 27/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.

import UIKit
import SwiftyJSON

protocol SetStockDelegate {
	
	func setStock(info: AllStockListModel)
}

class ListPopUpVC: UIViewController {
    
    
    enum StockListMode {
        
        case withSubCategory ,withoutSubCategory
        
    }
    
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var searchTxtField: UITextField!
    
    var stockListArray = [AllStockListModel]()
    var delegate:SetStockDelegate!
    var filteredStockListArray = [AllStockListModel]()
    var markerType = ChooseExpextType.Stock
    var selecteddata: AllStockListModel!
    var stockListOpenType : StockListMode = .withoutSubCategory
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTxtField.delegate = self
        //self.searchTxtField.isHidden = true
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_home_search_grey")
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: self.searchTxtField.frame.height)
        imageView.contentMode = .center
        self.searchTxtField.leftView = imageView
        self.searchTxtField.leftViewMode = .always
        self.listTableView.dataSource = self
        self.listTableView.delegate = self
        self.listTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.searchTxtField.placeholder = Search_Stocks.localized
        
        if sharedAppdelegate.appLanguage == .Arabic{
            self.searchTxtField.textAlignment = .right
        }else{
            self.searchTxtField.textAlignment = .left
        }
        
        
        if self.markerType == .Forex{
            self.get_follow_stock_currency_list(url: EndPoint.getCurrencyuListURL)
        }else{
            self.get_follow_stock_currency_list(url: EndPoint.getStockListURL)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func get_follow_stock_currency_list(url:String){
        
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id!
        showLoader()
        follow_Currency_Stock_API(params:params,url:url) { (success, msg, data) in
            
            if success{
                
                self.stockListArray = data!.map({ (stock) -> AllStockListModel in
                    AllStockListModel(with: stock)
                })
				
                self.filteredStockListArray = self.stockListArray
                self.listTableView.reloadData()
            }else{
                showToastWithMessage(msg: msg)
            }
        }
        
    }
    
}


extension ListPopUpVC: TimeLineDelegate{
    
    
    func refreshTimeline(_ info: ForecastPostDetailModel?, count: Int, isComment: Bool) {
        
    }
    
    func setDurationData(timeLength: String, timeType: String?) {
        
    }
    
    func setTimeLineFromDetail(info: ForecastPostDetailModel) {
        
    }
    
    
    func refreshTimeline() {
        
        self.dismiss(animated: true, completion: nil)
        
        self.delegate.setStock(info: self.selecteddata)
        
    }
    
    
    func setStockFilterType(type: String) {
        
        self.dismiss(animated: true, completion: nil)
        
        let data = self.selecteddata
        
        data?.stockFilterType = type
        
        self.delegate.setStock(info: data!)

    }
}


extension ListPopUpVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.filteredStockListArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCellID", for: indexPath) as? ListCell else{
            fatalError("Cell not found")
        }
        let data = self.filteredStockListArray[indexPath.row]
        
        cell.populatecell(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.stockListOpenType == .withSubCategory{
            
            self.selecteddata = self.filteredStockListArray[indexPath.row]
            
            let obj = homeStoryboard.instantiateViewController(withIdentifier: "HomePopUpID") as! HomePopUpVC
            
            obj.selectPopUp = .filter
            
            obj.modalPresentationStyle = .overCurrentContext
            
            obj.delegate = self
            
            self.present(obj, animated: true, completion: nil)
            
        }else{
            
            let data = self.filteredStockListArray[indexPath.row]
            
            self.delegate.setStock(info: data)
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
}

extension ListPopUpVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var search = ""
        
        if string.isEmpty
        {
            search = String(textField.text!.characters.dropLast())
        }
        else
        {
            search = textField.text! + string
        }
        
        print_debug(object: search)
        
        let arr = self.stockListArray.filter { (value) -> Bool in
            
//            if self.markerType == .Forex{
//
//                guard let symbol = value["symbol"] else{
//                    return false
//                }
//
//                return "\(symbol)".localizedLowercase.contains(search.localizedLowercase)
//
//            }else{
            
            let name = value.name ?? ""
            let s_symbol = value.symbol ?? ""
            return "\(name)".localizedLowercase.contains(search.localizedLowercase) || "\(s_symbol)".localizedLowercase.contains(search.localizedLowercase)

//            }

        }
        
        if search.characters.count > 0
        {
            self.filteredStockListArray.removeAll(keepingCapacity: true)
            self.filteredStockListArray = arr
        }
        else
        {
            self.filteredStockListArray = self.stockListArray
        }
        self.listTableView.reloadData()
        return true
    }
    
    
    
}


class ListCell : UITableViewCell{
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLbl.text = NAME.localized
    }
    
    
    func populatecell(with info: AllStockListModel){
        
//        if marketType == .Stock{
        
//            if sharedAppdelegate.appLanguage == .English{
        
                let s_name = info.name ?? ""
                let symbol = info.symbol ?? ""
                
                self.nameLbl.text = "\(symbol) - \(s_name)"
                    
//            }else{
//                let s_name = info["name_ar"].stringValue
//                let symbol = info["symbol"].stringValue
//
//                if let s_name = info["name_ar"] as? String,let symbol = info["symbol"]{
//
//                    self.nameLbl.text = "\(symbol) - \(s_name)"
//                }
//            }
            
//        }else{
//            if let c_name = info["symbol"] as? String{
//                self.nameLbl.text = c_name
//            }
//        }
        
    }
}
