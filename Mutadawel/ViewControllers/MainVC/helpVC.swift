//
//  helpVC.swift
//  Mutadawel
//
//  Created by MOMO on 9/24/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class helpVC: UIViewController {

	@IBOutlet weak var backBtn: UIButton!
	@IBOutlet weak var youTubeView: UIWebView!
	@IBOutlet weak var navigationBarLbl: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		if sharedAppdelegate.appLanguage == .Arabic {
			
			let img = #imageLiteral(resourceName: "ic_sign_in_next")
			self.backBtn.setImage(img, for: .normal)
		}else{
			
			let img = #imageLiteral(resourceName: "ic_sign_in_back")
			self.backBtn.setImage(img, for: .normal)
		}
		
		self.navigationBarLbl.text = "\(SUPPORT.localized)"
		
		let myVideo = "src=\"https://www.youtube.com/embed/UtN-VDYeADc?&rel=0&autoplay=1\""
		
		self.youTubeShow(myVideo: myVideo)
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func youTubeShow(myVideo: String) {
		
		youTubeView.allowsInlineMediaPlayback = true
		youTubeView.mediaPlaybackRequiresUserAction = false
		youTubeView.backgroundColor = UIColor.black
		
		
		
		let html = "<iframe width=\"400\" height=\"654\"\(myVideo) frameborder=\"0\" allowfullscreen></iframe>"
	
		
		
		//let myVideo2 = "https://www.youtube.com/watch?v=UtN-VDYeADc&feature=youtu.be&autoplay=1"
		
		//let request = URLRequest.init(url: URL.init(string: myVideo2)!)
		
		//youTubeView.loadRequest(request)
		
		youTubeView.loadHTMLString(html, baseURL: nil)
		
	}

	@IBAction func backBtnTapped(_ sender: Any) {
		
		_ = self.navigationController?.popViewController(animated: true)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
