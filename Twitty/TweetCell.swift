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
    @IBOutlet weak var tweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.clipsToBounds = true
        thumbImageView.layer.cornerRadius = 10
        
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var tweet: Tweet! {
        didSet {
            tweetNameLabel.text = tweet.user!.name
            tweetLabel.text = tweet.text
            timestampLabel.text = tweet.timestamp?.description
            
            if let imageURL = tweet.user!.profileUrl {
                thumbImageView.setImageWith(imageURL)
            }
        }
    }

}
