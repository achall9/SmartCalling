//
//  Profile.swift
//  SmartCalling
//
//  Created by Jonathan Ellis on 25/07/2016.
//  Copyright © 2016 SmartCalling. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class Profile {
    
    static let KEY_CALL_DESCRIPTION = "call_description";
    static let KEY_CALL_SUBTITLE = "call_subtitle";
    static let KEY_IMAGE_FULLSCREEN_URL = "image_fullscreen_url";
    
    var phoneNumbers: [String]!
    var metadata: [String: String]!
    var image: UIImage?
    
    func getString(_ key: String) -> String? {
        return metadata?[key]
    }

    func loadResources(_ completion: @escaping (Void) -> Void) {
        
        if let imageUrl = getString(Profile.KEY_IMAGE_FULLSCREEN_URL) {
            
            NSLog("Downloading from %@...", imageUrl)
        
            Alamofire.request(imageUrl)
                .responseImage(completionHandler: { response in
                    self.image = response.result.value
                    NSLog("Download complete!")
                    completion()
                })
            
        } else {
            NSLog("No image to download")
            completion()
        }

    }
    
}
