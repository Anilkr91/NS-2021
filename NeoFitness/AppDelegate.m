//
//  AppDelegate.m
//  mNivesh-2
//
//  Created by MOHD RAHIB on 17/03/15.
//  Copyright (c) 2015 dmondo. All rights reserved.
//

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "XMLReader.h"
#import "Utility.h"
//@import Firebase;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //[[UILabel appearance] setFont:[UIFont fontWithName:@"Helvetica-Regular" size:30]];
    // Override point for customization after application launch.
    
//    Property
//    
//    
//    @property (strong, nonatomic) UIWindow *window;
//    
//
    
   // [FIRApp configure];
//    FUNCtION :
    
       
      if ([Utility connected]) {
    
    [self Getmobileversion];
    NSLog(@"%@",AppVersionstring);
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    NSDate *date  = [dateFormatter dateFromString:DateString];
    
    // Convert to new Date Format
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *newDate = [dateFormatter stringFromDate:date];
    
    
    
    NSString*CompareDateString =@"01/01/2000";
    
//    if (![AppVersionstring isEqualToString:version] && [newDate isEqualToString:CompareDateString]) {
//        NSString *iTunesLink = @"https://itunes.apple.com/us/app/neo-fitness/id1195866204?mt=8";
        
       // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                
//        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
//        [userdefaults setObject:@"no" forKey:@"version"];
//        
//        [userdefaults synchronize];
//    }else{
//        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
//        [userdefaults setObject:@"yes" forKey:@"version"];
//        
//        [userdefaults synchronize];
//    }
          
         // UIStoryboard* mainStoryBoard;
//          if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//              mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
//          else
          //    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
          
          
          self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
         // UIViewController *viewController =   [mainStoryBoard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];   // determine the initial view controller here and instantiate it with [storyboard instantiateViewControllerWithIdentifier:<storyboard id>];
          
          //
          
        
          
          if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"]) {
             // [mainStoryBoard instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
              [self loginFow];
              
          } else {
               // [mainStoryBoard instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
              [self afterSucessfulLogin];
         
          }
          

    }else{
        [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"NO Internate Connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ([Utility connected]) {
        [self Getmobileversion];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        NSDate *date  = [dateFormatter dateFromString:DateString];
        
        // Convert to new Date Format
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *newDate = [dateFormatter stringFromDate:date];
        
        
        
        NSString*CompareDateString =@"01/01/2000";
        
        if (![AppVersionstring isEqualToString:version]&& [newDate isEqualToString:CompareDateString]) {
            NSString *iTunesLink = @"https://itunes.apple.com/us/app/neo-fitness/id1195866204?mt=8";
            
           // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
            //UIApplication *app = [UIApplication sharedApplication];
            // [app performSelector:@selector(suspend)];
            
            //wait 2 seconds while app is going background
            // [NSThread sleepForTimeInterval:2.0];
            
            //exit app when app is in background
            // exit(0);
            
            
        }else{
            NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults setObject:@"yes" forKey:@"version"];
            
            [userdefaults synchronize];
        }}
    
    
    else{
        [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"NO Internate Connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) loginFow {
    NSString *userType;
    NSString *roleId;
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    roleId =    [userdefaults valueForKey:@"RoleId"];
    userType =    [userdefaults valueForKey:@"USERTYPE"];
    if ([userType isEqualToString:@"S"]) {

              if ([roleId isEqualToString:@"2"]) {
                 [self showRoleBasedHome];
              } else {
                 // print show sales login dashoard
            }
    } else {
       [self afterSucessfulLogin];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:true forKey: @"currentUser"];
    [defaults synchronize];
    
}

- (void)showRoleBasedHome {

    
    SWRevealViewController *revealViewController = [[SWRevealViewController alloc ]init];
      revealViewController.frontViewController =  [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BranchAdminNVC"];
      revealViewController.rearViewController =  [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SidebarTableViewController"];
      //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:frontViewController];

      //[revealViewController setFrontViewController:selectedViewController];

     // UINavigationController *selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BranchAdminNVC"];
      //[revealViewController setFrontViewController:selectedViewController];
      self.window.rootViewController = revealViewController;
      [self.window makeKeyAndVisible];
      return;
    
//    SWRevealViewController *revealViewController = [[SWRevealViewController alloc ]init];
//    UINavigationController *selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BranchAdminNVC"];
//    [revealViewController setFrontViewController:selectedViewController];
//    self.window.rootViewController = revealViewController;
//    [self.window makeKeyAndVisible];
//    return;
}

-(void)afterSucessfulLogin{
  
     SWRevealViewController *revealViewController = [[SWRevealViewController alloc ]init];
        UIViewController *selectedViewController;
       selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
       [revealViewController setFrontViewController:selectedViewController];
        self.window.rootViewController = revealViewController;
       [self.window makeKeyAndVisible];
    return;

}



-(void)Getmobileversion{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    
    
    NSString *post =[NSString stringWithFormat:@"Customerdetail=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><MobileApp><AppType>IOS</AppType></MobileApp></NeoFitnes>",UserName,password];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetMobileAppVersion"]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //[request setValue:post forHTTPHeaderField:@"authentican"];
    
    [request setHTTPBody:postData];
    
    NSError *error;
    
    NSURLResponse *response;
    
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    
    NSError *err;
    
    NSMutableDictionary* dictionary = [[XMLReader dictionaryForXMLData:urlData error:&err] mutableCopy];
    
    NSLog(@"cc");
    
    NSString *strText = [[dictionary objectForKey:@"string"] valueForKey:@"text"];
    
    
    NSData *textData = [strText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:textData];
    [xmlParser setShouldResolveExternalEntities: YES];
    parser.delegate = self;
    [parser parse];
    
}






//Implement the NSXmlParserDelegate methods

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName

  namespaceURI:(NSString *)namespaceURI qualifiedName:

(NSString *)qName attributes:(NSDictionary *)attributeDict

{
   
    if( [elementName isEqualToString:@"Message"] ||[elementName isEqualToString:@"AppVersion"] ||[elementName isEqualToString:@"CreatedDate"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        xmlResults = YES;
    }
    
    //currentElement = elementName;
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string

{
    if( xmlResults )
    {
        [soapResults appendString: string];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName

  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName



{
    
    
        
    if( [elementName isEqualToString:@"AppVersion"])
    {
        xmlResults = FALSE;
        
        
        
        
        AppVersionstring = [NSString stringWithFormat:@"%@",soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"CreatedDate"])
    {
        xmlResults = FALSE;
        
        
        
        
        DateString = [NSString stringWithFormat:@"%@",soapResults];
        soapResults = nil;
    }

    
}

@end
