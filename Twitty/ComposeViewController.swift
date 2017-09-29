//
//  ComposeViewController.swift
//  Twitty
//
//  Created by Lia Zadoyan on 9/26/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

@objc protocol ComposeViewControllerDelegate {
    @objc func composeViewController(composeViewController: ComposeViewController,
                                     tweet: Tweet)
}
class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    var user = User.currentUser!
    var replyTo: Tweet?
    var delegate: ComposeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = user.name
        screennameLabel.text = ("@\(user.screenname!)")
        profileImage.setImageWith(user.profileUrl!)
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
        if let replyTo = replyTo {
            tweetTextView.text = "@\((replyTo.user!.screenname!))"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    

    func textViewDidChange(_ textView: UITextView) {
        let numberOfChars = textView.text.characters.count
        charCountLabel.text = (140 - numberOfChars).description
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onTweetButton(_ sender: Any) {
        
        let replyToId: IntMax?
        if (replyTo == nil) {
            replyToId = nil;
        } else {
            replyToId = replyTo?.id
        }
        
        TwitterClient.sharedInstance.composeTweet(tweetTextView.text, replyStatusId: replyToId as IntMax?, success: { (tweet: Tweet) in
            self.dismiss(animated: true, completion: nil)
            self.delegate?.composeViewController(composeViewController: self, tweet: tweet)
        }) { (error: Error!) in
            print("Error: \(error.localizedDescription)")
        }
    }
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
