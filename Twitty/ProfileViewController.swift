//
//  ProfileViewController.swift
//  Twitty
//
//  Created by Lia Zadoyan on 10/3/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class ProfileViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tweetsTableView: UITableView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerNameLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var tweetsCount: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    
    var user: User! = User.currentUser
    var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        profileImage.setImageWith(user.profileUrl!)
        nameLabel.text = user.name
        screennameLabel.text = user.screenname
        headerNameLabel.text = user.name
        followersCount.text = user.followersCount?.description
        followingCount.text = user.followingCount?.description
        tweetsCount.text = user.tweetsCount?.description
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 140
        
        profileImage.layer.cornerRadius = 25.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 3.0
        
        TwitterClient.sharedInstance.userTimeline(username: user.screenname!, success: {(tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            //refreshControl.endRefreshing()
            
        }, failure: { (error: Error) ->() in
            print(error.localizedDescription)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (headerImageView != nil) {
            headerImageView.removeFromSuperview()
        }
        if (headerBlurImageView != nil) {
            headerBlurImageView.removeFromSuperview()
        }
        
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.setImageWith(user.profileBackgroundUrl!)
        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerNameLabel)
        
        header.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTweetCell", for: indexPath) as! TweetCell
        cell.selectionStyle = .none
        let tweet = tweets?[indexPath.row]
        if tweet != nil {
            cell.tweet = tweets?[indexPath.row]
        }
        return cell
    }
    
    func addBlurEffect(image: UIImageView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = image.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        image.addSubview(blurEffectView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
           
            if (headerBlurImageView != nil) {
                headerBlurImageView.removeFromSuperview()
            }
            headerBlurImageView = UIImageView(frame: header.bounds)
            headerBlurImageView?.alpha = min (1.0, -(offset / (header.frame.height / 2)))
            headerBlurImageView?.setImageWith(user.profileBackgroundUrl!)
            addBlurEffect(image: headerBlurImageView)
            header.insertSubview(headerBlurImageView, belowSubview: headerNameLabel)
        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerNameLabel.layer.transform = labelTransform
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / profileImage.bounds.height / 1.8 // Slow down the animation
            let avatarSizeVariation = ((profileImage.bounds.height * (1.0 + avatarScaleFactor)) - profileImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                if profileImage.layer.zPosition < header.layer.zPosition{
                    if (headerImageView != nil) {
                        headerImageView.removeFromSuperview()
                    }
                    headerImageView = UIImageView(frame: header.bounds)
                    headerImageView?.setImageWith(user.profileBackgroundUrl!)
                    headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
                    header.insertSubview(headerImageView, belowSubview: headerNameLabel)
                    header.layer.zPosition = 0
                }
            } else {
                if profileImage.layer.zPosition >= header.layer.zPosition{
                    if (headerBlurImageView != nil) {
                        headerBlurImageView.removeFromSuperview()
                    }
                    headerBlurImageView = UIImageView(frame: header.bounds)
                    headerBlurImageView?.setImageWith(user.profileBackgroundUrl!)
                    addBlurEffect(image: headerBlurImageView)
                    header.insertSubview(headerBlurImageView, belowSubview: headerNameLabel)
                    header.layer.zPosition = 2
                    print(headerBlurImageView!.alpha.description)
                }
            }
        }
        
        header.layer.transform = headerTransform
        profileImage.layer.transform = avatarTransform
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
