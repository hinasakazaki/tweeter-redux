//
//  TweetsViewController.swift
//  tweeter
//
//  Created by Hina Sakazaki on 10/3/15.
//  Copyright © 2015 Hina Sakazaki. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetViewCellDelegate {
    var tweets : [Tweet]?
    var refreshControl:UIRefreshControl!
    
    var thisTweetToProfile : User?
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()

        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 400
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        TwitterClient.sharedInstance.homeTimelineWithCompletionWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logOut()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tweets != nil) {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetViewCell", forIndexPath: indexPath) as! TweetViewCell
        cell.tweet = tweets![indexPath.row]
        cell.menuView = self.menuView
        cell.delegate = self
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TweetDetailSegue" {
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            if let tweet = self.tweets?[indexPath!.row] {
                tweetDetailViewController.tweet = tweet
            } else {
                //handle the case of 'self.objects' being 'nil'
            }
        } else if segue.identifier == "ReplySegue" {
            let postViewController = segue.destinationViewController as! PostViewController
            let indexPath = tableView.indexPathForCell((sender?.superview)?.superview as! UITableViewCell)
            if let tweet = self.tweets?[indexPath!.row] {
                postViewController.replyToTweet = tweet
            } else {
                //nothing
            }
        } else if segue.identifier == "TweetToProfileSegue" {
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = thisTweetToProfile
            NSLog("SJDFLKJSDLKF")
            
        }
    }
    
    @objc func tapOnImage(tweetViewCell: TweetViewCell) {
        thisTweetToProfile = tweetViewCell.tweet.author
        performSegueWithIdentifier("TweetToProfileSegue", sender: nil)
    }
    
    @IBAction func goToProfile(sender: AnyObject) {
        thisTweetToProfile = User.currentUser
        performSegueWithIdentifier("TweetToProfileSegue", sender: nil)
    }

    @IBAction func goToHomeTimeLine(sender: AnyObject) {
    }
   
    @IBAction func goToMentions(sender: AnyObject) {
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
