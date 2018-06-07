//
//  PostLoginServiceController.swift
//  Mutadawel
//
//  Created by Appinventiv on 23/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation


func chooseFriendAPI(params:JSONDictionary,url:String,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(url, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func unfollowFriendAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.unfollowFriendURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func editProfileAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.editProfileURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func myProfileAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.myProfileURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func userProfileAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.userProfileURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func followerListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.followerURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func followingListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.followingURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func blockUserListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.blocked_usersListURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func addForecastAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.addForecastURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func contactUsAPI(params:JSONDictionary,url: String,webServiceSuccess: @escaping successClosure){
    
    
    NetworkController.POST(url, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func postListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.postListURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func timeLineAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.timeLineURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func reportPostAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.reportPostURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func hidePostAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.hidePostURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func blockUserAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.block_userURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })
        
    }
}


func unFollowMarketAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.unFollowMarketURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func unBlockUserAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.unBlock_userURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func follow_Currency_Stock_API(params:JSONDictionary,url: String,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(url, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func saveCommentAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.commentURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func commentListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.commentListURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func saveRepplyCommentAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.comment_RepplyURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func priceIndicatorAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.priceIndicatorURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func forexAPI(url:String,webServiceSuccess: @escaping successClosure){
    
    
    NetworkController.GETWithouHeader(url, parameter: [:]) { (json) in
        print_debug(object: json)
        switch json{
            
        case .value(let data):
            
            print_debug(object: data)
            
                if let _ = data["Ask"].double {
                    
                        webServiceSuccess(true, "", data)
                    
                } else{
                        
                        webServiceSuccess(false, "", nil)
                    }
        case .error(let error) :
            print_debug(object: error)
        }
    }
}


func rightForecastListAPI(params:JSONDictionary,url: String,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(url, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func forecastStatusAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.forecastStatusURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func stockPriceAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.stockPriceURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func saveTradeAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.saveTradeURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func rankingAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.rankingURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func walletAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.userWalletURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func saveLikeAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.saveLikeURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func myStockListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.myStockListURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func myDonationListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.myDonationListURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func makeDonationAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.makeDonationtURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func accntNotificationAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.accntNotificatinURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func donationConfirmationAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.donationConfirmationURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func addMoreMoneyAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.addMoreMoneyURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func updateForexAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.updateForexURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func closeOrderAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.closeOrderURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func notificationListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.notificationListURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func postDetailAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.postDetailURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func bankDetailAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.bankDetailURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func likersListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.likersListURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func staticPagesAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.staticPagesURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func chatListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.userChatURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func muteUserNotificationAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.block_userURL, parameter: params) { (json) in
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func chatNotificationAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.chatNotificationURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func muteUserNoificationAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.muteUserNotificationURL, parameter: params) { (json) in
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func getPayPalDetailAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.getPayPalDetailURL, parameter: params) { (json) in
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func getBankDetailAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.getBankDetailURL, parameter: params) { (json) in
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func savePayPalDetailAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.payPalDetailURL, parameter: params) { (json) in
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func feedbackAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.feedbackURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func sharePostAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.sharePostURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func getFeedbackAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.feedbackURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func saveFeedbackAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.saveFeedbackURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func readNotificationAPI(params:JSONDictionary){
    
    NetworkController.POST(EndPoint.readNotificationURL, parameter: params) { (json) in
        
        switch json{
            
        case .value(let data):
            
            let code = data["error_code"].intValue

                if code == 1{
                    
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }

                if code == 204{
                        
                    postLogoutNavigate()
                        
                }
        case .error(let error) :
            print_debug(object: error)
        }
    }
}



func setLangAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.setLangURL, parameter: params) { (json) in
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}
func getForecastPercentage(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
	
	NetworkController.POST(EndPoint.getForecastPercentageURL, parameter: params){ (json) in
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

	}

}

func clickRankingAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
	
	NetworkController.POST(EndPoint.clickRankingURL, parameter: params) { (json) in
		
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

	}
}

func priceIndicatorListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
	
	NetworkController.POST(EndPoint.priceIndicatorListURL, parameter: params) { (json) in
		
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })
	}
}

func walletNetValue(params: JSONDictionary, webServiceSuccess: @escaping successClosure){
	
	NetworkController.POST(EndPoint.walletNetValueURL, parameter: params) { (json) in
		
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

	}
}

func myBoughtStockListAPI(params:JSONDictionary,url : String,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(url, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })
        
    }
}

func messageClick(params: JSONDictionary, webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.messageClickURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })
        
    }
}


