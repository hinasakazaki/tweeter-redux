//
//  PostViewController.swift
//  tweeter
//
//  Created by Hina Sakazaki on 10/3/15.
//  Copyright © 2015 Hina Sakazaki. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var tweetEdit: UITextView!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = User.currentUser?.name
        userImageView.setImageWithURL(NSURL(string : (User.currentUser?.profileImageURL)!))
        userScreenName.text = User.currentUser?.screenName
        if (replyToTweet != nil) {
            tweetEdit.text = "@\(replyToTweet!.author!.screenName!)"
        }
        // Do any additional setup after loading the view.
    }
    
    var replyToTweet : Tweet! {
        didSet {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPost(sender: AnyObject) {
        if replyToTweet != nil {
            var pDictionary : Dictionary = ["status" : tweetEdit.text, "in_reply_to_status_id" : "\(replyToTweet.tweetId!)"]
            //,let paramDictionary : Dictionary = ["status" : tweetEdit.text, "in_reply_to_status_id" : replyToTweet?.tweetId]
            TwitterClient.sharedInstance.writePostWithParams(pDictionary as NSDictionary) { (tweet, error) -> () in
                if (tweet != nil) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
        else if (tweetEdit.text != nil){
            print(tweetEdit.text)
            let paramDictionary: NSDictionary = ["status": tweetEdit.text]
            TwitterClient.sharedInstance.writePostWithParams(paramDictionary) { (tweet, error) -> () in
                if (tweet != nil) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        };
    }

    @IBAction func onCancelPost(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
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
