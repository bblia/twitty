//
//  TweetsViewController.swift
//  Twitty
//
//  Created by Lia Zadoyan on 9/25/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class LikesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TweetCellDelegate, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    
    var isMoreDataLoading = false
    var user: User! = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.selectionStyle = .none
        cell.tweet = tweets![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? DetailsViewController {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            vc.tweet = tweets![indexPath!.row]
        }
    }
    
    func fetchData() {
        TwitterClient.sharedInstance.likesTimeline(username: user.screenname, success: {(tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) ->() in
            print(error.localizedDescription)
        })
    }
    
    func replyCallback(tweetCell: TweetCell, tweet: Tweet) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyBoard.instantiateViewController(withIdentifier: "ComposeViewController") as! UINavigationController
        let composeVc = navController.viewControllers.first as! ComposeViewController
        composeVc.replyTo = tweet
        self.present(navController, animated: true, completion: nil)
    }
    
    func retweetCallback(tweetCell: TweetCell, tweet: Tweet) {
        let indexPath = tableView.indexPath(for: tweetCell)!
        tweets[indexPath.row] = tweet
    }
    
    func likeCallback(tweetCell: TweetCell, tweet: Tweet) {
        let indexPath = tableView.indexPath(for: tweetCell)!
        tweets[indexPath.row] = tweet
    }
    
    func imageTapCallback(tweetCell: TweetCell, tweet: Tweet) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyBoard.instantiateViewController(withIdentifier: "ProfileNavigationController") as! ProfileViewController
        navController.user = tweet.user
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.isTranslucent = true
        show(navController, sender: self)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Likes")
    }
    
}
