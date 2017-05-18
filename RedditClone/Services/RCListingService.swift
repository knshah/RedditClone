//
//  RCListingService.swift
//  RedditClone
//
//  Created by Karan Shah on 5/17/17.
//  Copyright © 2017 Karan Shah. All rights reserved.
//

import Foundation

class RCListingService: NSObject {
    
    let manager = RCApiClientManager.shared
    var listings = [RCListingModel]()
    var after: String? = nil
    
    override init() {
        super.init()
    }
    
    func getNextListing(ofKind: String, completionHandler: @escaping RCCompletionHandler) {
        let params = self.after == nil ? nil : ["after": self.after!]
        manager.get("r/all/\(ofKind).json", parameters: params, progress: nil, success: { (task, responseObject) in
            if let response = responseObject as? NSDictionary {
                print(response)
                self.configureListing(response)
                completionHandler(true, nil)
            }
            else {
                completionHandler(false, "Unable to parse response data.")
            }
        }) { (task, error) in
            print("faliure")
            completionHandler(false, error.localizedDescription)
        }
    }
    
    // MARK: - Private methods
    private func configureListing(_ response: NSDictionary) {
        let listingsData = response.dictionary(forKey: "data")
        self.after = listingsData?.string(forKey: "after")
        let listings = listingsData?.array(forKey: "children")
        
        listings?.forEach({ listing in
            if let listingDict = listing as? NSDictionary {
                let data = listingDict.dictionary(forKey: "data")
                if let _ = data {
                    self.listings.append(RCListingModel(responseObject: data!))
                }
            }
        })
    }
}
