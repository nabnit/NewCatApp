//
//  CatDescriptionModel.swift
//  CatSampleApp
//
//  Created by Nabnit Patnaik on 12/22/22.
//

import Foundation

struct CatDescriptionModel: Codable {
    var data: [String]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try data.decode([String].self, forKey: .data)
       
    }
}

