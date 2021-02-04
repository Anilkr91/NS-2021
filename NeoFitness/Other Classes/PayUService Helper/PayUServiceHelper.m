//
//  PayUServiceHelper.m
//  EimarsMLM
//
//  Created by Vasu Saini on 22/11/17.
//  Copyright © 2017 oodlesTechnologies_Vasu_Saini. All rights reserved.
//

#import "PayUServiceHelper.h"
#import <PlugNPlay/PlugNPlay.h>

@interface PayUServiceHelper()
@property (nonatomic, strong) PayUCompletionBlock completionBlock;
@property (nonatomic, strong) PayUFailuerBlock failuerBlock;
@property (nonatomic, strong) UIViewController *parentController;
@property (nonatomic, strong) NSString *payu_salt;
@end

@implementation PayUServiceHelper

+ (PayUServiceHelper *)sharedManager {
    static PayUServiceHelper *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[PayUServiceHelper alloc] init];
    });
    return _sharedManager;
}

-(void) getPayment:(UIViewController*)controller :(NSString*)email :(NSString*)phone :(NSString*)name :(NSString*)amount :(NSString*)trxnID didComplete:(PayUCompletionBlock)getPaymentBlock didFail:(PayUFailuerBlock)failBlock{
    self.completionBlock = getPaymentBlock;
    self.failuerBlock = failBlock;
    self.parentController = controller;
    [self setParam:email :phone :name :amount :trxnID];
}


- (void)setParam: (NSString*)email : (NSString*)phone : (NSString*)firstName :(NSString*)amount :(NSString*)trxnID  {
    PUMTxnParam *txnParam= [[PUMTxnParam alloc] init];
    
    
#pragma mark Sandbox Crenditials
//    txnParam.environment = PUMEnvironmentTest;
//    txnParam.key = @"fC38x6HU";
//    txnParam.merchantid = @"6821433";
//    self.payu_salt = @"e6zHrnjijY";

#pragma mark Production Crenditials
///    txnParam.environment = PUMEnvironmentTest;
    txnParam.key = @"fC38x6HU";
    txnParam.merchantid = @"6821433";
    self.payu_salt = @"e6zHrnjijY";

    
//#define kMerchantKey @"fC38x6HU"
//#define kMerchantID @"6821433"
//#define kMerchantSalt @"e6zHrnjijY"
//
    txnParam.environment = PUMEnvironmentProduction;
    txnParam.phone = phone;
    txnParam.email = email;
    txnParam.amount = amount;
    txnParam.firstname = firstName;
    txnParam.txnID = trxnID;
    txnParam.surl = @"https://www.payumoney.com/mobileapp/payumoney/success.php";
    txnParam.furl = @"https://www.payumoney.com/mobileapp/payumoney/failure.php";
    txnParam.productInfo = @"Package";
    txnParam.udf1 = @"";
    txnParam.udf2 = @"";
    txnParam.udf3 = @"";
    txnParam.udf4 = @"";
    txnParam.udf5 = @"";
    txnParam.udf6 = @"";
    txnParam.udf7 = @"";
    txnParam.udf8 = @"";
    txnParam.udf9 = @"";
    txnParam.udf10 = @"";
    txnParam.hashValue = [self getHashForPaymentParams:txnParam];
   
    [PlugNPlay setDisableCompletionScreen:NO];
    [PlugNPlay setTopBarColor: [UIColor redColor]];
    [PlugNPlay setButtonColor: [UIColor redColor]];
//    [PlugNPlay setDisableCards:NO];
//    [PlugNPlay setDisableNetbanking:NO];
//    [PlugNPlay setDisableWallet:NO];
    [PlugNPlay disableCompletionScreen];
    [PlugNPlay setMerchantDisplayName:@"NEO FITNESS"];
    
    [PlugNPlay presentPaymentViewControllerWithTxnParams:txnParam onViewController:_parentController withCompletionBlock:^(NSDictionary *paymentResponse, NSError *error, id extraParam) {
        if (!error) {
            NSLog(@" Sucess Response--->>>   %@",paymentResponse);
            self.completionBlock(paymentResponse, error);
        } else {
            NSLog(@" Failuer Response--->>>   %@",paymentResponse);
            NSLog(@" Failuer Error--->>>   %@",error);
//            [UIUtility toastMessageOnScreen:[error localizedDescription]];
            self.failuerBlock(error);
            
        }
        
    }];
}


-(void)logOut{
    if ([PayUMoneyCoreSDK isUserSignedIn]) {
#warning CODE TO BE REMOVED BEFORE GOING LIVE
        [PayUMoneyCoreSDK signOut];
    }
}


-(NSString*)getHashForPaymentParams:(PUMTxnParam*)txnParam {
    NSString *salt = self.payu_salt;
    NSString *hashSequence = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@",txnParam.key,txnParam.txnID,txnParam.amount,txnParam.productInfo,txnParam.firstname,txnParam.email,txnParam.udf1,txnParam.udf2,txnParam.udf3,txnParam.udf4,txnParam.udf5,txnParam.udf6,txnParam.udf7,txnParam.udf8,txnParam.udf9,txnParam.udf10, salt];
    NSString *hash = [[[[[self createSHA512:hashSequence] description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    return hash;
}

- (NSString*) createSHA512:(NSString *)source {
    
    const char *cstr = [source cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:source.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    NSString *hash =  [[[output stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];

    return hash;
}


/*
 //Call this method as follows in swift 4
 
 PayUServiceHelper.sharedManager().getPayment("Controller", "mail@mymail.com", "+91-9896952757", "Name", "Amount 0011", didComplete: { (dict, error) in
 if let error = error {
 let _ = AlertController.alert("Error!", message: (error.localizedDescription))
 }else {
 }
 }) { (error) in
 }
 
 */

@end
