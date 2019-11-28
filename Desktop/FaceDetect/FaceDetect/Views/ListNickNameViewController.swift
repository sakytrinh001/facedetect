//
//  ListNickNameViewController.swift
//  FaceDetect
//
//  Created by administrator on 11/27/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit

protocol ListNickNameViewControllerDelegate {
    func passDataItemLocker(_ item: ListLockerModel)
}

class ListNickNameViewController: BaseViewController {

    @IBOutlet weak var tbView: UITableView!
    lazy var viewModel = ListNickNameViewModel()
    var delegate: ListNickNameViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbView.separatorStyle = .none
        tbView.register(UINib(nibName: viewModel.identifierCell, bundle: nil), forCellReuseIdentifier: viewModel.identifierCell)
        tbView.delegate = viewModel
        tbView.dataSource = viewModel
        viewModel.showError = { [weak self] (err) in
            self?.notifyError(err, action: {})
        }
        viewModel.reloadTBView = { [weak self] in
            self?.tbView.reloadData()
        }
        viewModel.selectItemLocker = { [weak self] (item) in
            self?.delegate.passDataItemLocker(item)
            self?.dismiss(animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
        
    }

    @IBAction func actClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
