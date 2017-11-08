//
//  SmartCallingManager.swift
//  SmartCalling
//
//  Created by Jonathan Ellis on 26/07/2016.
//  Copyright © 2016 SmartCalling. All rights reserved.
//

import Foundation

class SmartCallingManager {
    
    var apiKey: String!
    var deviceToken: String?
    
    var userId: String {
        if let userId = UserDefaults.standard.string(forKey: "sc_user_id") {
            return userId
        }
        
        let userId = randomStringWithLength(20)
        UserDefaults.standard.set(userId, forKey: "sc_user_id")
        UserDefaults.standard.synchronize()
        return userId
    }
    
    var userSecret: String {
        if let userSecret = UserDefaults.standard.string(forKey: "sc_user_secret") {
            return userSecret
        }
        
        let userSecret = randomStringWithLength(40)
        UserDefaults.standard.set(userSecret, forKey: "sc_user_secret")
        UserDefaults.standard.synchronize()
        return userSecret
    }
    
    fileprivate init() { }
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    
    func randomStringWithLength(_ length : Int) -> String {
        
        let letters : NSString = "0123456789abcdefghijklmnopqrstuvwxyz"
        
        let randomString : NSMutableString = NSMutableString(capacity: length)
        
        for _ in (0 ..< length){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
}
