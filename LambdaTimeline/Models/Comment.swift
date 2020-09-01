//
//  Comment.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

class Comment: Hashable {
    
    static private let textKey = "text"
    static private let authorKey = "author"
    static private let timestampKey = "timestamp"
    
    let text: String?
    let author: String
    let timestamp: Date
    
    init(text: String? = nil, author: String, timestamp: Date = Date()) {
        self.text = text
        self.author = author
        self.timestamp = timestamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(timestamp.hashValue ^ author.hashValue)
    }

    static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.author == rhs.author &&
            lhs.timestamp == rhs.timestamp
    }
}
