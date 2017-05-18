//
//  RCListingModel.swift
//  RedditClone
//
//  Created by Karan Shah on 5/17/17.
//  Copyright © 2017 Karan Shah. All rights reserved.
//

import Foundation

class RCListingModel: NSObject {
    
    var title = ""
    var thumbnail: String? = nil
    var thumbnailWidth: CGFloat = CGFloat(0)
    var thumbnailHeight: CGFloat = CGFloat(0)
    
    init(responseObject: NSDictionary) {
        super.init()
        
        self.title = responseObject.string(forKey: "title")
        self.thumbnail = responseObject.string(forKey: "thumbnail")
        if let width = responseObject.number(forKey: "thumbnail_width") {
            self.thumbnailWidth = CGFloat(width.floatValue)
        }
        if let height = responseObject.number(forKey: "thumbnail_height") {
            self.thumbnailHeight = CGFloat(height.floatValue)
        }
    }
    
    func thumbnailImageURL() -> URL? {
        if let _ = self.thumbnail {
            if let thumbnailURL = URL(string: self.thumbnail!) {
                return thumbnailURL
            }
        }
        return nil
    }
}
