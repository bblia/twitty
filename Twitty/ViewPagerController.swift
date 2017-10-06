//
//  ViewPagerController.swift
//  Twitty
//
//  Created by Lia Zadoyan on 10/5/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ViewPagerController: ButtonBarPagerTabStripViewController {
    var user: User = User.currentUser!
    
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = UIColor.white
        // buttonBar minimumInteritemSpacing value, note that button bar extends from UICollectionView
        
        // selected bar view is created programmatically so it's important to set up the following 2 properties properly
        settings.style.selectedBarBackgroundColor = UIColor.black
        settings.style.selectedBarHeight = 5
        
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        // helps to determine the cell width, it represent the space before and after the title label
        settings.style.buttonBarItemTitleColor = UIColor.black
        // in case the barView items do not fill the screen width this property stretch the cells to fill the screen
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarRightContentInset = CGFloat(0)

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let timelineViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        let likesViewController = storyboard.instantiateViewController(withIdentifier: "LikesViewController") as! LikesViewController
        likesViewController.user = self.user
        
        return [timelineViewController, likesViewController]
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
