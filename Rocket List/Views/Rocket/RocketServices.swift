//
//  RocketServices.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 14/02/23.
//

import Foundation
import Alamofire

class RocketService {
    
    static let shared = RocketService()
    
    func getAll(param: Rocket.Param, callback: @escaping (Rocket.Docs?) -> ()) {
        AF.request(
            URLs.baseURLQuery, method: .post, parameters: param,
            encoder: JSONParameterEncoder.default
        ).response {
            switch $0.result {
            case .success(_):
                do {
                    callback(try JSONDecoder().decode(Rocket.Docs.self, from: $0.data!))
                } catch {
                    print(error)
                }
            case .failure(_):
                callback(nil)
            }
        }
    }
    
    func getDetail(id: String, callback: @escaping (Rocket.Response?) -> ()) {
        AF.request("\(URLs.baseURL)/\(id)" , method: .get).response {
            switch $0.result {
            case .success(_):
                do {
                    callback(try JSONDecoder().decode(
                        Rocket.Response.self, from: $0.data!
                    ))
                } catch {
                    print(error)
                }
            case .failure(_):
                callback(nil)
            }
        }
    }
}
