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
    @IBOutlet weak var tweetLabel: UITextView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var verifiedBadge: UIImageView!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetedImage: UIImageView!
    @IBOutlet weak var retweetedNameLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = tweet.user?.name
        screennameLabel.text = ("@\((tweet.user?.screenname)!)")
        tweetLabel.text = tweet.text
        timestampLabel.text = tweet.longTimestamp
        retweetsLabel.text = tweet.retweetCount.description
        favoritesLabel.text = tweet.favoritesCount.description

        profileImageView.setImageWith((tweet.user?.profileUrl)!)
        profileImageView.layer.cornerRadius = 22
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.clipsToBounds = true
        
        if let retweetedStatus = tweet.retweetedStatus {
            retweetedNameLabel.isHidden = false
            retweetedImage.isHidden = false
            topConstraint.constant = 5
            retweetedNameLabel.text = tweet.user!.name! + " retweeted"
            let user = retweetedStatus["user"] as! NSDictionary
            
            nameLabel.text = user["name"] as? String
            tweetLabel.text = retweetedStatus["text"] as! String
            screennameLabel.text = "@\(user["screen_name"]!)"
            profileImageView.setImageWith(URL(string: user["profile_image_url_https"] as! String)!)
        } else {
            retweetedNameLabel.isHidden = true
            retweetedImage.isHidden = true
            topConstraint.constant = -10
        }
        
        if (tweet.retweeted) {
            let btnImage = UIImage(named: "retweet_filled")
            retweetButton.setImage(btnImage, for: UIControlState.normal)
        } else {
            let btnImage = UIImage(named: "retweet")
            retweetButton.setImage(btnImage, for: UIControlState.normal)
        }
        
        if (tweet.favorited) {
            let btnImage = UIImage(named: "like_filled")
            self.likeButton.setImage(btnImage, for: UIControlState.normal)
            
        } else {
            let btnImage = UIImage(named: "like")
            self.likeButton.setImage(btnImage, for: UIControlState.normal)
        }
        
        if let verified = tweet.user?.verified {
            verifiedBadge.isHidden = !verified
        }
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
                self.tweet.retweeted = false
                self.retweetsLabel.text = self.tweet.retweetCount.description
                let btnImage = UIImage(named: "retweet")
                self.retweetButton.setImage(btnImage, for: UIControlState.normal)

            }) { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            }
        } else {
            TwitterClient.sharedInstance.retweet(tweet: tweet, success: { (tweet: Tweet!) in
                self.tweet = tweet
                self.tweet.retweetCount = tweet.retweetCount
                self.retweetsLabel.text = self.tweet.retweetCount.description
                let btnImage = UIImage(named: "retweet_filled")
                self.retweetButton.setImage(btnImage, for: UIControlState.normal)
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
                let btnImage = UIImage(named: "like")
                self.likeButton.setImage(btnImage, for: UIControlState.normal)

            }) { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            }
        } else {
            TwitterClient.sharedInstance.favoriteTweet(tweet: tweet, success: { (tweet: Tweet!) in
                self.tweet = tweet
                self.favoritesLabel.text = self.tweet.favoritesCount.description
                let btnImage = UIImage(named: "like_filled")
                self.likeButton.setImage(btnImage, for: UIControlState.normal)

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
