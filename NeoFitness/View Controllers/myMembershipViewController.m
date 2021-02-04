//
//  myMembershipViewController.m
//  NeoFitness
//
//  Created by Sumit Saini on 27/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import "myMembershipViewController.h"
#import "SWRevealViewController.h"
#import "myMembershipTableViewCell.h"
#import "XMLReader.h"
#import "MainGridViewController.h"
@interface myMembershipViewController ()
{
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
    NSString *errorMessage;
    NSMutableArray *FirstNameArray;
    NSMutableArray *LastNameArray;
    
    NSMutableArray *PackageNameArray;
    
    NSMutableArray *PackageAmountArray;
    
    NSMutableArray *PackageStartDateArray;
    
    NSMutableArray *PackageExpiryDateArray;
     NSMutableArray *ErrorMessage;
    NSString * value;
    NSMutableArray *mainArray;
    NSInteger index;
    }
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPackageAmt;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmtPaid;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblDueBalanceDate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIView *View_norecord;

@end

@implementation myMembershipViewController

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
    ErrorMessage =[[NSMutableArray alloc]init];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = NO;
    FirstNameArray =[[NSMutableArray alloc]init];
    LastNameArray =[[NSMutableArray alloc]init];
    PackageNameArray =[[NSMutableArray alloc]init];
    PackageAmountArray =[[NSMutableArray alloc]init];
    PackageStartDateArray =[[NSMutableArray alloc]init];
    PackageExpiryDateArray =[[NSMutableArray alloc]init];
    mainArray =[[NSMutableArray alloc]init];
    


    
    [self getMembership];
    
    
    for (int i=0; i<PackageAmountArray.count; i++) {
        NSDictionary *dict = @{@"FirstName" : FirstNameArray[i],
                               @"LastName"   : LastNameArray[i],
                               @"PackageName"   : PackageNameArray[i],
                               @"PackageAmount"   : PackageAmountArray[i],
                               @"PackageStartDate"   : PackageStartDateArray[i],
                               @"PackageExpiryDate"   : PackageExpiryDateArray[i],
                               
                               
                               };
        
        [mainArray addObject: dict];
    }
    if (!(ErrorMessage.count==0)) {
        _View_norecord.hidden=NO;
        NSString*string = [NSString stringWithFormat:@"%@",[ErrorMessage objectAtIndex:0]];
        [[[UIAlertView alloc] initWithTitle:@"" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    _View_norecord.hidden=YES;

    NSLog(@"%@",mainArray);
    
    NSString* name = [NSString stringWithFormat:@"%@ %@",[[mainArray objectAtIndex:0] valueForKey:@"FirstName"],[[mainArray objectAtIndex:0] valueForKey:@"LastName"]];
    self.lblName.text =name;
    // Dispose of any resources that can be recreated.
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
   if (indexPath.row == index) {
    if ( [value isEqualToString:@"no"]) {
         return 120;
    }
       else
          return 45;
   }

    else


        return 45;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mainArray.count;
    // Return the number of rows in the section.
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"myMembershipCell";
    myMembershipTableViewCell *cell =(myMembershipTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   cell.lblmain.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]objectForKey:@"PackageName"]];
    cell.lblAmount.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]objectForKey:@"PackageAmount"]];
    cell.lblStartdate.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]objectForKey:@"PackageStartDate"]];
    cell.lblExperyDate.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]objectForKey:@"PackageExpiryDate"]];
   // [cell.contentView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
    if (indexPath.row == index) {
        if ([cell.viewShow isHidden]) {
            [cell.viewShow setHidden:NO];
            value=@"no";
            
            
        } else {
            [cell.viewShow setHidden:YES];
            value=@"yes";
        }

        
           // cell.viewShow.hidden = !cell.viewShow.hidden;
        }else{
          cell.viewShow.hidden = YES;
        }
        
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index1 = indexPath.row;
    if (index1==index) {
       
    }
    index = indexPath.row;
    
    
    [_tableView reloadData];
}






-(void)getMembership{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  BranchId =    [userdefaults valueForKey:@"BranchId"];
    NSString *  GymId =    [userdefaults valueForKey:@"GymId"];
        NSString *post =[NSString stringWithFormat:@"Customerdetail=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><Customers><Customer><EmailId>%@</EmailId><BranchId>%@</BranchId><GymId>%@</GymId></Customer></Customers></NeoFitnes>",UserName,password,UserName,BranchId,GymId];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetCustomerDetail"]]];
    
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
    if( [elementName isEqualToString:@"PackageName"]||[elementName isEqualToString:@"PackageAmount"] ||[elementName isEqualToString:@"PackageStartDate"] ||[elementName isEqualToString:@"PackageExpiryDate"] ||[elementName isEqualToString:@"FirstName"] ||[elementName isEqualToString:@"LastName"] ||[elementName isEqualToString:@"TotalAmount"] ||[elementName isEqualToString:@"PaidAmount"] ||[elementName isEqualToString:@"Discount"] ||[elementName isEqualToString:@"Balance"] ||[elementName isEqualToString:@"DueDate"]||[elementName isEqualToString:@"ErrorMessage"])
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
    
    
    if( [elementName isEqualToString:@"PackageName"])
    {
        xmlResults = FALSE;
        [PackageNameArray addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"PackageAmount"])
    {
        xmlResults = FALSE;
        [PackageAmountArray addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"PackageStartDate"])
    {
        xmlResults = FALSE;
        [PackageStartDateArray addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"PackageExpiryDate"])
    {
        xmlResults = FALSE;
        [PackageExpiryDateArray addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"FirstName"])
    {
        xmlResults = FALSE;
        [FirstNameArray addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"LastName"])
    {
        xmlResults = FALSE;
        [LastNameArray addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"TotalAmount"])
    {
        xmlResults = FALSE;
        _lblTotalPackageAmt.text = soapResults;
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"PaidAmount"])
    {
        xmlResults = FALSE;
        _lblTotalAmtPaid.text = soapResults;
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"Discount"])
    {
        xmlResults = FALSE;
        _lblTotalDiscount.text = soapResults;
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"Balance"])
    {
        xmlResults = FALSE;
        _lblTotalBalance.text =  [NSString stringWithFormat:@"Total Balance:%@",soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"DueDate"])
    {
        xmlResults = FALSE;
        if ([soapResults isEqualToString:@""] || soapResults ==Nil) {
             _lblDueBalanceDate.text =@"Due Balance Date:0";
        }else{
        _lblDueBalanceDate.text = [NSString stringWithFormat:@"Due Balance Date:%@",soapResults];
        }
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"ErrorMessage"])
    {
        xmlResults = FALSE;
        [ErrorMessage addObject:soapResults];
        soapResults = nil;
    }
}




@end
