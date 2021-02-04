//
//  DrObservationViewController.m
//  NeoFitness
//
//  Created by Sumit on 17/04/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import "DrObservationViewController.h"
#import "SWRevealViewController.h"
#import "DrObservationTableViewCell.h"
#import "MainGridViewController.h"
#import "XMLReader.h"
#import "WebXMLParser.h"
#import "CommentTableViewCell.h"
@interface DrObservationViewController (){
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
    NSString *errorMessage;
    NSMutableArray *CSObservationDate;
    NSMutableArray *CSObservationBy;
    NSMutableArray *CSObservation;
    NSMutableArray *CSObservationId;
    NSMutableArray *ErrorMessage;
     NSMutableArray *commentArray;
    NSMutableArray *mainArray1;
    NSInteger clickedBtntag;
    
    
}
@property (weak, nonatomic) IBOutlet UIView *view_norecord;
@property (weak, nonatomic) IBOutlet UITableView *table_drObservation;
@property (weak, nonatomic) IBOutlet UIView *view_drobservation;
@property (weak, nonatomic) IBOutlet UIView *view_writeComment;
@property (weak, nonatomic) IBOutlet UIView *view_writecommentanimation;
@property (weak, nonatomic) IBOutlet UITextView *textview_comment;

@property (weak, nonatomic) IBOutlet UIButton *btn_postcomment;
@property (weak, nonatomic) IBOutlet UITableView *tableview_showComment;
@property (weak, nonatomic) IBOutlet UIButton *btn_viewcommenrCross;


@end

@implementation DrObservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _view_writeComment.hidden=YES;
    _view_drobservation.hidden=NO;
    _tableview_showComment.hidden=YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //[self.sidebarButton setTarget: self.revealViewController];
        //[self.sidebarButton setAction: @selector( revealToggle: )];
        [self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
     commentArray=[[NSMutableArray alloc]init];
    CSObservationId=[[NSMutableArray alloc]init];
    CSObservationDate =[[NSMutableArray alloc]init];
    CSObservationBy =[[NSMutableArray alloc]init];
    CSObservation =[[NSMutableArray alloc]init];
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
    [self getdrObservation];
    for (int i=0; i<CSObservationBy.count; i++) {
        NSDictionary *dict = @{@"CSObservationBy" : CSObservationBy[i],
                               @"CSObservationDate"   : CSObservationDate[i],
                               @"CSObservation"   : CSObservation[i],
                               @"CSObservationId"   : CSObservationId[i],
                               
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
    NSLog(@"%@",mainArray1);
    
   // self.view_writecommentanimation.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btn_postcomment.layer.cornerRadius=5.0f;
    self.btn_viewcommenrCross.layer.cornerRadius=5.0f;
    //self.view_writecommentanimation.layer.borderWidth=1.0f;
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [self.view_writecommentanimation addGestureRecognizer: tapRec];

    [_textview_comment setText:@"Your Feedback"];
    
    [_btn_postcomment addTarget:self action:@selector(btn_postcommentTaped:) forControlEvents:UIControlEventTouchUpInside];
     [_btn_viewcommenrCross addTarget:self action:@selector(btn_viewcommenrCrossTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)tap:(id)sender{
    //[self moveViewUpOrDown:@"down"];
    [_textview_comment resignFirstResponder];
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
 
    
    
    if (tableView == _tableview_showComment) {
        
        NSString *CellIdentifier =@"CommentTableViewCell";
        CommentTableViewCell *cell =(CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.lbl_comment.text=[NSString stringWithFormat:@"%@",[[commentArray objectAtIndex:indexPath.row]objectForKey:@"CSObservation"]];
        [cell.lbl_comment sizeToFit];
        CGRect frame=cell.lbl_comment.frame;
        CGFloat y=8;
        CGFloat width=cell.view_commentMain.frame.size.width-16;
        frame.origin.y=y;
        frame.size.width=width;
        cell.lbl_comment.frame=frame;
        CGRect frame2 =cell.view_commentMain.frame;
        CGFloat y1=0;
        CGFloat width1=self.view.frame.size.width-16;
        CGFloat height1=cell.lbl_comment.frame.size.height+16;
        frame2.origin.y=y1;
        frame2.size.width=width1;
        frame2.size.height=height1;
        cell.view_commentMain.frame=frame2;
        
        CGRect frame1=cell.cellview_gap.frame;
        frame1.origin.y=frame2.origin.y+frame2.size.height;
        cell.cellview_gap.frame=frame1;
        CGFloat hight=frame2.origin.y+frame2.size.height+10;
        
        return hight;
    }else{
    
    NSString *CellIdentifier =@"DrObservationCell";
    DrObservationTableViewCell *cell =(DrObservationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString*date=   [self setDate:[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"CSObservationDate"]]];
    NSString *dateString =[NSString stringWithFormat:@"Date : %@",date];
    
    [cell.cellDateLabel setAttributedText:[self MakeattributedString:dateString And:1]];
    NSString *ObservationBysrring =[NSString stringWithFormat:@"Observation by %@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"CSObservationBy"]];
    [cell.cellObservationByLabel setAttributedText:[self MakeattributedString:ObservationBysrring And:2]];
    NSString *Observationsrring =[NSString stringWithFormat:@"Observation :\n%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"CSObservation"]];
    [cell.cellObservationLabel setAttributedText:[self MakeattributedString:Observationsrring And:3]];
    [cell.cellObservationLabel sizeToFit];
    [cell.cellObservationByLabel sizeToFit];
    
    CGRect frame = cell.cellObservationLabel.frame;
    CGFloat y = (cell.cellObservationByLabel.frame.origin.y+cell.cellObservationByLabel.frame.size.height)+10;
    frame.origin.y=y;
    cell.cellObservationLabel.frame=frame;
    CGRect frame1 = cell.cellMainView.frame;
    CGFloat height = (frame.origin.y+frame.size.height)+10;
    frame1.size.height=height;
    CGRect frameofcomment=cell.btn_comment.frame;
    CGFloat Yofcomment=cell.cellObservationLabel.frame.origin.y+cell.cellObservationLabel.frame.size.height+20;
    CGFloat hieghtofcomment=10;
    frameofcomment.origin.y=Yofcomment;
    frameofcomment.size.height=hieghtofcomment;
    cell.btn_comment.frame=frameofcomment;
    
    CGRect frame2 = cell.cellMainView.frame;
    CGFloat height1 = (frameofcomment.origin.y+frameofcomment.size.height)+20;
    frame2.size.height=height1;
    cell.cellMainView.frame=frame2;
    cell.cellMainScrView.frame=frame2;

        return height1+10;

    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (tableView == _tableview_showComment) {
         return commentArray.count;
     }else{
    return mainArray1.count;
    // Return the number of rows in the section.
}
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableview_showComment) {
        NSString *CellIdentifier =@"CommentTableViewCell";
        CommentTableViewCell *cell =(CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.lbl_comment.text=[NSString stringWithFormat:@"%@",[[commentArray objectAtIndex:indexPath.row]objectForKey:@"CSObservation"]];
       // [cell.lbl_comment sizeToFit];
//        CGRect frame=cell.lbl_comment.frame;
//        CGFloat y=8;
//        CGFloat width=cell.view_commentMain.frame.size.width-16;
//        frame.origin.y=y;
//        frame.size.width=width;
//        cell.lbl_comment.frame=frame;
//        CGRect frame2 =cell.view_commentMain.frame;
//        CGFloat y1=0;
//        CGFloat width1=self.view.frame.size.width-16;
//        CGFloat height1=cell.lbl_comment.frame.size.height+16;
//        frame2.origin.y=y1;
//        frame2.size.width=width1;
//        frame2.size.height=height1;
//        cell.view_commentMain.frame=frame2;
        
//        CGRect frame1=cell.cellview_gap.frame;
//        frame1.origin.y=frame2.origin.y+frame2.size.height;
//        cell.cellview_gap.frame=frame1;
//        CGFloat hight=frame1.origin.y+frame1.size.height+10;
        return cell;

    }else{
    
    NSString *CellIdentifier =@"DrObservationCell";
    DrObservationTableViewCell *cell =(DrObservationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   NSString*date=   [self setDate:[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"CSObservationDate"]]];
    NSString *dateString =[NSString stringWithFormat:@"Date : %@",date];

    [cell.cellDateLabel setAttributedText:[self MakeattributedString:dateString And:1]];
    NSString *ObservationBysrring =[NSString stringWithFormat:@"Observation by %@ On Date %@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"CSObservationBy"],date];
        [cell.cellObservationByLabel setAttributedText:[self MakeattributedString:ObservationBysrring And:2]];
         NSString *Observationsrring =[NSString stringWithFormat:@"Observation \n%@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"CSObservation"]];
        [cell.cellObservationLabel setAttributedText:[self MakeattributedString:Observationsrring And:3]];

      [cell.cellObservationLabel sizeToFit];
    [cell.cellObservationByLabel sizeToFit];
    
    [cell.btn_comment addTarget:self action:@selector(commentTaped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_comment.layer.borderWidth=1.0f;
        cell.btn_comment.layer.cornerRadius=10.0f;
        //cell.btn_comment.titleLabel.textColor=   [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
        cell.btn_comment.layer.borderColor=   [UIColor lightGrayColor].CGColor;
    cell.btn_comment.tag=indexPath.row;
    cell.btn_comment.layer.cornerRadius=5.0f;
    
    
    
    CGRect frame = cell.cellObservationLabel.frame;
    CGFloat y = (cell.cellObservationByLabel.frame.origin.y+cell.cellObservationByLabel.frame.size.height)+10;
    frame.origin.y=y;
    cell.cellObservationLabel.frame=frame;
    CGRect frameofcomment=cell.btn_comment.frame;
    CGFloat Yofcomment=cell.cellObservationLabel.frame.origin.y+cell.cellObservationLabel.frame.size.height+20;
    CGFloat hieghtofcomment=30;
    frameofcomment.origin.y=Yofcomment;
    frameofcomment.size.height=hieghtofcomment;
    cell.btn_comment.frame=frameofcomment;
    
     CGRect frame1 = cell.cellMainView.frame;
    CGFloat height = (frameofcomment.origin.y+frameofcomment.size.height)+20;
    frame1.size.height=height;
    cell.cellMainView.frame=frame1;
    cell.cellMainScrView.frame=frame1;
    
////////////////////////////////
    
    
    
    
    
    
    
    
    
    
//    [cell.cellObservationByLabel setAttributedText:[self MakeattributedString:ObservationBysrring And:2]];
//     NSString *Observationsrring =[NSString stringWithFormat:@"Observation : %@",[[mainArray1 objectAtIndex:indexPath.row]objectForKey:@"CSObservation"]];
//    [cell.cellObservationLabel setAttributedText:[self MakeattributedString:Observationsrring And:3]];
//
    return cell;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIStoryboard* mainStoryBoard;
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
//            mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
//        }
//        else{
            mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
//        }
        
        
//        MainGridViewController* MainGridViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainGridViewController"];
//
//
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:MainGridViewController];
//
//        [MainGridViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
//        [navController setViewControllers: @[MainGridViewController] animated: YES];
        
//        self.revealViewController.frontViewController = navController;
        
        
    }
}
-(void)getdrObservation{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
   
   
    NSString *post =[NSString stringWithFormat:@"XMLcustomerid=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><Observations><Observation><customerid>%@</customerid></Observation></Observations></NeoFitnes>",UserName,password,UserName];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetCustomerObservation"]]];
    
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
    if( [elementName isEqualToString:@"CSObservation"]||[elementName isEqualToString:@"CSObservationDate"]||[elementName isEqualToString:@"CSObservationId"] ||[elementName isEqualToString:@"CSObservationBy"] ||[elementName isEqualToString:@"ErrorMessage"])
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
    if( [elementName isEqualToString:@"CSObservation"])
    {
        xmlResults = FALSE;
        [CSObservation addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"CSObservationDate"])
    {
        xmlResults = FALSE;
        [CSObservationDate addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"CSObservationBy"])
    {
        xmlResults = FALSE;
        [CSObservationBy addObject:soapResults];
        soapResults = nil;
    }
    
       if( [elementName isEqualToString:@"CSObservationId"])
    {
        xmlResults = FALSE;
        [CSObservationId addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"ErrorMessage"])
    {
        xmlResults = FALSE;
        [ErrorMessage addObject:soapResults];
        soapResults = nil;
    }
}
-(void)setPropertyoflabel:(UILabel*)label{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        [label setFont:[UIFont systemFontOfSize:10]];
    }
    else{
        [label setFont:[UIFont systemFontOfSize:7]];
    }
    // label.backgroundColor = [UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1];
    label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    
    
    
    //label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
}
-(NSString*)setDate:(NSString*)datestring1{
    if (datestring1==nil) {
        return 0;
    }
    else{
        //        NSString *string1 = datestring1 ;
        //        NSRange range1 = NSMakeRange(0, 10);
        //        NSString *shortDateString = [string1 substringWithRange:range1];
        //NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:shortDateString];
      NSDateFormatter *dateFormatter=[NSDateFormatter new];
        
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
        NSDate *date=[dateFormatter dateFromString:datestring1];
        
        NSDateFormatter *dfTime = [NSDateFormatter new];
        [dfTime setDateFormat:@"dd-MM-yyyy"];
        NSString *time=[dfTime stringFromDate:date];
        
           return time;
    }
    
}
-(NSMutableAttributedString*)MakeattributedString:(NSString*)string And:(int)type{
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:string];
    UIFont *font_regular;
    UIFont *font_bold;
     if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
         font_regular=[UIFont fontWithName:@"Helvetica" size:14.0f];
         font_bold=[UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
     }else{
    font_regular=[UIFont fontWithName:@"Helvetica" size:12.0f];
    font_bold=[UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
     }
    [attString addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, string.length)];
    if (type==1) {
         [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(0, 6)];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 6)];
        
    }
    
   else if (type==2) {
        //[attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(0, 15)];
       NSDictionary *linkAttributes2 = @{NSForegroundColorAttributeName: [UIColor redColor],
                                         NSFontAttributeName:font_bold,
                                         
//                                         NSUnderlineColorAttributeName: [UIColor blackColor],
//                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                         
                                         };
       NSDictionary *linkAttributes3 = @{
                                         NSFontAttributeName:font_bold,
                                         
                                         //                                         NSUnderlineColorAttributeName: [UIColor blackColor],
                                         //                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                         
                                         };
       [attString addAttributes:linkAttributes2 range:[[attString string] rangeOfString:@"Observation by"]];
       [attString addAttributes:linkAttributes3 range:[[attString string] rangeOfString:@"Date"]];
       
      // [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 16)];
    }
   else if (type==3) {
       [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(0, 13)];
       [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 13)];
   }

    
//    [attString addAttribute:NSUnderlineStyleAttributeName
//                      value:[NSNumber numberWithInt:1]
//                      range:(NSRange){171,8}];
    return attString;
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
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Your Feedback"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [self moveViewUpOrDown:@"UP"];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Your Feedback";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [self moveViewUpOrDown:@"down"];
    [textView resignFirstResponder];
}
-(BOOL)textViewShouldReturn:(UITextView *)textView{
    
    [self moveViewUpOrDown:@"down"];
    [textView resignFirstResponder];
    return YES;
}
/*- (void)textViewDidChange:(UITextView *)textView
{
    
    CGFloat origanalY=textView.frame.origin.y;
    CGFloat hieght=textView.frame.size.height;
    if (hieght>=70) {
        return;
    }
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    CGFloat newhight=newFrame.size.height;
    
//    CGFloat differencehieght=newhight-hieght;
//    newFrame.origin.y=origanalY- differencehieght;
    
    textView.frame = newFrame;
    CGRect buttonFrame =self.btn_postcomment.frame;
     CGRect buttonFrame1 =self.btn_viewcommenrCross.frame;
    CGFloat y=newFrame.origin.y+newFrame.size.height;
    
    buttonFrame.origin.y=y;
    buttonFrame1.origin.y=y;
    self.btn_postcomment.frame=buttonFrame;
    self.btn_viewcommenrCross.frame=buttonFrame1;
 
}*/
-(void)setTextviewHieght:(UITextView*)textView{
    CGFloat origanalY=textView.frame.origin.y;
    CGFloat hieght=textView.frame.size.height;
    CGFloat contantsize = textView.contentSize.height-13;
    if (contantsize<hieght) {
        return;
    }
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    CGFloat newhight=newFrame.size.height;
    
    CGFloat differencehieght=newhight-hieght;
    newFrame.origin.y=origanalY- differencehieght;
    
    textView.frame = newFrame;
    
  
    
}
-(void)commentTaped:(id)sender{
    
    UIButton*btn=(UIButton*)sender;
    clickedBtntag=0;
    clickedBtntag=btn.tag;
    
    _view_writeComment.hidden=NO;
    _view_drobservation.hidden=YES;
    [self initialDelayEndeddropDownView:@"show"];
    [self getThreadingFeedback];
}


-(void)initialDelayEndeddropDownView:(NSString*)str

{
    if ([str isEqualToString:@"show"]) {
        self.view_writecommentanimation.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    }
    else{
        self.view_writecommentanimation.transform = CGAffineTransformIdentity;
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
        self.view_writecommentanimation.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    }
    else{
        self.view_writecommentanimation.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    }
    [UIView commitAnimations];
    
}



- (void)animationFinished2:(NSString *)a finished:(BOOL)finished context:(void *)context

{
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.1];
    if ([a isEqualToString:@"show"]) {
        self.view_writecommentanimation.transform = CGAffineTransformIdentity;
    }else{
        self.view_writecommentanimation.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        
    }
    
    [UIView commitAnimations];
    
    if ([a isEqualToString:@"show"]) {
    }else{
        _view_writeComment.hidden=YES;
    }
    
    
    
}
-(void)btn_postcommentTaped:(id)sender{
    if ([_textview_comment.text isEqualToString:@"Your Feedback"] || _textview_comment.text.length==0 ||[_textview_comment.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter comment." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
    }else{
        [self moveViewUpOrDown:@"down"];
         [_view_writeComment resignFirstResponder];
     // [self initialDelayEndeddropDownView:@"hide"];
        NSString*commenttext=[NSString stringWithFormat:@"%@",_textview_comment.text];
        
        [self insertThreadingFeedback:commenttext];
    }
}
-(void)btn_viewcommenrCrossTaped:(id)sender{
    [self moveViewUpOrDown:@"down"];
    [_view_writeComment resignFirstResponder];
    _view_writeComment.hidden=YES;
    _tableview_showComment.hidden=YES;
    _view_norecord.hidden=YES;
    _table_drObservation.hidden=NO;
    _view_drobservation.hidden=NO;
}

-(void)getThreadingFeedback{
    [commentArray removeAllObjects];
    _tableview_showComment.hidden=NO;
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
   
    
    NSString*CSObservationId1=[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:clickedBtntag]objectForKey:@"CSObservationId"]];
    
    NSString *post =[NSString stringWithFormat:@"Customerdetail=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><GetObservationFeedback><CSCustomerObservationId>%@</CSCustomerObservationId></GetObservationFeedback></NeoFitnes>",UserName,password,CSObservationId1];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetObservationFeedbackThreading"]]];
    
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
        [self.tableview_showComment reloadData];
        return;
    }
   id object  =[[responseDictonary objectForKey:@"GetObservationFeedback"]objectForKey:@"ObservationFeedbacks"];
    
    
    
    if([object isKindOfClass:[NSArray class]]){
        commentArray=object;
        //Is array
    }else if([object isKindOfClass:[NSDictionary class]]){
        [commentArray addObject:object];
        //is dictionary
    }
    

    NSLog(@"%lu",(unsigned long)commentArray.count);
    [self.tableview_showComment reloadData];
    
 
}


-(void)insertThreadingFeedback:(NSString*)text{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSString*CSObservationId1=[NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:clickedBtntag]objectForKey:@"CSObservationId"]];
    
    NSString *post =[NSString stringWithFormat:@"strXMLs=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><Mobile><GetObservationFeedback><CustomerId>%@</CustomerId><CSObservation>%@</CSObservation><CSObservationBy>%@</CSObservationBy><CSObservationDate>%@</CSObservationDate><CSCustomerObservationId>%@</CSCustomerObservationId></GetObservationFeedback></Mobile></NeoFitnes>",UserName,password,MemberID,text,MemberID,dateString,CSObservationId1];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/InsertObservationFeedbackThreading"]]];
    
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
        [self.textview_comment resignFirstResponder];
        [self.textview_comment setText:@"Your Feedback"];
         [self getThreadingFeedback];
        return;
    } else {
         [[[UIAlertView alloc] initWithTitle:@"" message:@"Observation Added successfullyssage1" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        [self.textview_comment resignFirstResponder];
        [self.textview_comment setText:@"Your Feedback"];
        [self getThreadingFeedback];
    }
//    responseArray=[[responseDictonary objectForKey:@"GetCustomerAssignedTrainer"]objectForKey:@"AssignedTrainer"];
   

}
-(void)moveViewUpOrDown:(NSString *)string{
    CGFloat upDownValue = 0;
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        upDownValue = -self.btn_postcomment.frame.origin.y+self.btn_postcomment.frame.size.height+64;
//    
    if ([string isEqualToString:@"UP"]){
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
       upDownValue = -self.btn_postcomment.frame.origin.y+self.btn_postcomment.frame.size.height+280;
        else
        upDownValue = -self.btn_postcomment.frame.origin.y+self.btn_postcomment.frame.size.height+280;
    }
    else{
        upDownValue = 0;
    }
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.view.frame = CGRectMake(0, upDownValue, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
    
    
}

@end
