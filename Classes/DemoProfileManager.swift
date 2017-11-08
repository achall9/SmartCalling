//
//  DemoProfileManager.swift
//  SmartCalling
//
//  Created by Dominic Thomas on 13/07/2017.
//  Copyright © 2017 SmartCalling. All rights reserved.
//

import Foundation
import UIKit

class DemoProfileManager {
    
    static let sharedInstance = DemoProfileManager()
    
    private init() {}
    
    func load(_ addressBookManager: AddressBookManager) {
        addressBookManager.deleteAllProfiles()
        
        // Add local profiles! - TODO: Move to SmartCallingManager in SDK!
        let profile1 = Profile()
        profile1.phoneNumbers = ["+447741311183"]
        profile1.metadata = [Profile.KEY_CALL_DESCRIPTION: "Ashley Unitt"]
        profile1.image = UIImage(named: "nvw_ashley")
        addressBookManager.addProfile(profile1) // TODO: Move to SmartCallingManager    
    }
    
}
