//
//  LoginViewController.m
//  NeoFitness-2
//
//  Created by MOHD RAHIB on 17/03/15.
//  Copyright (c) 2015 dmondo. All rights reserved.
//

#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import "MainGridViewController.h"
#import "SidebarTableViewController.h"
#import "AppDelegate.h"
#import "XMLReader.h"
#import "NeoFitness-Swift.h"
@interface LoginViewController ()
{
BOOL remember;
NSArray *responseObj;
NSString *soapMessage;
NSString *currentElement;
NSMutableData *webResponseData;
NSString *Invoke;
AppDelegate *appdel;
    
NSString *userType;
NSString *roleId;
  
}
@property(strong, nonatomic) IBOutlet UIButton* button_login;
@property(strong, nonatomic) IBOutlet UITextField* textfield_userName;
@property(strong, nonatomic) IBOutlet UITextField* textfield_password;
@property (weak, nonatomic) IBOutlet UIButton *btnRememberMe;
@property (weak, nonatomic) IBOutlet UIView *viewUserNameBottom;
@property (weak, nonatomic) IBOutlet UIView *viewUserPassBottom;
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) IBOutlet UIImageView *imgRememberMe;
@property (weak, nonatomic) IBOutlet UIView *viewForgetPassword;
@property (weak, nonatomic) IBOutlet UIView *ViewVersion;

@end

@implementation LoginViewController
@synthesize cityId;
@synthesize packageId;
@synthesize amount;
@synthesize offerAmount;
@synthesize pkgMinAmount;
@synthesize branchId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
//        NSLog(@"%@ => %@", key, value);
//    }];
    
   // [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(viewDidLoad)
//                                                name:UIApplicationDidBecomeActiveNotification
//                                              object:nil];
  //  self.navigationController.navigationBarHidden=YES;
     _viewForgetPassword.hidden=YES;
    [self addGestureRecog];
    [self startSettingUserInterface];
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
 
    NSString *AppVersionString =[userdefaults valueForKey:@"version"];
    if ([AppVersionString isEqualToString:@"no"]) {
        _ViewVersion.hidden=NO;
        return;
    }else{
        _ViewVersion.hidden=YES;
    }

     // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
  //  self.navigationController.navigationBarHidden=YES;
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"]) {
        _textfield_userName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
        _textfield_password.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    }
  }

-(void)viewDidAppear:(BOOL)animated{
      }
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_textfield_userName setText:@""];
    [_textfield_password setText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSignUpTaped:(id)sender {
    
    UIStoryboard* mainStoryBoard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    else
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    
  //  RegisterViewController* viewCtrl_Register = [mainStoryBoard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewCtrl_Register];
    
    //[viewCtrl_Register.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
    //[navController setViewControllers: @[viewCtrl_Register] animated: YES];
    
    //[self.navigationController pushViewController:viewCtrl_Register animated:YES];
}

- (IBAction)backButtonTapped:(id)sender {
    
    if (branchId == 0) {
        
        UIViewController *selectedViewController;
         SWRevealViewController *revealViewController = self.revealViewController;
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
//        else
//            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
//
//        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
//
//        [self.navigationController pushViewController:selectedViewController animated:YES];
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
        else
                selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTableViewController"];

                        
            UITabBarController *TABVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTabbarController"];
                           
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
            [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
            [navController setViewControllers: @[selectedViewController] animated: YES];

            [self.revealViewController setFrontViewController:TABVC];
                           
            [TABVC.navigationController pushViewController:selectedViewController animated:YES];
//            if ( revealViewController )
//                {
//                [revealViewController revealToggleEnd];
//            }
        return;
        
    } else {
         [self.navigationController popViewControllerAnimated:YES];
    }
    

   
    //animated:YES];

    return;
}



- (IBAction)btnRememberTaped:(id)sender {
    if(_imgRememberMe.hidden){
        [_btnRememberMe setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        remember =YES;
    }else{
        
        [_btnRememberMe setImage:[[UIImage imageNamed:@"uncheck.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        remember = NO;
    }
    
    _imgRememberMe.hidden = !_imgRememberMe.hidden;
}



-(void)startSettingUserInterface{
    // self.navigationController.navigationBarHidden = YES;
    [_button_login addTarget:self action:@selector(loginButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)loginButtonTaped:(id)sender{
      self.viewUserNameBottom.backgroundColor = [UIColor darkGrayColor];
    self.viewUserPassBottom.backgroundColor = [UIColor darkGrayColor];
    NSString* usernameString = _textfield_userName.text;
    NSString* passwordString = _textfield_password.text;
    if ([usernameString isEqualToString:@""] || [passwordString isEqualToString:@""]) {
        if ([usernameString isEqualToString:@""] && [passwordString isEqualToString:@""])
            [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Please enter your Username and Password both." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        else if ([usernameString isEqualToString:@""])
            [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Username field is empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        else if ([passwordString isEqualToString:@""])
            [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Password field is empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        else;
        
    }
    else{
        if ([Utility connected]) {
            //[self callService];
             [self LoginWebService];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        [_textfield_password resignFirstResponder];
        [_textfield_userName resignFirstResponder];
        [self moveViewUpOrDown:@"Down"];
        
    }
    
    /*    NSString* connectionString = [NSString stringWithFormat:@"http://m.investwell.in/hc/loginmobileandroid.jsp?bid=ARN-77444&user=%@&password=%@",usernameString, passwordString];
     ServerConnect* serverObj = [[ServerConnect alloc] init];
     serverObj._delegate = self;
     [serverObj createConnectionRequestToURL:connectionString withJsonString:nil];*/
}


//-(void)gotResponseFromServerP:(NSDictionary*)dictionary{
//    [self stopLoading];
//    if ([[dictionary valueForKey:@"flag"] isEqualToString:@"Y"]) {
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"]) {
//            [self afterSucessfulLogin];
//            
//        }
//        else
//            [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Do you want to remember your password?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil] show];
//    }
//    else{
//        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Either username or password is incorrect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//    }
//}


# pragma mark Text Field Delegate

# pragma mark Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self moveViewUpOrDown:@"UP"];
    if(textField == _textfield_userName){
        self.viewUserNameBottom.backgroundColor = [UIColor orangeColor];
        self.viewUserPassBottom.backgroundColor = [UIColor darkGrayColor];
    }else if(textField == _textfield_password){
        self.viewUserNameBottom.backgroundColor = [UIColor darkGrayColor];
        self.viewUserPassBottom.backgroundColor = [UIColor orangeColor];
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.viewUserNameBottom.backgroundColor = [UIColor darkGrayColor];
    self.viewUserPassBottom.backgroundColor = [UIColor darkGrayColor];
    [self moveViewUpOrDown:@"Down"];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:_textfield_userName.text forKey:@"user_name"];
        [userdefaults setObject:_textfield_password.text forKey:@"password"];
        [userdefaults synchronize];
    }
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:_textfield_password.text forKey:@"Pass"];
    [userdefaults synchronize];

   
    [self afterSucessfulLogin];
    
}

-(void)afterSucessfulLogin{
  
    SWRevealViewController *revealViewController = self.revealViewController;
        UIViewController *selectedViewController;
       selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
       [revealViewController setFrontViewController:selectedViewController];
    return;

}

-(void) loginFow {
    
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

    SWRevealViewController *revealViewController = self.revealViewController;
     UIViewController *selectedViewController;
    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BranchAdminNVC"];
    [revealViewController setFrontViewController:selectedViewController];

      return;
}


-(void)addGestureRecog{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToView:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

-(void)tapToView:(UITapGestureRecognizer *)gesture{
    [self moveViewUpOrDown:@"Down"];
    [_textfield_userName resignFirstResponder];
    [_textfield_password resignFirstResponder];
}

-(void)moveViewUpOrDown:(NSString *)string{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return;
    CGFloat upDownValue = 0;
    if ([string isEqualToString:@"UP"])
        upDownValue = -70;
    else
        upDownValue = 0;
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.view.frame = CGRectMake(0, upDownValue, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
    
    
}

#pragma mark - Activity Indicator

- (void)showLoadingIndicator:(NSString *)message
{
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.labelText = @"Loading..";
}

-(void)stopLoading
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (IBAction)doneSubmitOnForgotPass:(id)sender {
    [self showLoadingIndicator:@"Please wait.."];
    [self performSelector:@selector(submitPassword) withObject:nil afterDelay:3.0];
    
}

- (IBAction)forgotPasswordTaped:(id)sender {
    //self.viewForgotPassword.hidden ? [self.viewForgotPassword setHidden:NO] : [self.viewForgotPassword setHidden:YES];
    [self initialDelayEndeddropDownView];
}

-(void)submitPassword{
    // [self.viewForgotPassword setHidden:YES];
    [self stopLoading];
    [[[UIAlertView alloc] initWithTitle:@"" message:@"Please check your mail to reset your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}


-(void)initialDelayEndeddropDownView

{
    
    //  self.viewForgotPassword.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    //self.viewForgotPassword.alpha = 1.0;
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:.5];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStoppeddropDownView)];
    
    //self.viewForgotPassword.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
    
    [UIView commitAnimations];
    
}



- (void)bounce1AnimationStoppeddropDownView

{
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.2];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStoppeddropDownView)];
    
    // self.viewForgotPassword.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    
    [UIView commitAnimations];
    
}



- (void)bounce2AnimationStoppeddropDownView

{
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.2];
    
    // self.viewForgotPassword.transform = CGAffineTransformIdentity;
    
    [UIView commitAnimations];
    //[self performSelector:@selector(setAnimationForSplash) withObject:nil afterDelay:0.5];
    
    // [self fadeIn];
    
    
}


#pragma mark - API CALL

-(void)LoginWebService{
    NSString* usernameString = _textfield_userName.text;
    NSString* passwordString = _textfield_password.text;
    
    
    NSString *post =[NSString stringWithFormat:@"authentican=<NeoFitnes><Users><UserName>%@</UserName><Password>%@</Password></Users></NeoFitnes>",usernameString,passwordString];
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/Authorization"]]];
    
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
    
    NSLog(@"%@", strText);
    
    NSData *textData = [strText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:textData];
    
    parser.delegate = self;
    
    [parser parse];
     NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userdefaults valueForKey:@"USERTYPE"];
    if ([string isEqualToString:@"S"]||[string isEqualToString:@"C"]) {
        
    
    [self stopLoading];
        if (remember == YES) {
            NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults setObject:_textfield_userName.text forKey:@"user_name"];
            [userdefaults setObject:_textfield_password.text forKey:@"password"];
            [userdefaults synchronize];
        }
        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:_textfield_password.text forKey:@"Pass"];
        [userdefaults synchronize];
        
       // [self afterSucessfulLogin];
         [self loginFow];

    
   // [self afterSucessfulLogin];
    }
    
    else{
        [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Invalid Credential?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        //[self afterSucessfulLogin];
    }
}


    //initiate the request
//Implement the NSXmlParserDelegate methods

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName

  namespaceURI:(NSString *)namespaceURI qualifiedName:

(NSString *)qName attributes:(NSDictionary *)attributeDict

{
    
    currentElement = elementName;
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string

{
    NSString * USERTYPE;
     NSString * MemberID;
     NSString * UserName;
     NSString * GymId;
     NSString * FirstName;
     NSString * BranchId;
    NSString * GymName;
    NSString * BranchContactNo;
    NSString * BranchContactPerson;
    NSString * BranchName;
    NSString * RoleId;
    NSString * CustomerContactNo;
    NSString * LastName;
    
    
    if ([currentElement isEqualToString:@"USERTYPE"]) {
        
         USERTYPE =string;
      
        [self savevalueInUserDefault:USERTYPE and:currentElement];
       
          }
    
    if ([currentElement isEqualToString:@"MemberID"]) {
        
        MemberID =string;
        [self savevalueInUserDefault:MemberID and:currentElement];

    }
    
    if ([currentElement isEqualToString:@"UserName"]) {
        
        UserName =string;
        [self savevalueInUserDefault:UserName and:currentElement];

    }
    
    if ([currentElement isEqualToString:@"GymId"]) {
        
        GymId =string;
        [self savevalueInUserDefault:GymId and:currentElement];
       
    }
    
    if ([currentElement isEqualToString:@"FirstName"]) {
        
        FirstName =string;
        
        [self savevalueInUserDefault:FirstName and:currentElement];

    }
    if ([currentElement isEqualToString:@"LastName"]) {
        
        LastName =string;
        
            
        [self savevalueInUserDefault:LastName and:currentElement];
    }

    
    if ([currentElement isEqualToString:@"BranchId"]) {
        
        BranchId =string;
        [self savevalueInUserDefault:BranchId and:currentElement];

    }
    
    if ([currentElement isEqualToString:@"GymName"]) {
        
        GymName =string;
        [self savevalueInUserDefault:GymName and:currentElement];

    }
    
    if ([currentElement isEqualToString:@"BranchContactNo"]) {
        
        BranchContactNo =string;
        [self savevalueInUserDefault:BranchContactNo and:currentElement];

    }
    
    if ([currentElement isEqualToString:@"BranchContactPerson"]) {
        
        BranchContactPerson =string;
        [self savevalueInUserDefault:BranchContactPerson and:currentElement];
    }
    
    if ([currentElement isEqualToString:@"BranchName"]) {
              BranchName =string;
        [self savevalueInUserDefault:BranchName and:currentElement];

    }
    
    if ([currentElement isEqualToString:@"RoleId"]) {
                 RoleId =string;
           [self savevalueInUserDefault:RoleId and:currentElement];

       }
    
    NSLog(@"%@", currentElement);
    NSLog(@"%@", string);
    if ([currentElement isEqualToString:@"CustomerContactNo"]) {
       
              CustomerContactNo =string;
        [self savevalueInUserDefault:CustomerContactNo and:currentElement];

    }
    
}
    

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName

  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName

{
    
   // NSLog(@"Parsed Element : %@", currentElement);
    
}
-(void)savevalueInUserDefault:(NSString*)string and :(NSString*)key{
    if(string.length==0 || [string isKindOfClass:[NSNull class]] || [string isEqualToString:@""] || [string isEqualToString:@"  "] || [string isEqualToString:@"   "]|| [string isEqualToString:@"    "] || [string isEqualToString:@" "] ||string == NULL||[string isEqualToString:@"(null)"]||string==nil || [string isEqualToString:@"<null>"]) {
        
    }
    else{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:string forKey:key];
     
    [userdefaults synchronize];
    }
}


- (IBAction)okBtnClicked:(id)sender {
    _viewForgetPassword.hidden=YES;

}

- (IBAction)forgetPasswordbtntaped:(id)sender {
//    _viewForgetPassword.hidden=NO;
   
    ForgotPasswordTVC *vc =  [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ForgotPasswordTVC"];
    vc.email = _textfield_userName.text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)registrationButtonTapped:(id)sender {
    
   RegistrationTableViewController *vc =  [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"showRegistration"];
    vc.cityId = cityId;
    vc.packageId = packageId;
    vc.amount = amount;
    vc.offerAmount = offerAmount;
    vc.packageAmount = pkgMinAmount;
    vc.branchId = branchId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

