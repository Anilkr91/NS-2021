//
//  TodayTrainersViewController.m
//  NeoFitness
//
//  Created by Sumit on 20/09/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import "TodayTrainersViewController.h"
#import "TodayTrainerTableViewCell.h"
#import "XMLReader.h"
#import "Utility.h"
#import "WebXMLParser.h"
#import "SWRevealViewController.h"
#import "MainGridViewController.h"
@interface TodayTrainersViewController (){
    NSMutableArray*responseArray;
    NSInteger previoustag;
    NSInteger ratingBtnTag;
}
@property (weak, nonatomic) IBOutlet UITableView *table_gettrainer;
@property (weak, nonatomic) IBOutlet UIView *view_rating;
@property (weak, nonatomic) IBOutlet UIButton *btn_submitFeedback;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UIButton *btn_viewratingCross;
@property (weak, nonatomic) IBOutlet UILabel *lbl_trainerName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_workoutDate;

@end

@implementation TodayTrainersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ratingBtnTag=-1;
    _view_rating.hidden=YES;
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
    self.btn_submitFeedback.layer.cornerRadius=10.0f;
    self.view_rating.layer.borderColor=[UIColor lightGrayColor].CGColor;
     self.view_rating.layer.cornerRadius=10.0f;
    self.view_rating.layer.borderWidth=1.0f;
    responseArray=[[NSMutableArray alloc]init];
    if ([Utility connected]) {
        [self getTrainer];

    }
    //        if (!(ErrorMessage.count==0)) {
    //            _view_norecord.hidden=NO;
    //            NSString*string = [NSString stringWithFormat:@"%@",[ErrorMessage objectAtIndex:0]];
    //            [[[UIAlertView alloc] initWithTitle:@"" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    //            return;
    //        }
    //        _view_norecord.hidden=YES;
    //        [self getValue];
    
    //}
    else{
        [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"NO Internate Connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    // Do any additional setup after loading the view.
}
-(void)checkRating{
    if ([Utility connected]) {
        [self getTrainer];
        if (responseArray.count>0) {
            
            
            int  rating=[NSString stringWithFormat:@"%@",[[responseArray objectAtIndex:responseArray.count-1]objectForKey:@"Rating"]].intValue;
            if (rating==0) {
                _view_rating.hidden=NO;
                _table_gettrainer.hidden=YES;
                
                ratingBtnTag=responseArray.count-1;
                
            }else{
                _view_rating.hidden=YES;
                _table_gettrainer.hidden=NO;
                
            }
            
            
            
        }
    }
    //        if (!(ErrorMessage.count==0)) {
    //            _view_norecord.hidden=NO;
    //            NSString*string = [NSString stringWithFormat:@"%@",[ErrorMessage objectAtIndex:0]];
    //            [[[UIAlertView alloc] initWithTitle:@"" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    //            return;
    //        }
    //        _view_norecord.hidden=YES;
    //        [self getValue];
    
    //}
    else{
        [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"NO Internate Connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [_btn_submitFeedback addTarget:self action:@selector(SubmitFeedbackTaped:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_viewratingCross addTarget:self action:@selector(btn_viewratingCrossTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self setTaponimage:_imageView1];
     [self setTaponimage:_imageView2];
     [self setTaponimage:_imageView3];
     [self setTaponimage:_imageView4];
     [self setTaponimage:_imageView5];
    _btn_submitFeedback.layer.borderWidth=1.0f;
    _btn_submitFeedback.layer.cornerRadius=10.0f;
    //cell.btn_comment.titleLabel.textColor=   [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
   _btn_submitFeedback.layer.borderColor=   [UIColor lightGrayColor].CGColor;
    
    _btn_viewratingCross.layer.borderWidth=1.0f;
    _btn_viewratingCross.layer.cornerRadius=10.0f;
    //cell.btn_comment.titleLabel.textColor=   [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    _btn_viewratingCross.layer.borderColor=   [UIColor lightGrayColor].CGColor;

}


-(void)RatingTaped:(id)sender   {
    
    UIImageView *imageview = (UIImageView *)[(UITapGestureRecognizer*)sender view];
    
    NSInteger tag=imageview.tag;
    
    
    for (int i=1; i<=5; i++) {
         UIImageView *myImageView = (UIImageView *)[_view_rating viewWithTag:i];
        if (i<=tag) {
            
            if (i<tag) {
                 myImageView.image=[UIImage imageNamed:@"favorite.png"];
            }else{
                if (previoustag==tag) {
                    UIImageView *myImageView = (UIImageView *)[_view_rating viewWithTag:tag];
                    UIImage *secondImage = [UIImage imageNamed:@"star.png"];
                    
                    NSData * imgData1 = UIImagePNGRepresentation(myImageView.image);
                    NSData * imgData2 = UIImagePNGRepresentation(secondImage);
                    
                    BOOL isCompare =  [imgData1 isEqual:imgData2];
                    if(isCompare)
                    {
                        NSLog(@"Image View contains image.png");
                        
                        myImageView.image=[UIImage imageNamed:@"favorite.png"];
                        
                    }
                    else
                    {
                        NSLog(@"Image View doesn't contains image.png");
                        myImageView.image=[UIImage imageNamed:@"star.png"];
                        
                        
                    }
                }else{
                   myImageView.image=[UIImage imageNamed:@"favorite.png"];
                }
   
            }
           
           
        }else{
            myImageView.image=[UIImage imageNamed:@"star.png"];
        }
    }
    
    
    
previoustag=tag;
    
//    UIImage* checkImage = [UIImage imageNamed:@"star.png"];
//    NSData *checkImageData = UIImagePNGRepresentation(checkImage);
//    NSData *propertyImageData = UIImagePNGRepresentation(imageview.image);
//    if ([checkImageData isEqualToData:propertyImageData]) {
//         imageview.image=[UIImage imageNamed:@"favorite.png"];
//        
//        UIImageView *myImageView = (UIImageView *)[_view_rating viewWithTag:(tag+1)];
//        myImageView.userInteractionEnabled=YES;
//        imageview.userInteractionEnabled=YES;
//    }
//   
//       
//    else{
//        imageview.image = [UIImage imageNamed:@"star.png"] ;
//    
//}
}
-(void)setTaponimage:(UIImageView*)imageview{
    UITapGestureRecognizer *SaddaAddaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (RatingTaped:)];
    UIImage* checkImage = [UIImage imageNamed:@"star.png"];
    imageview.image=checkImage;
 
    [imageview setUserInteractionEnabled:YES];
  
    [imageview addGestureRecognizer: SaddaAddaTap];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int  rating=[NSString stringWithFormat:@"%@",[[responseArray objectAtIndex:indexPath.row]objectForKey:@"Rating"]].intValue;
    NSString *CellIdentifier =@"TodayTrainerCell";
    TodayTrainerTableViewCell *cell =(TodayTrainerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CGFloat y=cell.imageview5.frame.origin.y+cell.imageview5.frame.size.height+8+20;
     CGFloat y1=cell.btn_addRating.frame.origin.y+cell.btn_addRating.frame.size.height+8+20;
    if (rating==0) {
        return y1;
    }else{
      return y;
    }
    
    
    
    //return 69;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return responseArray.count;
    // Return the number of rows in the section.
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"TodayTrainerCell";
    TodayTrainerTableViewCell *cell =(TodayTrainerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.lbl_TrainerName.text = [NSString stringWithFormat:@"%@",[[responseArray objectAtIndex:indexPath.row]objectForKey:@"TrainerName"]];
  //cell.lbl_CreatedBy.text = [NSString stringWithFormat:@"%@",[[responseArray objectAtIndex:indexPath.row]objectForKey:@"CreatedBy"]];
   // cell.Status.text = [NSString stringWithFormat:@"%@",[[responseArray objectAtIndex:indexPath.row]objectForKey:@"Status"]];
    NSString*DateString=[NSString stringWithFormat:@"%@",[[responseArray objectAtIndex:indexPath.row]objectForKey:@"CreatedDate"]];
    cell.lbl_CreatedDate.text=DateString;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//    NSDate *date  = [dateFormatter dateFromString:DateString];
//    
//    // Convert to new Date Format
//    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//    NSString *newDate = [dateFormatter stringFromDate:date];
//    cell.lbl_CreatedDate.text =newDate;
   int  rating=[NSString stringWithFormat:@"%@",[[responseArray objectAtIndex:indexPath.row]objectForKey:@"Rating"]].intValue;
    
    
    
    
    //int rating=3;
    for (int i=1; i<=rating; i++) {
     UIImageView *myImageView = (UIImageView *)[cell.cellMainView viewWithTag:i];
        myImageView.image=[UIImage imageNamed:@"favorite.png"];
        
    }
  
    [cell.btn_addRating addTarget:self action:@selector(ratingTaped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_addRating.tag=indexPath.row;
    cell.btn_addRating.layer.cornerRadius=10.0f;
    cell.btn_addRating.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.btn_addRating.layer.cornerRadius=10.0f;
    cell.btn_addRating.layer.borderWidth=1.0f;
    CGRect frame=cell.cellLineView.frame;
    CGRect frame1=cell.cellMainView.frame;
    CGFloat y=cell.imageview5.frame.origin.y+cell.imageview5.frame.size.height+8+10;
    CGFloat y1=cell.btn_addRating.frame.origin.y+cell.btn_addRating.frame.size.height+8+10;
    
    if (rating==0) {
        cell.btn_addRating.hidden=NO;
        
        frame.origin.y=y1-10;
        cell.cellLineView.frame=frame;
        frame1.size.height=y1;
        cell.cellMainView.frame=frame1;
        
    }else{
     cell.btn_addRating.hidden=YES;
        frame.origin.y=y-10;
        cell.cellLineView.frame=frame;
        frame1.size.height=y;
        cell.cellMainView.frame=frame1;

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)getTrainer{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    
    
    
    NSString *post =[NSString stringWithFormat:@"Customerdetail=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><GetCustomerAssignedTrainer><CustomerId>%@</CustomerId></GetCustomerAssignedTrainer></NeoFitnes>",UserName,password,MemberID];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetCustomerAssignedTrainer"]]];
    
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
        [[[UIAlertView alloc] initWithTitle:@"" message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
  id  object=[[responseDictonary objectForKey:@"GetCustomerAssignedTrainer"]objectForKey:@"AssignedTrainer"];
    if([object isKindOfClass:[NSArray class]]){
        responseArray=object;
        //Is array
    }else if([object isKindOfClass:[NSDictionary class]]){
        [responseArray addObject:object];
        //is dictionary
    }
//    NSDictionary *view1 = @{
//                            @"CreatedBy" : @"23797",
//                            @"CreatedDate" : @"10/4/2017 12:00:00 AM",
//                            @"CustomerId" : @"172752",
//                            @"Id" : @"1255433",
//                            @"Rating" :@"",
//                            @"Status" : @"True",
//                            @"TrainerId" : @"2200",
//                            @"TrainerName" : @"TRAINERP",
//                            };
//
//    NSDictionary *view2 = @{
//                            @"CreatedBy" : @"23797",
//                            @"CreatedDate" : @"0/4/2017 12:00:00 AM",
//                            @"CustomerId" : @"172752",
//                            @"Id" : @"125543",
//                            @"Rating" :@"",
//                            @"Status" : @"True",
//                            @"TrainerId" : @"2210",
//                            @"TrainerName" : @"TRAINERPrabhdeep",
//                            };
////
////    NSDictionary *view3 = @{
////                            @"CreatedBy" : @"23797",
////                            @"CreatedDate" : @"0/4/2017 12:00:00 AM",
////                            @"CustomerId" : @"172752",
////                            @"Id" : @"125543",
////                            @"Rating" :@"3",
////                            @"Status" : @"True",
////                            @"TrainerId" : @"2210",
////                            @"TrainerName" : @"TRAINERPrabhdeep",
////                            };
   
    [self.table_gettrainer reloadData];
    
}

-(void)ratingTaped:(id)sender{
    UIButton*btn=(UIButton*)sender;
    ratingBtnTag=btn.tag;
    for (int i=1; i<=5; i++) {
        UIImageView *myImageView = (UIImageView *)[_view_rating viewWithTag:i];
        myImageView.image = [UIImage imageNamed:@"star.png"];
    }
    _view_rating.hidden=NO;
    self.lbl_trainerName.text = [NSString stringWithFormat:@"%@",[[responseArray objectAtIndex:ratingBtnTag]objectForKey:@"TrainerName"]];
    
    NSString*DateString=[NSString stringWithFormat:@"%@",[[responseArray objectAtIndex:ratingBtnTag]objectForKey:@"CreatedDate"]];
    self.lbl_workoutDate.text=DateString;
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [self initialDelayEndeddropDownView:@"show"];
    
    
}
-(void)SubmitFeedbackTaped:(id)sender{
    
    [self inserratingfortrainer];
}
-(void)btn_viewratingCrossTaped:(id)sender{
    ratingBtnTag=-1;
    
 [self initialDelayEndeddropDownView:@"hide"];
}

-(void)initialDelayEndeddropDownView:(NSString*)str

{
    if ([str isEqualToString:@"show"]) {
        self.view_rating.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    }
    else{
        self.view_rating.transform = CGAffineTransformIdentity;
    }
    
    //self.viewForgotPassword.alpha = 1.0;
    
    [UIView beginAnimations:str context:nil];
    
    [UIView setAnimationDuration:.1];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished1:finished:context:)];
    
    //  self.main_scrview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
    
    [UIView commitAnimations];
    
}



- (void)animationFinished1:(NSString *)a finished:(BOOL)finished context:(void *)context

{
    
    [UIView beginAnimations:a context:nil];
    
    [UIView setAnimationDuration:0.1];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished2:finished:context:)];
    if ([a isEqualToString:@"show"]) {
        self.view_rating.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    }
    else{
        self.view_rating.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    }
    [UIView commitAnimations];
    
}



- (void)animationFinished2:(NSString *)a finished:(BOOL)finished context:(void *)context

{
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.1];
    if ([a isEqualToString:@"show"]) {
        self.view_rating.transform = CGAffineTransformIdentity;
    }else{
        self.view_rating.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        
    }
    
    [UIView commitAnimations];
    
    if ([a isEqualToString:@"show"]) {
    }else{
        _view_rating.hidden=YES;
    }
    
    
    
}
-(void)inserratingfortrainer{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  TrainerId =[NSString stringWithFormat:@"%@" ,[ [responseArray objectAtIndex:ratingBtnTag ]objectForKey :@"Id"]];
    NSInteger Givenrating=0;
    for (int i=1; i<=5; i++) {
        UIImageView *myImageView = (UIImageView *)[_view_rating viewWithTag:i];
        UIImage *secondImage = [UIImage imageNamed:@"favorite.png"];
        
        NSData * imgData1 = UIImagePNGRepresentation(myImageView.image);
        NSData * imgData2 = UIImagePNGRepresentation(secondImage);
        
        BOOL isCompare =  [imgData1 isEqual:imgData2];
        if(isCompare)
        {
            Givenrating=Givenrating+1;
        }
        
    }
    
    if (Givenrating<=0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please Provide Rating For  Trainer" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    [self initialDelayEndeddropDownView:@"hide"];
    NSString* Rating=[NSString stringWithFormat:@"%ld",(long)Givenrating];
    
    
    NSString *post =[NSString stringWithFormat:@"strXMLs=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><Mobile><InsertCustomerAssignedTrainerRating><Id>%@</Id><Rating>%@</Rating></InsertCustomerAssignedTrainerRating></Mobile></NeoFitnes>",UserName,password,TrainerId,Rating];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/InsertCustomerAssignedTrainerRating"]]];
    
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
        [[[UIAlertView alloc] initWithTitle:@"" message:message1 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
        _table_gettrainer.hidden=NO;
        _view_rating.hidden=YES;
        [self getTrainer];
        return;
    }
   // responseArray=[[responseDictonary objectForKey:@"GetCustomerAssignedTrainer"]objectForKey:@"AssignedTrainer"];
   // [self.table_gettrainer reloadData];
 
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIStoryboard* mainStoryBoard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
        }
        else{
            mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
        }
        
        MainGridViewController*   controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainGridViewController"];
        
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [controller.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[controller] animated: YES];
        
        self.revealViewController.frontViewController = navController;
        
    }
    
}

@end
