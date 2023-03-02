//
//  HomeViewModel.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 15/02/23.
//

import UIKit

class HomeViewModel {
    
    var savedContentHeight = 0.0
    var defaultContentHeight = 0.0
    var maxContentHeight = 0.0
    
    var lastContentOffset = 0.0
    
    var search: String = ""
    var data: [Rocket.Response] = []
    
    var page = 1
    var paginate = false
    
    @Published var status: Status = .idle
    
    var loadMore = false
    
    func dispose() {
        page = 1
        data.removeAll()
        status = .idle
    }
    
    func fetch() {
        RocketService.shared.getAll(
            param: .init(
                query: search.isEmpty ? nil : .init(name: search),
                options: .init(limit: 20, page: page)
            )
        ) {
            if let data = $0 {
                self.data.append(contentsOf: data.docs)
                self.status = .success
            } else {
                self.status = .timeout
            }
            
            self.loadMore = false
        }
    }
}
