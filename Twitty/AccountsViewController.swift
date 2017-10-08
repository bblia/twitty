//
//  AccountsViewController.swift
//  Twitty
//
//  Created by Lia Zadoyan on 10/3/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, HalfModalPresentable, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var accountsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountsTableView.delegate = self
        accountsTableView.dataSource = self
        accountsTableView.rowHeight = UITableViewAutomaticDimension
        accountsTableView.estimatedRowHeight = 140

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
        cell.selectionStyle = .none
        
        if (indexPath.row == 0) {
            cell.accountName.text = User.currentUser?.name
            cell.accountName.textColor = UIColor.black
            cell.accountScreenname.text = ("@\(User.currentUser!.screenname!)")
            cell.accountImage.setImageWith((User.currentUser?.profileUrl!)!)
            cell.accountImage.layer.cornerRadius = 22
            cell.accountImage.layer.borderWidth = 1.0
            cell.accountImage.layer.masksToBounds = false
            cell.accountImage.layer.borderColor = UIColor.white.cgColor
            cell.accountImage.clipsToBounds = true
            cell.accountSelectedCheckmark.isHidden = false
        } else {
            cell.accountName.text = "Add Account"
            cell.accountName.textColor = UIColor.blue
            cell.accountScreenname.text = ""
            cell.accountSelectedCheckmark.isHidden = true
        }

        return cell
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func maximizeButtonTapped(sender: AnyObject) {
        maximizeToFullScreen()
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        
        dismiss(animated: true, completion: nil)
    }

}
