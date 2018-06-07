//
//  NetworkController.swift
//  Rpnzl
//
//  Created by Shubham on 2/10/16.
//  Copyright © 2016 AppInventiv. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

let TIME_OUT_INTERVAL_UPLOAD:CGFloat = 30.0


enum NetworkResponse {
    
    case value(JSON)
    case error(Error)
}


let NO_INTERNET_MESSAGE = "Internet Connection appears to be offline"


let loginData = "user@tridder:password@tridder".data(using: String.Encoding.utf8)!
let base64LoginString = loginData.base64EncodedString(options: [])

var headers:[String:String]{
    
    
    // if let token = CurrentUser.token{
    //return ["Authorization": ("Basic "+base64LoginString),"Auth-Token":""]
    // }
    
    // printlnDebug("Basic "+base64LoginString)
    if sharedAppdelegate.appLanguage == .Arabic{
        
        return ["Authorization": ("Basic \(base64LoginString)"),"lang":"ar"]

    }else{
        
        return ["Authorization": ("Basic \(base64LoginString)"),"lang":"en"]

    }
}



class NetworkController {
    
    static var manager : SessionManager?
    
    class func createSession(timeoutInterval: CGFloat = TIME_OUT_INTERVAL_UPLOAD) -> SessionManager {
        
        if let m = manager {
            return m
        }
        else {
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = TimeInterval(timeoutInterval)
            configuration.timeoutIntervalForResource = TimeInterval(timeoutInterval)
            
            let tempmanager = Alamofire.SessionManager(configuration: configuration)
            manager = tempmanager
            
            return manager!
        }
    }
    
    class func POST(_ URL : String, parameter : JSONDictionary, completionBlock: @escaping ((NetworkResponse) -> Void)) {
        
        let sessionManagerTemp = self.createSession()
        

            sessionManagerTemp.request(URL, method: .post, parameters: parameter, encoding: URLEncoding.methodDependent, headers: headers).responseJSON(completionHandler: { (response : DataResponse<Any>) in
                
                if let value = response.result.value {
                    response.log()
                    completionBlock(NetworkResponse.value(JSON(value)))
                }
                else if response.result.isSuccess {
                    response.log()
                    
                    // Data not in proper format
                   hideLoader()
                    
                }
                    
                else if let error = response.result.error {
                    
                    response.log()

                    guard let err = (error as? NSError) else {
                        
                        return
                    }
                    
                    if err.code == NSURLErrorNotConnectedToInternet {
                        
                        hideLoader()
                        
                        //showToastWithMessage(msg: NO_INTERNET_MESSAGE)
                        
                    }
                    
                    
                    if err.code == (-999) || err.code == (-1004) || err.code == (-1001) {
                        
                        hideLoader()
                        
                        //showToastWithMessage(msg: NO_INTERNET_MESSAGE)
                    }

                    completionBlock(NetworkResponse.error(error))
                    
                    hideLoader()
                }
            })
    }
    
    
    class func PostWithImage(_ URL : String, parameter :JSONDictionary , isImageAvail : Bool,image: [Data],singleImageFlag : Bool ,completionBlock: @escaping ((NetworkResponse) -> Void)) {
        
                let sessionManagerTemp = self.createSession()
    
        let urlConvertible = try! URLRequest(url: URL, method: .post, headers: headers)
        
        sessionManagerTemp.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameter {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                
//                data.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            
            if isImageAvail {
                
                if singleImageFlag {
                    
                    for image in image {
                        multipartFormData.append(image, withName: "userPhoto", fileName: "image.png", mimeType: "image/png")
                    }
                    
                } else {
                    
                    for image in image {
                        multipartFormData.append(image, withName: "userUploadMedia[]", fileName: "image.jpeg", mimeType: "image/jpeg")
                    }
                    
                }
            }
            
        }, with: urlConvertible, encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    if  let value =  response.result.value {
                        response.log()

                        completionBlock(NetworkResponse.value(JSON(value)))

                    }
                    else if let error = response.result.error {
                        
                        guard let err = (error as? NSError) else {
                            
                            return
                        }
                        
                        if err.code == NSURLErrorNotConnectedToInternet {
                            hideLoader()
                            //showToastWithMessage(msg: NO_INTERNET_MESSAGE)
                            
                        }
                        if err.code == (-999) || err.code == (-1004) || err.code == (-1001) {
                            hideLoader()
                            //showToastWithMessage(msg: NO_INTERNET_MESSAGE)
                        }
                    }
                }
                
            case .failure(let encodingError):
                print_debug(object: encodingError)
                hideLoader()
            }
            
        })
    }
    
    class func GET(_ URL : String, parameter : JSONDictionary, completionBlock: @escaping ((NetworkResponse) -> Void)) {
        
       // ACCESS_TOKEN.Dynamic = UserDefaults.userdefaultStringForKey("Dynamic")
                var sessionManagerTemp : SessionManager?
        
                if URL.hasSuffix("list?") {
                    self.manager = nil
                    sessionManagerTemp = self.createSession(timeoutInterval: CGFloat(TIME_OUT_INTERVAL_UPLOAD))
                }
                else {
                    sessionManagerTemp = self.createSession()
                }
        sessionManagerTemp?.request(URL, method: .get, parameters: parameter, encoding: URLEncoding.methodDependent, headers: headers).responseJSON(completionHandler: { (response : DataResponse<Any>) in
            
            if let value = response.result.value {
                response.log()

                completionBlock(NetworkResponse.value(JSON(value)))

            }
            else if response.result.isSuccess {
                // Data not in proper format
                response.log()

                hideLoader()
            }
            else if let error = response.result.error {
                
                guard let err = (error as? NSError) else {
                    
                    return
                }

                
                if err.code == NSURLErrorNotConnectedToInternet {
                    hideLoader()
                    //showToastWithMessage(msg: NO_INTERNET_MESSAGE)
                    
                }
                if err.code == (-999) || err.code == (-1004) || err.code == (-1001) {
                    hideLoader()
                    //showToastWithMessage(msg: NO_INTERNET_MESSAGE)
                }
                completionBlock(NetworkResponse.error(error))
                print_debug(object: error.localizedDescription)
                hideLoader()
            }
        })
    }
    
    
    class func GETList(_ URL : String, parameter : JSONDictionary, completionBlock: @escaping ((NetworkResponse) -> Void)) {
        
        
        let sessionManagerTemp = self.createSession()
        
        sessionManagerTemp.request(URL, method: .get, parameters: parameter, encoding: URLEncoding.methodDependent, headers: headers).responseJSON { (response : DataResponse<Any>) in
            

            print_debug(object: response)
            
            if let value = response.result.value {
                
                response.log()
                
                completionBlock(NetworkResponse.value(JSON(value)))

            }
            else if response.result.isSuccess {
                
                // Data not in proper format
                hideLoader()

            }
                
            else if let error = response.result.error {
                
                guard let err = error as? NSError else {
                    return
                }
                
                if err.code == NSURLErrorNotConnectedToInternet {
                    hideLoader()
                    //showToastWithMessage(msg: NO_INTERNET_MESSAGE)
                    
                }
                if err.code == (-999) || err.code == (-1004) || err.code == (-1001) {
                    hideLoader()
                    //showToastWithMessage(msg: NO_INTERNET_MESSAGE)
                }
                completionBlock(NetworkResponse.error(error))
                print_debug(object: error.localizedDescription)
                hideLoader()
                
            }
        }
    }
    
    
    class func PostGoogleMap(_ param :JSONDictionary,URL : String, completionBlock: @escaping ((NetworkResponse) -> Void)) {
                let sessionManagerTemp = self.createSession()
        
        sessionManagerTemp.request(URL, method: HTTPMethod.post, parameters: nil, encoding: URLEncoding.methodDependent, headers: nil).responseJSON { (response : DataResponse<Any>) in
            
            if let value = response.result.value {
                
                response.log()

                completionBlock(NetworkResponse.value(JSON(value)))

            }
            else if response.result.isSuccess {
                // Data not in proper format
                response.log()

                //CommonFunctions.hideLoader()
            }
            else if let error = response.result.error {
                
                guard let err = error as? NSError else {
                    
                    return
                }
                
                if err.code == NSURLErrorNotConnectedToInternet {
//                    CommonFunctions.hideLoader()
//                    CommonFunctions.showToast(error.localizedDescription)
                }
                
                if err.code == (-999) || err.code == (-1004) || err.code == (-1001) {
//                    CommonFunctions.hideLoader()
//                    CommonFunctions.showToast(NO_INTERNET_MESSAGE)
                }
                completionBlock(NetworkResponse.error(error))
            }
        }
    }
    
    class func PostWithVideo(_ URL : String, parameter :JSONDictionary ,image: [Data],video : [Data],title : [String],completionBlock: @escaping ((NetworkResponse) -> Void)) {
        
                self.manager = nil
                let sessionManagerTemp = self.createSession(timeoutInterval: CGFloat(TIME_OUT_INTERVAL_UPLOAD))
        
        let urlConvertible = try! URLRequest(url: URL, method: .post, headers: headers)

        
        sessionManagerTemp.upload(multipartFormData: { (data:MultipartFormData) in
            
            for (key, value) in parameter {
                
                data.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                data.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            
            for title in title {
                
                data.append((title as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "title[]")

//                data.appendBodyPart(data : title.dataUsingEncoding(NSUTF8StringEncoding)! , name : "title[]")
            }
            
            for img in image {
                data.append(img, withName: "mediaThumb[]", fileName: "image.jpg", mimeType: "image/jpg")
            }
            
            for vdo in video {
                data.append(vdo, withName: "userUploadMedia[]", fileName: "video.mp4", mimeType: "video/mp4")
            }
            
        }, with: urlConvertible) { (result : SessionManager.MultipartFormDataEncodingResult) in
            
            switch result {
            case .success(let upload, _, _):
                upload
                    .responseJSON { response in
                        
                        if  let value =  response.result.value {
                            response.log()

                            completionBlock(NetworkResponse.value(JSON(value)))

                        }
                        else if let error = response.result.error {
                            
                            guard let err = error as? NSError else {
                                return
                            }
                            
                        }
                }
                
            case .failure(let encodingError):
                print_debug(object: encodingError)
                //CommonFunctions.hideLoader()
            }
            
            
        }
    }
    
    class func Video(_ URL : String, parameter :JSONDictionary, imageKey: String, imageData: [Data]? = nil, videoKey: String, videoData : [Data]? = nil, completionBlock: @escaping ((NetworkResponse) -> Void)) {
        
                self.manager = nil
                let sessionManagerTemp = self.createSession(timeoutInterval: TIME_OUT_INTERVAL_UPLOAD)
        
        let urlConvertible = try! URLRequest(url: URL, method: .post, headers: headers)

        
        sessionManagerTemp.upload(multipartFormData: { (data : MultipartFormData) in
            
            for (key, value) in parameter {
                print_debug(object: " setting \(value) for \(key)")
                
                data.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }
            
            if let tempData = imageData {
                for image in tempData {
                    data.append(image, withName: imageKey, fileName: "image.jpg", mimeType: "image/jpg")
                }
            }
            
            if let tempData = videoData {
                for video in tempData {
                    data.append(video, withName: videoKey, fileName: "video.mp4", mimeType: "video/mp4")
                }
            }
            
        }, with: urlConvertible) { (result : SessionManager.MultipartFormDataEncodingResult) in
            
            switch result {
                
            case .success(let upload, _, _):
                upload
                    .responseJSON { response in
                        
                        if  let value =  response.result.value {
                            response.log()

                            completionBlock(NetworkResponse.value(JSON(value)))

                        } else if let error = response.result.error {
                            
                            guard let err = (error as? NSError) else {
                                
                                return
                            }
                            
                        }
                }
            case .failure(let encodingError):
                print_debug(object: encodingError)
            }
        }
    }
    
    class func Delete(_ URL : String, parameter : JSONDictionary ,completionBlock: @escaping ((NetworkResponse) -> Void)) {
        
                let sessionManagerTemp = self.createSession()
        
        sessionManagerTemp.request(URL, method: HTTPMethod.delete, parameters: parameter, encoding: URLEncoding.methodDependent, headers: headers).responseJSON { (response : DataResponse<Any>) in
            
            if let value = response.result.value {
                
                response.log()

                completionBlock(NetworkResponse.value(JSON(value)))

            }
            else if response.result.isSuccess {
                
            }
            else if let error = response.result.error {
                
                guard let err = (error as? NSError) else {
                    
                    return
                }
                
            }
        }
    }
    
    class func Put(_ URL : String, parameter : JSONDictionary, completionBlock: @escaping ((NetworkResponse) -> Void)) {
        
        
        let sessionManagerTemp = self.createSession()
        
        sessionManagerTemp.request(URL, method: HTTPMethod.put, parameters: parameter, encoding: URLEncoding.methodDependent, headers: headers).responseJSON(completionHandler: { (response : DataResponse<Any>) in
            
            
            if let value = response.result.value {
                response.log()

                completionBlock(NetworkResponse.value(JSON(value)))

            }
            else if response.result.isSuccess {
                response.log()
            }
            else if let error = response.result.error {
                
                guard let err = (error as? NSError) else {
                    
                    return
                }
            }
        })
    }
    
    
    class func downloadFileWithProgress(_ fileURL: URL, progressBlock:@escaping (_ currentBytes:Int64,_ totalBytes:Int64)->Void, complitionBlock:@escaping (_ filePath:String?,_ error:NSError?)->Void) {
        
        self.manager = nil
        
        let sessionManagerTemp = self.createSession(timeoutInterval: TIME_OUT_INTERVAL_UPLOAD)
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        let urlConvertible = try! URLRequest(url: fileURL, method: .get, headers: nil)
        
        Alamofire.download(urlConvertible, to: destination).downloadProgress { (prgrs : Progress) in
            
            progressBlock(prgrs.completedUnitCount, prgrs.totalUnitCount)
            
            }.response { (response : DefaultDownloadResponse) in
                
                                if let err = response.error {
                
                                    print_debug(object: "Error on downloading : \(err)")
                                    complitionBlock(nil, err as NSError?)
                
                                } else {
                                    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                                    let name = fileURL.absoluteString.components(separatedBy: "/").last!
                                    path = path.appending("/\(name)")
                                    complitionBlock(path, nil)
                                }

                
                
        }
            
    }
    
    
    
    class func GETWithouHeader(_ URL : String, parameter : JSONDictionary, completionBlock: @escaping ((NetworkResponse) -> Void)) {
        
        // ACCESS_TOKEN.Dynamic = UserDefaults.userdefaultStringForKey("Dynamic")
        var sessionManagerTemp : SessionManager?
        
        if URL.hasSuffix("list?") {
            self.manager = nil
            sessionManagerTemp = self.createSession(timeoutInterval: CGFloat(TIME_OUT_INTERVAL_UPLOAD))
        }
        else {
            sessionManagerTemp = self.createSession()
        }
        sessionManagerTemp?.request(URL, method: .get, parameters: parameter, encoding: URLEncoding.methodDependent, headers: nil).responseJSON(completionHandler: { (response : DataResponse<Any>) in
            
            if let value = response.result.value {
                response.log()
                
                completionBlock(NetworkResponse.value(JSON(value)))

            }
            else if response.result.isSuccess {
                // Data not in proper format
                response.log()
                
                hideLoader()
            }
            else if let error = response.result.error {
                
                guard let err = (error as? NSError) else {
                    
                    return
                }
                
                
                if err.code == NSURLErrorNotConnectedToInternet {
                    hideLoader()
                    //showToastWithMessage(msg: NO_INTERNET_MESSAGE)
                    
                }
                if err.code == (-999) || err.code == (-1004) || err.code == (-1001) {
                    hideLoader()
                }
                completionBlock(NetworkResponse.error(error))
                print_debug(object: error.localizedDescription)
                hideLoader()
            }
        })
    }
}

extension Alamofire.DataResponse {

    func log() {
        let paramsData : Data = self.request?.httpBody ?? Data()
            
            //self.request?.HTTPBody ?? NSData()
        let sentParams = String(data: paramsData as Data, encoding: String.Encoding.utf8)!
//        let sentParams = NSString(data: paramsData as Data, encoding: String.Encoding.utf8.rawValue)!
        print_debug(object: "************************************************************************")
        print_debug(object: "\n                              HITTING URL\n \(String(describing: self.request?.url?.absoluteString))\n                             WITH \(String(describing: self.request!.httpMethod)) PARAMETERS\n\(sentParams)\n                              HEADERS\n\n\(self.request!.allHTTPHeaderFields!)")
        print_debug(object: "\n************************************************************************")
        print_debug(object: "\n                              RESPONSE\n\(self)")
        print_debug(object: "\n************************************************************************")
    }
}
