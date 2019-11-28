//
//  Services.swift
//  FaceDetect
//
//  Created by administrator on 11/27/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit
import Alamofire

var services = Services.sharedInstance
class Services: NSObject {

    static let sharedInstance = Services()
    
    func requestAPI(url: String = ServiceConfig.urlSesame, httpMethod: HTTPMethod = .get, success: @escaping((Any?)->Void), failure: @escaping((String)->Void)) {
        
        let header: HTTPHeaders = ["Authorization": "uLS3qGX_TM6Mui5flbzfr-2U010A_7Y-lWhluEPEx10dpnXbb5yN2L8lakM3G2YZAoVgbt7FXImW"]
        
        Alamofire.request(url, method: httpMethod, headers: header).responseJSON { (res) in
            if res.error == nil{
                print("GET Success: \(res.result.value)")
                success(res.result.value)
            }else{
                failure(res.error?.localizedDescription ?? "Error Server")
            }
        }
        
    }
    
    func requestAPIWithBody(httpMethod: HTTPMethod = .post, success: @escaping((Any?)->Void), failure: @escaping((String)->Void)) {
        let json = "{\"command\" : \"unlock\"}"

        let url = URL(string: "https://api.candyhouse.co/public/sesame/" + (itemLocker?.device_id ?? ""))!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("uLS3qGX_TM6Mui5flbzfr-2U010A_7Y-lWhluEPEx10dpnXbb5yN2L8lakM3G2YZAoVgbt7FXImW", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON { (res) in
            if res.error == nil{
                success(res.result.value)
                print("POST Success: \(res.result.value)")
            }else{
                failure(res.error?.localizedDescription ?? "Error Server")
            }
        }
        
    }
    
}
