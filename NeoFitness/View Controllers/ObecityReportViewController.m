//
//  ObecityReportViewController.m
//  NeoFitness
//
//  Created by Sumit on 17/05/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import "ObecityReportViewController.h"
#import "ObacityReportTableViewCell.h"
#import "XMLReader.h"
#import "SWRevealViewController.h"
#import "ObecityReportDetailViewController.h"
#import "MainGridViewController.h"
#import "Utility.h"
@interface ObecityReportViewController (){
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
    NSString *errorMessage;
    NSMutableArray *PackageName;
    NSMutableArray *TotalSessionAttended;
    NSMutableArray *Treatment;
    NSMutableArray *ErrorMessage;
    
    NSMutableArray *InitialWeight;
    NSMutableArray *ConsultantName;
    NSMutableArray *Target;
    NSMutableArray *TargetWeightLoss;
    NSMutableArray *TargetInchLoss;
    NSMutableArray *CreatedBy;
    NSMutableArray *CreatedDate;
    NSMutableArray *TargetStatus;
    NSMutableArray *DiticianName;
    NSMutableArray *TrainerName;
     NSMutableArray *Comments;
    NSMutableArray *TargetId;
     NSMutableArray * TotalCMLoss;
    
     NSMutableArray * TotalWeightLoss;
    
    NSMutableArray *PostTherapyInchLoss;
    NSMutableArray * PostTherapyWeightLoss;
    NSMutableArray *mainArray1;
    bool xml;
  
}
@property (strong, nonatomic) IBOutlet UIView *view_norecord;
@property (strong, nonatomic) IBOutlet UITableView *table_obesity;


@end

@implementation ObecityReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    xmlResults = FALSE;
    
    soapResults = nil;

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //[self.sidebarButton setTarget: self.revealViewController];
        //[self.sidebarButton setAction: @selector( revealToggle: )];
        [self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
   
    PostTherapyInchLoss =[[NSMutableArray alloc]init];
    PostTherapyWeightLoss =[[NSMutableArray alloc]init];
    TotalWeightLoss=[[NSMutableArray alloc]init];
    
    
    
    PackageName =[[NSMutableArray alloc]init];
    TotalSessionAttended =[[NSMutableArray alloc]init];
    Treatment =[[NSMutableArray alloc]init];
    InitialWeight =[[NSMutableArray alloc]init];
    ConsultantName =[[NSMutableArray alloc]init];
    Target =[[NSMutableArray alloc]init];
    TargetWeightLoss =[[NSMutableArray alloc]init];
    TargetInchLoss =[[NSMutableArray alloc]init];
    CreatedBy =[[NSMutableArray alloc]init];
    CreatedDate =[[NSMutableArray alloc]init];
    TargetStatus =[[NSMutableArray alloc]init];
    DiticianName =[[NSMutableArray alloc]init];
    TrainerName =[[NSMutableArray alloc]init];
    Comments =[[NSMutableArray alloc]init];
   TargetId =[[NSMutableArray alloc]init];
    TotalCMLoss=[[NSMutableArray alloc]init];
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
    [self getObecityReport];
    
    for (int i=0; i<TrainerName.count; i++) {
        [self returnarray:i and:PackageName];
         [self returnarray:i and:TotalSessionAttended];
         [self returnarray:i and:Treatment];
         [self returnarray:i and:InitialWeight];
         [self returnarray:i and:ConsultantName];
         [self returnarray:i and:Target];
         [self returnarray:i and:TargetWeightLoss];
         [self returnarray:i and:TargetInchLoss];
         [self returnarray:i and:CreatedBy];
         [self returnarray:i and:CreatedDate];
         [self returnarray:i and:TargetStatus];
        [self returnarray:i and:DiticianName];
        [self returnarray:i and:TrainerName];
        [self returnarray:i and:Comments];
        [self returnarray:i and:TargetId];
        
        
        NSDictionary *dict = @{@"PackageName" : PackageName[i],
                               @"TotalSessionAttended"   : TotalSessionAttended[i],
                               @"Treatment"   : Treatment[i],
                               @"InitialWeight"   : InitialWeight[i],
                               @"ConsultantName"   : ConsultantName[i],
                               @"Target"   : Target[i],
                               @"TargetWeightLoss"   : TargetWeightLoss[i],
                               @"TargetInchLoss"   : TargetInchLoss[i],
                               @"CreatedBy"   : CreatedBy[i],
                               @"CreatedDate"   : CreatedDate[i],
                               @"TargetStatus"   : TargetStatus[i],
                               @"DiticianName"   : DiticianName[i],
                               @"TrainerName"   : TrainerName[i],
                               @"Comments"   : Comments[i],
                              @"TargetId"   : TargetId[i],
                               
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
    
 [self GetObesitySessionDetail];
    
    
    
    
    NSLog(@"%@",TotalCMLoss);
//    

   [_table_obesity reloadData];
}
-(NSMutableArray*)returnarray:(int)i and:(NSMutableArray*)array
{
    
    if (array.count==0 ||   array.count<i) {
        [array addObject:@"-"];
    }
    return array;
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
  
        return mainArray1.count;

 
    // Return the number of rows in the section.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *CellIdentifier =@"ObacityReportCell";
    ObacityReportTableViewCell *cell =(ObacityReportTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.lbl_Comments.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Comments"]];
        cell.lbl_Comments.numberOfLines=0;
    CGFloat hieght =[self getLabelHeight:cell.lbl_Comments];
 
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
           
            if (hieght>cell.lbl_Comments.frame.size.height) {
            return 920+hieght-46;
            }else{
                return 920;
            }
        }else
            if (hieght>cell.lbl_Comments.frame.size.height) {
                return 489+hieght-46;
            }else{
            return 489;
            
            
            
            
                }
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"ObacityReportCell";
    ObacityReportTableViewCell *cell =(ObacityReportTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.lbl_Comments.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Comments"]];
       cell.lbl_Comments.numberOfLines=0;
    CGFloat hieght =[self getLabelHeight:cell.lbl_Comments];
    if (hieght>cell.lbl_Comments.frame.size.height) {
        CGRect frame =cell.lbl_Comments.frame;
        frame.size.height=hieght;
        cell.lbl_Comments.frame=frame;
    }else{
        CGRect frame =cell.lbl_Comments.frame;
        frame.size.height=45;
        cell.lbl_Comments.frame=frame;
    }
    NSMutableAttributedString* Commentsstring=[self makeAttribuyeString:cell.lbl_Comments.text];
    //[cell.lbl_Comments setAttributedText:Commentsstring];
  
    
    cell.lbl_ConsultantName.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"ConsultantName"]];
    NSMutableAttributedString* ConsultantNamestring=[self makeAttribuyeString:cell.lbl_ConsultantName.text];
    //[cell.lbl_ConsultantName setAttributedText:ConsultantNamestring];
   
    
    
    cell.lbl_CreatedBy.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"CreatedBy"]];
    NSMutableAttributedString* CreatedBystring=[self makeAttribuyeString:cell.lbl_CreatedBy.text];
   // [cell.lbl_CreatedBy setAttributedText:CreatedBystring];
   
    
    cell.lbl_CreatedDate.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"CreatedDate"]];
    NSMutableAttributedString* CreatedDatestring=[self makeAttribuyeString:cell.lbl_CreatedDate.text];
    //[cell.lbl_CreatedDate setAttributedText:CreatedDatestring];
    
    
    cell.lbl_DiticianName.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"DiticianName"]];
    NSMutableAttributedString* DiticianNamestring=[self makeAttribuyeString:cell.lbl_DiticianName.text];
   // [cell.lbl_DiticianName setAttributedText:DiticianNamestring];
    
    
    cell.lbl_InitialWeight.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"InitialWeight"]];
    NSMutableAttributedString* InitialWeightstring=[self makeAttribuyeString:cell.lbl_InitialWeight.text];
    //[cell.lbl_InitialWeight setAttributedText:InitialWeightstring];
    
    
    cell.lbl_PackageName.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"PackageName"]];
    NSMutableAttributedString* PackageNamestring=[self makeAttribuyeString:cell.lbl_PackageName.text];
   // [cell.lbl_PackageName setAttributedText:PackageNamestring];

    
    
   // cell.lbl_Target.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Target"]];
    cell.lbl_TargetInchLoss.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"TargetInchLoss"]];
    NSMutableAttributedString* TargetInchLossstring=[self makeAttribuyeString:cell.lbl_TargetInchLoss.text];
    //[cell.lbl_TargetInchLoss setAttributedText:TargetInchLossstring];
  
    
    cell.lbl_TargetStatus.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"TargetStatus"]];
    NSMutableAttributedString* TargetStatusstring=[self makeAttribuyeString: cell.lbl_TargetStatus.text] ;
   // [cell.lbl_TargetStatus setAttributedText:TargetStatusstring];

    
    
    cell.lbl_TargetWeightLoss.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"TargetWeightLoss"]];
    NSMutableAttributedString* TargetWeightLosstring=[self makeAttribuyeString:cell.lbl_TargetWeightLoss.text];
    //[cell.lbl_TargetWeightLoss setAttributedText:TargetWeightLosstring];
    
    
    cell.lbl_TotalSessionAttended.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"TotalSessionAttended"]];
    NSMutableAttributedString* TotalSessionAttendedtring=[self makeAttribuyeString:cell.lbl_TotalSessionAttended.text];
    //[cell.lbl_TotalSessionAttended setAttributedText:TotalSessionAttendedtring];
    
    
    cell.lbl_TrainerName.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"TrainerName"]];
     NSMutableAttributedString* TrainerNametring=[self makeAttribuyeString:cell.lbl_TrainerName.text];
   // [cell.lbl_TrainerName setAttributedText:TrainerNametring];
   
    cell.lbl_Treatment.text = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Treatment"]];
    NSMutableAttributedString* Treatmentstring=    [self makeAttribuyeString: cell.lbl_Treatment.text];
    //[cell.lbl_Treatment setAttributedText:Treatmentstring];
    CGFloat totalInchloss=0;
    CGFloat totalWeightloss=0;
    CGFloat postTherapyInchLoss=0;
    CGFloat postWeightLoss=0;
    for (int i=0; i<TotalCMLoss.count; i++) {
        CGFloat a =[[TotalCMLoss objectAtIndex:i]floatValue];
        totalInchloss=totalInchloss+a;
        
        CGFloat weightloss =[[TotalWeightLoss objectAtIndex:i]floatValue];
        totalWeightloss=totalWeightloss+weightloss;
        
        CGFloat posttherepyinchLoss1 =[[PostTherapyInchLoss objectAtIndex:i]floatValue];
        postTherapyInchLoss=postTherapyInchLoss+posttherepyinchLoss1;
        CGFloat postWeightLoss1 =[[PostTherapyWeightLoss objectAtIndex:i]floatValue];
        postWeightLoss=postWeightLoss+postWeightLoss1;
 
    }
    CGFloat   TotalWeightLossAchieved=totalWeightloss+postWeightLoss;
    CGFloat   TotalInchLossAchieved=totalInchloss+postTherapyInchLoss;
     cell.lbl_totalInchLoss.text = [NSString stringWithFormat:@"%.2f",totalInchloss];
    cell.lbl_totalWeightLossAchieved.text = [NSString stringWithFormat:@"%.2f",TotalWeightLossAchieved];
    cell.lbl_totalInchLossAchieved.text = [NSString stringWithFormat:@"%.2f",TotalInchLossAchieved];
    
    
       return cell;
}
-(void)getObecityReport{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
     NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    
    NSString *post =[NSString stringWithFormat:@"XMLcustomerid=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><Obesity><Target><CustomerId>%@</CustomerId></Target></Obesity></NeoFitnes>",UserName,password,MemberID];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetObesityMasterDetail"]]];
    
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
   [_table_obesity reloadData];
}

-(void)GetObesitySessionDetail{

    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    NSString *  TargetId1=[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:0]objectForKey:@"TargetId"]];;
    NSString *post =[NSString stringWithFormat:@"Customerdetail=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><Obesity><Session><CustomerId>%@</CustomerId><TargetId>%@</TargetId></Session></Obesity></NeoFitnes>",UserName,password,MemberID,TargetId1];
    
    
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
    
    NSLog(@"cc");
    
    NSString *strText = [[dictionary objectForKey:@"string"] valueForKey:@"text"];
    
    
    NSData *textData = [strText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:textData];
    [xmlParser setShouldResolveExternalEntities: YES];
    parser.delegate = self;
    [parser parse];
    
    [_table_obesity reloadData];
    
}



//Implement the NSXmlParserDelegate methods

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName

  namespaceURI:(NSString *)namespaceURI qualifiedName:

(NSString *)qName attributes:(NSDictionary *)attributeDict

{
    
    if( [elementName isEqualToString:@"PackageName"]||[elementName isEqualToString:@"TotalSessionAttended"] ||[elementName isEqualToString:@"Treatment"] ||[elementName isEqualToString:@"InitialWeight"] ||[elementName isEqualToString:@"ConsultantName"] ||[elementName isEqualToString:@"Target"] ||[elementName isEqualToString:@"TargetWeightLoss"] ||[elementName isEqualToString:@"TargetInchLoss"] ||[elementName isEqualToString:@"CreatedBy"] ||[elementName isEqualToString:@"CreatedDate"] ||[elementName isEqualToString:@"TargetStatus"] ||[elementName isEqualToString:@"DiticianName"] ||[elementName isEqualToString:@"TrainerName"] ||[elementName isEqualToString:@"Comments"] ||[elementName isEqualToString:@"TargetId"] ||[elementName isEqualToString:@"TotalCMLoss"] || [elementName isEqualToString:@"TotalWeightLoss"] ||[elementName isEqualToString:@"PostTherapyInchLoss"] ||[elementName isEqualToString:@"PostTherapyWeightLoss"] ||[elementName isEqualToString:@"ErrorMessage"])
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
        xml=YES;
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName

  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName



{
    if (xml==YES) {
        
    
        if( [elementName isEqualToString:@"TotalWeightLoss"])
        {
            xmlResults = FALSE;
            [TotalWeightLoss addObject:soapResults];
            soapResults = nil;
        }
        if( [elementName isEqualToString:@"PostTherapyInchLoss"])
        {
            xmlResults = FALSE;
            [PostTherapyInchLoss addObject:soapResults];
            soapResults = nil;
        }
        if( [elementName isEqualToString:@"PostTherapyWeightLoss"])
        {
            xmlResults = FALSE;
            [PostTherapyWeightLoss addObject:soapResults];
            soapResults = nil;
        }

  
    if( [elementName isEqualToString:@"PackageName"])
    {
        xmlResults = FALSE;
        [PackageName addObject:soapResults];
        soapResults = nil;
    }
        if( [elementName isEqualToString:@"TotalCMLoss"])
        {
            xmlResults = FALSE;
            [TotalCMLoss addObject:soapResults];
            soapResults = nil;
        }
    if( [elementName isEqualToString:@"TotalSessionAttended"])
    {
        xmlResults = FALSE;
        [TotalSessionAttended addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"Treatment"])
    {
        xmlResults = FALSE;
        [Treatment addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"InitialWeight"])
    {
        xmlResults = FALSE;
        [InitialWeight addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"ConsultantName"])
    {
        xmlResults = FALSE;
        [ConsultantName addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"Target"])
    {
        xmlResults = FALSE;
        [Target addObject:soapResults];
        soapResults = nil;
    }
        if( [elementName isEqualToString:@"TargetId"])
        {
            xmlResults = FALSE;
            [TargetId addObject:soapResults];
            soapResults = nil;
        }
    if( [elementName isEqualToString:@"TargetWeightLoss"])
    {
        xmlResults = FALSE;
        [TargetWeightLoss addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"TargetInchLoss"])
    {
        xmlResults = FALSE;
        [TargetInchLoss addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"CreatedBy"])
    {
        xmlResults = FALSE;
        [CreatedBy addObject:soapResults];
        soapResults = nil;
    }

    if( [elementName isEqualToString:@"CreatedDate"])
    {
        xmlResults = FALSE;
        [CreatedDate addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"TargetStatus"])
    {
        xmlResults = FALSE;
        [TargetStatus addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"DiticianName"])
    {
        xmlResults = FALSE;
        [DiticianName addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"TrainerName"])
    {
        xmlResults = FALSE;
        [TrainerName addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"Comments"])
    {
        xmlResults = FALSE;
        [Comments addObject:soapResults];
        soapResults = nil;
    }

    
    
    
    
    if( [elementName isEqualToString:@"ErrorMessage"])
    {
        xmlResults = FALSE;
        [ErrorMessage addObject:soapResults];
        soapResults = nil;
    }
    
}
    xmlResults = FALSE;
    xml=NO;
    soapResults = nil;
}
-(NSMutableAttributedString*)makeAttribuyeString:(NSString*)string{
//    NSString *infoString =@"Address : BFC Capital Pvt. Ltd.\n1st Floor, 2/10, Vineet  Khand,\nGomti Nagar , Lucknow, U.P. - 226010\n\nE-mail : customersupport@bfccapital.com\n\nPhone No : +91-522- 4026940\n\nWebsite : http://www.bfccapital.com";
    NSRange range;
    range = [string rangeOfString:@":"];
    
    
    
    if (range.location == NSNotFound) {
      NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:string];
        return attString;
    }
    
    else{
        NSLog(@"%lu",(unsigned long)range.location);
        
        
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:string];
        
        UIFont *font_regular=[UIFont fontWithName:@"Helvetica" size:12.0f];
        UIFont *font_bold=[UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [attString addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, string.length)];
        [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(0,range.location+1)];
       // [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(102, 8)];
       // [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(141, 12)];
        //[attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(170, 10)];
//        [attString addAttribute:NSUnderlineStyleAttributeName
//                          value:[NSNumber numberWithInt:1]
//                          range:(NSRange){0,7}];
//        [attString addAttribute:NSUnderlineStyleAttributeName
//                          value:[NSNumber numberWithInt:1]
//                          range:(NSRange){102,6}];
//        [attString addAttribute:NSUnderlineStyleAttributeName
//                          value:[NSNumber numberWithInt:1]
//                          range:(NSRange){141,10}];
//        [attString addAttribute:NSUnderlineStyleAttributeName
//                          value:[NSNumber numberWithInt:1]
//                          range:(NSRange){171,8}];
        return attString;

            }
}
- (IBAction)btn_viewDetailTaped:(id)sender {
    UIStoryboard* mainStoryBoard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    }
    else{
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    }
    
    if ([Utility connected]) {
        ObecityReportDetailViewController*    controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ObecityReportDetailViewController"];
          controller.TargetId=[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:0]objectForKey:@"TargetId"]];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [controller.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[controller] animated: YES];
        
        self.revealViewController.frontViewController = navController;
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    
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


- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

@end
