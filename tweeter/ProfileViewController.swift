//
//  ProfileViewController.swift
//  tweeter
//
//  Created by Hina Sakazaki on 10/8/15.
//  Copyright © 2015 Hina Sakazaki. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (user != nil) {
            numFollowers.text = "\(user.numFollowers!)"
            numFollowing.text = "\(user.numFollowing!)"
            numTweets.text = "\(user.numTweets!)"
            screenNameLabel.text = user.screenName
            nameLabel.text = user.name
            
            profileImageView.setImageWithURL(NSURL(string: user.profileImageURL!))
            bgImageView.setImageWithURL(NSURL(string: user.profileBGImageURL!))
        }

        // Do any additional setup after loading the view.
    }
    
    var user : User! {
        didSet {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
