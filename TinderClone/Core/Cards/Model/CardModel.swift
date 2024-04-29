//
//  CardModel.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import Foundation

struct CardModel : Codable {
    let user: User
    
    init(user: User) {
            self.user = user
        }
    
    enum CodingKeys: String, CodingKey {
            case user
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            user = try container.decode(User.self, forKey: .user)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(user, forKey: .user)
        }
}

extension CardModel: Identifiable, Hashable {
    var id: String { return user.id}
}
