//
//  testDetailViewController.m
//  NeoFitness
//
//  Created by Sumit on 21/01/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import "testDetailViewController.h"
#import "SWRevealViewController.h"
#import "testDetailTableViewCell.h"
#import "MainGridViewController.h"
#import "XMLReader.h"

@interface testDetailViewController (){
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
    NSString *errorMessage;
    NSMutableArray *TestName;
    NSMutableArray *ResultValue;
    NSMutableArray *TestMinValue;
    NSMutableArray *TestMaxValue;
     NSMutableArray *ErrorMessage;
    NSMutableArray *DoctorName;
    
    NSMutableArray *DoctorObservation;
    
    NSMutableArray *mainArray1;
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_drName;
@property (weak, nonatomic) IBOutlet UILabel *Lbl_drobservation;
@property (weak, nonatomic) IBOutlet UILabel *lbl_package;
@property (weak, nonatomic) IBOutlet UIView *view_norecord;


@end

@implementation testDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //[self.sidebarButton setTarget: self.revealViewController];
        //[self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    TestName =[[NSMutableArray alloc]init];
    ResultValue =[[NSMutableArray alloc]init];
    TestMinValue =[[NSMutableArray alloc]init];
    TestMaxValue =[[NSMutableArray alloc]init];
    DoctorName =[[NSMutableArray alloc]init];
    DoctorObservation =[[NSMutableArray alloc]init];
    mainArray1 =[[NSMutableArray alloc]init];
    ErrorMessage =[[NSMutableArray alloc]init];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = NO;
    
    //[[[UIAlertView alloc] initWithTitle:@"" message:@"Attendance not generated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    // Dispose of any resources that can be recreated.
    [self getestdetail];
    for (int i=0; i<TestName.count; i++) {
        NSDictionary *dict = @{@"TestName" : TestName[i],
                               @"ResultValue"   : ResultValue[i],
                               @"TestMinValue"   : TestMinValue[i],
                               @"TestMaxValue"   : TestMaxValue[i],
                               @"DoctorName"   : DoctorName[i],
                               @"DoctorObservation"   : DoctorObservation[i],
                               
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


    self.lbl_package.text=self.lblstring;
    self.lbl_drName.text=[NSString stringWithFormat:@"Doctor Name:%@",[[mainArray1 objectAtIndex:0]valueForKey:@"DoctorName"]];
     self.Lbl_drobservation.text=[NSString stringWithFormat:@"Doctor's Observation :%@",[[mainArray1 objectAtIndex:0]valueForKey:@"DoctorObservation"]];
    // Do any additional setup after loading the view.
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
     if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
          return ([mainArray1  count]*40)+100;
     }else
    return ([mainArray1  count]*25)+100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!(ErrorMessage.count==0)) {
        return 0;
    }
    else
    return 1;
    // Return the number of rows in the section.
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"testDetailCell";
    testDetailTableViewCell *cell =(testDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self showView:(testDetailTableViewCell *)cell and:indexPath];
    return cell;
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
        
        
        MainGridViewController* MainGridViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainGridViewController"];
        
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:MainGridViewController];
        
        [MainGridViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[MainGridViewController] animated: YES];
        
        self.revealViewController.frontViewController = navController;
        
        
    }
}
-(void)getestdetail{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    NSString* DiagnosisId=self.testid;
    
    
    NSString *post =[NSString stringWithFormat:@"CustomerDetail=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><MedicalHistory><TestDetails><customerid>%@</customerid><DiagnosisId>%@</DiagnosisId></TestDetails></MedicalHistory></NeoFitnes>",UserName,password,MemberID,DiagnosisId];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetCustomerMedicalTestResults"]]];
    
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
    if( [elementName isEqualToString:@"TestName"]||[elementName isEqualToString:@"ResultValue"] ||[elementName isEqualToString:@"TestMinValue"] ||[elementName isEqualToString:@"TestMaxValue"] ||[elementName isEqualToString:@"DoctorName"]||[elementName isEqualToString:@"DoctorObservation"]||[elementName isEqualToString:@"ErrorMessage"])
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
    if( [elementName isEqualToString:@"TestName"])
    {
        xmlResults = FALSE;
        [TestName addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"ResultValue"])
    {
        xmlResults = FALSE;
        [ResultValue addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"TestMinValue"])
    {
        xmlResults = FALSE;
        [TestMinValue addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"TestMaxValue"])
    {
        xmlResults = FALSE;
        [TestMaxValue addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"DoctorName"])
    {
        xmlResults = FALSE;
        [DoctorName addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"DoctorObservation"])
    {
        xmlResults = FALSE;
        [DoctorObservation addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"ErrorMessage"])
    {
        xmlResults = FALSE;
        [ErrorMessage addObject:soapResults];
        soapResults = nil;
    }
    
}
-(void)showView:(testDetailTableViewCell *)cell and:(NSIndexPath*)indexPath{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        
        
        
        
        CGRect frame = cell.mainview.frame;
        frame.size.height = ([mainArray1 count]*40)+50;
        cell.mainview.frame = frame;
        cell.scrview.frame = frame;
        [cell.mainview.layer setBorderColor:[UIColor  colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainview.layer setBorderWidth:1.0f];
        
        //UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:frame];
        
        // UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54, frame.size.width, ([[TableDataArr objectAtIndex:indexPath.row] count]*30))];
        // [cell.mainview addSubview:scrollview];
        // scrollview.backgroundColor = [UIColor clearColor];
        
        for(int i=0; i<[mainArray1 count]; i++){
            
            NSDictionary *currentDict = [mainArray1 objectAtIndex:i] ;
            // cell.lblDay.text = [[[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"DayArray"];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40*(i)+23, frame.size.width, 40)];
            UILabel *classNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(6, 8, 170, 40)];
            
            classNameLbl.text=   [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"TestName"]];
            
            //
            //
            //
            [self setPropertyoflabel:classNameLbl];
           // classNameLbl.text =date;
            
            UILabel *trainerNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(188, 8, 170, 40)];
             trainerNameLbl.textAlignment = NSTextAlignmentCenter;
            [self setPropertyoflabel:trainerNameLbl];
            NSString* resultValue1 =[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"ResultValue"]];
            float resultValue =[resultValue1 floatValue];
            trainerNameLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"ResultValue"]];
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
            UILabel *startTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(370, 8, 170, 40)];
            [self setPropertyoflabel:startTimeLbl];
            startTimeLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"TestMinValue"]];
             startTimeLbl.textAlignment = NSTextAlignmentCenter;
            NSString*testminvalue1=[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"TestMinValue"]];
            float testminvalue =[testminvalue1 floatValue];
            UILabel *endTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(552, 8, 170, 40)];
            [self setPropertyoflabel:endTimeLbl];
                endTimeLbl.textAlignment = NSTextAlignmentCenter;
            endTimeLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"TestMaxValue"]];
            NSString*testmaxvalue1=[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"TestMaxValue"]];
            float testmaxvalue = [testmaxvalue1 floatValue];
            if (testminvalue>resultValue || resultValue>testmaxvalue) {
                trainerNameLbl.textColor =[UIColor redColor];
            }
            
            [view addSubview:classNameLbl];
            [view addSubview:trainerNameLbl];
            [view addSubview:startTimeLbl];
            [view addSubview:endTimeLbl];
            // [view addSubview:venueLbl];
            
            [cell.mainview addSubview:view];
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
        
        CGRect frame = cell.mainview.frame;
        frame.size.height = ([mainArray1 count]*25)+50;
        cell.mainview.frame = frame;
         cell.scrview.frame = frame;
        [cell.mainview.layer setBorderColor:[UIColor  colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainview.layer setBorderWidth:1.0f];
        
        //UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:frame];
        
        // UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54, frame.size.width, ([[TableDataArr objectAtIndex:indexPath.row] count]*30))];
        // [cell.mainview addSubview:scrollview];
        // scrollview.backgroundColor = [UIColor clearColor];
        
        for(int i=0; i<[mainArray1 count]; i++){
            
            NSDictionary *currentDict = [mainArray1 objectAtIndex:i] ;
            // cell.lblDay.text = [[[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"DayArray"];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 25*(i)+23, frame.size.width, 25)];
            UILabel *classNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 124, 25)];
             classNameLbl.text=   [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"TestName"]];
           // NSString*date=   [self setDate:[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"AttendanceDate"]]];
            
            //
            //
            //
            [self setPropertyoflabel:classNameLbl];
           // classNameLbl.text =date;
            
            UILabel *trainerNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(137, 8, 62, 25)];
            [self setPropertyoflabel:trainerNameLbl];
             trainerNameLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"ResultValue"]];
            NSString* resultValue1 =[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"ResultValue"]];
            float resultValue =[resultValue1 floatValue];
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
            UILabel *startTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(204, 8, 51, 25)];
            [self setPropertyoflabel:startTimeLbl];
             startTimeLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"TestMinValue"]];
            NSString*testminvalue1=[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"TestMinValue"]];
            float testminvalue =[testminvalue1 floatValue];
            UILabel *endTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(282, 8, 55, 25)];
            [self setPropertyoflabel:endTimeLbl];
            endTimeLbl.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"TestMaxValue"]];
            NSString*testmaxvalue1=[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]objectForKey:@"TestMaxValue"]];
            float testmaxvalue = [testmaxvalue1 floatValue];
            // cell.LblEndTime.frame =CGRectMake(522, 8, 170, 25);
            if (testminvalue>resultValue || resultValue>testmaxvalue) {
                trainerNameLbl.textColor =[UIColor redColor];
            }
            endTimeLbl.textAlignment = NSTextAlignmentCenter;
            trainerNameLbl.textAlignment = NSTextAlignmentCenter;
            startTimeLbl.textAlignment = NSTextAlignmentCenter;
            [view addSubview:classNameLbl];
            [view addSubview:trainerNameLbl];
            [view addSubview:startTimeLbl];
            [view addSubview:endTimeLbl];
            // [view addSubview:venueLbl];
            
            [cell.mainview addSubview:view];
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
      if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
    [label setFont:[UIFont systemFontOfSize:10]];
      }
      else{
       [label setFont:[UIFont systemFontOfSize:9]];
      }
   // label.backgroundColor = [UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1];
    label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    
    
    
    //label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
}


@end
