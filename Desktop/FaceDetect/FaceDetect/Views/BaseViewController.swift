//
//  BaseViewController.swift
//  FaceDetect
//
//  Created by administrator on 11/27/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func notifyError(_ err: String, action: @escaping(()->Void)){
        let alert = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            action()
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
