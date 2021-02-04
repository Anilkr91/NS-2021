//
//  SocketConnect.h
//  ServerConnection
//
//  Created by Harsh Duggal on 11/06/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CmnzWiFiFaceAppDelegate;

@interface ServerConnect : NSObject//<NSStreamDelegate>
{
    id                      _delegate;
    // data from server
    NSMutableData* _recievedData;
    CmnzWiFiFaceAppDelegate *_appDelegateObj;

}

@property (nonatomic, retain) id                        _delegate;
@property (nonatomic, retain) NSURLConnection * _connection;

#pragma mark-
#pragma mark- Creating connection with url
-(void)createConnectionRequestToURL:(NSString*)urlStr withJsonString:(NSString *)jsonStringToServer;
-(void)sendImageToURL:(NSString*)urlStr withImage:(UIImage *)image withImageName:(NSString *)imageName withCoordinates:(NSString*)coord;

@end

@protocol ServerConnectDelegate
- (void) dataLoadRequestFailedWithError:(NSError*)error andMsg:(NSString*)errorMsg;
- (void) dictLoadedFromServer:(NSDictionary*)dict;
- (void) stringLoadedFromServer:(NSString*)str;
- (void) arrayLoadedFromServer:(NSArray*)Array;

@end
