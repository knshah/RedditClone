//
//  RCCommentModel.swift
//  RedditClone
//
//  Created by Karan Shah on 5/18/17.
//  Copyright © 2017 Karan Shah. All rights reserved.
//

import Foundation

class RCCommentModel: NSObject {
    
    var author = ""
    var body = ""
    var depth = 0
    
    init(responseObject: NSDictionary) {
        super.init()
        
        self.author = responseObject.string(forKey: "author")
        self.body = responseObject.string(forKey: "body")
        if let depth = responseObject.number(forKey: "depth") {
            self.depth = depth.intValue
        }
        
        print("\(self.author)---\n\(self.body)\n---")
    }
}
