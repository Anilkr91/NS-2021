//
//  medicalHistoryViewController.m
//  NeoFitness
//
//  Created by Sumit Saini on 27/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import "medicalHistoryViewController.h"
#import "medicalHistoryTableViewCell.h"
#import "SWRevealViewController.h"
#import "MainGridViewController.h"
#import "XMLReader.h"
#import "VSDropdown.h"
#import "testDetailViewController.h"
@interface medicalHistoryViewController ()<UITextFieldDelegate>{
    VSDropdown *_dropdown;
NSArray *responseObj;
NSString *soapMessage;
NSString *currentElement;
NSMutableData *webResponseData;
NSXMLParser *xmlParser;
NSMutableString *soapResults;
BOOL xmlResults;
NSString *errorMessage;
     NSMutableArray *searcharray;
NSMutableArray *PackageName;
NSMutableArray *TestDate;

NSMutableArray *Status;

NSMutableArray *Gender;

NSMutableArray *Age;

NSMutableArray *GymBranchName;
NSMutableArray *DiagnosisId;
NSMutableArray *mainArray1;
    NSMutableArray *mainArray2;
   NSMutableArray *ErrorMessage;
    NSInteger *count;

}
@property (weak, nonatomic) IBOutlet UIView *View_norecord;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UILabel *lblgymName;
@end

@implementation medicalHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
    
    PackageName =[[NSMutableArray alloc]init];
    TestDate =[[NSMutableArray alloc]init];
    Status =[[NSMutableArray alloc]init];
    Gender =[[NSMutableArray alloc]init];
    DiagnosisId =[[NSMutableArray alloc]init];
    ErrorMessage =[[NSMutableArray alloc]init];
    Age =[[NSMutableArray alloc]init];
    GymBranchName =[[NSMutableArray alloc]init];
     searcharray =[[NSMutableArray alloc]init];
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:YES];
    _dropdown.allowMultipleSelection =NO;
    _dropdown.tintColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    

    mainArray1 =[[NSMutableArray alloc]init];
     mainArray2 =[[NSMutableArray alloc]init];
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
   // [[[UIAlertView alloc] initWithTitle:@"" message:@"MedicalHistory not generated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    // Dispose of any resources that can be recreated.
    [self getMedicalHistory];
    
    for (int i=0; i<PackageName.count; i++) {
        NSDictionary *dict = @{@"PackageName" : PackageName[i],
                               @"TestDate"   : TestDate[i],
                               @"Status"   : Status[i],
                               @"Gender" : Gender[i],
                               @"Age"   : Age[i],
                               @"GymBranchName"   : GymBranchName[i],
                               @"DiagnosisId"   : DiagnosisId[i]
                                                              
                               };
        
        [mainArray1 addObject: dict];
    }
         
         
         
    if (!(ErrorMessage.count==0)) {
        _View_norecord.hidden=NO;
        NSString*string = [NSString stringWithFormat:@"%@",[ErrorMessage objectAtIndex:0]];
        [[[UIAlertView alloc] initWithTitle:@"" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    _View_norecord.hidden=YES;

    for (int i=0; i<PackageName.count; i++) {
        NSDictionary *dict = @{@"PackageName" : PackageName[i],
                               @"DiagnosisId"   : DiagnosisId[i],
                               
                               };
        
        [mainArray2 addObject: dict];
    }
searcharray = mainArray2 ;

         if ([mainArray1 count] == 0) {
             count = 0 ;
             [self EmptyAlert];
         } else {
         
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString * finalString;
    if (![userdefaults valueForKey:@"LastName"]) {
        
        
        finalString = [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"FirstName"]];
    }
    else{
        finalString = [NSString stringWithFormat:@"%@ %@",[userdefaults valueForKey:@"FirstName"],[userdefaults valueForKey:@"LastName"]];
    }
         _lblName.text = finalString;
         _lblYear.text =[NSString stringWithFormat:@"%@, %@ Years",[[mainArray1 objectAtIndex:0]valueForKey:@"Gender"],[[mainArray1 objectAtIndex:0]valueForKey:@"Age"]];
         _lblgymName.text =[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:0]valueForKey:@"GymBranchName"]];
    
         }
     }
    
}

-(void) EmptyAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Neo fitnes"
                                                                   message:@"Medical history not generated"
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



- (void)didReceiveMemoryWarning {
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
//        UIStoryboard* mainStoryBoard;
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
//            mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
//        }
//        else{
//            mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
//        }
//
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

- (void)testAction:(id)sender

{
    //UIButton *btn = (UIButton *)sender;
    _dropdown.backgroundColor = [UIColor whiteColor];
    _dropdown.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    _dropdown.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    _dropdown.separatorType =NO;
    _dropdown.separatorColor = [UIColor whiteColor];
    
    if (mainArray2.count==0) {
        
    }else{
        NSMutableArray* arrray =[[NSMutableArray alloc]init];
        for (int i=0; i<mainArray2.count; i++) {
            NSString *element =[NSString stringWithFormat:@"%@) %@",[[mainArray2 objectAtIndex:i]valueForKey:@"DiagnosisId"],[[mainArray2 objectAtIndex:i]valueForKey:@"PackageName"]];
            [arrray addObject:element];
        }
    
 [self showDropDownForButton:sender adContents:arrray multipleSelection:NO];
    
    
}
}
-(void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection
{
    
    [_dropdown setDrodownAnimation:rand()%2];
    
    [_dropdown setAllowMultipleSelection:NO];
    
    [_dropdown setupDropdownForView:sender];
    
    //[_dropdown setSeparatorColor:sender.titleLabel.textColor];
    
    //if (_dropdown.allowMultipleSelection)
    //{
    [_dropdown reloadDropdownWithContents:contents ];
    
    // }
    //else
    //{
    // [_dropdown reloadDropdownWithContents:contents andSelectedItems:@[[sender titleForState:UIControlStateNormal]]];
    
    // }
    _dropdown.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    
}

#pragma mark -
#pragma mark - VSDropdown Delegate methods.
- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected
{
    UITextField *btn = (UITextField *)dropDown.dropDownView;
    
   // NSString *allSelectedItems = nil;
   
        btn.text=str;
    NSInteger test =[str integerValue];
    //NSRange range = NSMakeRange(0, 3);
    NSString *string =[str substringFromIndex:3];
    
    
        //NSInteger anIndex=[servicename indexOfObject:allSelectedItems];
       // webserviceId = [serviceId objectAtIndex:anIndex];
    
    _dropdown.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    
    [self gotestdetail:string and:test];
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown
{
    
    _dropdown.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    
    return [UIColor whiteColor];
    
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown
{
    _dropdown.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    
    return 2.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown
{
    _dropdown.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    
    return 3.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown
{
    _dropdown.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    
    return -2.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld", mainArray1.count);
    
    
       return mainArray1.count;
    
    
    // Return the number of rows in the section.
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"medicalHistoryCell";
    medicalHistoryTableViewCell *cell =(medicalHistoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.lblpackagename.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"PackageName"]];
    CGFloat   highestLengthOfText1 =[self callculateHigestLength:cell.lblpackagename.text];
 NSString*date=   [self setDate:[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"TestDate"]]];
    cell.lbltestdate.text =date;
    
//    CGFloat   highestLengthOfText2 =[self callculateHigestLength:cell.lbltestdate.text];
    cell.lbltestatus.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Status"]];
//    CGFloat   highestLengthOfText3 =[self callculateHigestLength:cell.lbltestatus.text];
//    highestLengthOfText1=[self compareWidth:highestLengthOfText1];
//    highestLengthOfText2=[self compareWidth:highestLengthOfText2];
//    highestLengthOfText3=[self compareWidth:highestLengthOfText3];
//    CGFloat X1=highestLengthOfText1;
//    CGFloat X2=highestLengthOfText1+highestLengthOfText2;
//    CGFloat X3=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3;
//    CGFloat X4=X3+20;
//    
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
//        cell.lblpackagename.frame=CGRectMake(7, 31, highestLengthOfText1, cell.lblpackagename.frame.size.height);
//        cell.lblpackagename1.frame=CGRectMake(7, 8, highestLengthOfText1, cell.lblpackagename1.frame.size.height);
//        cell.lbltestdate.frame=CGRectMake(X1+11, 31, highestLengthOfText2, cell.lbltestdate.frame.size.height);
//        cell.lbltestdate1.frame=CGRectMake(X1+11, 8, highestLengthOfText2, cell.lbltestdate1.frame.size.height);
//        cell.lbltestatus.frame=CGRectMake(X2+15, 31, highestLengthOfText3, cell.lbltestatus.frame.size.height);
//        cell.lbltestatus1.frame=CGRectMake(X2+15, 8, highestLengthOfText3, cell.lbltestatus1.frame.size.height);
//        
//    }else{
//        cell.lblpackagename.frame=CGRectMake(7, 31, highestLengthOfText1, cell.lblpackagename.frame.size.height);
//        cell.lblpackagename1.frame=CGRectMake(7, 8, highestLengthOfText1, cell.lblpackagename1.frame.size.height);
//        cell.lbltestdate.frame=CGRectMake(X1+11, 31, highestLengthOfText2, cell.lbltestdate.frame.size.height);
//        cell.lbltestdate1.frame=CGRectMake(X1+11, 8, highestLengthOfText2, cell.lbltestdate1.frame.size.height);
//        cell.lbltestatus.frame=CGRectMake(X2+15, 31, highestLengthOfText3, cell.lbltestatus.frame.size.height);
//        cell.lbltestatus1.frame=CGRectMake(X2+15, 8, highestLengthOfText3, cell.lbltestatus1.frame.size.height);;
//    }
    //[cell.mainView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
    //[cell.mainView.layer setBorderWidth:1.0f];
    //CGRect frame = cell.mainView.frame;
  //  frame.size.width = X4;
    //cell.mainView.frame = frame;
    //cell.ScrView.contentSize =CGSizeMake(X4, 0);
    return cell;
}

-(void)getMedicalHistory{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    
    
    
    NSString *post =[NSString stringWithFormat:@"XMLcustomerid=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><MedicalHistory> <TestDetails><customerid>%@</customerid></TestDetails></MedicalHistory></NeoFitnes>",UserName,password,MemberID];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetCustomerMedicalHistory"]]];
    
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
    if( [elementName isEqualToString:@"TestDate"]||[elementName isEqualToString:@"PackageName"] ||[elementName isEqualToString:@"Status"] ||[elementName isEqualToString:@"Gender"] ||[elementName isEqualToString:@"Age"] ||[elementName isEqualToString:@"GymBranchName"]||[elementName isEqualToString:@"DiagnosisId"]||[elementName isEqualToString:@"ErrorMessage"])
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
    if( [elementName isEqualToString:@"PackageName"])
    {
        xmlResults = FALSE;
        [PackageName addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"TestDate"])
    {
        xmlResults = FALSE;
        [TestDate addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"Status"])
    {
        xmlResults = FALSE;
        [Status addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"GymBranchName"])
    {
        xmlResults = FALSE;
        [GymBranchName addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"Gender"])
    {
        xmlResults = FALSE;
        [Gender addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"Age"])
    {
        xmlResults = FALSE;
        [Age addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"DiagnosisId"])
    {
        xmlResults = FALSE;
        [DiagnosisId addObject:soapResults];
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
       // return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // [self filterOperators:textField.text and:textField];
}// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
   //[self filterOperators:textField.text and:textField];
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string==nil ||[string isEqualToString:@""]) {
        
    }
    else{
    [self filterOperators:textField.text and:textField];
    }
    return YES;
}








//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//     [self filterOperators:searchBar.text and:searchBar];
//}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    [self filterOperators:searchBar.text and:searchBar];
//}
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
//    [searchBar resignFirstResponder];
//    return YES;
//}
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    [self filterOperators:searchBar.text and:searchBar];
//}

- (void)filterOperators:(NSString*)name and:(UITextField *)textField {
    NSMutableArray * searchResults = [[NSMutableArray alloc]init];
    
    if([name isEqualToString:@""] || name == nil) {
              searchResults = [mainArray2 mutableCopy];
        mainArray2 = searcharray;
        
            }
        else {
        
                NSString *searchName = [name lowercaseString];
        
                NSPredicate *containsPredicate = [NSPredicate predicateWithFormat:@"self.PackageName CONTAINS[cd] %@" , searchName];
        
                searchResults = [[searcharray filteredArrayUsingPredicate:containsPredicate] mutableCopy];
        mainArray2 =searchResults;
            }
         [self testAction:textField];
    
        
}
-(void)gotestdetail:(NSString*)namesting and:(NSInteger)number{
    UIStoryboard* mainStoryBoard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    }
    else{
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    }
    
    if ([Utility connected]) {
    testDetailViewController*    controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"testDetailViewController"];
        controller.lblstring=namesting;
        controller.testid =[NSString stringWithFormat:@"%ld",(long)number];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [controller.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[controller] animated: YES];
        
        self.revealViewController.frontViewController = navController;
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        NSString *finalString =[NSString stringWithFormat:@"%@) %@",[[mainArray1 objectAtIndex:indexPath.row]valueForKey:@"DiagnosisId"],[[mainArray1 objectAtIndex:indexPath.row]valueForKey:@"PackageName"]];
    NSString * str=finalString;
    NSInteger test =[str integerValue];
    //NSRange range = NSMakeRange(0, 3);
    NSString *string =[str substringFromIndex:3];
    
    
    //NSInteger anIndex=[servicename indexOfObject:allSelectedItems];
    // webserviceId = [serviceId objectAtIndex:anIndex];
    
      [self gotestdetail:string and:test];

   }



@end
