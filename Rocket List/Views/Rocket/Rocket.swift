//
//  Rocket.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 14/02/23.
//

import Foundation

struct Rocket {
    struct Param: Encodable {
        var query: Query?
        var options: Options
        
        struct Options: Encodable {
            var limit: Int
            var page: Int
        }
        
        struct Query: Encodable {
            var name: String
            
            enum CodingKeys: String, CodingKey {
                case name = "name"
            }
        }
    }
    
    struct Docs: Decodable {
        var docs: [Response]
        var totalPages: Int
    }
    
    struct Response: Decodable {
        var id: String
        var name: String
        var links: Links
        var date: String
        var desc: String?
        var failures: [Failures]
        
        struct Failures: Decodable {
            var reason: String
        }
        
        struct Links: Decodable {
            var image: Image
            
            enum CodingKeys: String, CodingKey {
                case image = "patch"
            }
        }
        
        struct Image: Decodable {
            var small: String?
            var large: String
        }
        
        enum CodingKeys: String, CodingKey {
            case desc = "details"
            case date = "date_utc"
            case id, name, links, failures
        }
    }
}

