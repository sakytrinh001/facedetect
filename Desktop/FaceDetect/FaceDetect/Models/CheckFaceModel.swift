//
//  CheckFaceModel.swift
//  FaceDetect
//
//  Created by administrator on 11/27/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit

class CheckFaceModel: BaseModel {
    //                                        let arrData = dic?["data"] as? [Dictionary<String, String>]
    //                                        self.log_id = dic?["log_id"] as? String ?? ""
    //                                        self.name = arrData?[0]["name"] ?? ""
    //                                        self.img_name = arrData?[0]["img_name"] ?? ""
    //                                        self.lbName.text = self.name
    //                                        self.imgPreview.downloadImageFrom(link: "https://picture.vision-vietnam.com/public/files_regis/\(self.img_name)", contentMode: UIView.ContentMode.scaleAspectFill)
    //
    
    @objc dynamic var data: [Dictionary<String, String>]?
    @objc dynamic var log_id: String?
    
}
