//
//  TweetCell.swift
//  Twitty
//
//  Created by Lia Zadoyan on 9/25/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    @objc func replyCallback(tweetCell: TweetCell, tweet: Tweet)
    @objc func likeCallback(tweetCell: TweetCell, tweet: Tweet)
    @objc func retweetCallback(tweetCell: TweetCell, tweet: Tweet)
    @objc func imageTapCallback(tweetCell: TweetCell, tweet: Tweet)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UITextView!
    @IBOutlet weak var screenameLabel: UILabel!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var retweetedImage: UIImageView!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var verifiedConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    weak var delegate: TweetCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.cornerRadius = 22
        thumbImageView.layer.borderWidth = 1.0
       
        
        thumbImageView.layer.masksToBounds = false
        thumbImageView.layer.borderColor = UIColor.white.cgColor
        thumbImageView.clipsToBounds = true

        let padding = tweetLabel.textContainer.lineFragmentPadding
        tweetLabel.textContainerInset = UIEdgeInsetsMake(0, -padding, 0, -padding)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TweetCell.onTappedImage))
        thumbImageView.addGestureRecognizer(tap)
        thumbImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var tweet: Tweet! {
        didSet {
            tweetNameLabel.text = tweet.user!.name
            tweetLabel.text = tweet.text
            timestampLabel.text = tweet.timestamp
            screenameLabel.text = "@\(tweet.user!.screenname!)"
            retweetsCountLabel.text = formatPoints(from: tweet.retweetCount)
            likesCountLabel.text = formatPoints(from: tweet.favoritesCount)
            
            if let imageURL = tweet.user!.profileUrl {
                thumbImageView.setImageWith(imageURL)
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
            verifiedImage.isHidden = !(tweet.user!.verified)
            verifiedConstraint.constant = verifiedImage.isHidden ? -12 : 2
            
            if let retweetedStatus = tweet.retweetedStatus {
                retweetedLabel.isHidden = false
                retweetedImage.isHidden = false
                topConstraint.constant = 5
                retweetedLabel.text = tweet.user!.name! + " retweeted"
                let user = retweetedStatus["user"] as! NSDictionary
                
                tweetNameLabel.text = user["name"] as? String
                tweetLabel.text = retweetedStatus["text"] as! String
                screenameLabel.text = "@\(user["screen_name"]!)"
                thumbImageView.setImageWith(URL(string: user["profile_image_url_https"] as! String)!)
            } else {
                retweetedLabel.isHidden = true
                retweetedImage.isHidden = true
                topConstraint.constant = -10
            }
        }
    }
    
    func onTappedImage() {
        delegate?.imageTapCallback(tweetCell: self, tweet: self.tweet)
    }
    
    
    @IBAction func onReplyButton(_ sender: Any) {
        delegate?.replyCallback(tweetCell: self, tweet: self.tweet)
    }

    @IBAction func onRetweetButton(_ sender: Any) {
        if tweet.retweeted {
            TwitterClient.sharedInstance.unretweet(tweet: tweet, success: { (tweet: Tweet!) in
               // self.tweet = tweet
                self.tweet.retweetCount -= 1
                self.tweet.retweeted = false
                self.retweetsCountLabel.text = self.tweet.retweetCount.description
                let btnImage = UIImage(named: "retweet")
                self.retweetButton.setImage(btnImage, for: UIControlState.normal)
                
            }) { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            }
        } else {
            TwitterClient.sharedInstance.retweet(tweet: tweet, success: { (tweet: Tweet!) in
                //self.tweet = tweet
                self.tweet.retweetCount = tweet.retweetCount
                self.retweetsCountLabel.text = self.tweet.retweetCount.description
                let btnImage = UIImage(named: "retweet_filled")
                self.retweetButton.setImage(btnImage, for: UIControlState.normal)
            }) { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            }
        }
        delegate?.retweetCallback(tweetCell: self, tweet: tweet)
    }
    
    @IBAction func onLikeButton(_ sender: Any) {
        if tweet.favorited {
            TwitterClient.sharedInstance.unfavoriteTweet(tweet: tweet, success: { (tweet: Tweet!) in
                self.tweet = tweet
                self.likesCountLabel.text = self.tweet.favoritesCount.description
                let btnImage = UIImage(named: "like")
                self.likeButton.setImage(btnImage, for: UIControlState.normal)
                
            }) { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            }
        } else {
            TwitterClient.sharedInstance.favoriteTweet(tweet: tweet, success: { (tweet: Tweet!) in
                self.tweet = tweet
                self.likesCountLabel.text = self.tweet.favoritesCount.description
                let btnImage = UIImage(named: "like_filled")
                self.likeButton.setImage(btnImage, for: UIControlState.normal)
                
            }) { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            }
        }
        delegate?.likeCallback(tweetCell: self, tweet: tweet)
    }
    
    func formatPoints(from: Int) -> String {
        let number = Double(from)
        let thousand = number / 1000
        let million = number / 1000000
        
        if million >= 1.0 { return "\(round(million*10)/10)M" }
        else if thousand >= 1.0 { return "\(round(thousand*10)/10)K" }
        else { return "\(Int(number))"}
    }
    
}
