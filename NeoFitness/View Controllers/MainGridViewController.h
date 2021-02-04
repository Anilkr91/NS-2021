//
//  MainGridViewController.h
//  mNivesh-2
//
//  Created by MOHD RAHIB on 17/03/15.
//  Copyright (c) 2015 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import <MessageUI/MessageUI.h>

@interface MainGridViewController : UIViewController <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *userType;

@end
//(
//{
//    Change = "-45";
//    ChangePer = "-0.52";
//    CurrentVal = "8590.65";
//    IndexName = "NIFTY 50";
//    PrevClose = "8635.65";
//    recordDateTime = "2016-07-26 15:32:09";
//},
//{
//    Change = "-118.82";
//    ChangePer = "-0.42";
//    CurrentVal = "27976.52";
//    IndexName = "S&P BSE SENSEX";
//    PrevClose = "28095.34";
//    recordDateTime = "2016-07-26 15:59:00";
//}
// )
