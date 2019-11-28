//
//  InfoFaceViewController.swift
//  FaceDetect
//
//  Created by administrator on 11/27/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit

class InfoFaceViewController: UIViewController {

    @IBOutlet weak var avatarUser: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNotify: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    var itemUser: CheckFaceModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUp()
        self.navigationController?.isNavigationBarHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if itemLocker == nil{
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            self.navigationController?.pushViewController(ResultsViewController(), animated: true)
        }
        
    }
    
    func setUp(){
        avatarUser.layer.cornerRadius = avatarUser.frame.height/2
        guard let item = itemUser, let data = item.data else {
            return
        }
        DispatchQueue.main.async {
            self.lbName.text = data[0]["name"] ?? ""
        }
        self.avatarUser.downloadImageFrom(link: "https://picture.vision-vietnam.com/public/files_regis/\(data[0]["img_name"] ?? "")", contentMode:UIView.ContentMode.scaleAspectFill)
        self.lbDate.text = self.convertDate()
    }

    func convertDate() -> String
    {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "HH:mm:ss\n\nyyyy/MM/dd"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
}
