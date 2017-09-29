//
//  TweetCell.swift
//  Twitty
//
//  Created by Lia Zadoyan on 9/25/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UITextView!
    @IBOutlet weak var screenameLabel: UILabel!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var retweetedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.cornerRadius = 22
        thumbImageView.layer.borderWidth = 1.0
        thumbImageView.layer.masksToBounds = false
        thumbImageView.layer.borderColor = UIColor.white.cgColor
        thumbImageView.clipsToBounds = true

        let padding = tweetLabel.textContainer.lineFragmentPadding
        tweetLabel.textContainerInset = UIEdgeInsetsMake(0, -padding, 0, -padding)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var tweet: Tweet! {
        didSet {
            tweetNameLabel.text = tweet.user!.name
            tweetLabel.text = tweet.text
            timestampLabel.text = tweet.timestamp
            screenameLabel.text = "@\(tweet.user!.screenname!)"
            
            if let imageURL = tweet.user!.profileUrl {
                thumbImageView.setImageWith(imageURL)
            }
            
            if let retweetedStatus = tweet.retweetedStatus {
                retweetedLabel.isHidden = false
                retweetedImage.isHidden = false
                retweetedLabel.text = tweet.user!.name! + " retweeted"
                let user = retweetedStatus["user"] as! NSDictionary
                
                tweetNameLabel.text = user["name"] as? String
                tweetLabel.text = retweetedStatus["text"] as! String
                screenameLabel.text = "@\(user["screen_name"]!)"
                thumbImageView.setImageWith(URL(string: user["profile_image_url_https"] as! String)!)
            } else {
                retweetedLabel.isHidden = true
                retweetedImage.isHidden = true
            }
        }
    }

}
