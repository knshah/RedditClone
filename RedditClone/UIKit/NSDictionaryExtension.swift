//
//  NSDictionaryExtension.swift
//  RedditClone
//
//  Created by Karan Shah on 5/17/17.
//  Copyright © 2017 Karan Shah. All rights reserved.
//

import Foundation

extension NSDictionary {
    
    func dictionary(forKey key: String) -> NSDictionary? {
        let object = self.object(forKey: key)
        if let dictionary = object as? NSDictionary {
            return dictionary
        }
        
        return nil
    }
    
    func string(forKey key: String) -> String {
        let object = self.object(forKey: key)
        if let strObject = object as? NSString {
            return strObject as String
        }
        if let number = object as? NSNumber {
            return number.stringValue
        }
        
        return ""
    }
    
    func array(forKey key: String) -> NSArray? {
        let object = self.object(forKey: key)
        if let array = object as? NSArray {
            return array
        }
        
        return nil
    }
    
    func number(forKey key: String) -> NSNumber? {
        let object = self.object(forKey: key)
        if let number = object as? NSNumber {
            return number
        }
        
        return nil
    }
}
