//
//  AppDelegate.h
//  mNivesh-2
//
//  Created by MOHD RAHIB on 17/03/15.
//  Copyright (c) 2015 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
    NSMutableArray *messagearray;
    
  
    NSString *AppVersionstring;
    NSString *DateString;
    NSString *userType;
    NSString *roleId;
    //IBOutlet UIView *marqueeView;
    
}

//public static final String PAYUMONEY_Key = "fC38x6HU";
//public static final String PAYUMONEY_Salt = "e6zHrnjijY";
//public static final String PAYUMONEY_MID = "6821433";
//public static final String PAYUMONEY_SURL = "https://www.payumoney.com/mobileapp/payumoney/success.php";
//public static final String PAYUMONEY_FURL = "https://www.payumoney.com/mobileapp/payumoney/failure.php";

@property (strong, nonatomic) UIWindow *window;

@end
//- (void)filterOperators:(NSString*)name {
//        
//        if([name isEqualToString:@""] || name == nil) {
//                searchResults = [cityArray mutableCopy];
//            }
//        else {
//                NSString *searchName = [name lowercaseString];
//                
//                NSPredicate *containsPredicate = [NSPredicate predicateWithFormat:@"self.CityName CONTAINS[cd] %@", searchName];
//                searchResults = [[cityArray filteredArrayUsingPredicate:containsPredicate] mutableCopy];
//            }
//        // [self createSections];
//        [self.tableView reloadData];
//        
//}
//


