//
//  MenuViewController.swift
//  Twitty
//
//  Created by Lia Zadoyan on 10/3/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MenuViewController: UIViewController{

    private var profileViewController: UIViewController!
    private var mentionsViewController: UIViewController!
    private var timelineViewController: UIViewController!
    private var accountsViewController: UIViewController!
    
    @IBOutlet weak var profileThumbView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        timelineViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        accountsViewController = storyboard.instantiateViewController(withIdentifier: "AccountsNavigationController")
        
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        viewControllers.append(timelineViewController)
        viewControllers.append(accountsViewController)
        
        hamburgerViewController.contentViewController = viewControllers[2]
        
        
        nameLabel.text = User.currentUser?.name
        screennameLabel.text = ("@\(User.currentUser!.screenname!)")
        followingCount.text = User.currentUser?.followingCount?.description
        followersCount.text = User.currentUser?.followersCount?.description
        
        profileThumbView.layer.cornerRadius = 22
        profileThumbView.layer.borderWidth = 1.0
        profileThumbView.layer.masksToBounds = false
        profileThumbView.layer.borderColor = UIColor.white.cgColor
        profileThumbView.clipsToBounds = true
        profileThumbView.setImageWith((User.currentUser?.profileUrl)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onProfileSelected(_ sender: Any) {
        hamburgerViewController.contentViewController = viewControllers[0]
    }
    
    
    @IBAction func onTimelineSelected(_ sender: Any) {
        hamburgerViewController.contentViewController = viewControllers[2]

    }
    
    @IBAction func onMentionsSelected(_ sender: Any) {
        hamburgerViewController.contentViewController = viewControllers[1]

    }
    
    
    @IBAction func onAccountsSelected(_ sender: Any) {
        hamburgerViewController.contentViewController = viewControllers[3]
    }

    @IBAction func onSignOutSelected(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
}
