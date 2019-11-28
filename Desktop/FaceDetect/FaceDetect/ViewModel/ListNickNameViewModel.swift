//
//  ListNickNameViewModel.swift
//  FaceDetect
//
//  Created by administrator on 11/27/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit

var itemLocker: ListLockerModel?
class ListNickNameViewModel: NSObject {
    
    lazy var lists = [ListLockerModel]()
    lazy var identifierCell = "ListNickNameTableViewCell"
    
    var showError: ((String) -> ())?
    var reloadTBView: (() -> ())?
    var selectItemLocker: ((ListLockerModel) -> ())?
    
    override init() {
        super.init()
        self.requestAPI()
    }
    
    private func requestAPI(){
        services.requestAPI(success: { [weak self] (res) in
            guard let results = res as? [NSDictionary] else{
                return
            }
            self?.lists = ListLockerModel.listLockers(results)
            self?.reloadTBView?()
        }) { [weak self] (err) in            
            self?.showError?(err)
        }
    }
    
}

extension ListNickNameViewModel: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemLocker = lists[indexPath.row]
        guard let item = itemLocker else{
            return
        }
        self.selectItemLocker?(item)
    }
}

extension ListNickNameViewModel: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath) as! ListNickNameTableViewCell
        cell.lb.text = lists[indexPath.row].nickname
        return cell
    }
    
}
