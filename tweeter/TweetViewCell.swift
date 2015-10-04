//
//  TweetViewCell.swift
//  tweeter
//
//  Created by Hina Sakazaki on 10/3/15.
//  Copyright © 2015 Hina Sakazaki. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {

    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var tweet : Tweet! {
        didSet{
            tweetText.text = tweet.text
//            if (tweet.createdAt?.timeIntervalSinceNow < )
//            tweetTime.text = tweet.
            authorName.text = tweet.author?.name
            tweetImageView.setImageWithURL(NSURL(string: (tweet.author?.profileImageURL)!))
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
