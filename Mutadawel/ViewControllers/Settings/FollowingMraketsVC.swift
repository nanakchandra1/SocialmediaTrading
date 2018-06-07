//
//  FollowingMraketsVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 01/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class FollowingMraketsVC: UIViewController {
    
    
    //MARK:- IBOutlets
    //MARK:- ===============================

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var followingMarketTableView: UITableView!
    
    //MARK:- Properties
    //MARK:- ===============================

    var marketList = [FollowedMarketModel]()
 
    
    //MARK:- View life cycle methods
    //MARK:- ===============================

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.initialSetup()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Methods
    //MARK:- ===============================
    
    func initialSetup(){
        
        self.followingMarketTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.backBtn.rotateBackImage()
        
        self.navigationTitle.text = FOLLOWING_MARKET.localized
        
        self.navigationTitle.font = setNavigationTitleFont()
        
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        
        self.followingMarketTableView.delegate = self
        
        self.followingMarketTableView.dataSource = self
        
        
        self.getFollowingMarketList()
        
    }
    
    
    
    func unfollowMarket(indexPath:  IndexPath){
        
        if self.marketList.count == 1{
            
            showToastWithMessage(msg: You_can_not_unfollow_this_market.localized)
            return
        }
        
        var params = JSONDictionary()
        showLoader()
        
            params["userId"] = CurrentUser.user_id ?? ""
        
            params["marketId"] = self.marketList[indexPath.row].market_id ?? ""
        
        unFollowMarketAPI(params: params) { (success, msg, data) in
            hideLoader()
            
            if success{
                
                self.marketList.remove(at: indexPath.row)
                
                self.followingMarketTableView.reloadData()
            }
        }
        
    }
    
    
    func getFollowingMarketList(){
        
        var params = JSONDictionary()
        
        if CurrentUser.user_id != nil{
            
            params["userId"] = CurrentUser.user_id as AnyObject
            
        }
        
        showLoader()
        
        follow_Currency_Stock_API(params: params, url: EndPoint.followingMarketListURL) { (success, msg, data) in
            
            hideLoader()
            
            if success{
                
                self.marketList = data!.map({ (market) -> FollowedMarketModel in
                    
                    FollowedMarketModel(withData: market)
                })
                self.followingMarketTableView.reloadData()
            }
        }
    }
    
    
    //MARK:- IBActions
    //MARK:- ===============================
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        _ =  sharedAppdelegate.nvc.popViewController(animated: true)
    }
    
}


//MARK:- Table view delegate datasource
//MARK:- ===============================


extension FollowingMraketsVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.marketList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingMarketCell", for: indexPath) as! FollowingMarketCell
        cell.setLayout()
        cell.followBtn.addTarget(self, action: #selector(FollowingMraketsVC.followBtnTapped), for: .touchUpInside)
        
        let data = self.marketList[indexPath.row]
        cell.populateView(userInfo: data)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
        
    }
    
    
    func followBtnTapped(_ sender: UIButton){
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.followingMarketTableView) else{return}
        
        self.unfollowMarket(indexPath: indexPath as IndexPath)
        
    }
}


//MARK:- Tableview cell classes
//MARK:- ===============================


//MARK:- Tble view cell class

class FollowingMarketCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func setLayout(){
        
        self.followBtn.layer.cornerRadius = 2
        self.followBtn.layer.masksToBounds = true
        self.followBtn.tintColor = UIColor.white
        self.followBtn.setTitle(UNFOLLOW.localized, for: UIControlState.normal)
        
    }
    
    
    func populateView(userInfo: FollowedMarketModel){
        
        if let market_name = userInfo.market_name{
            self.nameLbl.text = market_name
        }
        
        if let follower = userInfo.follower{
            self.followersCountLbl.text = "\(follower) followers"
        }
    }
    
}
