//
//  DietCardViewController.m
//  NeoFitness
//
//  Created by Sumit Saini on 19/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import "DietCardViewController.h"
#import "XMLReader.h"
#import "SWRevealViewController.h"
#import "DietCardTableViewCell.h"
#import "MainGridViewController.h"
#import "WebXMLParser.h"
#import "XMLDictionary.h"
#import "DietFeedbackViewController.h"
@interface DietCardViewController ()
{
NSArray *responseObj;
NSString *soapMessage;
NSString *currentElement;
NSMutableData *webResponseData;
NSXMLParser *xmlParser;
NSMutableString *soapResults;
BOOL xmlResults;
NSString *errorMessage;

NSMutableArray *mainArray1;
NSMutableArray *searcharray;
 NSMutableArray *ErrorMessage;

}
@property (weak, nonatomic) IBOutlet UIView *view_norecord;

@property (weak, nonatomic) IBOutlet UILabel *lblCreatedDate;

@property (weak, nonatomic) IBOutlet UILabel *lblRenewalDate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *btn_postFeedback;
@property (strong, nonatomic) IBOutlet UIButton *btn_viewFeedback;
@property (strong, nonatomic) IBOutlet UIView *view_postFeedbackContainer;
@property (strong, nonatomic) IBOutlet UIView *view_postFeedback;
@property (strong, nonatomic) IBOutlet UIButton *btn_cross;
@property (strong, nonatomic) IBOutlet UIButton *btn_submit;
@property (strong, nonatomic) IBOutlet UITextView *text_Comment;

@end

@implementation DietCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _text_Comment.delegate=self;
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidPressed:)];
    UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[self class] toolbarHeight])];
    [toolbar setItems:[NSArray arrayWithObjects:flexableItem,doneItem, nil]];
   
    _text_Comment.inputAccessoryView = toolbar;
  
_view_norecord.hidden=YES;
 _view_postFeedbackContainer.hidden=YES;
    [_text_Comment resignFirstResponder];
  ErrorMessage=[[NSMutableArray alloc]init];
    mainArray1 =[[NSMutableArray alloc]init];
    
    searcharray =[[NSMutableArray alloc]init];
    
    self.btn_submit.layer.cornerRadius=10.0f;
    self.btn_postFeedback.layer.cornerRadius=5.0f;
     self.btn_viewFeedback.layer.cornerRadius=5.0f;
    self.view_postFeedback.layer.cornerRadius=5.0f;
    // [ mainArray1 removeAllObjects];
    //[ TableDataArr removeAllObjects];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //[self.sidebarButton setTarget: self.revealViewController];
        //[self.sidebarButton setAction: @selector( revealToggle: )];
        [self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = NO;
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer: tapRec];
    [self getGroupClass];
    

//    if (!(ErrorMessage.count==0)) {
//        _view_norecord.hidden=NO;
//        NSString*string = [NSString stringWithFormat:@"%@",[ErrorMessage objectAtIndex:0]];
//        [[[UIAlertView alloc] initWithTitle:@"" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return;
//    }
    
    searcharray = mainArray1 ;
   
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    
    
    [_btn_postFeedback addTarget:self action:@selector(btn_postcommentTaped:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_viewFeedback addTarget:self action:@selector(btn_viewcommentTaped:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_cross addTarget:self action:@selector(canceltaped) forControlEvents:UIControlEventTouchUpInside];
    [_btn_submit addTarget:self action:@selector(SubmitTaped) forControlEvents:UIControlEventTouchUpInside];
    [_text_Comment setText:@"Enter Your Feedback"];
}
- (void)doneButtonDidPressed:(id)sender {

    [_text_Comment resignFirstResponder];
   
    
    [self moveViewUpOrDown:@"down"];
}

+ (CGFloat)toolbarHeight {
    // This method will handle the case that the height of toolbar may change in future iOS.
    return 44.f;
}
-(void)SubmitTaped{
    if ([Utility connected]) {
        [self callService];
        
    }
    
    else{
        [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"NO Internate Connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}
-(NSString*)setdate:(NSString*)dietDate and:(int)type{
  
        NSDateFormatter *dateFormatter=[NSDateFormatter new];
        
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        NSDate *date=[dateFormatter dateFromString:dietDate];
        
        
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *finalDate=[dateFormatter stringFromDate:date];
        return finalDate;
    
}
-(void)callService{
    
    NSString* CommentText = _text_Comment.text;
    if ([CommentText isEqualToString:@"Enter Your Feedback"] || CommentText.length==0 || [CommentText isEqualToString:@""]) {
        CommentText=@"";
        [[[UIAlertView alloc] initWithTitle:@"Neo Fitnes" message:@"Plese enter your comment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    NSString*date= [self setdate :[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:0] objectForKey:@"CreatedDate"]] and:0];
    
    
    NSString *post =[NSString stringWithFormat:@"strXMLs=<NeoFitnes>   <Credential>     <UserName>%@</UserName>     <Password>%@</Password>   </Credential>   <Mobile>     <GetObservationFeedback>       <CustomerId>%@</CustomerId >       <DietCreatedDate>%@</DietCreatedDate>       <Feedback>%@</Feedback>     </GetObservationFeedback>   </Mobile> </NeoFitnes>",UserName,password,MemberID,date,_text_Comment.text];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/InsertDietCardFeedbackThreading"]]];
    
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
    
    if ([strText rangeOfString:@"Observation Added successfully"].location == NSNotFound) {
      NSLog(@"string does not contain bla");
    } else {
      NSLog(@"string contains bla!");
        
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Observation Added successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                 [_text_Comment resignFirstResponder];
                _view_postFeedbackContainer.hidden=YES;
        
                return;
        
    }
    
    
//    NSData *textData = [strText dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *responseDictonary = [WebXMLParser parseXML:textData];
//    if ([responseDictonary objectForKey:@"ErrorMessage"]) {
//        NSString*message1=[NSString stringWithFormat:@"%@",[responseDictonary objectForKey:@"ErrorMessage"]];
//
//
//        [[[UIAlertView alloc] initWithTitle:@"" message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//         [_text_Comment resignFirstResponder];
//        _view_postFeedbackContainer.hidden=YES;
//
//        return;
//
//    } else if responseDictonary.
    
    
   
   
    //    NSData *textData = [strText dataUsingEncoding:NSUTF8StringEncoding];
    //
    //    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:textData];
    //    [xmlParser setShouldResolveExternalEntities: YES];
    //    parser.delegate = self;
    //    [parser parse];
    
    
    
    
    
}
-(void)canceltaped{
     _view_postFeedbackContainer.hidden=YES;
    [_text_Comment resignFirstResponder];
}
-(void)btn_postcommentTaped:(id)sender{
    _view_postFeedbackContainer.hidden=NO;
}
-(void)btn_viewcommentTaped:(id)sender{
    if ([Utility connected]) {
        UIStoryboard* mainStoryBoard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
        }
        else{
            mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
        }
        
        DietFeedbackViewController*   controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DietFeedbackViewController"];
        NSString*date=[NSString stringWithFormat:@"%@",[[searcharray objectAtIndex:0] objectForKey:@"CreatedDate"]];
        controller.createdDate=[NSString stringWithFormat:@"%@",[[searcharray objectAtIndex:0] objectForKey:@"CreatedDate"]];
        NSLog(@"%@",date);
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [controller.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[controller] animated: YES];
        
        self.revealViewController.frontViewController = navController;
        
    }

    else{
        [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"NO Internate Connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIStoryboard* mainStoryBoard;
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
//            mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
//        }
//        else{
            mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
//        }
        
//        MainGridViewController*   controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainGridViewController"];
//       
//        
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
//        
//        [controller.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
//        [navController setViewControllers: @[controller] animated: YES];
//        
//        self.revealViewController.frontViewController = navController;
        
    }
    
}
-(void)tap:(UITapGestureRecognizer *)tapRec{
    [[self view] endEditing: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
//    NSString *CellIdentifier =@"DietCardCell";
//    DietCardTableViewCell *cell =(DietCardTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.lblTime.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"DietTime"]];
//    cell.lblDetail.text = [NSString stringWithFormat:@"Diet Details- %@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"DietDetails"]];
//    cell.lbl_remark.text = [NSString stringWithFormat:@"Remark- %@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Remark"]];
//    NSMutableAttributedString *detail=[self MakeSomePartBold:cell.lblDetail.text and:1];
//    [cell.lblDetail setAttributedText:detail ];
//
//    NSMutableAttributedString *Remark=[self MakeSomePartBold:cell.lbl_remark.text and:2];
//    [cell.lbl_remark setAttributedText:Remark ];
//
//    CGFloat   highestLengthOfText3 =[self getLabelHeight:cell.lblDetail];
//    CGFloat   highestLengthOfText =cell.lblDetail.frame.size.height;
//    CGFloat   highestLengthOfText4 =[self getLabelHeight:cell.lbl_remark];
//    CGFloat   highestLengthOfText1 =cell.lbl_remark.frame.size.height;
//
//    CGFloat hieghtOfDetailLbl =highestLengthOfText;
//    CGFloat hieghtOfRemarkLbl =highestLengthOfText1;
//    if (highestLengthOfText3>highestLengthOfText) {
//        hieghtOfDetailLbl=highestLengthOfText3;
//    }
//    if (highestLengthOfText4>highestLengthOfText1) {
//        hieghtOfRemarkLbl=highestLengthOfText4;
//    }
//
//    NSString *remarkstring = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Remark"]];
//
//
//    if (remarkstring.length==0 || [remarkstring isEqualToString:@"(null)"]) {
//        hieghtOfRemarkLbl=0;
//    }
//
//    CGRect frame1 = cell.lblDetail.frame;
//    frame1.origin.y=cell.view_diet.frame.origin.y+cell.view_diet.frame.size.height;
//    frame1.size.height=hieghtOfDetailLbl;
//    cell.lblDetail.frame = frame1;
//
//    CGRect frame2 = cell.view_DietBottom.frame;
//    frame2.origin.y=cell.lblDetail.frame.origin.y+cell.lblDetail.frame.size.height;
//    frame2.size.height=0;
//    cell.view_DietBottom.frame = frame2;
//
//
//    CGRect frame3 = cell.lbl_remark.frame;
//    frame3.origin.y=cell.view_DietBottom.frame.origin.y+cell.view_DietBottom.frame.size.height;
//    frame3.size.height=hieghtOfRemarkLbl;
//    cell.lbl_remark.frame = frame3;
//
//
//    CGRect frame = cell.mainView.frame;
//    frame.size.height = cell.lbl_remark.frame.origin.y+cell.lbl_remark.frame.size.height;
//    cell.mainView.frame = frame;
//    cell.ScrView.frame = frame;
//    return cell.lbl_remark.frame.origin.y+cell.lbl_remark.frame.size.height+22;
    
    return 100;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//   
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mainArray1.count;
    // Return the number of rows in the section.
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"DietCardCell";
    DietCardTableViewCell *cell =(DietCardTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.lblDietList.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"DietList"]];
   //  CGFloat   highestLengthOfText1 =[self callculateHigestLength:cell.lblDietList.text];
   cell.lblTime.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"DietTime"]];
    cell.lblDetail.text = [NSString stringWithFormat:@"Diet Details- %@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"DietDetails"]];
    cell.lbl_remark.text = [NSString stringWithFormat:@"Remark- %@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Remark"]];
    NSMutableAttributedString *detail=[self MakeSomePartBold:cell.lblDetail.text and:1];
    [cell.lblDetail setAttributedText:detail ];
    
    NSMutableAttributedString *Remark=[self MakeSomePartBold:cell.lbl_remark.text and:2];
    [cell.lbl_remark setAttributedText:Remark ];
    
    CGFloat   highestLengthOfText3 =[self getLabelHeight:cell.lblDetail];
    CGFloat   highestLengthOfText =cell.lblDetail.frame.size.height;
    CGFloat   highestLengthOfText4 =[self getLabelHeight:cell.lbl_remark];
    CGFloat   highestLengthOfText1 =cell.lbl_remark.frame.size.height;
    
    CGFloat hieghtOfDetailLbl =highestLengthOfText;
    CGFloat hieghtOfRemarkLbl =highestLengthOfText1;
     if (highestLengthOfText3>highestLengthOfText) {
         hieghtOfDetailLbl=highestLengthOfText3;
     }
    if (highestLengthOfText4>highestLengthOfText1) {
        hieghtOfRemarkLbl=highestLengthOfText4;
    }
    
    NSString *remarkstring = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Remark"]];
    
    
    if (remarkstring.length==0 || [remarkstring isEqualToString:@"(null)"]) {
        hieghtOfRemarkLbl=0;
    }
    
    CGRect frame1 = cell.lblDetail.frame;
    frame1.origin.y=cell.view_diet.frame.origin.y+cell.view_diet.frame.size.height;
    frame1.size.height=hieghtOfDetailLbl;
    cell.lblDetail.frame = frame1;
  
    CGRect frame2 = cell.view_DietBottom.frame;
    frame2.origin.y=cell.lblDetail.frame.origin.y+cell.lblDetail.frame.size.height;
    frame2.size.height=0;
    cell.view_DietBottom.frame = frame2;
    
    
    CGRect frame3 = cell.lbl_remark.frame;
    frame3.origin.y=cell.view_DietBottom.frame.origin.y+cell.view_DietBottom.frame.size.height;
    frame3.size.height=hieghtOfRemarkLbl;
    cell.lbl_remark.frame = frame3;
    
    
    CGRect frame = cell.mainView.frame;
    frame.size.height = cell.lbl_remark.frame.origin.y+cell.lbl_remark.frame.size.height+10;
    cell.mainView.frame = frame;
    cell.ScrView.frame = frame;
    
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)getGroupClass{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    
    
    
    NSString *post =[NSString stringWithFormat:@"XMLcustomerid=<NeoFitnes> <Credential><UserName>%@</UserName><Password>%@</Password></Credential> <WorkoutCard> <Workout><customerid>%@</customerid></Workout></WorkoutCard></NeoFitnes>",UserName,password,MemberID];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetCustomerDietCard"]]];
    
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
    NSDictionary *responseDictonary = [WebXMLParser parseXML:textData];
    if ([responseDictonary objectForKey:@"ErrorMessage"]) {
        NSString*message1=[NSString stringWithFormat:@"%@",[responseDictonary objectForKey:@"ErrorMessage"]];
        _view_norecord.hidden=NO;
        
        [[[UIAlertView alloc] initWithTitle:@"" message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
        return;
    }
    
    id  object=[responseDictonary objectForKey:@"Dietcard"];
    NSLog(@"cc%@",object);
    if([object isKindOfClass:[NSArray class]]){
        mainArray1=object;
        //Is array
    }else if([object isKindOfClass:[NSDictionary class]]){
        [mainArray1 addObject:object];
        //is dictionary
    }
    
    if ([ mainArray1 count] == 0) {
        [self EmptyAlert];
    
    }
    else {
        
        [self setDate];
        [self.tableView reloadData];
    }
    
    
//    NSData *textData = [strText dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:textData];
//    [xmlParser setShouldResolveExternalEntities: YES];
//    parser.delegate = self;
//    [parser parse];
    
}

-(void) EmptyAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Neo fitnes"
                                                                   message:@"Diet-Card not generated"
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                            [self goToHome];
                                                          }]; // 2
//    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Login"
//                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                               if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
//                                                                   [self goToHome];
//
//                                                               } else {
//                                                                   [self goToLogin];
//                                                               }
//
//
//                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
//    [alert addAction:secondAction]; // 5
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
    
}


-(void) goToHome {
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    UIViewController *selectedViewController;
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
//    else
        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
     
     UITabBarController *TABVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTabbarController"];
     
     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];

     [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
     [navController setViewControllers: @[selectedViewController] animated: YES];

     [self.revealViewController setFrontViewController:TABVC];
     
     [TABVC.navigationController pushViewController:selectedViewController animated:YES];
//     if ( revealViewController )
//     {
//         [revealViewController revealToggleEnd];
//     }
     return;
    
//    UITabBarController *tab = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
//    [self.revealViewController setFrontViewController:tab];
//    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    
    
//    [self.navigationController pushViewController:selectedViewController animated:YES];
//    if ( revealViewController )
//    {
//        [revealViewController revealToggleEnd];
//    }
//
//    return;
}





//Implement the NSXmlParserDelegate methods
-(NSMutableAttributedString *)MakeSomePartBold:(NSString*)string and:(int)type{
  
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:string];
    
    UIFont *font_regular=[UIFont fontWithName:@"Helvetica" size:11.0f];
    UIFont *font_bold=[UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
    [attString addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, attString.length)];
    if (type==1) {
     [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(0, 12)];
    }else{
    [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(0, 7)];
}
    return attString;
   
    
}


-(void)setDate{
    NSString *datestring1 = [NSString stringWithFormat:@"  Created Date : %@",[[mainArray1 objectAtIndex:0] objectForKey:@"CreatedDate"]];
   
    NSString *string1 = datestring1 ;
    NSRange range1 = [string1 rangeOfString:@"12:00:00 AM"];
    NSString *shortDateString = [string1 substringToIndex:range1.location];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:shortDateString];
    
    UIFont *font_regular=[UIFont fontWithName:@"Helvetica" size:11.0f];
    UIFont *font_bold=[UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
    [attString addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, shortDateString.length)];
    [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(2, 12)];
    [self.lblCreatedDate setAttributedText:attString];
    NSString *datestring2 = [NSString stringWithFormat:@"  Renewal Date : %@",[[mainArray1 objectAtIndex:0] objectForKey:@"RenewalDate"]];
    NSString *string2 = datestring2 ;
    NSRange range2 = [string2 rangeOfString:@"12:00:00 AM"];
    NSString *shortDateString2 = [string2 substringToIndex:range2.location];
    
    NSMutableAttributedString *attString1=[[NSMutableAttributedString alloc] initWithString:shortDateString2];
    
    
    [attString1 addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, shortDateString2.length)];
    [attString1 addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(2, 12)];
    [self.lblRenewalDate setAttributedText:attString1];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterOperators:searchText];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self filterOperators:searchBar.text];
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self filterOperators:searchBar.text];
     [searchBar resignFirstResponder];
}

- (void)filterOperators:(NSString*)name {
    NSMutableArray * searchResults = [[NSMutableArray alloc]init];
    
    if([name isEqualToString:@""] || name == nil) {
              searchResults = [mainArray1 mutableCopy];
        mainArray1 = searcharray;
        
            }
        else {
        
                NSString *searchName = [name lowercaseString];
        
                NSPredicate *containsPredicate = [NSPredicate predicateWithFormat:@"self.DietList CONTAINS[cd] %@" , searchName];
        
                searchResults = [[mainArray1 filteredArrayUsingPredicate:containsPredicate] mutableCopy];
        mainArray1 =searchResults;
            }
         [self.tableView reloadData];
   
              
}

-(CGFloat)callculateHigestLength:(NSString *)comment {
    CGFloat higestvalue=0;
    NSString *finalstring;
    
    
        CGFloat h1 =[comment length] ;
        if (h1>higestvalue) {
            higestvalue =h1;
            finalstring = comment;
        }
        else{
            higestvalue = higestvalue;
            finalstring =finalstring;
        }
    
    CGFloat width;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0)
    {
        width = [finalstring sizeWithFont:[UIFont systemFontOfSize:12]].width;
    }
    else
    {
        width = ceil([finalstring  sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}].width);
    }
    return width;
}
-(CGFloat)compareWidth:(CGFloat)Lenfth{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        if (Lenfth<250 ) {
            return 250
            ;
        }
        else{
            return Lenfth;
        }
        
    }else{
        
        if (Lenfth<90 ) {
            return 90;
        }
        else{
            return Lenfth;
        }
    }

}
- (CGFloat)getLabelHeight:(UILabel*)label
{
     UIFont *font_regular=[UIFont fontWithName:@"Helvetica" size:11.0f];
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:font_regular}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Enter Your Feedback"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [self moveViewUpOrDown:@"UP"];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Enter Your Feedback";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [self moveViewUpOrDown:@"down"];
    [textView resignFirstResponder];
}
-(BOOL)textViewShouldReturn:(UITextView *)textView{
    
    
    [textView resignFirstResponder];
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    CGFloat origanalY=textView.frame.origin.y;
    CGFloat hieght=textView.frame.size.height;
    if (hieght>=59) {
        return;
    }
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    CGFloat newhight=newFrame.size.height;
    
    CGFloat differencehieght=newhight-hieght;
    newFrame.origin.y=origanalY- differencehieght;
    
    textView.frame = newFrame;
}
-(void)setTextviewHieght:(UITextView*)textView{
    CGFloat origanalY=textView.frame.origin.y;
    CGFloat hieght=textView.frame.size.height;
    CGFloat contantsize = textView.contentSize.height-13;
    if (contantsize<hieght) {
        return;
    }
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    CGFloat newhight=newFrame.size.height;
    
    CGFloat differencehieght=newhight-hieght;
    newFrame.origin.y=origanalY- differencehieght;
    
    textView.frame = newFrame;
    

}
-(void)moveViewUpOrDown:(NSString *)string{
  if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
      return;
  }
    CGFloat upDownValue = 0;
    if ([string isEqualToString:@"UP"])
        upDownValue = -80;
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
@end
