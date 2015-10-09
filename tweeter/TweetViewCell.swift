//
//  TweetViewCell.swift
//  tweeter
//
//  Created by Hina Sakazaki on 10/3/15.
//  Copyright © 2015 Hina Sakazaki. All rights reserved.
//

import UIKit

@objc protocol TweetViewCellDelegate {
    optional func tapOnImage(tweetViewCell: TweetViewCell)
}

class TweetViewCell: UITableViewCell {
    
    weak var delegate: TweetViewCellDelegate?
    
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

    var menuOriginalCenter : CGPoint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // add a pan recognizer
        var recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
        tweetImageView.addGestureRecognizer(tapGesture)
        tweetImageView.userInteractionEnabled = true
        
    }
    
    var menuView : UIView! {
        didSet {
            menuOriginalCenter = menuView.center

        }
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
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
        }
        if recognizer.state == .Changed {
            if (recognizer.velocityInView(menuView).x > 0) {
                //move right
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.menuView.center = CGPoint(x : 67, y:  self.menuOriginalCenter.y) //this is bullshit
                    }, completion: nil)
                
            } else {
                //move left
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.menuView.center = CGPoint(x : self.menuOriginalCenter.x, y: self.menuOriginalCenter.y) //this makes sense because we are setting original center to original center
                    }, completion: nil)
        }
        if recognizer.state == .Ended {
            }
        }
    }

    func imageTapped(gesture: UITapGestureRecognizer) {
        if (delegate != nil) {
            delegate?.tapOnImage!(self)
        }
    }
}