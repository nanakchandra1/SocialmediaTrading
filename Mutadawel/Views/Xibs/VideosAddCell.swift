//
//  VideosAddCell.swift
//  Mutadawel
//
//  Created by Appinventiv on 19/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import KILabel
import AVFoundation

class VideosAddCell: UITableViewCell, UIWebViewDelegate {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var sponserName: UILabel!
    @IBOutlet weak var youTubeView: UIWebView!
    @IBOutlet weak var commentLbl: KILabel!
    @IBOutlet weak var urlLbl: KILabel!
    
    var videourl = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.borderColor = AppColor.appPinkColor.cgColor
        self.bgView.layer.borderWidth = 1
        self.youTubeView.scrollView.isScrollEnabled = false
        self.youTubeView.scrollView.bounces = false
        self.youTubeView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(with data: ForecastPostDetailModel){
        
        if let ad_link = data.ad_link{
            
            self.youTubeShow(myVideo: ad_link)
            self.videourl = ad_link
            self.urlLbl.text = ad_link
//            self.idd(withUrl: ad_link)

        }
        let add_description = data.add_description ?? ""
        let sponsor_by = data.sponsor_by ?? ""

        self.commentLbl.text = add_description
        self.sponserName.text = sponsor_by

    }
    
//    func idd( withUrl videoURL: String){
//
//        print_debug(object: "linked path: \(videoURL)")
//        let url = URL(string: videoURL)
//        var linkedPath = ""
//        var asset: AVURLAsset?
//        let filemgr = FileManager.default
//        for string: String in AVURLAsset.audiovisualMIMETypes() {
//            if string.contains("video/") {
//
//                print_debug(object: "Trying: \(string)")
//                linkedPath = URL(fileURLWithPath: videoURL).appendingPathExtension(string.replacingOccurrences(of: "video/", with: "")).absoluteString
//                print_debug(object: "linked path: \(linkedPath)")
//                if !filemgr.fileExists(atPath: linkedPath) {
//                    let error: Error? = nil
//                    try? filemgr.createSymbolicLink(at: URL(string: linkedPath)!, withDestinationURL: url!)
//                    if error != nil {
//                        print_debug(object: "error \(String(describing: error?.localizedDescription))")
//                    }
//                }
//                asset = AVURLAsset(url: URL(string: linkedPath)!)
//                if (asset?.isPlayable)! {
//                    print_debug(object: "Playable")
//                    break
//                }
//                else {
//                    print_debug(object: "Not Playable")
//                    asset = nil
//                }
//            }
//    }
//}
    func youTubeShow(myVideo: String) {
        
        youTubeView.allowsInlineMediaPlayback = true
        youTubeView.mediaPlaybackRequiresUserAction = false
        youTubeView.backgroundColor = UIColor.black
        print_debug(object: myVideo)
        
        var videoId = ""
        var video = ""

        if myVideo.contains("youtube.com"){
            
            videoId = self.extractYoutubeId(fromLink: myVideo)
            
            video = "src=\"https://www.youtube.com/embed/\(videoId)?autoplay=1&playsinline=1\""
            
        }else if myVideo.contains("vimeo.com"){
            
            let str: String = myVideo.replacingOccurrences(of: "https://", with: "")
            let arryVedios = str.components(separatedBy: "/")
            let id = arryVedios.last ?? ""
            video = "src=\"https://player.vimeo.com/video/\(id)?autoplay=0&playsinline=0\""

        }
        
        guard let url = URL(string: myVideo) else{return}
        
        let html = "<iframe width=\"\(screenWidth)\" height=\"\(self.youTubeView.bounds.height)\"\(video) frameborder=\"0\" ></iframe>"
        
        youTubeView.loadHTMLString(html, baseURL: url)

    }
    
    func extractYoutubeId(fromLink link: String) -> String {
        
        let regexString: String = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regExp = try? NSRegularExpression(pattern: regexString, options: .caseInsensitive)
        let array: [Any] = (regExp?.matches(in: link, options: [], range: NSRange(location: 0, length: (link.characters.count ))))!
        if array.count > 0 {
            let result: NSTextCheckingResult? = array.first as? NSTextCheckingResult
            return (link as NSString).substring(with: (result?.range)!)
        }
        
        return ""
    }

  
}
