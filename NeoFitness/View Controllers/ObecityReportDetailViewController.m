//
//  ObecityReportDetailViewController.m
//  NeoFitness
//
//  Created by Sumit on 18/05/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import "ObecityReportDetailViewController.h"
#import "XMLReader.h"
#import "SWRevealViewController.h"
#import "ObecityReportDetailTableViewCell.h"
#import "ObesitySessionDetailTableViewCell.h"
#import "ObesitySessionPopupViewTableViewCell.h"
#import "ObecityReportViewController.h"
#import "WebXMLParser.h"
#import "XMLDictionary.h"


@interface ObecityReportDetailViewController (){
    NSArray *responseObj;
  ;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
 
    NSString *errorMessage;

     NSMutableArray * bodyCompositionArray;
     NSMutableArray * sessionArray;
    NSMutableArray * nameArray;
    
    bool xml;
    CGFloat higestHieght;
    bool first;
    NSInteger clickedBtnTag;
    
    
}
@property (strong, nonatomic) IBOutlet UITableView *TableView_obesitySessionPopUp;
@property (strong, nonatomic) IBOutlet UIView *view_header;
@property (strong, nonatomic) IBOutlet UILabel *lbl_sessionName;
@property (strong, nonatomic) IBOutlet UIView *view_sessionDetailPopUp;

@property (strong, nonatomic) IBOutlet UIButton *btn_crossTaped;
@property (strong, nonatomic) IBOutlet UIView *view_norecord;
@property (strong, nonatomic) IBOutlet UIButton *Btnclose;
@property (weak, nonatomic) IBOutlet UITableView *table_bodyComposition;
@property (weak, nonatomic) IBOutlet UITableView *table_session;
@property (weak, nonatomic) IBOutlet UIScrollView *scr_main;
@property (weak, nonatomic) IBOutlet UIButton *btn_bodyCompisition;
@property (weak, nonatomic) IBOutlet UIButton *btn_session;
@property (weak, nonatomic) IBOutlet UIView *view_moving;
@property (nonatomic) CGFloat lastContentOffset;
@end

@implementation ObecityReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scr_main.delegate=self;
    higestHieght=0;
    clickedBtnTag=0;
    _scr_main.decelerationRate=UIScrollViewDecelerationRateFast;
    _scr_main.contentSize=CGSizeMake(2*self.view.frame.size.width, 10);
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //[self.sidebarButton setTarget: self.revealViewController];
        //[self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    bodyCompositionArray =[[NSMutableArray alloc]init];
    sessionArray=[[NSMutableArray alloc]init];

   
    nameArray =[[NSMutableArray alloc]initWithObjects:@"Neck",@"Chest 4\" below arm pit",@"Tummy Region of maximum girth while lying down",@"Waist 1\" above the iliac crest",@"Hip 1\" most prominent widest part of the hip while lying down",@"Thighs 9\"above the outermost edge if bent knee [RIGHT]",@"Thighs 9\"above the outermost edge if bent knee [LEFT]",@"Arms 9\"mid Pt. between upper bony prominence at shoulder & elbow [Right]",@"Arms 9\"mid Pt. between upper bony prominence at shoulder & elbow [LEFT]",@"WEIGHT",@"TOTAL WEIGHT LOSS",@"Total Inch Loss",@"Post Therapy Weight Loss",@"Post Therapy Inch Loss", nil];
  
   
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = NO;
    
    //[[[UIAlertView alloc] initWithTitle:@"" message:@"Attendance not generated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    // Dispose of any resources that can be recreated.
    [self GetObesityBCADetail];
    [self GetObesitySessionDetail];

   
    
    
    
        if ((sessionArray.count==0 &&bodyCompositionArray.count==0 )) {
            _view_norecord.hidden=NO;
           // NSString*string = [NSString stringWithFormat:@"%@",[ErrorMessage objectAtIndex:0]];
            [[[UIAlertView alloc] initWithTitle:@"" message:@"NO RECORD FOUND" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            return;
        }
        _view_norecord.hidden=YES;
   
  
    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [_btn_crossTaped addTarget:self action:@selector(crossTaped:) forControlEvents:UIControlEventTouchUpInside];
    [_Btnclose addTarget:self action:@selector(crossTaped:) forControlEvents:UIControlEventTouchUpInside];
     [_btn_bodyCompisition addTarget:self action:@selector(btn_bodyCompisitionTaped:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_session addTarget:self action:@selector(btn_sessionTaped:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)btn_sessionTaped:(id)sender{
    [_scr_main scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0, _scr_main.frame.size.width, _scr_main.frame.size.height) animated:YES];
    [self setMovingFrame:sender];
    
}
    
-(void)btn_bodyCompisitionTaped:(id)sender{
    [_scr_main scrollRectToVisible:CGRectMake(0, 0, _scr_main.frame.size.width, _scr_main.frame.size.height) animated:YES];
    [self setMovingFrame:sender];
    
}
-(void)setMovingFrame:(id)sender{
    UIButton*btn=(UIButton*)sender;
    CGRect frame =self.view_moving.frame;
    frame.origin.x=btn.frame.origin.x;
    self.view_moving.frame=frame;
}
-(void)setMovingFrame1:(UIScrollView *)scrollView{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        float x = ((scrollView.contentOffset.x)/2);
        CGRect frame =self.view_moving.frame;
        
        frame.origin.x=x;
        self.view_moving.frame=frame;
        
    }else{
        
        float x = ((scrollView.contentOffset.x)/2);
        CGRect frame =self.view_moving.frame;
        
        frame.origin.x=x;
        self.view_moving.frame=frame;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setMovingFrame1:_scr_main];
    
    float x = scrollView.contentOffset.x;
    
    NSLog(@"newcontantoffset%f", x);
    
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.lastContentOffset = scrollView.contentOffset.x;
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat contentOffset = _scr_main.contentOffset.x;
    CGFloat contentOffset1 = _scr_main.contentOffset.x;
    if(contentOffset1<=self.view.frame.size.width/2){
        [_scr_main scrollRectToVisible:CGRectMake(0, 0, _scr_main.frame.size.width, _scr_main.frame.size.height) animated:YES];
    }
    else if (contentOffset1>self.view.frame.size.width/2 && contentOffset1<=self.view.frame.size.width) {
        
        
        [_scr_main scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0, _scr_main.frame.size.width, _scr_main.frame.size.height) animated:YES];
    }
    else if (contentOffset1>self.view.frame.size.width && contentOffset1<=(self.view.frame.size.width+self.view.frame.size.width/2)){
        [_scr_main scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0, _scr_main.frame.size.width, _scr_main.frame.size.height) animated:YES];
    }else{
        [_scr_main scrollRectToVisible:CGRectMake(2*self.view.frame.size.width, 0, _scr_main.frame.size.width, _scr_main.frame.size.height) animated:YES];
    }
    
    [self setMovingFrame1:_scr_main];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat contentOffset = _scr_main.contentOffset.x;
    CGFloat contentOffset1 = _scr_main.contentOffset.x;
    if(contentOffset1<=self.view.frame.size.width/2){
        [_scr_main scrollRectToVisible:CGRectMake(0, 0, _scr_main.frame.size.width, _scr_main.frame.size.height) animated:YES];
    }
    else if (contentOffset1>self.view.frame.size.width/2 && contentOffset1<=self.view.frame.size.width) {
        
        
        [_scr_main scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0, _scr_main.frame.size.width, _scr_main.frame.size.height) animated:YES];
    }
    else if (contentOffset1>self.view.frame.size.width && contentOffset1<=(self.view.frame.size.width+self.view.frame.size.width/2)){
        [_scr_main scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0, _scr_main.frame.size.width, _scr_main.frame.size.height) animated:YES];
    }else{
        [_scr_main scrollRectToVisible:CGRectMake(2*self.view.frame.size.width, 0, _scr_main.frame.size.width, _scr_main.frame.size.height) animated:YES];
    }
    [self setMovingFrame1:_scr_main];
}

-(void)crossTaped:(id)sender{
    _view_sessionDetailPopUp.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       if(tableView==self.TableView_obesitySessionPopUp) {
           return 14;
       } else if (tableView==self.table_bodyComposition){
           return bodyCompositionArray.count;
       }
       else if (tableView==self.table_session){
           return sessionArray.count;
       }else
           return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(tableView==self.TableView_obesitySessionPopUp) {
        return 61;
    }
    else if (tableView==self.table_bodyComposition){
        return 316;
    }
    else if (tableView==self.table_session){
        return 204;
    }else
     return 204;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier1 =@"ObacityReportCell";
    NSString *CellIdentifier2 = @"ObesitySessionDetailCell";
     NSString *CellIdentifier3 = @"ObesitySessionPopupViewCell";
    UITableViewCell*CELL;
    if(tableView==self.TableView_obesitySessionPopUp) {
        ObesitySessionPopupViewTableViewCell *cell =(ObesitySessionPopupViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
     
        if (indexPath.row==14) {
          
        }
        else
            cell.CellMainLabel.text=[NSString stringWithFormat:@"%@",[nameArray objectAtIndex:indexPath.row]];
         [self showpopUpView:cell and:indexPath];
        
       
        return cell;

    }
   else if (tableView==self.table_bodyComposition) {
        ObecityReportDetailTableViewCell *cell =(ObecityReportDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        [self showView:cell and:indexPath];
        return cell;

    }
     else if (tableView==self.table_session){
        ObesitySessionDetailTableViewCell *cell =(ObesitySessionDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        [self showSessionView:cell and:indexPath];
        return cell;
   
    }else
        return CELL;
    }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     if(tableView==self.TableView_obesitySessionPopUp) {
         
    return self.view_header.frame.size.height;
     }
    else
        return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.view_header;
}
-(void)GetObesityBCADetail{
    first=YES;
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    NSString *  TargetId =self.TargetId;
    NSString *post =[NSString stringWithFormat:@"Customerdetail=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><Obesity><BCA><CustomerId>%@</CustomerId><TargetId>%@</TargetId></BCA></Obesity></NeoFitnes>",UserName,password,MemberID,TargetId];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetObesityBCADetail"]]];
    
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
       // [[[UIAlertView alloc] initWithTitle:@"" message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
    id  object=[[responseDictonary objectForKey:@"Obesity"]objectForKey:@"BCA"];
    NSLog(@"cc%@",object);
    if([object isKindOfClass:[NSArray class]]){
        bodyCompositionArray=object;
        //Is array
    }else if([object isKindOfClass:[NSDictionary class]]){
        [bodyCompositionArray addObject:object];
        //is dictionary
    }
  
    
    [self.table_bodyComposition reloadData];

//    
}

-(void)GetObesitySessionDetail{
    first=NO;
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    NSString *  TargetId =self.TargetId;
    NSString *post =[NSString stringWithFormat:@"Customerdetail=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><Obesity><Session><CustomerId>%@</CustomerId><TargetId>%@</TargetId></Session></Obesity></NeoFitnes>",UserName,password,MemberID,TargetId];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetObesitySessionDetail"]]];
    
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
    
    NSString *strText = [[dictionary objectForKey:@"string"] valueForKey:@"text"];
    
    
    NSData *textData = [strText dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseDictonary = [WebXMLParser parseXML:textData];
    if ([responseDictonary objectForKey:@"ErrorMessage"]) {
        NSString*message1=[NSString stringWithFormat:@"%@",[responseDictonary objectForKey:@"ErrorMessage"]];
       // [[[UIAlertView alloc] initWithTitle:@"" message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
    id  object=[[responseDictonary objectForKey:@"Obesity"]objectForKey:@"Session"];
     NSLog(@"cc%@",object);
    if([object isKindOfClass:[NSArray class]]){
        sessionArray=object;
        //Is array
    }else if([object isKindOfClass:[NSDictionary class]]){
        [sessionArray addObject:object];
        //is dictionary
    }
    
    
    [self.table_session reloadData];
    
}



//Implement the NSXmlParserDelegate methods


-(void)showpopUpView:(ObesitySessionPopupViewTableViewCell *)cell and:(NSIndexPath*)indexPath{
    if (sessionArray.count>0) {
        
    
    NSDictionary*currentdict=[sessionArray objectAtIndex:clickedBtnTag];
    
    for (UIView *view in [cell.contentView subviews]){
        if(view.tag != 1004 && view.tag != 1003 && view.tag != 1002 && view.tag != 1001 && view.tag != 1000 && view.tag != 999 ){
            [view removeFromSuperview];
        }
    }
    CGRect frame =cell.textfield_before.frame;
    CGFloat width;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        width =119;
    }else
     width =56;
    frame.size.width=width;
    cell.textfield_before.frame=frame;

    cell.textfield_difference.hidden=NO;
    cell.textfield_after.hidden=NO;
    cell.textfield_before.hidden=NO;
    cell.CellMainLabel.hidden=NO;
//    if (SessionNo.count) {
//        <#statements#>
//    }
    self.lbl_sessionName.text=[NSString stringWithFormat:@"Session %@",[currentdict objectForKey:@"SessionNo"]];
    if (indexPath.row==0) {
        cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"NeckBefore"]];
        cell.textfield_after.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"NeckAfter"]];
        cell.textfield_difference.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"NeckDifference"]];
    }
   else if (indexPath.row==1) {
        cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"ChestBefore"]];
        cell.textfield_after.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"ChestAfter"]];
        cell.textfield_difference.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"ChestDifference"]];
    }
   else if (indexPath.row==2) {
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"TummyBefore"]];
       cell.textfield_after.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"TummyAfter"]];
       cell.textfield_difference.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"TummyDifference"]];
   }
   else if (indexPath.row==3) {
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"WaistBefore"]];
       cell.textfield_after.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"WaistAfter"]];
       cell.textfield_difference.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"WaistDifference"]];
   }
   else if (indexPath.row==4) {
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"HipBefore"]];
       cell.textfield_after.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"HipAfter"]];
       cell.textfield_difference.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"HipDifference"]];
   }
   else if (indexPath.row==5) {
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"RightThighBefore"]];
       cell.textfield_after.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"RightThighAfter"]];
       cell.textfield_difference.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"RightThighDifference"]];
   }
   else if (indexPath.row==6) {
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"LeftThighBefore"]];
       cell.textfield_after.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"LeftThighAfter"]];
       cell.textfield_difference.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"LeftThighDifference"]];
   }
   else if (indexPath.row==7) {
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"RightArmBefore"]];
       cell.textfield_after.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"RightArmAfter"]];
       cell.textfield_difference.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"RightArmDifference"]];
   }
   else if (indexPath.row==8) {
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"LeftArmBefore"]];
       cell.textfield_after.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"LeftArmAfter"]];
       cell.textfield_difference.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"LeftArmDifference"]];
   }
   else if (indexPath.row==9) {
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"WeightBefore"]];
       cell.textfield_after.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"WeightAfter"]];
       cell.textfield_difference.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"WeightDifference"]];
   }
   else if (indexPath.row==10) {
       cell.textfield_difference.hidden=YES;
       cell.textfield_after.hidden=YES;

       CGRect frame =cell.textfield_before.frame;
       CGFloat width;
       if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
          width =240;
       }else
        width =120;
       frame.size.width=width;
       cell.textfield_before.frame=frame;
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"TotalWeightLoss"]];
          }
   else if (indexPath.row==11) {
       cell.textfield_difference.hidden=YES;
       cell.textfield_after.hidden=YES;
       CGRect frame =cell.textfield_before.frame;
       CGFloat width;
       if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
           width =240;
       }else
           width =120;
       frame.size.width=width;
       cell.textfield_before.frame=frame;
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"TotalCMLoss"]];
   }
   else if (indexPath.row==12) {
       cell.textfield_difference.hidden=YES;
       cell.textfield_after.hidden=YES;
       CGRect frame =cell.textfield_before.frame;
       CGFloat width;
       if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
           width =240;
       }else
           width =120;
       frame.size.width=width;
       cell.textfield_before.frame=frame;
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"PostTherapyWeightLoss"]];
   }

   else if (indexPath.row==13) {
       cell.textfield_difference.hidden=YES;
       cell.textfield_after.hidden=YES;
       CGRect frame =cell.textfield_before.frame;
       CGFloat width;
       if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
           width =240;
       }else
           width =120;
       frame.size.width=width;
       cell.textfield_before.frame=frame;
       cell.textfield_before.text=[NSString stringWithFormat:@"%@",[currentdict objectForKey:@"PostTherapyInchLoss"]];
   }

   else if (indexPath.row==14) {
       cell.textfield_difference.hidden=YES;
       cell.textfield_after.hidden=YES;
       cell.textfield_before.hidden=YES;
       cell.CellMainLabel.hidden=YES;
       UIButton *BtnView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
       if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
           BtnView.frame=CGRectMake(0, 6, 768, 50);

       }else
       BtnView.frame=CGRectMake(0, 6, 320, 40);

       [BtnView setTitle:@"Close" forState:UIControlStateNormal];

       [BtnView addTarget:self action:@selector(crossTaped:) forControlEvents:UIControlEventTouchUpInside];
       //BtnView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
       BtnView.titleLabel.font = [UIFont systemFontOfSize:7.0];
       [BtnView setBackgroundColor:[UIColor redColor]];
       [BtnView setTitleColor:[UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1] forState:UIControlStateNormal];


       [cell.contentView addSubview:BtnView];

   }

    }
}


-(void)showView:(ObecityReportDetailTableViewCell *)cell and:(NSIndexPath*)indexPath{
    
    cell.lbl_createdDate.text=[NSString stringWithFormat:@"%@",[[bodyCompositionArray objectAtIndex:indexPath.row]objectForKey:@"CreatedDate"]];
      cell.lbl_CreatedBy.text=[NSString stringWithFormat:@"%@",[[bodyCompositionArray objectAtIndex:indexPath.row]objectForKey:@"CreatedBy"]];
      cell.lbl_MBR.text=[NSString stringWithFormat:@"%@",[[bodyCompositionArray objectAtIndex:indexPath.row]objectForKey:@"MBR"]];
      cell.lbl_BodyFat.text=[NSString stringWithFormat:@"%@",[[bodyCompositionArray objectAtIndex:indexPath.row]objectForKey:@"BodyFat"]];
    
    cell.VisceralFat.text=[NSString stringWithFormat:@"%@",[[bodyCompositionArray objectAtIndex:indexPath.row]objectForKey:@"VisceralFat"]];
    cell.lbl_BodyAge.text=[NSString stringWithFormat:@"%@",[[bodyCompositionArray objectAtIndex:indexPath.row]objectForKey:@"BodyAge"]];
    cell.lbl_BMI.text=[NSString stringWithFormat:@"%@",[[bodyCompositionArray objectAtIndex:indexPath.row]objectForKey:@"BMI"]];
    cell.lbl_RestingMetabolism.text=[NSString stringWithFormat:@"%@",[[bodyCompositionArray objectAtIndex:indexPath.row]objectForKey:@"RestingMetabolism"]];
    
}

-(void)setPropertyoflabel:(UILabel*)label and:(int) type{
    if (type==1) {
         label.textAlignment = NSTextAlignmentLeft;
        [label setFont:[UIFont systemFontOfSize:12]];
    label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];    
    }else{
        label.textAlignment = NSTextAlignmentRight;
        [label setFont:[UIFont boldSystemFontOfSize:12]];
        label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];  
    }
    
//    label.layer.borderColor = [[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:.3] CGColor];
//    label.layer.borderWidth=.50f;
    label.numberOfLines = 0;
    
    
  //  label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];;
    
    
}


-(void)showSessionView:(ObesitySessionDetailTableViewCell *)cell and:(NSIndexPath*)indexPath{

        
     cell.Lbl_session.text=[NSString stringWithFormat:@"%@",[[sessionArray objectAtIndex:(indexPath.row)]objectForKey:@"SessionNo"]];
     cell.Lbl_cretedDate.text=[NSString stringWithFormat:@"%@",[[sessionArray objectAtIndex:(indexPath.row)]objectForKey:@"CreatedDate"]];
     cell.Lbl_Therepistname.text=[NSString stringWithFormat:@"%@",[[sessionArray objectAtIndex:(indexPath.row)]objectForKey:@"Therepist"]];
     cell.Lbl_totalInchLoss.text=[NSString stringWithFormat:@"%@",[[sessionArray objectAtIndex:(indexPath.row)]objectForKey:@"TotalCMLoss"]];
     cell.Lbl_totalweightLoss.text=[NSString stringWithFormat:@"%@",[[sessionArray objectAtIndex:(indexPath.row)]objectForKey:@"TotalWeightLoss"]];
    cell.btn_detailedView.tag=(indexPath.row);
    [cell.btn_detailedView addTarget:self action:@selector(ViewTaped:) forControlEvents:UIControlEventTouchUpInside];
     
        
       }

-(void)ViewTaped:(id)sender{
    UIButton*btn=(UIButton*)sender;
    clickedBtnTag=btn.tag;
    _view_sessionDetailPopUp.hidden=NO;
    [self.TableView_obesitySessionPopUp reloadData];

}


-(void)getLabelHeight:(UILabel*)label {
    
   
    
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    
    
        CGFloat h1 =size.height; ;
        if (h1>higestHieght) {
            higestHieght =h1;
        }
          
    }

- (IBAction)backTaped:(id)sender
{
    UIStoryboard* mainStoryBoard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    else
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    
    
    ObecityReportViewController* viewCtrl_loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ObecityReportViewController"];
    
    // viewCtrl_loginVC.controller =@"CalCViewController";
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewCtrl_loginVC];
    
    [viewCtrl_loginVC.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
    [navController setViewControllers: @[viewCtrl_loginVC] animated: YES];
    
    self.revealViewController.frontViewController = navController;

}


@end
