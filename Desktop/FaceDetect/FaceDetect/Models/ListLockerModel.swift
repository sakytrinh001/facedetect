//
//  ListLockerModel.swift
//  FaceDetect
//
//  Created by administrator on 11/27/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit

class ListLockerModel: BaseModel {

    @objc dynamic var device_id: String?
    @objc dynamic var nickname: String?
    @objc dynamic var serial: String?
    
    class func listLockers(_ dics: [NSDictionary]) -> [ListLockerModel]{
        
        var output = [ListLockerModel]()
        
        for item in dics {
            output.append(ListLockerModel(dictionary: item))
        }
        return output
        
    }
}
