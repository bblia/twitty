//
//  TwitterClient.swift
//  Twitty
//
//  Created by Lia Zadoyan on 9/25/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")! as URL!, consumerKey:"a6bpAUlv93CcFbQo8LgkaWUS9", consumerSecret: "hWmehAVZV5ymIRBXy7tmTPPTRv11hyap7HZaUbNhjdBxEwAfNS")!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        var token = ""
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            token = requestToken.token
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")
            UIApplication.shared.open(url!)
        }, failure: { (error: Error!) -> Void in
            self.loginFailure?(error)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in

            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        }, failure: { (error: Error!) -> Void in
            self.loginFailure?(error)
        })

    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })

    }
    
    func composeTweet(_ status: String, replyStatusId: AnyObject?, success: @escaping (Tweet) -> (), failure: @escaping (Error?) -> ()) {
        var parameters = ["status": status as AnyObject]
        if let replyStatusId = replyStatusId {
            parameters["in_reply_to_status_id"] = replyStatusId as AnyObject
        }
        post("/1.1/statuses/update.json",
            parameters: parameters,
            progress: nil,
            success: { (task, response) in
                let tweetDict = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetDict)
                success(tweet)
            }, failure: { (task, error) in
                failure(error)
            })
    }
    
    func favoriteTweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error?) -> ()) {
        let tweetId = tweet.id!
        print(tweetId)
        post("/1.1/favorites/create.json",
            parameters: [
                "id": tweetId as AnyObject
            ],
            progress: nil,
            success: { (task, response) in
                let tweetDict = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetDict)
                success(tweet)
        },  failure: { (task, error) in
            failure(error)
        })
    }
    
    func unfavoriteTweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error?) -> ()) {
        let tweetId = tweet.id!
        print(tweetId)
        post("/1.1/favorites/destroy.json",
             parameters: [
                "id": tweetId as AnyObject
            ],
             progress: nil,
             success: { (task, response) in
                let tweetDict = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetDict)
                success(tweet)
        },  failure: { (task, error) in
            failure(error)
        })
    }
    
    func retweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error?) -> ()) {
        let tweetId = tweet.id!
        print(tweetId)
        post("/1.1/statuses/retweet/\(tweet.id!).json",
            parameters: nil,
            progress: nil,
            success: { (task, response) in
                let tweetDict = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetDict)
                success(tweet)
        },  failure: { (task, error) in
            failure(error)
        })
    }
    
    func unretweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error?) -> ()) {
        let tweetId = tweet.id!
        print(tweetId)
        post("/1.1/statuses/unretweet/\(tweet.id!).json",
            parameters: nil,
            progress: nil,
            success: { (task, response) in
                let tweetDict = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetDict)
                success(tweet)
        },  failure: { (task, error) in
            failure(error)
        })
    }

}
