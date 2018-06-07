//
//  SettingsVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 07/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SettingsVC: MutadawelBaseVC {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    
    let eventId = "setting"
    
let titleArray = [EDIT_PROFILE.localized,INVITE_FRIENDS.localized,BLOCKED_USER.localized,CHANGE_PASSWORD.localized,CHANGE_LANGUAGE.localized , DISCLAIMER.localized]
    
    
    var selectedInde = [NSIndexPath]()
    var isFollow = false
    var isStockList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialViewStup()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    func initialViewStup(){
        
        self.navigationTitle.text = SETTINGS.localized
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        if sharedAppdelegate.appLanguage == .English{
            
            openLeft()
            
        }else{
            
            openRight()
            
        }
        
    }
    
}

//MARK:- ================================================
//MARK:- UItable view delegate and datasource

extension SettingsVC: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.settingTitleLbl.text = self.titleArray[indexPath.row].localized
        
        if sharedAppdelegate.appLanguage == .Arabic{
            cell.arrowBtn.setImage(#imageLiteral(resourceName: "ic_settings_nextarrow").imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            
        }else{
            
            cell.arrowBtn.setImage(#imageLiteral(resourceName: "ic_settings_nextarrow"), for: .normal)
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "EditProfileID") as! EditProfileVc
            self.navigationController?.pushViewController(obj, animated: true)
            setEvent(eventName: FirebaseEventName.edit_profile, params: ["eventId": self.eventId as NSObject])

            
        case 1:
            
            displayShareSheet(shareContent: APPSTORE_URL, viewController: self)
            setEvent(eventName: FirebaseEventName.invite_profile, params: ["eventId": self.eventId as NSObject])

            
        case 2:
            
            let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChoosePeopleID") as! ChoosePeopleVC
            obj.choosePeopleState = .Block
            obj.titleStr = BLOCKED_USER.localized
            setEvent(eventName: FirebaseEventName.block_users, params: ["eventId": self.eventId as NSObject])

            self.navigationController?.pushViewController(obj, animated: true)
            
        case 3:
            let obj = settingsStoryboard.instantiateViewController(withIdentifier: "ChangePasswordID") as! ChangePasswordVC
            self.navigationController?.pushViewController(obj, animated: true)
            
            
        case 4:
            
            let popUp = homeStoryboard.instantiateViewController(withIdentifier: "HomePopUpID") as! HomePopUpVC
            popUp.modalPresentationStyle = .overCurrentContext
            popUp.selectPopUp = .Language
            self.present(popUp, animated: true, completion: nil)
            setEvent(eventName: FirebaseEventName.change_language, params: ["eventId": self.eventId as NSObject])

            
        case 5:
            
            let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "TermsAndConditionsID") as! TermsAndConditionsVC
            obj.navTitleStr = DISCLAIMER.localized
            obj.action = "3"
            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
            setEvent(eventName: FirebaseEventName.desclaimer, params: ["eventId": self.eventId as NSObject])

            
        default:
            print_debug(object: "")
        }
    }
}



class SettingCell: UITableViewCell{
    
    @IBOutlet weak var settingTitleLbl: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
