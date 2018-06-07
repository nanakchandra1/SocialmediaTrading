//
//  RankingVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 08/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import GraphKit
import SwiftyJSON

class RankingVC: MutadawelBaseVC {

    //MARK:- IBOutlets
    //MARK:- ================================================

    @IBOutlet weak var rankingTableView: UITableView!
    @IBOutlet weak var rankingOptionTableView: UITableView!
    @IBOutlet weak var rankingListBgView: UIView!
    @IBOutlet weak var allTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var listHeightConstant: NSLayoutConstraint!
  
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    //MARK:- properties
    //MARK:- ================================================

	//TODO:- add filterType 5 by (wallet net value) (Done)
	
    let optionArray = [BY_DELTA_FORECAST.localized,BY_CORRECT_FORECAST.localized,BY_FORECAST_PROFIT.localized,BY_WALLET_PROFIT.localized,BY_STOCK.localized,WALLET_NET_VALUE.localized]
    let eventArray = [FirebaseEventName.filter_by_delta,FirebaseEventName.filter_by_correct_forecast,FirebaseEventName.filter_by_profit,FirebaseEventName.filter_by_wallet,FirebaseEventName.filter_by_stock,FirebaseEventName.WALLET_NET_VALUE]
    
    var currentPage = 1
    var rankingInfo = [RankingModel]()
    var filterType = 0
    var timeFilter = [String:String]()
    var stockFilterType = String()
    var stock_id = String()
    var rightForcast = [Any]()
    var wrongForecast = [Any]()
    var refreshControl = UIRefreshControl()
    var eventId = "ranking"
    
    //MARK:- view life cycle methods
    //MARK:- ================================================

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialViewStup()
		
//		self.filterType = 3
//		allTextField.text = optionArray[3]
//		setEvent(eventName: self.eventArray[3], params: ["eventId": eventId as NSObject ])
//		
//		self.timeFilter["isTimeFilter"] = "1"
//		self.timeFilter["timeLength"] = "1"
//		self.timeFilter["timeType"] = "1"
//		self.getRankingInfo()
		
		
    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()

        if sharedAppdelegate.appLanguage == .Arabic{
            
            if UIApplication.shared.statusBarFrame.height > 20{
                
                self.topConstraint.constant = 70
                
            }else{
                self.topConstraint.constant = 15
                
            }
        }

        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:- Private methods
    //MARK:- ================================================

    func initialViewStup(){
        
        self.rankingListBgView.dropShadow()
        self.rankingTableView.delegate = self
        self.rankingTableView.dataSource = self
        self.rankingOptionTableView.delegate = self
        self.rankingOptionTableView.dataSource = self
        self.listHeightConstant.constant = 0
        self.rankingListBgView.layer.borderWidth = 1
        self.rankingListBgView.layer.borderColor = AppColor.appTextColor.cgColor
        self.rankingListBgView.clipsToBounds = true
        
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.allTextField.textAlignment = .right
            
        }else{
            
            self.allTextField.textAlignment = .left
            
        }
        self.rankingTableView.register(UINib(nibName: "ActivityIndicatorCell", bundle: nil), forCellReuseIdentifier: "ActivityIndicatorCell")

        
        self.allTextField.placeholder = BY_DELTA_FORECAST.localized
        self.allTextField.selectedTitle = BY_DELTA_FORECAST.localized
        self.allTextField.title = BY_DELTA_FORECAST.localized
        self.timeFilter["isTimeFilter"] = "0"
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefress), for: UIControlEvents.valueChanged)
        self.refreshControl.tintColor = AppColor.navigationBarColor
        self.rankingTableView?.addSubview(refreshControl)
		
		//TODO:- change type 3 to type 5
		
		self.filterType = 5
		allTextField.text = optionArray[5]
		setEvent(eventName: self.eventArray[5], params: ["eventId": eventId as NSObject ])
		
		self.timeFilter["isTimeFilter"] = "1"
		self.timeFilter["timeLength"] = "1"
		self.timeFilter["timeType"] = "3"
		self.getRankingInfo()

        //self.getRankingInfo()
		
    }
    
    func showNodata(){
        
        if self.rankingInfo.isEmpty{
            
            self.rankingTableView.backgroundView = makeLbl(view: self.rankingTableView, msg: data_not_available.localized)
            
            self.rankingTableView.backgroundView?.isHidden = false
            
        }else{
            
            self.rankingTableView.backgroundView?.isHidden = true
            
        }
        
    }
    
    func refreshRanking(){
        
        self.currentPage = 1
        
        if !self.rankingInfo.isEmpty{
            
            self.rankingTableView.scrollToRow(at: IndexPath(row: 0, section: 0) , at: .top, animated: true)
            
        }
    }

	
    func pullToRefress(){
        
        self.currentPage = 1
        self.getRankingInfo()
        
    }

    
    func getRankingInfo(){
		
        var params = JSONDictionary()
        
        
        params["userId"] = CurrentUser.user_id
        
        params["pageNumber"] = self.currentPage
        
        params["stockId"] = self.stock_id

        params["filterType"] = self.filterType
        
        if self.filterType == 4 {
            
            params["stockFilterType"] = self.stockFilterType
            
        }

        if self.timeFilter["isTimeFilter"] == "1" {
            
            params["timeLength"] = self.timeFilter["timeLength"]
            
            params["timeType"] = self.timeFilter["timeType"]
            
            params["isTimeFilter"] = "1"

        }else{
            
            params["isTimeFilter"] = "0" 
            
        }
        
        
        self.refreshControl.endRefreshing()

        print_debug(object: "******************  PARAMETERS ******************** \n\n")
        print_debug(object: params)
        
        rankingAPI(params: params) { (success, msg, data) in
            hideLoader()
            if success{
                
                print_debug(object: data!)
                
                var rankingist = [RankingModel]()
                
                
                for res in data!{
                    
                    let ranking = RankingModel(with: res)
                    
                    rankingist.append(ranking)
                }

                if self.currentPage == 1{
                    
                    self.rankingInfo = rankingist
                    
                }else{
                    
                    for res in rankingist{
                        
                        self.rankingInfo.append(res)

                    }
                }
                
            }else{
                
                if self.currentPage == 1{
                    
                    self.rankingInfo.removeAll()

                }
                
            if self.currentPage != 1{
                
                self.currentPage -= 1
                
                }
            }
            
            self.rankingTableView.reloadData()
        }
    }

    
    func hideList(value:CGFloat){
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.listHeightConstant.constant = value
            
            self.view.layoutIfNeeded()
            
        }) { (true) in
            
        }
    }
    
    
    //MARK:- IBActions
    //MARK:- ================================================

    
    @IBAction func durationBtnTapped(_ sender: UIButton) {
        
        let popUp = homeStoryboard.instantiateViewController(withIdentifier: "HomePopUpID") as! HomePopUpVC
      
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.selectPopUp = .Duration
        popUp.delegate = self
        self.present(popUp, animated: true, completion: nil)
        setEvent(eventName: FirebaseEventName.click_on_clock, params: ["eventId": self.eventId as NSObject])

        self.hideList(value: 0)

    }
    
    @IBAction func openProfileBtnTapped(_ sender: UIButton) {
        
        setEvent(eventName: FirebaseEventName.click_on_user_picture, params: ["eventId": self.eventId as NSObject])

        guard let indexPath = sender.tableViewIndexPath(tableView: self.rankingTableView) else{return}
      
        let data = self.rankingInfo[indexPath.row]
        if let userId = data.user_id{
            
            
                if userId ==  currentUserId(){
                    
                    let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
                 
                    sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                    
                }else{
                  
                    let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
                   
                    obj.userID = userId
                   
                    sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                }
        }
    }
    
    
    @IBAction func allBtnTapped(_ sender: UIButton) {
        
       self.hideList(value: 190)
        
    }
}


//MARK:- set time lile delegate methods
//MARK:- ================================================

extension RankingVC : TimeLineDelegate {
    
    func refreshTimeline(_ info: ForecastPostDetailModel?, count: Int, isComment: Bool) {
        
    }
    
    func setStockFilterType(type: String) {
        
    }
    
    func setTimeLineFromDetail(info: ForecastPostDetailModel) {
        
    }
    
    
    
    func setDurationData(timeLength: String, timeType: String?) {
        
        if timeType == nil{
            
            self.timeFilter["isTimeFilter"] = "0"
            
        }else{
            
            self.timeFilter["timeLength"] = timeLength
            
            self.timeFilter["timeType"] = timeType
            
            self.timeFilter["isTimeFilter"] = "1"
            self.currentPage = 1
            self.getRankingInfo()

        }
        

    }
}


//MARK:- UITable view delegate and data source methods
//MARK:- ================================================

extension RankingVC: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView === self.rankingOptionTableView{
            return 1

        }else{
            if self.self.rankingInfo.count >= 100{
                return 1

            }else{
                return 2
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.rankingOptionTableView{
            return self.optionArray.count

        }else{
            
            print_debug(object: self.rankingInfo.count)

            if section == 0{
                return self.rankingInfo.count
            }else{
                return 1
            }

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView === self.rankingOptionTableView{

        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingOptionCell", for: indexPath) as! RankingOptionCell
            
            cell.optionLbl.text = self.optionArray[indexPath.row]
            return cell
            
        }else{
			
            if indexPath.section == 0{

            let data = self.rankingInfo[indexPath.row]

			if self.filterType == 5{
				
				let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCellNetValue", for: indexPath) as! RankingCellNetValue
				
                self.rightForcast = data.right
				
                self.wrongForecast = data.wrong
				
				cell.followBtn.addTarget(self, action: #selector(RankingVC.followBtnTappedBtnTapped), for: .touchUpInside)
				
				
				cell.populateView(index: indexPath, userInfo: data,filterType: self.filterType)
				
				cell.setLayout()
				
				return cell
				
				
			}else{
			
				let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath) as! RankingCell
            
                self.rightForcast = data.right
                
                self.wrongForecast = data.wrong

				cell.graphView.dataSource = self
				cell.graphView.draw()
				cell.graphView.reset()
				cell.graphView.draw()
				cell.followBtn.addTarget(self, action: #selector(RankingVC.followBtnTappedBtnTapped), for: .touchUpInside)
            
				let data = self.rankingInfo[indexPath.row]
            
				cell.populateView(index: indexPath, userInfo: data,filterType: self.filterType)
            
				cell.setLayout()
            
				return cell
            
                }
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityIndicatorCell", for: indexPath) as! ActivityIndicatorCell
                if self.rankingInfo.count > 0 && self.rankingInfo.count < 100{
                    
                    self.currentPage += 1

                }
                self.getRankingInfo()
                return cell

            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === self.rankingOptionTableView{
            return 30
        }else{
            if indexPath.section == 0{

                return 200
                
            }else{
                
                return 70

            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hideList(value: 0)
        if tableView === self.rankingOptionTableView{
            self.allTextField.text = self.optionArray[indexPath.row]
            //self.timeFilter["isTimeFilter"] = "0"
            self.currentPage = 1
            if indexPath.row == 4{
                let obj = homeStoryboard.instantiateViewController(withIdentifier: "ListPopUpID") as! ListPopUpVC
                obj.markerType = .Stock
                obj.stockListOpenType = .withSubCategory
                obj.delegate = self
                self.filterType = indexPath.row
                obj.modalPresentationStyle = .overCurrentContext
                self.present(obj, animated: true, completion: nil)
                obj.searchTxtField.isHidden = false
            }else{
                self.filterType = indexPath.row
                setEvent(eventName: self.eventArray[indexPath.row], params: ["eventId": eventId as NSObject ])
                showLoader()
                self.getRankingInfo()
            }
        }
        self.refreshRanking()
    }
    
    
    
    //MARK:- Target methods
    //MARK:- ================================================
    
    func followBtnTappedBtnTapped(_ sender: UIButton){
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.rankingTableView) else{return}
        
        if let is_following =  self.rankingInfo[indexPath.row].is_following{
            
            if is_following.lowercased() == "yes"{
                setEvent(eventName: FirebaseEventName.unfollow_user, params: ["eventId": eventId as NSObject ])

                self.follow_UnFollow_Friend(indexPath as IndexPath,url: EndPoint.unfollowFriendURL)
                
            }else{
                setEvent(eventName: FirebaseEventName.follow_user, params: ["eventId": eventId as NSObject ])

                self.follow_UnFollow_Friend(indexPath as IndexPath,url: EndPoint.chooseFriendURL)
				
            }
        }
    }
    
    
    
    func follow_UnFollow_Friend(_ indexPath: IndexPath,url:String){
        
        var params = JSONDictionary()
        
        params["follower_id"] = CurrentUser.user_id
        
        params["following_id"] = self.rankingInfo[indexPath.row].user_id

        print_debug(object: url)
        
        chooseFriendAPI(params: params,url:url) { (success, msg, data) in
            if success{
                
                if let is_following =  self.rankingInfo[indexPath.row].is_following{
                    
                    if is_following.lowercased() == "yes"{
                        
                        self.rankingInfo[indexPath.row].is_following = "no"
                        
                    }else{
                        
                        self.rankingInfo[indexPath.row].is_following = "yes"
                        
                    }
                }

                self.rankingTableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    

//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//        if scrollView === self.rankingTableView{
//
//            let endScrolling = scrollView.contentOffset.y + scrollView.contentSize.height
//            if endScrolling > scrollView.contentSize.height {
//
//                self.currentPage += 1
//
//                //TODO:- becouse the the API send the same data that sent again
////                    self.getRankingInfo()
////                self.getRankingInfo()
//
//            }
//        }
//    }
}


//MARK:- GKLine graph delegate datasource methods
//MARK:- ================================================


extension RankingVC: GKLineGraphDataSource {
    
    func numberOfLines() -> Int {
        return 2
    }
    
    func colorForLine(at index: Int) -> UIColor! {
        let colourArr = [AppColor.blue, AppColor.appButtonColor]
        return colourArr[index]
    }
    
    func valuesForLine(at index: Int) -> [Any]! {
        
        let lineDrawArr:Array = [self.rightForcast,self.wrongForecast]
        
        return lineDrawArr[index]


    }
    
}


//MARK:- set stock delegate methods
//MARK:- ================================================


extension RankingVC : SetStockDelegate {
    
    func setStock(info: AllStockListModel) {
        
        print_debug(object: info.follower)
        self.stockFilterType = info.stockFilterType!
        self.stock_id = "\(info.stock_id!)"
        showLoader()
        self.getRankingInfo()
    }
    
    func setStock(info: JSONDictionary) {
    
        guard let stockFilterTyp = info["stockFilterType"] else{return}
        self.stockFilterType = "\(stockFilterTyp)"
        
        guard let stock_id = info["id"] else{return}

        self.stock_id = "\(stock_id)"
        self.getRankingInfo()

    }
 }


//MARK:- Table view cell classess
//MARK:- ================================================


class RankingCell: UITableViewCell {
    
    
    @IBOutlet weak var graphView: GKLineGraph!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var followWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var rateViewWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var expextationBgView: UIView!
    @IBOutlet weak var expectationLbl: UILabel!
    @IBOutlet weak var wrongExpectationCountLbl: UILabel!
    @IBOutlet weak var wrongLbl: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var rightExpectationCountLbl: UILabel!
    @IBOutlet weak var statusBgView: UIView!
    @IBOutlet weak var statusExpectLbl: UILabel!
    @IBOutlet weak var statusArrow: UIImageView!
    @IBOutlet weak var statusPercentLbl: UILabel!
    @IBOutlet weak var graphImg: UIImageView!
    @IBOutlet weak var profitlostLbl: UILabel!
    @IBOutlet weak var rankingCountLbl: UILabel!
    @IBOutlet weak var profitLossValue: UILabel!


    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.graphView.lineWidth = 2.0
        self.graphView.margin = 0.0
        self.profitlostLbl.text = PROFIT_AND_LOST.localized
        self.wrongLbl.text = WRONG.localized
        self.rightLabel.text = RIGHT.localized
        self.expectationLbl.text = FORECAST.localized
        self.statusExpectLbl.text = STATUS_OF_FORECAST.localized
        self.statusPercentLbl.text = "0%"
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.rightExpectationCountLbl.textAlignment = .left
            self.wrongExpectationCountLbl.textAlignment = .left

        }else{
            
            self.rightExpectationCountLbl.textAlignment = .right
            self.wrongExpectationCountLbl.textAlignment = .right
            
        }

    }
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.statusPercentLbl.text = "0%"
        
    }
    
    func setLayout(){
        
        self.userImg.layer.cornerRadius = 20
        self.userImg.layer.masksToBounds = true
    }
    
    
    func populateView(index: IndexPath, userInfo: RankingModel,filterType: Int){
        
        
        if let is_following = userInfo.is_following{
            

            if is_following.lowercased() == "yes"{
                
                self.followBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
                self.followBtn.setTitle(UNFOLLOW.localized, for: UIControlState.normal)
                self.followWidthConstant.constant = 70

            }else{
                
                self.followBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
                self.followBtn.setTitle(FOLLOW.localized, for: UIControlState.normal)
                self.followWidthConstant.constant = 70

            }
        }

        
        if let user_name = userInfo.name {
            self.userNameLbl.text = user_name
        }
        
        if let right_forecast = userInfo.right_forecast {
            self.rightExpectationCountLbl.text = "\(right_forecast)"
        }
        
        if let wrong_forecast = userInfo.wrong_forecast {
            self.wrongExpectationCountLbl.text = "\(wrong_forecast)"
        }
        
        if let forecast_profit = userInfo.forecast_profit {
            if filterType == 3{
            
                self.profitLossValue.text = "SR \(forecast_profit)"

            }else{
            
                self.profitLossValue.text = "\(forecast_profit)%"

            }
        }
        
        if let forecast_status_precent = userInfo.forecast_status_precent {
            
            self.statusPercentLbl.text = "\(forecast_status_precent)%"
            
            if forecast_status_precent < 0{
                
                self.statusArrow.image = #imageLiteral(resourceName: "ic_home_downarrow")
            }else{
                
                self.statusArrow.image = #imageLiteral(resourceName: "ic_home_uparrow")
            }
            
        }

        
        if let profile_pic = userInfo.profile_pic {
            
            let url = URL(string: "\(profile_pic)")
            
            self.userImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
            
        }
        
        if let rating = userInfo.rating {
            
            let rate = rating.roundTo(places: 4)
            self.setRating(rating: Float("\(rate)")!)
            
        }
        
        if let user_id = userInfo.user_id {
            if user_id == currentUserId(){
                
                 self.followBtn.isHidden = true
            }else{
                self.followBtn.isHidden = false

            }
        }
		
        
        if index.row < 9{
            
            self.rankingCountLbl.text = "0\(index.row+1)"

        }else{
            
            self.rankingCountLbl.text = "\(index.row+1)"

        }

    }
    
    
    func setRating(rating: Float){
        
        self.floatRatingView.rating = rating
        self.rateLbl.text = "\(rating)"

    }
}

class RankingCellNetValue: UITableViewCell {
	
	
	@IBOutlet weak var graphView: GKLineGraph!
	@IBOutlet weak var bgView: UIView!
	@IBOutlet weak var userImg: UIImageView!
	@IBOutlet weak var userNameLbl: UILabel!
	@IBOutlet weak var floatRatingView: FloatRatingView!
	@IBOutlet weak var rateLbl: UILabel!
	@IBOutlet weak var followWidthConstant: NSLayoutConstraint!
	@IBOutlet weak var followBtn: UIButton!
	@IBOutlet weak var rateViewWidthConstant: NSLayoutConstraint!
	@IBOutlet weak var expextationBgView: UIView!
	@IBOutlet weak var expectationLbl: UILabel!
	@IBOutlet weak var wrongExpectationCountLbl: UILabel!
	@IBOutlet weak var wrongLbl: UILabel!
	@IBOutlet weak var rightLabel: UILabel!
	@IBOutlet weak var rightExpectationCountLbl: UILabel!
	@IBOutlet weak var statusBgView: UIView!
	@IBOutlet weak var statusExpectLbl: UILabel!
	@IBOutlet weak var statusArrow: UIImageView!
	@IBOutlet weak var statusPercentLbl: UILabel!
	@IBOutlet weak var graphImg: UIImageView!
	@IBOutlet weak var profitlostLbl: UILabel!
	@IBOutlet weak var rankingCountLbl: UILabel!
	@IBOutlet weak var profitLossValue: UILabel!
	@IBOutlet weak var lineView: UIView!
	
	
	override func awakeFromNib() {
		
		super.awakeFromNib()
		
		self.lineView.isHidden = true
		self.graphView.isHidden = true
		self.graphView.lineWidth = 2.0
		self.graphView.margin = 0.0
		self.profitlostLbl.text = WALLET_NET_VALUE.localized
		self.wrongLbl.text = WRONG.localized
		self.rightLabel.text = RIGHT.localized
		self.expectationLbl.text = FORECAST.localized
		self.statusExpectLbl.text = STATUS_OF_FORECAST.localized
		self.statusPercentLbl.text = "0%"
		
		if sharedAppdelegate.appLanguage == .Arabic{
			
			self.rightExpectationCountLbl.textAlignment = .left
			self.wrongExpectationCountLbl.textAlignment = .left
			
		}else{
			
			self.rightExpectationCountLbl.textAlignment = .right
			self.wrongExpectationCountLbl.textAlignment = .right
			
		}
		
	}
	
	
	override func prepareForReuse() {
		
		super.prepareForReuse()
		
		self.statusPercentLbl.text = "0%"
		
	}
	
	func setLayout(){
		
		self.userImg.layer.cornerRadius = 20
		self.userImg.layer.masksToBounds = true
	}
	
	
	func populateView(index: IndexPath, userInfo: RankingModel,filterType: Int){
		
		
		if let is_following = userInfo.is_following {
			
			
			if is_following.lowercased() == "yes"{
				
				self.followBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
				self.followBtn.setTitle(UNFOLLOW.localized, for: UIControlState.normal)
				self.followWidthConstant.constant = 70
				
			}else{
				
				self.followBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
				self.followBtn.setTitle(FOLLOW.localized, for: UIControlState.normal)
				self.followWidthConstant.constant = 70
				
			}
		}
		
		
		if let user_name = userInfo.name {
			self.userNameLbl.text = user_name
		}
		
		if let right_forecast = userInfo.right_forecast {
			self.rightExpectationCountLbl.text = right_forecast
		}
		
		if let wrong_forecast = userInfo.wrong_forecast {
			self.wrongExpectationCountLbl.text = wrong_forecast
		}
		
		if let wallet_value = userInfo.wallet_value {
            
			 if filterType == 5{
				self.profitLossValue.text = "SR \(wallet_value.roundTo(places: 4))"
			}
		}
		
		if let forecast_status_precent = userInfo.forecast_status_precent {
			
			self.statusPercentLbl.text = "\(forecast_status_precent.roundTo(places: 4))%"
			
			if forecast_status_precent < 0{
				
				self.statusArrow.image = #imageLiteral(resourceName: "ic_home_downarrow")
			}else{
				
				self.statusArrow.image = #imageLiteral(resourceName: "ic_home_uparrow")
			}
		}
		
		
		if let profile_pic = userInfo.profile_pic {
			
			let url = URL(string: "\(profile_pic)")
			
			self.userImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
			
		}
		
		if let rating = userInfo.rating {
			
			let rate = rating.roundTo(places: 4)
			self.setRating(rating: Float("\(rate)")!)
			
		}
		
		if let user_id = userInfo.user_id {
			if user_id == currentUserId(){
				
				self.followBtn.isHidden = true
			}else{
				self.followBtn.isHidden = false
				
			}
		}
		
		if index.row < 9{
			
			self.rankingCountLbl.text = "0\(index.row+1)"
			
		}else{
			
			self.rankingCountLbl.text = "\(index.row+1)"
			
		}
		
	}
	
	
	func setRating(rating: Float){
		
		self.floatRatingView.rating = rating
		self.rateLbl.text = "\(rating)"
		
	}
}

class RankingOptionCell: UITableViewCell {
    
    @IBOutlet weak var optionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

