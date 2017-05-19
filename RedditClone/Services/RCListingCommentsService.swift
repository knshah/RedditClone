//
//  RCListingCommentsService.swift
//  RedditClone
//
//  Created by Karan Shah on 5/18/17.
//  Copyright © 2017 Karan Shah. All rights reserved.
//

import Foundation

class RCListingCommentsService: NSObject {
    
    let manager = RCApiClientManager.shared
    var comments = [RCCommentModel]()
    
    override init() {
        super.init()
    }
    
    func getComments(subreddit: String, article: String, completionHandler: @escaping RCCompletionHandler) {
        let path = "/r/\(subreddit)/comments/\(article)/.json"
        manager.get(path, parameters: nil, progress: nil, success: { (task, responseObject) in
            if let response = responseObject as? NSArray {
                self.configureComments(responseObject: response.object(at: 1) as! NSDictionary)
                completionHandler(true, nil)
            } else {
                completionHandler(false, "Invalid response.")
            }
        }) { (task, error) in
            print("error: \(error.localizedDescription)")
            completionHandler(false, error.localizedDescription)
        }
    }
    
    private func configureComments(responseObject: NSDictionary) {
        let data = responseObject.dictionary(forKey: "data")
        let childrens = data?.array(forKey: "children")
        
        childrens?.forEach({ object in
            if let objectDict = object as? NSDictionary {
                if let commentData = objectDict.dictionary(forKey: "data") {
                    if let _ = commentData.object(forKey: "body") {
                        let comment = RCCommentModel(responseObject: commentData)
                        self.comments.append(comment)
                    }
                    
                    if let replyData = commentData.dictionary(forKey: "replies") {
                        self.configureComments(responseObject: replyData)
                    }
                }
            }
        })
    }
}
