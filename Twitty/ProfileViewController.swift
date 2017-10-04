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

class ProfileViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerNameLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: AvatarImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    
    var user: User! = User.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        profileImage.setImageWith(user.profileUrl!)
        nameLabel.text = user.name
        screennameLabel.text = user.screenname
        headerNameLabel.text = user.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Header - Blurred Image
        
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
    
    func addBlurEffect(image: UIImageView)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = image.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        image.addSubview(blurEffectView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerNameLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / profileImage.bounds.height / 1.4 // Slow down the animation
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
                
            }else {
                if profileImage.layer.zPosition >= header.layer.zPosition{
                    if (headerBlurImageView != nil) {
                        headerBlurImageView.removeFromSuperview()
                    }
                    headerBlurImageView = UIImageView(frame: header.bounds)
                    headerBlurImageView?.setImageWith(user.profileBackgroundUrl!)
                    addBlurEffect(image: headerBlurImageView)
                    header.insertSubview(headerBlurImageView, belowSubview: headerNameLabel)
                    header.layer.zPosition = 2
                }
            }
        }
        
        // Apply Transformations
        
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
