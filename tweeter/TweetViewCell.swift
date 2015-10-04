//
//  TweetViewCell.swift
//  tweeter
//
//  Created by Hina Sakazaki on 10/3/15.
//  Copyright © 2015 Hina Sakazaki. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {

    @IBOutlet weak var faveCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var authorScreenName: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var replyIcon: UIButton!
    @IBOutlet weak var retweetIcon: UIButton!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var faveIcon: UIButton!
    @IBOutlet weak var tweetTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var tweet : Tweet! {
        didSet{
            tweetText.text = tweet.text
            authorScreenName.text = "@\(tweet.author!.screenName!)"
            
            if (tweet.retweetCount != nil && tweet.retweetCount > 0) {
                retweetCount.text = "\(tweet.retweetCount!)"
            }
            if (tweet.retweetCount != nil && tweet.faveCount > 0){
                faveCount.text = "\(tweet.faveCount!)"
            }
            tweetTime.text = formatTimeElapsed(tweet.createdAt!)
            authorName.text = tweet.author?.name
            tweetImageView.setImageWithURL(NSURL(string: (tweet.author?.profileImageURL)!))
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatTimeElapsed(sinceDate: NSDate) -> String {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        formatter.collapsesLargestUnit = true
        formatter.maximumUnitCount = 1
        let interval = NSDate().timeIntervalSinceDate(sinceDate)
        return formatter.stringFromTimeInterval(interval)!
    }

    @IBAction func onLike(sender: AnyObject) {
        faveIcon.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        let paramDictionary : NSDictionary = ["id": "\(tweet.tweetId!)"]
        TwitterClient.sharedInstance.likePostWithParams(paramDictionary) {(tweet, error) -> () in
            print(tweet)
        }

    }
    @IBAction func onFave(sender: AnyObject) {
    }
    @IBAction func onRetweet(sender: AnyObject){
        retweetIcon.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        let paramDictionary : NSDictionary = ["id": "\(tweet.tweetId!)"] //doesnt quite work
        TwitterClient.sharedInstance.retweetPostWithParams(paramDictionary) {(tweet, error) -> () in
            print(tweet)
        }
    }
}
