//
//  SalesEnquiryViewController.m
//  NeoFitness
//
//  Created by Sumit Saini on 10/08/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import "SalesEnquiryViewController.h"
#import "salesEnquiryTableViewCell.h"
#import "SWRevealViewController.h"
#import "SubmitEnquiryViewController.h"
#import "XMLReader.h"
@interface SalesEnquiryViewController ()<UISearchBarDelegate>
{
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
    NSString *errorMessage;
    NSMutableArray * InquiryIdArray ;
    NSMutableArray * FirstNameArray ;
    NSMutableArray * LastNameArray ;
    NSMutableArray * ContactNoArray ;
    NSMutableArray * EmailIdArray;
    NSMutableArray * FollowupCommentsArray ;
    NSMutableArray * NextFollowupDateArray ;
    NSMutableArray * FStatusArray ;
    NSMutableArray * InquiryTypeArray ;
    NSMutableArray * ExpectedJoiningDateArray ;
    NSMutableArray *mainArray;
      NSMutableArray *mainArray1;


}
@property (weak, nonatomic) IBOutlet UITableView *salesEnquiryTableView;

@property (weak, nonatomic) IBOutlet UIView *view_norecord;

@end

@implementation SalesEnquiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.navigationController.navigationBarHidden = NO;    // Do any additional setup after loading the view.
     InquiryIdArray = [[NSMutableArray alloc]init];
     FirstNameArray = [[NSMutableArray alloc]init];
     LastNameArray = [[NSMutableArray alloc]init];
   ContactNoArray = [[NSMutableArray alloc]init];
     EmailIdArray = [[NSMutableArray alloc]init];
    FollowupCommentsArray = [[NSMutableArray alloc]init];
    NextFollowupDateArray = [[NSMutableArray alloc]init];
     FStatusArray = [[NSMutableArray alloc]init];
     InquiryTypeArray = [[NSMutableArray alloc]init];
     ExpectedJoiningDateArray = [[NSMutableArray alloc]init];
    [mainArray removeAllObjects];
    if ([Utility connected]) {
        mainArray =[[NSMutableArray alloc]init];
        [self getInquery];
        for (int i=0; i<EmailIdArray.count; i++) {
            NSDictionary *dict = @{@"InquiryId" : InquiryIdArray[i],
                                   @"FirstName"   : FirstNameArray[i],
                                   @"LastName"   : LastNameArray[i],
                                   @"ContactNo"   : ContactNoArray[i],
                                   @"EmailId"   : EmailIdArray[i],
                                   @"FollowupComments"   : FollowupCommentsArray[i],
                                   @"NextFollowupDate"   : NextFollowupDateArray[i],
                                   @"FStatus"   : FStatusArray[i],
                                   @"InquiryType"   : InquiryTypeArray[i],
                                   @"ExpectedJoiningDate"   : ExpectedJoiningDateArray[i],
                                   };
            
            [mainArray addObject: dict];
            
            
        }
        
        
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

    
    
    
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer: tapRec];
    
    
   mainArray1=mainArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    
}
-(void)tap:(UITapGestureRecognizer *)tapRec{
    [[self view] endEditing: YES];
}
    // Do any additional setup after loading the view.


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mainArray1.count;
    // Return the number of rows in the section.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"salesEnquiryCell";
    salesEnquiryTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString * firstname =[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]valueForKey:@"FirstName"]];
     NSString * laststname =[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]valueForKey:@"LastName"]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",firstname,laststname];
    cell.emailLabel.text =[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]valueForKey:@"EmailId"]];
     cell.phonelabel.text =[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]valueForKey:@"ContactNo"]];
     cell.commentLabel.text =[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]valueForKey:@"FollowupComments"]];
     NSString * expectedJoiningDate  =[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]valueForKey:@"ExpectedJoiningDate"]];
    if ([expectedJoiningDate isEqualToString:@""] || expectedJoiningDate==nil) {
        expectedJoiningDate =0;
        cell.expectedJDLabel.text = @"Expected Joining Date:   0";
    }
    else{
       cell.expectedJDLabel.text =[NSString stringWithFormat:@"Expected Joining Date:   %@",expectedJoiningDate];
    }
    
    
    
    
    
     NSString * type =[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]valueForKey:@"InquiryType"]];
    if ([type isEqualToString:@"1"]) {
        type=@"Hot";
    }
    else if ([type isEqualToString:@"2"]){
        type=@"Warm";
    }
    else
        type=@"Cold";
 cell.typelabel.text =type;
    
     NSString * status =[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]valueForKey:@"FStatus"]];
    cell.statusLabel.text =status;
    if ([status isEqualToString:@"Close"]) {
        cell.nextFUDLabel.text = @"N/A";
    }else
    cell.nextFUDLabel.text =[NSString stringWithFormat:@"NextFollow Up Date:   %@",[[mainArray1 objectAtIndex:indexPath.row]valueForKey:@"NextFollowupDate"]];
    [cell.mainView.layer setBorderColor:[UIColor  colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
    [cell.mainView.layer setBorderWidth:1.0f];

       return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (IBAction)AddNewTaped:(id)sender {
    UIStoryboard* mainStoryBoard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    else
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    
    
    SubmitEnquiryViewController* viewCtrl_loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubmitEnquiryViewController"];
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewCtrl_loginVC];
    
    [viewCtrl_loginVC.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
    [navController setViewControllers: @[viewCtrl_loginVC] animated: YES];
    
    self.revealViewController.frontViewController = navController;
}

-(void)getInquery{
         
        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
        NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
        NSString *  password =    [userdefaults valueForKey:@"Pass"];
     NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    NSString *post =[NSString stringWithFormat:@"strXML=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><SalesStaff><Sales><customerid>%@</customerid></Sales></SalesStaff></NeoFitnes>",UserName,password,MemberID];

        
        // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetInquiryBySales"]]];
        
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
    [InquiryIdArray removeAllObjects];
    [FirstNameArray removeAllObjects];
    [LastNameArray removeAllObjects];
    [ContactNoArray removeAllObjects];
    [EmailIdArray removeAllObjects];
    [FollowupCommentsArray removeAllObjects];
   [NextFollowupDateArray removeAllObjects];
   [ FStatusArray  removeAllObjects];
    [InquiryTypeArray removeAllObjects];
    [ExpectedJoiningDateArray removeAllObjects];
    
        [parser parse];
    [self.salesEnquiryTableView reloadData];
    }
    
    
    
    
    //Implement the NSXmlParserDelegate methods
    
    -(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
    
namespaceURI:(NSString *)namespaceURI qualifiedName:
    
    (NSString *)qName attributes:(NSDictionary *)attributeDict
    
    {
        NSLog(@"fsdfsd");
        if( [elementName isEqualToString:@"InquiryId"]||[elementName isEqualToString:@"FirstName"] ||[elementName isEqualToString:@"LastName"] ||[elementName isEqualToString:@"ContactNo"] ||[elementName isEqualToString:@"EmailId"] ||[elementName isEqualToString:@"FollowupComments"] ||[elementName isEqualToString:@"NextFollowupDate"] ||[elementName isEqualToString:@"FStatus"]||[elementName isEqualToString:@"InquiryType"] ||[elementName isEqualToString:@"ExpectedJoiningDate"])
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
       
        
        if( [elementName isEqualToString:@"InquiryId"])
        {
            xmlResults = FALSE;
            [InquiryIdArray addObject:soapResults];
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
        
        if( [elementName isEqualToString:@"ContactNo"])
        {
            xmlResults = FALSE;
            [ContactNoArray addObject:soapResults];
            soapResults = nil;
        }
        
        if( [elementName isEqualToString:@"EmailId"])
        {
            xmlResults = FALSE;
            [EmailIdArray addObject:soapResults];
            soapResults = nil;
        }
        
        if( [elementName isEqualToString:@"FollowupComments"])
        {
            xmlResults = FALSE;
            [FollowupCommentsArray addObject:soapResults];
            soapResults = nil;
        }
        if( [elementName isEqualToString:@"NextFollowupDate"])
        {
            xmlResults = FALSE;
            [NextFollowupDateArray addObject:soapResults];
            soapResults = nil;
            
        }
        
        if( [elementName isEqualToString:@"FStatus"])
        {
            xmlResults = FALSE;
            [ FStatusArray addObject:soapResults];
            soapResults = nil;
        }
        if( [elementName isEqualToString:@"InquiryType"])
        {
            xmlResults = FALSE;
            //errorMessage=soapResults;
            [InquiryTypeArray addObject:soapResults];
            soapResults = nil;
           
        }
        if( [elementName isEqualToString:@"ExpectedJoiningDate"])
        {
            xmlResults = FALSE;
            //errorMessage=soapResults;
            [ExpectedJoiningDateArray addObject:soapResults];
            soapResults = nil;
            
        }

        
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
}

- (void)filterOperators:(NSString*)name {
    NSMutableArray * searchResults = [[NSMutableArray alloc]init];
    
    if([name isEqualToString:@""] || name == nil) {
                  searchResults = [mainArray mutableCopy];
        mainArray1 = mainArray;
                }
            else {
            
                    NSString *searchName = [name lowercaseString];
    
                    NSPredicate *containsPredicate = [NSPredicate predicateWithFormat:@"self.FirstName CONTAINS[cd] %@ OR self.FStatus contains[cd] %@ OR self.ContactNo contains[cd] %@" , searchName,searchName,searchName];
                    searchResults = [[mainArray filteredArrayUsingPredicate:containsPredicate] mutableCopy];
            mainArray1 =searchResults;
                }
            // [self createSections];
            [self.salesEnquiryTableView reloadData];
            
    }




@end
