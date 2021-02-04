

#import "fitnessSummaryViewController.h"
#import "XMLReader.h"
#import "SWRevealViewController.h"
#import "fitnessSummaryTableViewCell.h"
#import "MainGridViewController.h"
@interface fitnessSummaryViewController ()
{
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSString *soapResults;
    BOOL xmlResults;
    NSString *errorMessage;
    
  
    NSMutableDictionary *mainDict;
    NSArray *array11;
    NSArray *array22;
    NSMutableArray *Array1;
    NSMutableArray *Array2;
       NSMutableDictionary *dict;
     NSMutableArray *ErrorMessage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblCreatedDate;
@property (weak, nonatomic) IBOutlet UILabel *lblRenewalDate;
@property (weak, nonatomic) IBOutlet UIView *view_norecord;

@end

@implementation fitnessSummaryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
    
    
     Array1 =[[NSMutableArray alloc]init];
     Array2 =[[NSMutableArray alloc]init];
     
    ErrorMessage =[[NSMutableArray alloc]init];
    
    dict =[[NSMutableDictionary alloc]init];
       dict =[[NSMutableDictionary alloc]init];
mainDict =[[NSMutableDictionary alloc]init];
    
 
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = NO;
    
    
    [self getfitnessSummary];
    
    if (!(ErrorMessage.count==0)) {
        _view_norecord.hidden=NO;
        _tableView.delegate=nil;
        _tableView.dataSource=nil;
        NSString*string = [NSString stringWithFormat:@"%@",[ErrorMessage objectAtIndex:0]];
        [[[UIAlertView alloc] initWithTitle:@"" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    _view_norecord.hidden=YES;

    _tableView.delegate=self;
    _tableView.dataSource=self;
  
        
        if ( [dict[@"Message"] isEqualToString: @"Records Not Founds!"]) {
            [self EmptyAlert];
        }
        else {
            //code here
            [self setDate];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     if ( [dict[@"Message"] isEqualToString: @"Records Not Founds!"]) {
         return 0;
     } else {
        return 5;
     }
    
   
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"fitnessSummaryCell";
    fitnessSummaryTableViewCell *cell =(fitnessSummaryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        for (UIView *view in [cell.mainView subviews]){
        if(view.tag != 1004 && view.tag != 1003 && view.tag != 1002 && view.tag != 1001 && view.tag != 1000 && view.tag != 999 ){
            [view removeFromSuperview];
        }
    }

    [self showView:cell and:indexPath];
   

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void) EmptyAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Neo fitnes"
                                                                   message:@"Fitness assesment not generated"
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



-(void)getfitnessSummary{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    
    
    
    NSString *post =[NSString stringWithFormat:@"strXML=<NeoFitnes><Credential><UserName>%@</UserName> <Password>%@</Password></Credential><AssessmentList><Assessment><customerid>%@</customerid></Assessment></AssessmentList></NeoFitnes>",UserName,password,MemberID];
    
    

    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetAssessment"]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    [request setHTTPBody:postData];
    
    NSError *error;
    
    NSURLResponse *response;
    
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
 
    
    NSError *err;
    
    NSMutableDictionary* dictionary = [[XMLReader dictionaryForXMLData:urlData error:&err] mutableCopy];
    
    NSLog(@"cc");
    
    NSString *strText = [[dictionary objectForKey:@"string"] valueForKey:@"text"];
    
    NSLog(@"%s",strText);
    
    
    NSData *textData = [strText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:textData];
    [xmlParser setShouldResolveExternalEntities: YES];
    parser.delegate = self;
    [parser parse];
    
}


-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName

  namespaceURI:(NSString *)namespaceURI qualifiedName:

(NSString *)qName attributes:(NSDictionary *)attributeDict

{
    NSLog(@"fsdfsd");
    if( [elementName isEqualToString:@"Assessment"]||[elementName isEqualToString:@"DietcardId"] ||[elementName isEqualToString:@"DietTime"] ||[elementName isEqualToString:@"DietDetails"] ||[elementName isEqualToString:@"RenewalDate"] ||[elementName isEqualToString:@"CreatedDate"]||[elementName isEqualToString:@"ErrorMessage"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        xmlResults = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string

{
    soapResults =string;
 
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName

  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName



{
    if( [elementName isEqualToString:@"ErrorMessage"])
    {
        xmlResults = FALSE;
        [ErrorMessage addObject:soapResults];
        soapResults = nil;
    }

    
    NSString *my =soapResults;
      if (my ==nil) {
        soapResults =@"0";
        [dict setObject:soapResults forKey:elementName];
    }else{
    [dict setObject:soapResults forKey:elementName];
    }
    
    soapResults=Nil;
    
}

-(void)showView:(fitnessSummaryTableViewCell *)cell and:(NSIndexPath*)indexPath{
    for (UIView *view in [cell.mainView subviews]){
        if(view.tag != 1004 && view.tag != 1003 && view.tag != 1002 && view.tag != 1001 && view.tag != 1000 && view.tag != 999 ){
            [view removeFromSuperview];
        }
    }

        
        if (indexPath.row==0) {
            
            if ([[dict objectForKey:@"ParentId"] intValue] == 0) {
            
                [Array1 removeAllObjects];
                [Array2 removeAllObjects];
               NSArray* array1 =[NSArray arrayWithObjects:@"VFAT",@"FFM",@"TBF",@"TBW",@"BMI", nil];
                [Array1 addObject:array1];
               NSArray* array2 =[NSArray arrayWithObjects:@"PushUp",@"ChipUp",@"Cruches",@"Lunges",@"Burpees", nil];
               [Array2 addObject:array2];

                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lblname1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"BodyComposition"]];
                cell.lblname2.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"MuscularEndurance"]];
                CGRect frame = cell.mainView.frame;
                frame.size.height = ([Array1[0] count]*25)+50;
                cell.lblname2.hidden=NO;
                cell.mainView.frame = frame;
                [cell.mainView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
                [cell.mainView.layer setBorderWidth:1.0f];
                
                
                for (int k=0; k<[Array1[0] count]; k++) {
                    NSString * CurrentName =[Array1[0] objectAtIndex:k];
                    // NSString * CurrentName1 =[Array2[0] objectAtIndex:k];
                    [self makelbl:CurrentName and:k and:1   and:cell and:indexPath];
                    [self makelbl:CurrentName and:k and:2   and:cell and:indexPath];
        //            [self makelbl:CurrentName1 and:k and:3   and:cell and:indexPath];
        //            [self makelbl:CurrentName1 and:k and:4   and:cell and:indexPath];
                }
                
                for (int k=0; k<[Array2[0] count]; k++) {
                   
                    NSString * CurrentName1 =[Array2[0] objectAtIndex:k];
                    
                    [self makelbl:CurrentName1 and:k and:3   and:cell and:indexPath];
                    [self makelbl:CurrentName1 and:k and:4   and:cell and:indexPath];
                }
                
        } else if ([[dict objectForKey:@"ParentId"] intValue] == 1) {
        
       
            
                [Array1 removeAllObjects];
                [Array2 removeAllObjects];
               NSArray* array1 =[NSArray arrayWithObjects:@"Weight",@"VFat",@"BodyWater",@"Muscle Mass",@"MetabolicAge",@"BodyFat",@"BMI",@"MuscleQuality",@"BoneMass",@"PhysiqueRating",@"DCI",@"BMR", nil];
                [Array1 addObject:array1];
               NSArray* array2 =[NSArray arrayWithObjects:@"PushUp",@"ChipUp",@"Cruches",@"Lunges",@"Burpees", nil];
               [Array2 addObject:array2];

                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lblname1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"BodyComposition"]];
                cell.lblname2.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"MuscularEndurance"]];
                CGRect frame = cell.mainView.frame;
                frame.size.height = ([Array1[0] count]*25)+50;
                cell.lblname2.hidden=NO;
                cell.mainView.frame = frame;
                [cell.mainView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
                [cell.mainView.layer setBorderWidth:1.0f];
                
                
                for (int k=0; k<[Array1[0] count]; k++) {
                    NSString * CurrentName =[Array1[0] objectAtIndex:k];
                    // NSString * CurrentName1 =[Array2[0] objectAtIndex:k];
                    [self makelbl:CurrentName and:k and:1   and:cell and:indexPath];
                    [self makelbl:CurrentName and:k and:2   and:cell and:indexPath];
        //            [self makelbl:CurrentName1 and:k and:3   and:cell and:indexPath];
        //            [self makelbl:CurrentName1 and:k and:4   and:cell and:indexPath];
                }
                
                for (int k=0; k<[Array2[0] count]; k++) {
                   
                    NSString * CurrentName1 =[Array2[0] objectAtIndex:k];
                    
                    [self makelbl:CurrentName1 and:k and:3   and:cell and:indexPath];
                    [self makelbl:CurrentName1 and:k and:4   and:cell and:indexPath];
                }
           
        } else if ([[dict objectForKey:@"ParentId"] intValue] == 2) {
        
                [Array1 removeAllObjects];
                [Array2 removeAllObjects];
            
            
            
             NSArray* array1 =[NSArray arrayWithObjects:@"Weight",@"BMI",@"BodyWater",@"LearnBodyMass",@"Height",@"PercentBodyFat",@"BMR",@"SegmentalLearnMass", nil];
            
              // NSArray* array1 =[NSArray arrayWithObjects:@"VFAT",@"FFM",@"TBF",@"TBW",@"BMI",@"New",@"New", nil];
                [Array1 addObject:array1];
               NSArray* array2 =[NSArray arrayWithObjects:@"PushUp",@"ChipUp",@"Cruches",@"Lunges",@"Burpees", nil];
               [Array2 addObject:array2];

                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lblname1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"BodyComposition"]];
                cell.lblname2.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"MuscularEndurance"]];
                CGRect frame = cell.mainView.frame;
                frame.size.height = ([Array1[0] count]*25)+50;
                cell.lblname2.hidden=NO;
                cell.mainView.frame = frame;
                [cell.mainView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
                [cell.mainView.layer setBorderWidth:1.0f];
                
                
                for (int k=0; k<[Array1[0] count]; k++) {
                    NSString * CurrentName =[Array1[0] objectAtIndex:k];
                    // NSString * CurrentName1 =[Array2[0] objectAtIndex:k];
                    [self makelbl:CurrentName and:k and:1   and:cell and:indexPath];
                    [self makelbl:CurrentName and:k and:2   and:cell and:indexPath];
        //            [self makelbl:CurrentName1 and:k and:3   and:cell and:indexPath];
        //            [self makelbl:CurrentName1 and:k and:4   and:cell and:indexPath];
                }
                
                for (int k=0; k<[Array2[0] count]; k++) {
                   
                    NSString * CurrentName1 =[Array2[0] objectAtIndex:k];
                    
                    [self makelbl:CurrentName1 and:k and:3   and:cell and:indexPath];
                    [self makelbl:CurrentName1 and:k and:4   and:cell and:indexPath];
               
            }
            
        }  else if ([[dict objectForKey:@"ParentId"] intValue] == 3) {
        
                [Array1 removeAllObjects];
                [Array2 removeAllObjects];
            
            NSArray* array1 =[NSArray arrayWithObjects:@"BMI",@"Height",@"RestingMetabolizar",@"Age",@"VFAT",@"Weight",@"FatPercent",@"BodyAge", nil];
        
                [Array1 addObject:array1];
               NSArray* array2 =[NSArray arrayWithObjects:@"PushUp",@"ChipUp",@"Cruches",@"Lunges",@"Burpees", nil];
               [Array2 addObject:array2];

                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lblname1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"BodyComposition"]];
                cell.lblname2.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"MuscularEndurance"]];
                CGRect frame = cell.mainView.frame;
                frame.size.height = ([Array1[0] count]*25)+50;
                cell.lblname2.hidden=NO;
                cell.mainView.frame = frame;
                [cell.mainView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
                [cell.mainView.layer setBorderWidth:1.0f];
                
                
                for (int k=0; k<[Array1[0] count]; k++) {
                    NSString * CurrentName =[Array1[0] objectAtIndex:k];
                    // NSString * CurrentName1 =[Array2[0] objectAtIndex:k];
                    [self makelbl:CurrentName and:k and:1   and:cell and:indexPath];
                    [self makelbl:CurrentName and:k and:2   and:cell and:indexPath];
        //            [self makelbl:CurrentName1 and:k and:3   and:cell and:indexPath];
        //            [self makelbl:CurrentName1 and:k and:4   and:cell and:indexPath];
                }
                
                for (int k=0; k<[Array2[0] count]; k++) {
                   
                    NSString * CurrentName1 =[Array2[0] objectAtIndex:k];
                    
                    [self makelbl:CurrentName1 and:k and:3   and:cell and:indexPath];
                    [self makelbl:CurrentName1 and:k and:4   and:cell and:indexPath];
            }
        }
    }
    
    
    if (indexPath.row==1) {
        [Array1 removeAllObjects];
        [Array2 removeAllObjects];
         NSArray *array1 =[NSArray arrayWithObjects:@"Height",@"Weight",@"Chest",@"UpperWaist",@"LowerWaist",@"Calf",@"UpperArm",@"Thigh", nil];
        NSArray *array2 =[NSArray arrayWithObjects:@"RestingHeartRate",@"MaxHeartRate",@"Lap1",@"Lap2",@"Lap3", nil];
         [Array1 addObject:array1];
        [Array2 addObject:array2];

        cell.lblname2.hidden=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblname1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"PhysicalMeasurement"]];
        cell.lblname2.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"CardiovascularFitness"]];
        CGRect frame = cell.mainView.frame;
        frame.size.height = ([Array1[0] count]*25)+50;
        cell.mainView.frame = frame;
        [cell.mainView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainView.layer setBorderWidth:1.0f];
        
        for (int k=0; k<[Array1[0] count]; k++) {
            NSString * CurrentName =[Array1[0] objectAtIndex:k];
           
            [self makelbl:CurrentName and:k and:1   and:cell and:indexPath];
            [self makelbl:CurrentName and:k and:2   and:cell and:indexPath];
            
        }
        for (int k=0; k<[Array2[0] count]; k++) {
           
            NSString * CurrentName1 =[Array2[0] objectAtIndex:k];
            
            [self makelbl:CurrentName1 and:k and:3   and:cell and:indexPath];
            [self makelbl:CurrentName1 and:k and:4   and:cell and:indexPath];
        }
    }
    
    if (indexPath.row==2) {
        [Array1 removeAllObjects];
        [Array2 removeAllObjects];
        NSArray *array1 =[NSArray arrayWithObjects:@"SitAndReach1",@"SitAndReach2",@"SitAndReach3", nil];
        NSArray *array2 =[NSArray arrayWithObjects:@"RenewalDate", nil];
        [Array1 addObject:array1];
        [Array2 addObject:array2];
               cell.lblname2.hidden=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblname1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"Flexibility"]];
        cell.lblname2.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"Information"]];
        CGRect frame = cell.mainView.frame;
        frame.size.height = ([Array1[0] count]*25)+50;
        cell.mainView.frame = frame;
        [cell.mainView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainView.layer setBorderWidth:1.0f];
        
        for (int k=0; k<[Array1[0] count]; k++) {
            NSString * CurrentName =[Array1[0] objectAtIndex:k];
            
            [self makelbl:CurrentName and:k and:1   and:cell and:indexPath];
            [self makelbl:CurrentName and:k and:2   and:cell and:indexPath];
            
        }
        for (int k=0; k<[Array2[0] count]; k++) {
            
            NSString * CurrentName1 =[Array2[0] objectAtIndex:k];
            
            [self makelbl:CurrentName1 and:k and:3   and:cell and:indexPath];
            [self makelbl:CurrentName1 and:k and:4   and:cell and:indexPath];
        }
    }

    if (indexPath.row==3) {
        [Array1 removeAllObjects];
     
        NSArray *array1 =[NSArray arrayWithObjects:@"TargetBodyFat",@"PredictedWeight",@"PredictedFatMass",@"FatToLoose", nil];
               [Array1 addObject:array1];
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblname1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:@"Target"]];
        cell.lblname2.hidden = YES;
        CGRect frame = cell.mainView.frame;
        frame.size.height = ([Array1[0] count]*25)+50;
        cell.mainView.frame = frame;
        [cell.mainView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainView.layer setBorderWidth:1.0f];
        
        for (int k=0; k<[Array1[0] count]; k++) {
            NSString * CurrentName =[Array1[0] objectAtIndex:k];
            
            [self makelbl:CurrentName and:k and:5   and:cell and:indexPath];
            [self makelbl:CurrentName and:k and:6   and:cell and:indexPath];
            
        }
    }
    
    if (indexPath.row==4) {
        [Array1 removeAllObjects];
       
        NSArray *array1 =[NSArray arrayWithObjects:@"SpecialInstruction", nil];
        
        [Array1 addObject:array1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblname1.text = @"  Special Instruction";
        cell.lblname2.hidden = YES;
        CGRect frame = cell.mainView.frame;
        frame.size.height = ([Array1[0] count]*25)+50;
        cell.mainView.frame = frame;
        [cell.mainView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainView.layer setBorderWidth:1.0f];
        
        for (int k=0; k<[Array1[0] count]; k++) {
            NSString * CurrentName =[Array1[0] objectAtIndex:k];
            
            [self makelbl:CurrentName and:k and:5   and:cell and:indexPath];
         
        }
    }
}


-(void)makelbl:(NSString*)LblName and :(int)number and:(int)type   and:(fitnessSummaryTableViewCell *)cell and:(NSIndexPath*)indexPath {
    
    UIView *    view;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        if (type==1) {
            view = [[UIView alloc] initWithFrame:CGRectMake(6, 27*(number+2)-22, 85*2.5, 25)];
            
            
            UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85*2.5, 25)];
            [self setPropertyoflabel:LblName1 and:type];
            LblName1.text = [NSString stringWithFormat:@"  %@",LblName];
            [view addSubview:LblName1];
            
        }
        
        else if (type==2){
            
            view = [[UIView alloc] initWithFrame:CGRectMake(96*2.3, 27*(number+2)-22, 51*2.5, 25)];
            
            
            UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 51*2.5, 25)];
            [self setPropertyoflabel:LblName1 and:type];
            LblName1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:LblName]];
            [view addSubview:LblName1];
        }
        else if (type==3){
            view = [[UIView alloc] initWithFrame:CGRectMake(145*2.5, 27*(number+2)-22, 95*2.5, 25)];
            
            
            UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 89*2.5, 25)];
            [self setPropertyoflabel:LblName1 and:type];
            LblName1.text =  [NSString stringWithFormat:@"  %@",LblName];
            [view addSubview:LblName1];
        }
        else if (type==4){
            view = [[UIView alloc] initWithFrame:CGRectMake(235*2.5, 27*(number+2)-22, 51*2.5, 25)];
            
            
            UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 51*2.5, 25)];
            [self setPropertyoflabel:LblName1 and:type];
            LblName1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:LblName]];
            [view addSubview:LblName1];
            
        }
        else if (type==5){
            view = [[UIView alloc] initWithFrame:CGRectMake(6, 27*(number+2)-22, 240*2.5, 25)];
            
            
            UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240*2.5, 25)];
            
            [self setPropertyoflabel:LblName1 and:type];
            if (indexPath.row ==4) {
                LblName1.text =[NSString stringWithFormat:@"  %@",[dict valueForKey:LblName]];
                
                
                CGFloat width =  [LblName1.text sizeWithFont:[UIFont systemFontOfSize:8]].width;
                UIView *view1 =[[UIView alloc]init];
                
                view1.frame = CGRectMake(LblName1.frame.origin.x+4, LblName1.frame.origin.y+16, width-4, 2);
                view1.backgroundColor = [UIColor whiteColor];
                [LblName1 addSubview:view1];
            }
            else
                LblName1.text =  [NSString stringWithFormat:@"  %@",LblName];
            [view addSubview:LblName1];
            
        }
        else if (type==6){
            view = [[UIView alloc] initWithFrame:CGRectMake(243*2.5, 27*(number+2)-22, 50, 25)];
            
            
            UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
            
            [self setPropertyoflabel:LblName1 and:type];
            LblName1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:LblName]];
            [view addSubview:LblName1];
            
        }
        
        [cell.mainView addSubview:view];
        
    }
    
    
     else{
    
       if (type==1) {
               view = [[UIView alloc] initWithFrame:CGRectMake(6, 27*(number+2)-22, 85, 25)];

        
         UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 25)];
        [self setPropertyoflabel:LblName1 and:type];
           
           LblName1.text =  [NSString stringWithFormat:@"  %@",LblName];;
        [view addSubview:LblName1];
        
    }
        
    else if (type==2){
       
        view = [[UIView alloc] initWithFrame:CGRectMake(96, 27*(number+2)-22, 51, 25)];
        
        
        UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 51, 25)];
        [self setPropertyoflabel:LblName1 and:type];
        LblName1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:LblName]];
        [view addSubview:LblName1];
    }
    else if (type==3){
        view = [[UIView alloc] initWithFrame:CGRectMake(160, 27*(number+2)-22, 85, 25)];
        
        
        UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 25)];
        [self setPropertyoflabel:LblName1 and:type];
        LblName1.text =  [NSString stringWithFormat:@"  %@",LblName];;
        [view addSubview:LblName1];
    }
    else if (type==4){
        view = [[UIView alloc] initWithFrame:CGRectMake(250, 27*(number+2)-22, 51, 25)];
        
        
        UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 51, 25)];
        [self setPropertyoflabel:LblName1 and:type];
        LblName1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:LblName]];
        [view addSubview:LblName1];

    }
    else if (type==5){
         view = [[UIView alloc] initWithFrame:CGRectMake(6, 27*(number+2)-22, 240, 25)];
    
        
        UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 25)];
 
        [self setPropertyoflabel:LblName1 and:type];
        if (indexPath.row ==4) {
            LblName1.text =[NSString stringWithFormat:@"  %@",[dict valueForKey:LblName]];
           
            CGFloat width =  [LblName1.text sizeWithFont:[UIFont systemFontOfSize:8]].width;
            UIView *view1 =[[UIView alloc]init];
            
            view1.frame = CGRectMake(LblName1.frame.origin.x+4, LblName1.frame.origin.y+17, width-4, 2);
       
            [LblName1 addSubview:view1];
        }
        else
        LblName1.text =  [NSString stringWithFormat:@"  %@",LblName];;
        [view addSubview:LblName1];
        
    }
    else if (type==6){
        view = [[UIView alloc] initWithFrame:CGRectMake(250, 27*(number+2)-22, 50, 25)];
        
        
        UILabel *LblName1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
        
        [self setPropertyoflabel:LblName1 and:type];
        LblName1.text = [NSString stringWithFormat:@"  %@",[dict valueForKey:LblName]];
        [view addSubview:LblName1];
        
    }

   [cell.mainView addSubview:view];
        
    }
 }


-(void)setPropertyoflabel:(UILabel*)label and:(int) type{
        [label setFont:[UIFont systemFontOfSize:8]];
        label.layer.borderColor = [[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:.3] CGColor];
    label.layer.borderWidth=.50f;
        label.numberOfLines = 0;
    if (type==2 || type==4 || type==6) {
        label.textAlignment = UITextAlignmentCenter;
    }
    
    label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (indexPath.row==0) {
        
        if ([[dict objectForKey:@"ParentId"] intValue] == 0) {
            [Array1 removeAllObjects];
            [Array2 removeAllObjects];
            NSArray* array1 =[NSArray arrayWithObjects:@"VFAT",@"FFM",@"TBF",@"TBW",@"BMI", nil];
             NSArray* array2 =[NSArray arrayWithObjects:@"PushUp",@"ChipUp",@"Cruches",@"Lunges",@"Burpees", nil];
                  
            [Array1 addObject:array1];
            [Array2 addObject:array2];
            return ([Array1[0] count]*25)+70;
            
        } else if ([[dict objectForKey:@"ParentId"] intValue] == 1) {
            
            [Array1 removeAllObjects];
            [Array2 removeAllObjects];
            
            NSArray* array1 =[NSArray arrayWithObjects:@"Weight",@"VFAT",@"BodyWater",@"MuscleMass",@"MetaBolicAge",@"BodyFat",@"BMI",@"MuscleQuality",@"BoneMass",@"PhysiqueRating",@"DCI",@"BMR", nil];
            NSArray* array2 =[NSArray arrayWithObjects:@"PushUp",@"ChipUp",@"Cruches",@"Lunges",@"Burpees", nil];
           
            [Array1 addObject:array1];
            [Array2 addObject:array2];
            return ([Array1[0] count]*25)+70;
            
            
        } else if ([[dict objectForKey:@"ParentId"] intValue] == 2) {
            
            [Array1 removeAllObjects];
            [Array2 removeAllObjects];
            
            NSArray* array1 =[NSArray arrayWithObjects:@"Weight",@"BMI",@"BodyWater",@"LearnBodyMass",@"Height",@"PercentBodyFat",@"BMR",@"SegmentalLearnMass", nil];
            NSArray* array2 =[NSArray arrayWithObjects:@"PushUp",@"ChipUp",@"Cruches",@"Lunges",@"Burpees", nil];
                [Array1 addObject:array1];
                [Array2 addObject:array2];

                return ([Array1[0] count]*25)+70;
            
        } else if ([[dict objectForKey:@"ParentId"] intValue] == 3) {
            
            NSArray* array1 =[NSArray arrayWithObjects:@"BMI",@"Height",@"RestingMetabolizar",@"Age",@"VFAT",@"Weight",@"FatPercent",@"BodyAge", nil];
            NSArray* array2 =[NSArray arrayWithObjects:@"PushUp",@"ChipUp",@"Cruches",@"Lunges",@"Burpees", nil];
            
            [Array1 addObject:array1];
            [Array2 addObject:array2];

            return ([Array1[0] count]*25)+70;
        }
    }
    
    if (indexPath.row==1) {
        
        [Array1 removeAllObjects];
        [Array2 removeAllObjects];
        NSArray *array1 =[NSArray arrayWithObjects:@"Height",@"Weight",@"Chest",@"UpperWaist",@"LowerWaist",@"Calf",@"UpperArm",@"Thigh", nil];
        NSArray *array2 =[NSArray arrayWithObjects:@"RestingHeartRate",@"MaxHeartRate",@"Lap1",@"Lap2",@"Lap3", nil];
        [Array1 addObject:array1];
        [Array2 addObject:array2];
        return ([Array1[0] count]*25)+70;
    
    }
    
    
    if (indexPath.row==2) {
        
        [Array1 removeAllObjects];
        [Array2 removeAllObjects];
        NSArray *array1 =[NSArray arrayWithObjects:@"SitAndReach1",@"SitAndReach2",@"SitAndReach3", nil];
        NSArray *array2 =[NSArray arrayWithObjects:@"RenewalDate", nil];
        [Array1 addObject:array1];
        [Array2 addObject:array2];
        
        
        
        return ([Array1[0] count]*25)+60;
    }
    if (indexPath.row==3) {
        
        [Array1 removeAllObjects];
       
        NSArray *array1 =[NSArray arrayWithObjects:@"TargetBodyFat",@"PredictedWeight",@"PredictedFatMass",@"FatToLoose", nil];
     
        [Array1 addObject:array1];
        return ([Array1[0] count]*25)+60;
    }

    if (indexPath.row==4) {
        
        [Array1 removeAllObjects];
      
        NSArray *array1 =[NSArray arrayWithObjects:@"TargetBodyFat", nil];
       
        [Array1 addObject:array1];
        
        return ([Array1[0] count]*25)+60;

//        return ([Array1[0] count]*25)+60;
    }

    else
        return 400;
   
}
-(void)setDate{
    NSString *datestring1 = [NSString stringWithFormat:@"  Created Date : %@",[dict  objectForKey:@"CreatedDate"]];
    NSString *string1 = datestring1 ;
    NSRange range1 = [string1 rangeOfString:@"12:00:00 AM"];
    NSString *shortDateString = [string1 substringToIndex:range1.location];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:shortDateString];
    
    UIFont *font_regular=[UIFont fontWithName:@"Helvetica" size:11.0f];
    UIFont *font_bold=[UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
    [attString addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, shortDateString.length)];
    [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(2, 12)];
    [self.lblCreatedDate setAttributedText:attString];
    
    NSString *datestring2 = [NSString stringWithFormat:@"  Renewal Date : %@",[dict  objectForKey:@"RenewalDate"]];
    NSMutableAttributedString *attString1=[[NSMutableAttributedString alloc] initWithString:datestring2];
    

    [attString1 addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, datestring2.length)];
    [attString1 addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(2, 12)];
    [self.lblRenewalDate setAttributedText:attString1];

    
}

-(CGFloat)callculateHigestLength:(int)type and:(NSIndexPath*)index {
    CGFloat higestvalue=0;
    NSString *finalstring;
    NSString*comment;
    if (type==1) {
        for (int k=0; k<[Array1[0] count]; k++) {
             comment =[Array1[0] objectAtIndex:k];
    }
    }  else if (type==2)
        for (int k=0; k<[Array1[0] count]; k++) {
            
         comment =[Array2[0] objectAtIndex:k];
       
    }
    
    
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
        width = [finalstring sizeWithFont:[UIFont systemFontOfSize:11]].width;
    }
    else
    {
        width = ceil([finalstring  sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}].width);
    }
    return width;
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
