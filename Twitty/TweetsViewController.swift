//
//  TweetsViewController.swift
//  Twitty
//
//  Created by Lia Zadoyan on 9/25/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    
    var isMoreDataLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchData(refreshControl: refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollViewOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollViewOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                let maxId = tweets[tweets.count - 1].id
                TwitterClient.sharedInstance.homeTimeline(maxId: maxId, success: { (tweets: [Tweet]) in
                    var tweetMinusOne = tweets
                    tweetMinusOne.remove(at: 0)
                    for tweet in tweetMinusOne {
                        self.tweets.append(tweet)
                    }
                    self.tableView.reloadData()
                    self.isMoreDataLoading = false
                }, failure: { (error: Error) in
                    print("Error: \(error.localizedDescription)")
                })
            }
        }
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
        
        if let navVC = segue.destination as? UINavigationController {
            let composeVc = navVC.viewControllers.first as! ComposeViewController
            composeVc.delegate = self
        }

        
    }
    
    func composeViewController(composeViewController: ComposeViewController, tweet: Tweet) {
        self.tweets.insert(tweet, at: 0)
     //   let indexPath = IndexPath(row: 0, section: 0)
        tableView.reloadData()
    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        fetchData(refreshControl: refreshControl)
    }
    
    func fetchData(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline(maxId: nil, success: {(tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            
        }, failure: { (error: Error) ->() in
            print(error.localizedDescription)
        })
    }

}
