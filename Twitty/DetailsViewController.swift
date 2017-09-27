//
//  DetailsViewController.swift
//  Twitty
//
//  Created by Lia Zadoyan on 9/26/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.setImageWith((tweet.user?.profileUrl)!)
        nameLabel.text = tweet.user?.name
        screennameLabel.text = tweet.user?.screenname
        tweetLabel.text = tweet.text
        timestampLabel.text = tweet.timestamp
        retweetsLabel.text = tweet.retweetCount.description
        favoritesLabel.text = tweet.favoritesCount.description
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReplyButton(_ sender: Any) {
  
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        if tweet.retweeted {
            TwitterClient.sharedInstance.unretweet(tweet: tweet, success: { (tweet: Tweet!) in
                self.tweet = tweet
                self.tweet.retweetCount -= 1
                self.retweetsLabel.text = self.tweet.retweetCount.description
            }) { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            }
        } else {
            TwitterClient.sharedInstance.retweet(tweet: tweet, success: { (tweet: Tweet!) in
                self.tweet = tweet
                self.retweetsLabel.text = self.tweet.retweetCount.description
            }) { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        if tweet.favorited {
            TwitterClient.sharedInstance.unfavoriteTweet(tweet: tweet, success: { (tweet: Tweet!) in
                self.tweet = tweet
                self.favoritesLabel.text = self.tweet.favoritesCount.description
            }) { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            }
        } else {
            TwitterClient.sharedInstance.favoriteTweet(tweet: tweet, success: { (tweet: Tweet!) in
                self.tweet = tweet
                self.favoritesLabel.text = self.tweet.favoritesCount.description
            }) { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navVC = segue.destination as? UINavigationController
        let composeVc = navVC?.viewControllers.first as! ComposeViewController
        composeVc.replyTo = self.tweet
    }
    

}
