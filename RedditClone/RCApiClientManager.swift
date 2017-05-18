//
//  RCApiClientManager.swift
//  RedditClone
//
//  Created by Karan Shah on 5/17/17.
//  Copyright © 2017 Karan Shah. All rights reserved.
//

import Foundation
import AFNetworking

typealias RCCompletionHandler = (_ success: Bool, _ errorMessage: String?) -> Void

class RCApiClientManager: AFHTTPSessionManager {
    
    static let shared = RCApiClientManager()
    
    private init() {
        let baseURL = URL(string: "https://www.reddit.com/")
        super.init(baseURL: baseURL, sessionConfiguration: URLSessionConfiguration.default)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
