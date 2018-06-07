//
//  PreLoginServicesController.swift
//  Mutadawel
//
//  Created by Appinventiv on 20/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

internal typealias successClosure = (_ success : Bool, _ errorMessage: String, _ data: JSON?) -> Void
internal typealias successArrayClosure = (_ success : Bool, _ errorMessage: String, _ data: [JSON]?) -> Void


func signUpAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){

    NetworkController.POST(EndPoint.signUpURL, parameter: params) { (json) in
       
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })
    }
}


func loginAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.loginURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })
    }
}

func autoLoginAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
	
	NetworkController.POST(EndPoint.autoLoginURL, parameter: params) { (json) in
		
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })
	}
}

func changePasswordAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.changePasswordURL, parameter: params) { (json) in
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func forgotPasswordAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.forgotPasswordURL, parameter: params) { (json) in
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func getMarketListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){

    NetworkController.POST(EndPoint.getMarketListURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })
    }
}


func chooseMarketAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.chooseMarketListURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func getStock_currncy_ListAPI(params:JSONDictionary,url: String ,webServiceSuccess: @escaping successArrayClosure){
    
    
    NetworkController.POST(url, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}

func search_ListAPI(params:JSONDictionary ,webServiceSuccess: @escaping successClosure){
    
    
    NetworkController.POST(EndPoint.normalSearchURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}



func chooseCurrencyListAPI(params:JSONDictionary,url: String,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(url, parameter: params) { (json) in
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
}


func getUserListAPI(params:JSONDictionary,webServiceSuccess: @escaping successArrayClosure){
    
    NetworkController.POST(EndPoint.getUserListURL, parameter: params) { (json) in
        
        checkSessionWithArrayData(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

        
        
    }
}



func logOutAPI(params:JSONDictionary,webServiceSuccess: @escaping successClosure){
    
    NetworkController.POST(EndPoint.logoutURL, parameter: params) { (json) in
        
        checkSession(with: json, completionBlock: { (success, msg, data) in
            webServiceSuccess(success, msg, data)
        })

    }
    
}

func checkSession(with response : NetworkResponse , completionBlock: successClosure){
    
    hideLoader()
    switch response{
        
    case .value(let data):
        
        let message = data["error_message"].stringValue
        let code = data["error_code"].intValue
        
        if code == 1{
            
            let result = data["data"]
            
            completionBlock(true, message, result)
            
        }else if code == 204{
            
            postLogoutNavigate()
            
        }else{
            
            completionBlock(false, message, nil)
        }
        
    case .error(let error) :
        completionBlock(false, "", nil)
        print_debug(object: error)
        
    }
}


func checkSessionWithArrayData(with response : NetworkResponse , completionBlock: successArrayClosure){
    hideLoader()

    switch response{
        
    case .value(let data):
        
        let message = data["error_message"].stringValue
        let code = data["error_code"].intValue
        
        if code == 1{
            
            let result = data["data"].arrayValue
            
            completionBlock(true, message, result)
            
        }else if code == 204{
            
            postLogoutNavigate()
            
        }else{
            
            completionBlock(false, message, nil)
        }
        
    case .error(let error) :
        
        print_debug(object: error)
        
    }
}
