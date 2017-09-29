//
//  Tweet.swift
//  Twitty
//
//  Created by Lia Zadoyan on 9/25/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String? = ""
    var timestamp: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    var id: IntMax?
    var favorited: Bool
    var retweeted: Bool
    var retweetedStatus: NSDictionary?

    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        self.id = dictionary["id"] as? IntMax
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        favorited = dictionary["favorited"] as! Bool
        retweeted = dictionary["retweeted"] as! Bool
        retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        let timeStampString = dictionary["created_at"] as? String

        if let timestampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d H:mm:ss Z y"
            let timestampDate = formatter.date(from: timestampString)
            let dateFormatter = DateFormatter()
            self.timestamp = dateFormatter.timeSince(from: timestampDate! as NSDate, numericDates: true)  // Just now
        }
        
        if let user = dictionary["user"] as? NSDictionary {
            self.user = User(dictionary: user)
        }
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }

}

