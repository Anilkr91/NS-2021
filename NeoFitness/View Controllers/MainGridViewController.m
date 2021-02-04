//
//  MainGridViewController.m
//  NeoFitness-2
//
//  Created by MOHD RAHIB on 17/03/15.
//  Copyright (c) 2015 dmondo. All rights reserved.
//

#import "MainGridViewController.h"
#import "SWRevealViewController.h"
#import "SidebarTableViewController.h"
#import "SalesEnquiryViewController.h"
#import "GroupClassesViewController.h"
#import "WorkoutCardViewController.h"
#import "DietCardViewController.h"
#import "fitnessSummaryViewController.h"
#import "MyAttendanceViewController.h"
#import "medicalHistoryViewController.h"
#import "myMembershipViewController.h"
#import "DrObservationViewController.h"
#import "ObecityReportViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "XMLReader.h"
#import "TodayTrainersViewController.h"
#import "SupportViewController.h"
@interface MainGridViewController (){
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
    NSMutableArray *messagearray;
    
    NSString *messagestring;
     
    //IBOutlet UIView *marqueeView;
   
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *viewNifty;
@property (weak, nonatomic) IBOutlet UIView *viewSales;
@property (weak, nonatomic) IBOutlet UIView *viewCustomer;
@property (weak, nonatomic) IBOutlet UIView *viewForgetPassword;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
//@property (weak, nonatomic) IBOutlet UIImageView *versionView;
@property (weak, nonatomic) IBOutlet UIView *versionView;


@end

@implementation MainGridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults*userdefaults=[NSUserDefaults standardUserDefaults];
   
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(viewDidLoad)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
    
    if ([_identifier isEqualToString:@"incentive"]) {
        [[[UIAlertView alloc] initWithTitle:@"Neo Fitnes" message:@"Coming Soon." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    
    [_toolBar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;    // Do any additional setup after loading the view.
    
    NSString * userType =    [userdefaults valueForKey:@"USERTYPE"];
    if ([userType isEqualToString:@"C"]) {
    if ([Utility connected]) {
        [self getSpecialMessage];
        _lbl1.text =messagestring;
        _lbl2.text =messagestring;

    }
    else{
        [self showmessage];
    }
    }
    
    [self showview];
       if (!(messagestring==nil)) {
        [userdefaults setObject:messagestring forKey:@"messagestring"];
        [userdefaults synchronize];
    }
    
    CGFloat width = [self setlabelframe];
    [_lbl1 setFrame:CGRectMake(self.lbl1.frame.origin.x, self.lbl1.frame.origin.y, width, self.lbl1.frame.size.height)];
     [_lbl2 setFrame:CGRectMake(width, self.lbl2.frame.origin.y, width, self.lbl2.frame.size.height)];
    //_lbl2.hidden =YES;
}
-(void)showmessage{
 NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString*message=[userdefaults valueForKey:@"messagestring"];
    if (!(message==nil)) {
        
        _lbl1.text =message;
        _lbl2.text =message;
        CGFloat width = [self setlabelframe];
        [_lbl1 setFrame:CGRectMake(self.lbl1.frame.origin.x, self.lbl1.frame.origin.y, width, self.lbl1.frame.size.height)];
        [_lbl2 setFrame:CGRectMake(width, self.lbl2.frame.origin.y, width, self.lbl2.frame.size.height)];
        //_lbl2.hidden =YES;

        
          }

}
-(void)viewDidAppear:(BOOL)animated{
    
      
    
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    
    
    
    
   NSString * userType =    [userdefaults valueForKey:@"USERTYPE"];
    
    
    if ([userType isEqualToString:@"C"]) {
    [NSTimer scheduledTimerWithTimeInterval:0.002
     
                                     target:self
     
                                   selector:@selector(targetMethod:)
     
                                   userInfo:nil
     
                                    repeats:YES];
    }

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //[self.sidebarButton setTarget: self.revealViewController];
        //[self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;    // Do any additional setup after loading the view.
  
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString*string=[userdefaults valueForKey:@"version"];
     
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //[self.sidebarButton setTarget: self.revealViewController];
        //[self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;    // Do any additional setup after loading the view.

    
    
    
    
    [self showview];
    
    if ([_identifier isEqualToString:@"Change Password"]) {
        _viewForgetPassword.hidden = NO;
    }
    
    if ([_identifier isEqualToString:@"Call Branch"]) {
        [self callBranch];
    }

    
    
    
    if ([Utility connected]) {
        
    }
    else{
        
    }
    
    
 [self showview];
   // [self LabelAnimation];
    

//    [NSTimer scheduledTimerWithTimeInterval:10.0
//                                     target:self
//                                   selector:@selector(LabelAnimation)
//                                   userInfo:nil
//                                    repeats:YES];

}

-(void)viewWillDisappear:(BOOL)animated{
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showview{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
  NSString *  userType =    [userdefaults valueForKey:@"USERTYPE"];
    
  
    NSString *AppVersionString =[userdefaults valueForKey:@"version"];
    if ([AppVersionString isEqualToString:@"no"]) {
        _versionView.hidden=NO;
        return;
    }else{
        _versionView.hidden=YES;
    }
    
    if ([userType isEqualToString:@"S"]) {
        _viewCustomer.hidden =YES;
        _viewSales.hidden =NO;
       _versionView.hidden=YES;
    }
    else{
        _viewCustomer.hidden =NO;
        _viewSales.hidden =YES;
        _versionView.hidden=YES;
    }

    
}

//Add button tag here in IF condition to open in Web View

- (IBAction)forgetPassOkBtnClicked:(id)sender {
    _viewForgetPassword.hidden = YES;
}
-(void)callBranch{
    if ([_userType isEqualToString:@"sales"]) {
         NSString *phNo = @"9990003436";
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        }
        else {
            UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support this feature." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [notPermitted show];
        }
    }
        else{
            NSString *phNo = @"9990123400";
            NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            }
            else {
                UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support this feature." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [notPermitted show];
            }
 
        }
        

    }

- (IBAction)salesEnquiryBtnClicked:(id)sender {
    SalesEnquiryViewController *SalesEnquiryViewController;
    NSString * string = @"SalesEnquiryViewController";
    [self Btntaped:string and:SalesEnquiryViewController];
    
   }
- (IBAction)GroupClassBtnClicked:(id)sender {
    GroupClassesViewController *GroupClassesViewController;
    NSString * string = @"GroupClassesViewController";
    [self Btntaped:string and:GroupClassesViewController];
  }
- (IBAction)BtnWorkoutCardClicked:(id)sender {
    WorkoutCardViewController *WorkoutCardViewController;
    NSString * string = @"WorkoutCardViewController";
    [self Btntaped:string and:WorkoutCardViewController];
    

   
}
- (IBAction)DietCardBtnClicked:(id)sender {
    DietCardViewController *DietCardViewController;
    NSString * string = @"DietCardViewController";
    [self Btntaped:string and:DietCardViewController];

    
    
}
- (IBAction)fitnessSummaryclicked:(id)sender {
    fitnessSummaryViewController *fitnessSummaryViewController;
    NSString * string = @"fitnessSummaryViewController";
    [self Btntaped:string and:fitnessSummaryViewController];
  }
- (IBAction)supportTaped:(id)sender {
    SupportViewController *SupportViewController;
    NSString * string = @"SupportViewController";
    [self Btntaped:string and:SupportViewController];
}

- (IBAction)AttendanceBtnClicked:(id)sender {
    MyAttendanceViewController *MyAttendanceViewController;
    NSString * string = @"MyAttendanceViewController";
    [self Btntaped:string and:MyAttendanceViewController];
  
}

- (IBAction)medicalHistoryBtnClicked:(id)sender {
    medicalHistoryViewController *medicalHistoryViewController;
    NSString * string = @"medicalHistoryViewController";
    [self Btntaped:string and:medicalHistoryViewController];
}
- (IBAction)membershipBtnClicked:(id)sender {
    myMembershipViewController *myMembershipViewController;
    NSString * string = @"myMembershipViewController";
    [self Btntaped:string and:myMembershipViewController];
}
- (IBAction)book_appoinmentTaped:(id)sender {
      [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Coming Soon...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
- (IBAction)online_constationTaped:(id)sender {
    DrObservationViewController *DrObservationViewController;
    NSString * string = @"DrObservationViewController";
    [self Btntaped:string and:DrObservationViewController];

}

- (IBAction)ObecityReportTaped:(id)sender {
    
    ObecityReportViewController *ObecityReportViewController;
    NSString * string = @"ObecityReportViewController";
    [self Btntaped:string and:ObecityReportViewController];
    
    
}
- (IBAction)TodaysTrainerTaped:(id)sender {
    TodayTrainersViewController *ObecityReportViewController;
    NSString * string = @"TodayTrainersViewController";
    [self Btntaped:string and:ObecityReportViewController];
}


-(void)Btntaped:(NSString *)identifier and :(UIViewController*)controller{
    UIStoryboard* mainStoryBoard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    }
    else{
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    }
    
    if ([Utility connected]) {
         controller = [mainStoryBoard instantiateViewControllerWithIdentifier:identifier];
        
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [controller.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[controller] animated: YES];
        
        self.revealViewController.frontViewController = navController;
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

    
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

   
-(void)getSpecialMessage{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  BranchId =    [userdefaults valueForKey:@"BranchId"];
    NSString *  GymId =    [userdefaults valueForKey:@"GymId"];
    NSString *  MemberType =    [userdefaults valueForKey:@"USERTYPE"];
    
    NSString *post =[NSString stringWithFormat:@"Customerdetail=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><WorkoutCard><Workout><BranchId>%@</BranchId><GymId>%@</GymId><MemberType>%@</MemberType></Workout></WorkoutCard></NeoFitnes>",UserName,password,BranchId,GymId,MemberType];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetSpecialMessage"]]];
    
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
    NSLog(@"fsdfsd");
    if( [elementName isEqualToString:@"Message"] ||[elementName isEqualToString:@"AppVersion"])
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
    
    
    if( [elementName isEqualToString:@"Message"])
    {
        xmlResults = FALSE;
        
       
        
        
        messagestring = [NSString stringWithFormat:@"%@",soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"AppVersion"])
    {
        xmlResults = FALSE;
        
        
        
        
        
        soapResults = nil;
    }

}








-(void)targetMethod: (id)sender{
     CGFloat width = [self setlabelframe];

   
    CGRect frame = _lbl1.frame;
    
    CGRect frame1 = _lbl2.frame;
    
    frame.origin.x = frame.origin.x-0.1;
    
    _lbl1.frame = frame;
    
    frame1.origin.x = frame1.origin.x-0.1;
    
    _lbl2.frame = frame1;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
    if(frame.origin.x < -width){
        
        frame.origin.x = width;
        
        _lbl1.frame = frame;
        
    }
    
    
    
    if(frame1.origin.x < -width){
        
        frame1.origin.x = width;
        
        _lbl2.frame = frame1;
        
    }
    }
    else{
        if(frame.origin.x < -width){
            
            frame.origin.x = width;
            
            _lbl1.frame = frame;
            
        }
        
        
        
        if(frame1.origin.x < -width){
            
            frame1.origin.x = width;
            
            _lbl2.frame = frame1;
        
        }
 
    }

}
-(CGFloat)setlabelframe{
    CGFloat width;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0)
        {
            width = [_lbl1.text sizeWithFont:[UIFont systemFontOfSize:27]].width;
        }
        else
        {
            width = ceil([_lbl1.text  sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:27]}].width);
        }
    }else{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0)
    {
        width = [_lbl1.text sizeWithFont:[UIFont systemFontOfSize:14]].width;
    }
    else
    {
        width = ceil([_lbl1.text  sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}].width);
    }
    }
    if (width<self.view.frame.size.width ) {
        return self.view.frame.size.width;
    }
    else{
        return width;
    }

   
}

@end
