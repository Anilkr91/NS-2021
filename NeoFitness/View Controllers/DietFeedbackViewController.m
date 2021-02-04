//
//  DietFeedbackViewController.m
//  NeoFitness
//
//  Created by Sumit on 16/02/18.
//  Copyright © 2018 dmondo. All rights reserved.
//

#import "DietFeedbackViewController.h"
#import "XMLReader.h"
#import "SWRevealViewController.h"
#import "DietFeedbackTableViewCell.h"
#import "MainGridViewController.h"
#import "WebXMLParser.h"
#import "XMLDictionary.h"
#import "DietCardViewController.h"
@interface DietFeedbackViewController (){

  
  
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
    NSString *errorMessage;
    
    NSMutableArray *mainArray1;
    NSMutableArray *searcharray;
    NSMutableArray *ErrorMessage;

}
@property (strong, nonatomic) IBOutlet UITableView *table_main;
@property (weak, nonatomic) IBOutlet UIView *view_norecord;
@end

@implementation DietFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _view_norecord.hidden=YES;
    ErrorMessage=[[NSMutableArray alloc]init];
    mainArray1 =[[NSMutableArray alloc]init];
    
    searcharray =[[NSMutableArray alloc]init];
    
    
    // [ mainArray1 removeAllObjects];
    //[ TableDataArr removeAllObjects];
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     self.navigationController.navigationBarHidden = YES;
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
        
        DietCardViewController*   controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DietCardViewController"];
        
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [controller.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[controller] animated: YES];
        
        self.revealViewController.frontViewController = navController;
        
    }
    
}
-(void)tap:(UITapGestureRecognizer *)tapRec{
    [[self view] endEditing: YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *CellIdentifier =@"DietFeedbackTableViewCell";
    DietFeedbackTableViewCell *cell =(DietFeedbackTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.lblfeedback.text = [NSString stringWithFormat:@"Feedback - %@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Feedback"]];
   
    NSMutableAttributedString *detail=[self MakeSomePartBold:cell.lblfeedback.text and:1];
    [cell.lblfeedback setAttributedText:detail ];
    

    
    CGFloat   highestLengthOfText3 =[self getLabelHeight:cell.lblfeedback];
    CGFloat   highestLengthOfText =cell.lblfeedback.frame.size.height;
   
    
    CGFloat hieghtOfDetailLbl =highestLengthOfText;

    if (highestLengthOfText3>highestLengthOfText) {
        hieghtOfDetailLbl=highestLengthOfText3;
    }
   
    
    NSString *remarkstring = [NSString stringWithFormat:@"Feedback - %@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Feedback"]];
    
    
    if (remarkstring.length==0 || [remarkstring isEqualToString:@"(null)"]) {
        hieghtOfDetailLbl =0;
    }

  
    return cell.lblcreatedDate.frame.origin.y+cell.lblcreatedDate.frame.size.height+cell.lblFeedbackBy.frame.size.height+hieghtOfDetailLbl+45;
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
    
    NSString *CellIdentifier =@"DietFeedbackTableViewCell";
    DietFeedbackTableViewCell *cell =(DietFeedbackTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.lblfeedback.text = [NSString stringWithFormat:@"Feedback - %@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Feedback"]];
    NSString*createdDate=[self setdate:[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"DietCreatedDate"]] and:1];
    
    
    cell.lblcreatedDate.text=[NSString stringWithFormat:@"DietCreatedDate - %@",createdDate];
    NSString*feedbackDate=[self setdate:[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"FeedbackDate"]] and:1];
    
    cell.lblfeedbackDate.text=[NSString stringWithFormat:@"FeedbackDate - %@",feedbackDate];
    NSMutableAttributedString *detail=[self MakeSomePartBold:cell.lblfeedback.text and:1];
    
    [cell.lblfeedback setAttributedText:detail ];
     NSString*feedbackBy=[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"FeedBy"]] ;
    if ([feedbackBy isEqualToString:@"C"]) {
        cell.lblFeedbackBy.text =@"FeedbackBy-Customer";
    }
    if ([feedbackBy isEqualToString:@"S"]) {
        cell.lblFeedbackBy.text =@"FeedbackBy-Staff";
    }
    CGFloat   highestLengthOfText3 =[self getLabelHeight:cell.lblfeedback];
    CGFloat   highestLengthOfText =cell.lblfeedback.frame.size.height;
    
    
    CGFloat hieghtOfDetailLbl =highestLengthOfText;
    
    if (highestLengthOfText3>highestLengthOfText) {
        hieghtOfDetailLbl=highestLengthOfText3;
    }
    CGRect frame = cell.lblfeedback.frame;
    frame.size.height=hieghtOfDetailLbl;
    cell.lblfeedback.frame=frame;
    CGRect frame1 =cell.ScrView.frame;
    CGFloat hieght =cell.lblfeedback.frame.origin.y+hieghtOfDetailLbl+8;
     frame1.size.height=hieght;
    cell.ScrView.frame=frame1;
    cell.mainView.frame=frame1;
    NSString *remarkstring = [NSString stringWithFormat:@"Feedback - %@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"Feedback"]];
    
    
    if (remarkstring.length==0 || [remarkstring isEqualToString:@"(null)"]) {
        hieghtOfDetailLbl =0;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)getGroupClass{
    NSString*date=[self setdate:self.createdDate and:0];
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    
    
    
    NSString *post =[NSString stringWithFormat:@"Customerdetail=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential> <GetDietCardFeedback><DietCreatedDate>%@</DietCreatedDate><CustomerId>%@</CustomerId></GetDietCardFeedback> </NeoFitnes>",UserName,password,date,MemberID];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetDietCardFeedbackThreading"]]];
    
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
    
    id  object=[[responseDictonary objectForKey:@"GetDietCardFeedback"]objectForKey:@"DietCardFeedbacks"];
    NSLog(@"cc%@",object);
    if([object isKindOfClass:[NSArray class]]){
        mainArray1=object;
        //Is array
    }else if([object isKindOfClass:[NSDictionary class]]){
        [mainArray1 addObject:object];
        //is dictionary
    }
   // [self setDate];
    
    [self.table_main reloadData];
    //    NSData *textData = [strText dataUsingEncoding:NSUTF8StringEncoding];
    //
    //    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:textData];
    //    [xmlParser setShouldResolveExternalEntities: YES];
    //    parser.delegate = self;
    //    [parser parse];
    
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
-(NSMutableAttributedString *)MakeSomePartBold:(NSString*)string and:(int)type{
    
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:string];
    
    UIFont *font_regular=[UIFont fontWithName:@"Helvetica" size:11.0f];
    UIFont *font_bold=[UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
    [attString addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, attString.length)];
    if (type==1) {
        [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(0, 10)];
    }else{
        [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(0, 7)];
    }
    return attString;
    
    
}


-(NSString*)setdate:(NSString*)dietDate and:(int)type{
    if (type==0) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        NSDate *date=[dateFormatter dateFromString:dietDate];
        
        
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *finalDate=[dateFormatter stringFromDate:date];
        return finalDate;
    }else{
        NSDateFormatter *dateFormatter=[NSDateFormatter new];
        
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        NSDate *date=[dateFormatter dateFromString:dietDate];
        
        
        
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *finalDate=[dateFormatter stringFromDate:date];
        return finalDate;
    }
    
  
}
- (IBAction)backTaped:(id)sender {
    UIStoryboard* mainStoryBoard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    }
    else{
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    }
    
    DietCardViewController*   controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DietCardViewController"];
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [controller.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
    [navController setViewControllers: @[controller] animated: YES];
    
    self.revealViewController.frontViewController = navController;
}
@end
