//
//  ResultsViewController.swift
//  FaceDetect
//
//  Created by administrator on 11/27/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit

class ResultsViewController: BaseViewController {

    @IBOutlet weak var lbResults: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        services.requestAPI(url: "https://api.candyhouse.co/public/sesame/\(itemLocker?.device_id ?? "")",success: { [weak self](res) in
            guard let results = res as? NSDictionary, let isLock = results["locked"] as? Bool else{
                return
            }
            self?.lbResults.text = isLock ? "ドアが施錠しました" : "ドアが施錠していません！"
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.navigationController?.popViewControllers(viewsToPop: 2)
            }
        }) { [weak self](err) in
            self?.notifyError(err, action: {
                self?.navigationController?.popViewControllers(viewsToPop: 2)
            })
        }
    }

}

extension UINavigationController {

  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
      popToViewController(vc, animated: animated)
    }
  }

  func popViewControllers(viewsToPop: Int, animated: Bool = true) {
    if viewControllers.count > viewsToPop {
      let vc = viewControllers[viewControllers.count - viewsToPop - 1]
      popToViewController(vc, animated: animated)
    }
  }

}
