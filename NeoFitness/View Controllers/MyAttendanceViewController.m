//
//  MyAttendanceViewController.m
//  NeoFitness
//
//  Created by Sumit Saini on 26/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import "MyAttendanceViewController.h"
#import "SWRevealViewController.h"
#import "myAttendanceTableViewCell.h"
#import "MainGridViewController.h"
#import "XMLReader.h"
@interface MyAttendanceViewController (){
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
    NSString *errorMessage;
    NSMutableArray *AttendanceDate;
    NSMutableArray *MorningStatus;
    
    NSMutableArray *AfternoonStatus;
    
    NSMutableArray *EveningStatus;
    NSMutableArray *ErrorMessage;
    NSMutableArray *mainArray1;
 
    
    
}
@property (weak, nonatomic) IBOutlet UIView *view_norecord;


@end

@implementation MyAttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //[self.sidebarButton setTarget: self.revealViewController];
        //[self.sidebarButton setAction: @selector( revealToggle: )];
        [self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    AttendanceDate =[[NSMutableArray alloc]init];
    MorningStatus =[[NSMutableArray alloc]init];
    AfternoonStatus =[[NSMutableArray alloc]init];
    EveningStatus =[[NSMutableArray alloc]init];
    ErrorMessage =[[NSMutableArray alloc]init];
    mainArray1 =[[NSMutableArray alloc]init];

    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = NO;
    //[[[UIAlertView alloc] initWithTitle:@"" message:@"Attendance not generated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    // Dispose of any resources that can be recreated.
    [self getattandacce];
    
    for (int i=0; i<AttendanceDate.count; i++) {
        NSDictionary *dict = @{@"AttendanceDate" : AttendanceDate[i],
                               @"MorningStatus"   : MorningStatus[i],
                               @"AfternoonStatus"   : AfternoonStatus[i],
                              
                               @"EveningStatus"   : EveningStatus[i],
                             
                               
                               
                               };
        
        [mainArray1 addObject: dict];
    }
    if (!(ErrorMessage.count==0)) {
        _view_norecord.hidden=NO;
        NSString*string = [NSString stringWithFormat:@"%@",[ErrorMessage objectAtIndex:0]];
        [[[UIAlertView alloc] initWithTitle:@"" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    _view_norecord.hidden=YES;
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
- (void)didReceiveMemoryWarning {
  }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  return ([mainArray1  count]*25)+100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    // Return the number of rows in the section.
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"myAttendanceCell";
    myAttendanceTableViewCell *cell =(myAttendanceTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     [self showView:(myAttendanceTableViewCell *)cell and:indexPath];
    return cell;
}

-(void)getattandacce{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    
    
    
    NSString *post =[NSString stringWithFormat:@"XMLcustomerid=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><WorkoutCard><Workout><customerid>%@</customerid></Workout></WorkoutCard></NeoFitnes>",UserName,password,MemberID];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetCustomerAttandance"]]];
    
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
    if( [elementName isEqualToString:@"AttendanceDate"]||[elementName isEqualToString:@"MorningStatus"] ||[elementName isEqualToString:@"AfternoonStatus"] ||[elementName isEqualToString:@"EveningStatus"]||[elementName isEqualToString:@"ErrorMessage"] )
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
    
    NSLog(@"%@",soapResults);
    if( [elementName isEqualToString:@"AttendanceDate"])
    {
        xmlResults = FALSE;
        [AttendanceDate addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"MorningStatus"])
    {
        xmlResults = FALSE;
        [MorningStatus addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"EveningStatus"])
    {
        xmlResults = FALSE;
        [EveningStatus addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"AfternoonStatus"])
    {
        xmlResults = FALSE;
        [AfternoonStatus addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"ErrorMessage"])
    {
        xmlResults = FALSE;
        [ErrorMessage addObject:soapResults];
        soapResults = nil;
    }

    
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

-(NSString*)setDate:(NSString*)datestring1{
    if (datestring1==nil) {
        return nil;
    }
    else{
//        NSString *string1 = datestring1 ;
//        NSRange range1 = NSMakeRange(0, 10);
//        NSString *shortDateString = [string1 substringWithRange:range1];
        //NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:shortDateString];
        NSDateFormatter *dateFormatter=[NSDateFormatter new];
       
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        NSDate *date=[dateFormatter dateFromString:datestring1];
    
        NSDateFormatter *dfTime = [NSDateFormatter new];
        [dfTime setDateFormat:@"MM/dd/yyyy"];
        NSString *time=[dfTime stringFromDate:date];
        return time;
    }
    
}
-(void)showView:(myAttendanceTableViewCell *)cell and:(NSIndexPath*)indexPath{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        
      
        
      
        CGRect frame = cell.mainView.frame;
        frame.size.height = ([mainArray1 count]*25)+50;
        cell.mainView.frame = frame;
        [cell.mainView.layer setBorderColor:[UIColor  colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainView.layer setBorderWidth:1.0f];
        
        //UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:frame];
        
        // UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54, frame.size.width, ([[TableDataArr objectAtIndex:indexPath.row] count]*30))];
       // [cell.mainView addSubview:scrollview];
       // scrollview.backgroundColor = [UIColor clearColor];
        
        for(int i=0; i<[mainArray1 count]; i++){
            
            NSDictionary *currentDict = [mainArray1 objectAtIndex:i] ;
            // cell.lblDay.text = [[[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"DayArray"];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 25*(i)+23, frame.size.width, 25)];
            UILabel *classNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(6, 8, 170, 25)];
           
            NSString*date=   [self setDate:[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"AttendanceDate"]]];
            
            //
            //
            //
            [self setPropertyoflabel:classNameLbl];
           classNameLbl.text =date;
            
            UILabel *trainerNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(188, 8, 170, 25)];
             [self setPropertyoflabel:trainerNameLbl];
            trainerNameLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"MorningStatus"]];
           //ZZZ cell.lblTrainer.frame =CGRectMake(
           // [self setPropertyoflabel:trainerNameLbl];
          //  NSString * trainerName = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"TrainerName"]];
//            if ([trainerName isEqualToString:@" "]||[trainerName isEqualToString:@"  "]||[trainerName isEqualToString:@""]||trainerName==nil) {
//                trainerNameLbl.text = @"  0";
//            }
//            else{
//                
//                trainerNameLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"TrainerName"]];
//            }
            UILabel *startTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(370, 8, 170, 25)];
              [self setPropertyoflabel:startTimeLbl];
          startTimeLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"AfternoonStatus"]];
                        
            UILabel *endTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(552, 8, 170, 25)];
              [self setPropertyoflabel:endTimeLbl];
            endTimeLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"EveningStatus"]];

           // cell.LblEndTime.frame =CGRectMake(522, 8, 170, 25);
                       
            
            [view addSubview:classNameLbl];
            [view addSubview:trainerNameLbl];
            [view addSubview:startTimeLbl];
            [view addSubview:endTimeLbl];
           // [view addSubview:venueLbl];
            
            [cell.mainView addSubview:view];
        }
//        [scrollview addSubview:cell.lblClassName];
//        [scrollview addSubview:cell.lblTrainer];
//        [scrollview addSubview:cell.lblstartTime];
//        [scrollview addSubview:cell.LblEndTime];
//        [scrollview addSubview:cell.lblVanue];
        
        //scrollview.contentSize = CGSizeMake(X6, 0);
        //scrollview.scrollEnabled = YES;
        
        
    }
    
    else{
        
        CGRect frame = cell.mainView.frame;
        frame.size.height = ([mainArray1 count]*25)+50;
        cell.mainView.frame = frame;
        [cell.mainView.layer setBorderColor:[UIColor  colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainView.layer setBorderWidth:1.0f];
        
        //UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:frame];
        
        // UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54, frame.size.width, ([[TableDataArr objectAtIndex:indexPath.row] count]*30))];
        // [cell.mainView addSubview:scrollview];
        // scrollview.backgroundColor = [UIColor clearColor];
        
        for(int i=0; i<[mainArray1 count]; i++){
            
            NSDictionary *currentDict = [mainArray1 objectAtIndex:i] ;
            // cell.lblDay.text = [[[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"DayArray"];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 25*(i)+23, frame.size.width, 25)];
            UILabel *classNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 96, 25)];
            
            NSString*date=   [self setDate:[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"AttendanceDate"]]];
            
            //
            //
            //
            [self setPropertyoflabel:classNameLbl];
            classNameLbl.text =date;
            
            UILabel *trainerNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(106, 8, 65, 25)];
            [self setPropertyoflabel:trainerNameLbl];
            trainerNameLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"MorningStatus"]];
            //ZZZ cell.lblTrainer.frame =CGRectMake(
            // [self setPropertyoflabel:trainerNameLbl];
            //  NSString * trainerName = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"TrainerName"]];
            //            if ([trainerName isEqualToString:@" "]||[trainerName isEqualToString:@"  "]||[trainerName isEqualToString:@""]||trainerName==nil) {
            //                trainerNameLbl.text = @"  0";
            //            }
            //            else{
            //
            //                trainerNameLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"TrainerName"]];
            //            }
            UILabel *startTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(174, 8, 65, 25)];
            [self setPropertyoflabel:startTimeLbl];
            startTimeLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"AfternoonStatus"]];
            
            UILabel *endTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(242, 8, 60, 25)];
            [self setPropertyoflabel:endTimeLbl];
            endTimeLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"EveningStatus"]];
            
            // cell.LblEndTime.frame =CGRectMake(522, 8, 170, 25);
            
            
            [view addSubview:classNameLbl];
            [view addSubview:trainerNameLbl];
            [view addSubview:startTimeLbl];
            [view addSubview:endTimeLbl];
            // [view addSubview:venueLbl];
            
            [cell.mainView addSubview:view];
        }
        //        [scrollview addSubview:cell.lblClassName];
        //        [scrollview addSubview:cell.lblTrainer];
        //        [scrollview addSubview:cell.lblstartTime];
        //        [scrollview addSubview:cell.LblEndTime];
        //        [scrollview addSubview:cell.lblVanue];
        
        //scrollview.contentSize = CGSizeMake(X6, 0);
        //scrollview.scrollEnabled = YES;
        
    }
    
}
-(void)setPropertyoflabel:(UILabel*)label{
    [label setFont:[UIFont systemFontOfSize:10]];
   // label.backgroundColor = [UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1];
    label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    
    
    //label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
}


@end
