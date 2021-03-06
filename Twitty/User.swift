//
//  User.swift
//  Twitty
//
//  Created by Lia Zadoyan on 9/25/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenname: String!
    var profileUrl: URL?
    var tagline: String?
    var verified: Bool
    var followersCount: Int?
    var followingCount: Int?
    var profileBackgroundUrl: URL?
    var tweetsCount: Int?
    
    var dictionary: NSDictionary
    static let userDidLogoutNotification = "UserDidLogout"

    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as! String
        verified = dictionary["verified"] as! Bool
        followersCount = dictionary["followers_count"] as? Int ?? 0
        followingCount = dictionary["friends_count"] as? Int ?? 0
        tweetsCount = dictionary["statuses_count"] as? Int ?? 0
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        let profileBackgroundUrlString = dictionary["profile_banner_url"] as? String
        if let profileBackgroundUrlString = profileBackgroundUrlString {
            profileBackgroundUrl = URL(string: profileBackgroundUrlString)
        }
        tagline = dictionary["description"] as? String

    }
    
    static var _currentUser: User?

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                if let userData = UserDefaults.standard.object(forKey: "currentUserData")  as? Data {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    let user = User(dictionary: dictionary)
                    _currentUser = user
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user {
                let userJson = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(userJson, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }

}
