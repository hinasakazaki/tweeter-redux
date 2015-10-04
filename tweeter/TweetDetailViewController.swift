//
//  TweetDetailViewController.swift
//  tweeter
//
//  Created by Hina Sakazaki on 10/3/15.
//  Copyright © 2015 Hina Sakazaki. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    @IBOutlet weak var retweetcount: UILabel!
    @IBOutlet weak var faveCount: UILabel!
    @IBOutlet weak var tweetCreated: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var authorScreenName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (tweet.retweetCount != nil && tweet.retweetCount > 0) {
            self.retweetcount.text = "\(tweet.retweetCount!)"
        }
        if (tweet.retweetCount != nil && tweet.faveCount > 0){
            self.faveCount.text = "\(tweet.faveCount)"
        }
        self.userImageView.setImageWithURL(NSURL(string: (tweet.author?.profileImageURL)!))
        self.tweetCreated.text = tweet.createdAtString
        self.authorScreenName.text = tweet.author?.screenName
        self.authorName.text = tweet.author?.name
        self.tweetText.text = "@\(tweet.text)"

        // Do any additional setup after loading the view.
    }
    
    var tweet : Tweet! {
        didSet{
//            print(tweet)
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
