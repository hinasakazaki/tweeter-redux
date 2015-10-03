//
//  TwitterClient.swift
//  tweeter
//
//  Created by Hina Sakazaki on 10/3/15.
//  Copyright © 2015 Hina Sakazaki. All rights reserved.
//

import UIKit
let twitterBaseURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?)-> ())?
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        //fetch request token & redirect to authorizaiton page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweeeeeeeeeeeeeeter://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("yay")
            var authURL = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)"
            UIApplication.sharedApplication().openURL(NSURL(string: authURL)!)
            }, failure: { (error: NSError!) -> Void in
                print("Fail : \(error)")
                self.loginCompletion?(user:nil, error: error)
        })
        
    }
    
    func openURL(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Access token \(accessToken)")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters:nil, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
                print("user: \(user.name)")
                }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    print(error)
                    self.loginCompletion?(user:nil, error: error)
            })
           
            
           
            
            }) { (error:NSError!) -> Void in
                print("Failed to receive access token")
                self.loginCompletion?(user:nil, error: error)
        }

    }
    
    func homeTimelineWithCompletionWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters:params, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            for tweet in tweets {
                print("text: \(tweet.text), createdAt: \(tweet.createdAt)")
            }
            completion(tweets: tweets, error:nil)
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error)
                completion(tweets: nil, error:error)
        })
    }

}
