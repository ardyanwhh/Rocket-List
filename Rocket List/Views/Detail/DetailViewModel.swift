//
//  DetailViewModel.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 15/02/23.
//

import UIKit

class DetailViewModel {
    
    var savedContentHeight = 0.0
    var defaultContentHeight = 0.0
    var maxContentHeight = 0.0
    
    var id = ""
    
    var data: Rocket.Response?
    var collectedData: [[String]] = []
    
    @Published var status: Status = .idle
    
    func dispose() {
        data = nil
        collectedData.removeAll()
    }
    
    func fetch() {
        status = .loading
        
        RocketService.shared.getDetail(id: id) {
            if let data = $0 {
                self.data = data
                self.collectedData.append(["Description", data.desc ?? "Empty description"])
                
                if !data.failures.isEmpty {
                    self.collectedData.append(["Failure Reason", data.failures[0].reason])
                } else {
                    self.collectedData.append(["Failure Reason", "Empty failure reason"])
                }
                self.status = .success
            } else {
                self.status = .timeout
            }
        }
    }
}
