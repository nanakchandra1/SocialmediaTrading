//
//  ChoosePeopleVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 08/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

enum ChoosePeopleState {
    
    case Choose, Block
    
}

class ChoosePeopleVC: MutadawelBaseVC {

    
    //MARK:- IBOutlets
    //MARK:- ==========================
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var choosePeopleTableView: UITableView!
    
    //MARK:- Properties
    //MARK:- ==========================

    var selectedIndexPath = [Int]()
    var choosePeopleState = ChoosePeopleState.Choose
    var titleStr = AppNavigationTitleName.choosePeople
    var peopleListArray = [UsersModel]()

    //MARK:- View life cycle methods
    //MARK:- ==========================

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialViewStup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Methods
    //MARK:- ==========================

    func initialViewStup(){
        self.choosePeopleTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        self.backBtn.rotateBackImage()
        self.navigationTitle.text = CHOOSE_PEOPLE.localized
        self.choosePeopleTableView.delegate = self
        self.choosePeopleTableView.dataSource = self
        if self.choosePeopleState == .Block{
            self.startBtn.isHidden = true
        }
        self.choosePeopleTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.startBtn.setTitle(START.localized, for: UIControlState.normal)
        if self.choosePeopleState == .Choose{
            self.navigationTitle.text = CHOOSE_PEOPLE.localized
        }else{
            self.navigationTitle.text = BLOCKED_USER.localized
        }
        if self.choosePeopleState == .Choose{
            self.getUserList()
        }else{
            self.getBlockUserList()
        }
        
    }

    private func getUserList(){
        
        var params = JSONDictionary()

        params["userId"] = CurrentUser.user_id ?? ""

        showLoader()
        getUserListAPI(params: params) { (success, msg, data) in
            
            if success{
                
                self.peopleListArray = data!.map({ (user) -> UsersModel in
                    UsersModel(withData: user)
                })
                
                self.choosePeopleTableView.reloadData()

            }else{

            }
        }
        
    }
    
    
    private func getBlockUserList(){
    
        var params = JSONDictionary()
        params["blocker_id"] = CurrentUser.user_id ?? ""
        showLoader()
        blockUserListAPI(params: params) { (success, msg, data) in
            
            if success{
                
                self.peopleListArray = data!.map({ (user) -> UsersModel in
                    UsersModel(withData: user)
                })
                self.setNoDataFound()
                self.choosePeopleTableView.reloadData()
            }else{
                self.setNoDataFound()
            }
        }
    }
    
    
    func follow_UnFollow_Friend(index: Int,url:String){
    
        var params = JSONDictionary()
        
        params["follower_id"] = CurrentUser.user_id ?? ""
        params["following_id"] = self.peopleListArray[index].user_id ?? ""
        
        print_debug(object: url)
        
        chooseFriendAPI(params: params,url:url) { (success, msg, data) in
            if success{
                
            }else{
                
            }
        }
    }
    
    
    
    func unBlockUser(index: Int){
        
        var params = JSONDictionary()
        params["blockerId"] = CurrentUser.user_id ?? ""
        params["blockedId"] = self.peopleListArray[index].user_id

        unBlockUserAPI(params: params) { (success, msg, data) in
            if success{
                self.peopleListArray.remove(at: index)
                self.choosePeopleTableView.reloadData()
            }
        }
    }
    

    func appendindex(indexPath: IndexPath){
        
        if self.choosePeopleState == .Choose{
        if (self.selectedIndexPath.contains(indexPath.row)){
            let indexs = self.selectedIndexPath.filter({ ($0 != indexPath.row)})
            self.selectedIndexPath = indexs
            follow_UnFollow_Friend(index: indexPath.row,url: EndPoint.unfollowFriendURL)
        }else{
            self.selectedIndexPath.append(indexPath.row)
            self.follow_UnFollow_Friend(index: indexPath.row,url: EndPoint.chooseFriendURL)
        }

        self.choosePeopleTableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
        }else{
            self.unBlockUser(index: indexPath.row)
        }
    }
    
    
    func setNoDataFound(){
        
        if self.peopleListArray.isEmpty{
            self.choosePeopleTableView.backgroundView = makeLbl(view: self.view, msg: No_Blocked_Users.localized)
            self.choosePeopleTableView.backgroundView?.isHidden = false
        }else{
            self.choosePeopleTableView.backgroundView?.isHidden = true
        }

    }
    
    
    //MARK:- ================================================
    //MARK:- IBActions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func startBtnTapped(_ sender: UIButton) {
        
        gotoHome()
    }
    
}


//MARK:- ================================================
//MARK:- UItable view delegate and datasource

extension ChoosePeopleVC: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.peopleListArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosePeopleCell", for: indexPath) as! ChoosePeopleCell
        cell.followBtn.addTarget(self, action: #selector(ChoosePeopleVC.followBtnTappedBtnTapped), for: .touchUpInside)
        let data = self.peopleListArray[indexPath.row]
        cell.setLayout()
        cell.populateView(index: indexPath, userInfo: data, selectedIndexPath: self.selectedIndexPath,choosePeopleState: self.choosePeopleState)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let info = self.peopleListArray[indexPath.row]
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
        
        if let userId = info.user_id{
            
            obj.userID = userId
        }
        
        sharedAppdelegate.nvc.pushViewController(obj, animated: true)
    }
   
    
    //Target methods
    
    func followBtnTappedBtnTapped(_ sender: UIButton){
    
        guard let indexPath = sender.tableViewIndexPath(tableView: self.choosePeopleTableView) else{return}
        
        self.appendindex(indexPath: indexPath as IndexPath)

    }
}



//MARK:- Tableview cell class
//MARK:- ==========================

class ChoosePeopleCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var followBtnWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var rateViewWidthConstant: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userNameLbl.text = USER_NAME.localized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userNameLbl.text = ""
        self.followersCountLbl.text = ""
    }
    
    
    func setLayout(){
        
        self.userImg.layer.cornerRadius = 20
        self.userImg.layer.masksToBounds = true
        self.followBtn.layer.cornerRadius = 3
    }
    
    
    func populateView(index: IndexPath, userInfo: UsersModel,selectedIndexPath: [Int],choosePeopleState: ChoosePeopleState){
        
        if choosePeopleState == .Choose{
            if selectedIndexPath.contains(index.row){
                self.followBtn.setImage(UIImage(named: "ic_following_tick"), for: UIControlState.normal)
                self.followBtn.setTitle("", for: UIControlState.normal)
                self.followBtnWidthConstant.constant = 40
            }else{
                self.followBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
                self.followBtn.setTitle(FOLLOW.localized, for: UIControlState.normal)
                self.followBtnWidthConstant.constant = 70
            }
        }else{
            self.followBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
            self.followBtn.setTitle(UNBLOCK.localized, for: UIControlState.normal)
            self.followBtnWidthConstant.constant = 70
        }
        
        if let rating = userInfo.rating {
            
            self.setRating(rating: rating)
            
        }
        
        if let p_name = userInfo.name{
            self.userNameLbl.text = p_name
        }
        
        if let folowers = userInfo.follower{
            self.followersCountLbl.text = "\(folowers) \(FOLLOWERS.localized)"
        }
        if let img = userInfo.profile_pic{
            let imageUrl = URL(string: img)
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
        }
}

    
    
    func setRating(rating: Float){
        
        self.floatRatingView.rating = rating
        self.rateLbl.text = "\(rating)"

    }
}
