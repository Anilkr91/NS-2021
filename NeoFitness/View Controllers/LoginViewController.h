//
//  LoginViewController.h
//  mNivesh-2
//
//  Created by MOHD RAHIB on 17/03/15.
//  Copyright (c) 2015 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnect.h"
#import "Utility.h"
#import "MBProgressHUD.h"


@interface LoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>{
    MBProgressHUD* _HUD;
}

@property(nonatomic, assign) int cityId;
@property(nonatomic, assign) int packageId;
@property(nonatomic, assign) int amount;
@property(nonatomic, assign) int pkgMinAmount;
@property(nonatomic, assign) int offerAmount;
@property(nonatomic, assign) int branchId;

@end
