//
//  WorkoutCardViewController.m
//  NeoFitness
//
//  Created by Sumit Saini on 06/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutCardViewController.h"
#import "WorkoutCardTableViewCell.h"
#import "SWRevealViewController.h"
#import "XMLReader.h"
#import "MainGridViewController.h"
@interface WorkoutCardViewController ()
{
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
    NSString *errorMessage;
    NSMutableArray *DayArray;
    NSMutableArray *TimesArray;
    
    NSMutableArray *RepeatArray;
    
    NSMutableArray *SestArray;
    
    NSMutableArray *ExerciseNameArray;
    
    NSMutableArray *BodyPartArray;
    
     NSMutableArray *RemarksArray;
     NSMutableArray *SequenceArray;
     NSMutableArray *RENEWALDATEArray;
    NSMutableArray *searcharray;
    
    NSMutableArray *CREATEDDATEArray;
    NSMutableArray *mainArray1;
    NSMutableArray *TableDataArr;
    CGFloat hieght;
     NSMutableArray *ErrorMessage;
    int h;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblCreatedDate;
@property (weak, nonatomic) IBOutlet UILabel *lblRenewDate;
@property (weak, nonatomic) IBOutlet UIView *view_norecord;


@end

@implementation WorkoutCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DayArray =[[NSMutableArray alloc]init];
    TimesArray =[[NSMutableArray alloc]init];
    RepeatArray =[[NSMutableArray alloc]init];
    SestArray =[[NSMutableArray alloc]init];
    ExerciseNameArray =[[NSMutableArray alloc]init];
    BodyPartArray =[[NSMutableArray alloc]init];
        RemarksArray =[[NSMutableArray alloc]init];
    SequenceArray =[[NSMutableArray alloc]init];
    RENEWALDATEArray =[[NSMutableArray alloc]init];
       mainArray1 =[[NSMutableArray alloc]init];
        CREATEDDATEArray =[[NSMutableArray alloc]init];
 searcharray =[[NSMutableArray alloc]init];
    ErrorMessage =[[NSMutableArray alloc]init];
    TableDataArr =[[NSMutableArray alloc]init];
   // [ mainArray1 removeAllObjects];
    //[ TableDataArr removeAllObjects];
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
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer: tapRec];
 
    [self getGroupClass];
    
    
    for (int i=0; i<DayArray.count; i++) {
        NSDictionary *dict = @{@"DayArray" : DayArray[i],
                               @"Times"   : TimesArray[i],
                               @"Repeat"   : RepeatArray[i],
                               @"Sest"   : SestArray[i],
                               @"ExerciseName"   : ExerciseNameArray[i],
                               @"BodyPart"   : BodyPartArray[i],
                               @"Remarks"   : RemarksArray[i],
                               @"Sequence"   : SequenceArray[i],
                               @"RENEWALDATE"   : RENEWALDATEArray[i],
                               @"CREATEDDATE"   : CREATEDDATEArray[i],

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
    

   searcharray = mainArray1 ;
    [self getValue];
       // Do any additional setup after loading the view.
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
-(void)tap:(UITapGestureRecognizer *)tapRec{
    [[self view] endEditing: YES];
}
-(void)whensearch{
    for (int i=0; i<DayArray.count; i++) {
        NSDictionary *dict = @{@"DayArray" : DayArray[i],
                               @"Times"   : TimesArray[i],
                               @"Repeat"   : RepeatArray[i],
                               @"Sest"   : SestArray[i],
                               @"ExerciseName"   : ExerciseNameArray[i],
                               @"BodyPart"   : BodyPartArray[i],
                               @"Remarks"   : RemarksArray[i],
                               @"Sequence"   : SequenceArray[i],
                               @"RENEWALDATE"   : RENEWALDATEArray[i],
                               @"CREATEDDATE"   : CREATEDDATEArray[i],
                               
                               };
        
        [mainArray1 addObject: dict];
    }
    
    
    [self getValue];

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
    NSLog(@"%lu", ([[TableDataArr objectAtIndex:indexPath.row] count]*20)+40);
    return ([[TableDataArr objectAtIndex:indexPath.row] count]*30)+64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TableDataArr.count;
    // Return the number of rows in the section.
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"WorkoutCardCell";
    WorkoutCardTableViewCell *cell =(WorkoutCardTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     [self setDate];
    NSDictionary *currentDict = [[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:indexPath.row];
    cell.lblDay.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"DayArray"]];
    cell.lblBodyPartValue.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"BodyPart"]];
    cell.lblExcerciseValue.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"ExerciseName"]];
    cell.lblSetsValue.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Sest"]];
    cell.lblRepValue.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Repeat"]];
    cell.lblTimeValue.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Times"]];
    cell.lblSeqValue.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Sequence"]];
    cell.lblRemarkValue.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Remarks"]];
    
//
//    for (UIView *view in [cell.mainView subviews]){
//        if(view.tag != 1004 && view.tag != 1003 && view.tag != 1002 && view.tag != 1001 && view.tag != 1000 && view.tag != 999 ){
//            [view removeFromSuperview];
//        }
//    }
//
//
//    [self showView:(WorkoutCardTableViewCell *)cell and:indexPath];
    
  
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)getGroupClass{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    
    
    
    NSString *post =[NSString stringWithFormat:@"XMLcustomerid=<NeoFitnes> <Credential><UserName>%@</UserName><Password>%@</Password></Credential> <WorkoutCard> <Workout><customerid>%@</customerid><EmailId>%@</EmailId></Workout></WorkoutCard></NeoFitnes>",UserName,password,MemberID,@""];
    
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetCustomerWorkout"]]];
    
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
   
    if( [elementName isEqualToString:@"DayName"]||[elementName isEqualToString:@"BodyPart"] ||[elementName isEqualToString:@"ExerciseName"] ||[elementName isEqualToString:@"Sest"] ||[elementName isEqualToString:@"Repeat"] ||[elementName isEqualToString:@"Times"] ||[elementName isEqualToString:@"Remarks"] ||[elementName isEqualToString:@"Sequence"] ||[elementName isEqualToString:@"RENEWALDATE"] ||[elementName isEqualToString:@"CREATEDDATE"]||[elementName isEqualToString:@"ErrorMessage"]
)
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
    
    
    if( [elementName isEqualToString:@"DayName"])
    {
        xmlResults = FALSE;
        [DayArray addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"BodyPart"])
    {
        xmlResults = FALSE;
        [BodyPartArray addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"ExerciseName"])
    {
        xmlResults = FALSE;
        [ExerciseNameArray addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"Sest"])
    {
        xmlResults = FALSE;
        [SestArray addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"Repeat"])
    {
        xmlResults = FALSE;
        [RepeatArray addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"Times"])
    {
        xmlResults = FALSE;
        [TimesArray addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"Remarks"])
    {
        xmlResults = FALSE;
        [RemarksArray addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"Sequence"])
    {
        xmlResults = FALSE;
        [SequenceArray addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"RENEWALDATE"])
    {
        xmlResults = FALSE;
        [RENEWALDATEArray addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"CREATEDDATE"])
    {
        xmlResults = FALSE;
        [CREATEDDATEArray addObject:soapResults];
        soapResults = nil;
    }

    if( [elementName isEqualToString:@"ErrorMessage"])
    {
        xmlResults = FALSE;
        [ErrorMessage addObject:soapResults];
        soapResults = nil;
    }
   
}

-(void)getValue{
   
    while (TableDataArr.count< 7){
        NSMutableArray *temparr= [[NSMutableArray alloc]init];
        NSArray *dayarr = [[NSArray alloc] initWithObjects:@"Monday",@"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
        NSString *currentDay = [dayarr objectAtIndex:TableDataArr.count];
        for (int i=0; i<mainArray1.count; i++) {
            NSString *daystring = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]valueForKey:@"DayArray"]];
            
            if ([daystring isEqualToString:currentDay]) {
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[mainArray1 objectAtIndex:i]];
                [temparr addObject: dict];
            }
            
        }
       
        
        [TableDataArr addObject:temparr];
        
    }
    
    for (NSInteger j=[TableDataArr count]-1; j>=0; j--){
        if ([[TableDataArr objectAtIndex:j] count] == 0)
            [TableDataArr removeObjectAtIndex:j];
    }

    [self.tableView reloadData];
}

-(void)showView:(WorkoutCardTableViewCell *)cell and:(NSIndexPath*)indexPath{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        [self setDate];
        CGFloat   highestLengthOfText7 =[self callculateHigestLength:7 and:indexPath];
        CGFloat   highestLengthOfText1 =[self callculateHigestLength:1 and:indexPath];
        CGFloat   highestLengthOfText2 =[self callculateHigestLength:2 and:indexPath];
        CGFloat   highestLengthOfText3 =[self callculateHigestLength:3 and:indexPath];
        CGFloat   highestLengthOfText4 =[self callculateHigestLength:4 and:indexPath];
        CGFloat   highestLengthOfText5 =[self callculateHigestLength:5 and:indexPath];
        CGFloat   highestLengthOfText6 =[self callculateHigestLength:6 and:indexPath];
        highestLengthOfText1=[self compareWidth:highestLengthOfText1];
        highestLengthOfText2=[self compareWidth:highestLengthOfText2];
        highestLengthOfText3=[self compareWidth:highestLengthOfText3];
        highestLengthOfText4=[self compareWidth:highestLengthOfText4];
        highestLengthOfText5=[self compareWidth:highestLengthOfText5];
        highestLengthOfText6=[self compareWidth:highestLengthOfText6];
        highestLengthOfText7=[self compareWidth:highestLengthOfText7];
        
        
        
        
        NSUInteger widthoflabel =self.view.frame.size.width+highestLengthOfText7;
        CGFloat X1=highestLengthOfText1;
        CGFloat X2=highestLengthOfText1+highestLengthOfText2;
        CGFloat X3=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3;
        CGFloat X4=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4;
        CGFloat X5=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4+highestLengthOfText5;
        CGFloat X6=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4+highestLengthOfText5+highestLengthOfText6;
        CGFloat X7=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4+highestLengthOfText5+highestLengthOfText6+highestLengthOfText7+45;

        CGFloat  width;
       

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblDay.text = [[[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"DayArray"];
        CGRect frame = cell.mainView.frame;
        frame.size.height = ([[TableDataArr objectAtIndex:indexPath.row] count]*30)+54;
        cell.mainView.frame = frame;
        [cell.mainView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainView.layer setBorderWidth:1.0f];
        UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:frame];
        //UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54, frame.size.width, ([[TableDataArr objectAtIndex:indexPath.row] count]*24))];
        [cell.mainView addSubview:scrollview];
        scrollview.backgroundColor = [UIColor clearColor];
        
        for(int i=0; i<[[TableDataArr objectAtIndex:indexPath.row] count]; i++){
            
            
            
            
            
            NSDictionary *currentDict = [[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:i];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(6, 25*(i+2)+1, frame.size.width, 27)];
            UILabel *bodyPartLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, highestLengthOfText1, 25)];
            cell.lblBodyPart.frame =CGRectMake(6, 24, highestLengthOfText1, 25);
            [self setPropertyoflabel:bodyPartLbl];
            bodyPartLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"BodyPart"]];
            
            UILabel *ExerciseNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(X1+5, 0, highestLengthOfText2, 25)];
            cell.lblExcercise.frame =CGRectMake(X1+11, 24, highestLengthOfText2, 25);
            
            [self setPropertyoflabel:ExerciseNameLbl];
            ExerciseNameLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"ExerciseName"]];
            
            UILabel *SestLbl = [[UILabel alloc] initWithFrame:CGRectMake(X2+10, 0, highestLengthOfText3, 25)];
            cell.lblSets.frame =CGRectMake(X2+10, 24, highestLengthOfText3, 25);
            [self setPropertyoflabel:SestLbl];
            SestLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Sest"]];
            
            UILabel *RepeatLbl = [[UILabel alloc] initWithFrame:CGRectMake(X3+15, 0, highestLengthOfText4, 25)];
            cell.lblRep.frame =CGRectMake(X3+15, 24, highestLengthOfText4, 25);
            [self setPropertyoflabel:RepeatLbl];
            RepeatLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Repeat"]];
            
            UILabel *TimesLbl = [[UILabel alloc] initWithFrame:CGRectMake(X4+20,0, highestLengthOfText5, 25)];
            cell.lblTime.frame =CGRectMake(X4+20,24, highestLengthOfText5, 25);
            NSString  *time=[NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Times"]];
            [self setPropertyoflabel:TimesLbl];
            if ([time isEqualToString:@" "]||[time isEqualToString:@"  "]||[time isEqualToString:@""]||time==nil) {
                TimesLbl.text = @"  0";
            }
            else{
                TimesLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Times"]];
            }
            UILabel *SequenceLbl = [[UILabel alloc] initWithFrame:CGRectMake(X5+25,0, highestLengthOfText6, 25)];
            cell.lblSeq.frame =CGRectMake(X5+25,24, highestLengthOfText6, 25);
            
            [self setPropertyoflabel:SequenceLbl];
            SequenceLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Sequence"]];
            UILabel *RemarksLbl = [[UILabel alloc] initWithFrame:CGRectMake(X6+30,0, highestLengthOfText7, 25)];
            cell.lblRemark.frame =CGRectMake(X6+30,24, highestLengthOfText7, 25);
            //        UILabel *RemarksLbl = [[UILabel alloc] init];
            
            [self setPropertyoflabel:RemarksLbl];
            RemarksLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Remarks"]];
            //width = ceil([RemarksLbl.text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:9.0]}].width)+12;
            // RemarksLbl.frame =CGRectMake((highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4+highestLengthOfText5+highestLengthOfText6)+35, 0, highestLengthOfText7, 25);
            //scrollview.contentSize = CGSizeMake(320+width, 0);            scrollview.scrollEnabled = YES;
            
            
            [view addSubview:bodyPartLbl];
            [view addSubview:ExerciseNameLbl];
            [view addSubview:SestLbl];
            [view addSubview:RepeatLbl];
            [view addSubview:TimesLbl];
            [view addSubview:SequenceLbl];
            [view addSubview:RemarksLbl];
            
            [scrollview addSubview:view];
            // highestLengthOfText =     [self callculateHigestLength:indexPath and:cell ];
            
            
        }
        [scrollview addSubview:cell.lblExcercise];
        [scrollview addSubview:cell.lblSets];
        [scrollview addSubview:cell.lblRep];
        [scrollview addSubview:cell.lblTime];
        [scrollview addSubview:cell.lblSeq];
        cell.lblRemark.frame = CGRectMake(cell.lblRemark.frame.origin.x, cell.lblRemark.frame.origin.y, highestLengthOfText7, cell.lblRemark.frame.size.height);
        [scrollview addSubview:cell.lblRemark];
        
        [scrollview addSubview:cell.lblBodyPart];
        
        
        scrollview.contentSize = CGSizeMake(X7, 0);
        scrollview.scrollEnabled = YES;
        


    }
    else{
    
    
    [self setDate];
  
        CGFloat   highestLengthOfText7 =[self callculateHigestLength:7 and:indexPath];
        CGFloat   highestLengthOfText1 =[self callculateHigestLength:1 and:indexPath];
        CGFloat   highestLengthOfText2 =[self callculateHigestLength:2 and:indexPath];
        CGFloat   highestLengthOfText3 =[self callculateHigestLength:3 and:indexPath];
        CGFloat   highestLengthOfText4 =[self callculateHigestLength:4 and:indexPath];
        CGFloat   highestLengthOfText5 =[self callculateHigestLength:5 and:indexPath];
        CGFloat   highestLengthOfText6 =[self callculateHigestLength:6 and:indexPath];
        highestLengthOfText1=[self compareWidth:highestLengthOfText1];
        highestLengthOfText2=[self compareWidth:highestLengthOfText2];
        highestLengthOfText3=[self compareWidth:highestLengthOfText3];
        highestLengthOfText4=[self compareWidth:highestLengthOfText4];
        highestLengthOfText5=[self compareWidth:highestLengthOfText5];
        highestLengthOfText6=[self compareWidth:highestLengthOfText6];
         highestLengthOfText7=[self compareWidth:highestLengthOfText7];
        
        
        
        
        NSUInteger widthoflabel =self.view.frame.size.width+highestLengthOfText7;
        CGFloat X1=highestLengthOfText1;
        CGFloat X2=highestLengthOfText1+highestLengthOfText2;
        CGFloat X3=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3;
        CGFloat X4=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4;
        CGFloat X5=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4+highestLengthOfText5;
        CGFloat X6=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4+highestLengthOfText5+highestLengthOfText6;
CGFloat X7=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4+highestLengthOfText5+highestLengthOfText6+highestLengthOfText7+45;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblDay.text = [NSString stringWithFormat:@" %@", [[[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"DayArray"]];
    CGRect frame = cell.mainView.frame;
    frame.size.height = ([[TableDataArr objectAtIndex:indexPath.row] count]*30)+54;
    cell.mainView.frame = frame;
   // UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54, frame.size.width, ([[TableDataArr objectAtIndex:indexPath.row] count]*24))];
      
        UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:frame];
    [cell.mainView addSubview:scrollview];
        [cell.mainView.layer setBorderColor:[UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainView.layer setBorderWidth:1.0f];
    scrollview.backgroundColor = [UIColor clearColor];
   
    for(int i=0; i<[[TableDataArr objectAtIndex:indexPath.row] count]; i++){
        
        
        
        
        
                NSDictionary *currentDict = [[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(6, 25*(i+2)+1, frame.size.width, 27)];
        UILabel *bodyPartLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, highestLengthOfText1, 25)];
        cell.lblBodyPart.frame =CGRectMake(6, 24, highestLengthOfText1, 25);
        [self setPropertyoflabel:bodyPartLbl];
        bodyPartLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"BodyPart"]];
        
        UILabel *ExerciseNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(X1+5, 0, highestLengthOfText2, 25)];
         cell.lblExcercise.frame =CGRectMake(X1+11, 24, highestLengthOfText2, 25);
        
        [self setPropertyoflabel:ExerciseNameLbl];
        ExerciseNameLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"ExerciseName"]];
        
        UILabel *SestLbl = [[UILabel alloc] initWithFrame:CGRectMake(X2+10, 0, highestLengthOfText3, 25)];
        cell.lblSets.frame =CGRectMake(X2+10, 24, highestLengthOfText3, 25);
        [self setPropertyoflabel:SestLbl];
        SestLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Sest"]];
        
        UILabel *RepeatLbl = [[UILabel alloc] initWithFrame:CGRectMake(X3+15, 0, highestLengthOfText4, 25)];
        cell.lblRep.frame =CGRectMake(X3+15, 24, highestLengthOfText4, 25);
        [self setPropertyoflabel:RepeatLbl];
        RepeatLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Repeat"]];
        
        UILabel *TimesLbl = [[UILabel alloc] initWithFrame:CGRectMake(X4+20,0, highestLengthOfText5, 25)];
         cell.lblTime.frame =CGRectMake(X4+20,24, highestLengthOfText5, 25);
      NSString  *time=[NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Times"]];
        [self setPropertyoflabel:TimesLbl];
        if ([time isEqualToString:@" "]||[time isEqualToString:@"  "]||[time isEqualToString:@""]||time==nil) {
            TimesLbl.text = @"  0";
        }
        else{
        TimesLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Times"]];
        }
        UILabel *SequenceLbl = [[UILabel alloc] initWithFrame:CGRectMake(X5+25,0, highestLengthOfText6, 25)];
        cell.lblSeq.frame =CGRectMake(X5+25,24, highestLengthOfText6, 25);

        [self setPropertyoflabel:SequenceLbl];
        SequenceLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Sequence"]];
        UILabel *RemarksLbl = [[UILabel alloc] initWithFrame:CGRectMake(X6+30,0, highestLengthOfText7, 25)];
        cell.lblRemark.frame =CGRectMake(X6+30,24, highestLengthOfText7, 25);
//        UILabel *RemarksLbl = [[UILabel alloc] init];
        
        [self setPropertyoflabel:RemarksLbl];
        RemarksLbl.text = [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Remarks"]];
          //width = ceil([RemarksLbl.text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:9.0]}].width)+12;
      // RemarksLbl.frame =CGRectMake((highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4+highestLengthOfText5+highestLengthOfText6)+35, 0, highestLengthOfText7, 25);
        //scrollview.contentSize = CGSizeMake(320+width, 0);
        scrollview.scrollEnabled = YES;
        
        
        [view addSubview:bodyPartLbl];
        [view addSubview:ExerciseNameLbl];
        [view addSubview:SestLbl];
        [view addSubview:RepeatLbl];
        [view addSubview:TimesLbl];
        [view addSubview:SequenceLbl];
        [view addSubview:RemarksLbl];
        
        


        
        [scrollview addSubview:view];
        
        
    }
        [scrollview addSubview:cell.lblExcercise];
        [scrollview addSubview:cell.lblSets];
        [scrollview addSubview:cell.lblRep];
        [scrollview addSubview:cell.lblTime];
        [scrollview addSubview:cell.lblSeq];
        cell.lblRemark.frame = CGRectMake(cell.lblRemark.frame.origin.x, cell.lblRemark.frame.origin.y, highestLengthOfText7, cell.lblRemark.frame.size.height);
        [scrollview addSubview:cell.lblRemark];

        [scrollview addSubview:cell.lblBodyPart];
       
        
        scrollview.contentSize = CGSizeMake(X7, 0);
    scrollview.scrollEnabled = YES;
    }
    
    
}
-(void)setPropertyoflabel:(UILabel*)label{
    [label setFont:[UIFont systemFontOfSize:10]];
   // label.textAlignment = NSTextAlignmentCenter;
   // label.backgroundColor = [UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1];
    label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];

    
    //label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
}

-(void)setDate{
    NSString *datestring1 = [NSString stringWithFormat:@"  Created Date : %@",[[mainArray1 objectAtIndex:0] objectForKey:@"CREATEDDATE"]];
    NSString *string1 = datestring1 ;
    NSRange range1 = [string1 rangeOfString:@"12:00:00 AM"];
    NSString *shortDateString = [string1 substringToIndex:range1.location];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:shortDateString];
    
    UIFont *font_regular=[UIFont fontWithName:@"Helvetica" size:11.0f];
    UIFont *font_bold=[UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
    [attString addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, shortDateString.length)];
    [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(2, 12)];
    [self.lblCreatedDate setAttributedText:attString];
    NSString *datestring2 = [NSString stringWithFormat:@"  Renewal Date : %@",[[mainArray1 objectAtIndex:0] objectForKey:@"RENEWALDATE"]];
    NSString *string2 = datestring2 ;
    NSRange range2 = [string2 rangeOfString:@"12:00:00 AM"];
    NSString *shortDateString2 = [string2 substringToIndex:range2.location];
    
    NSMutableAttributedString *attString1=[[NSMutableAttributedString alloc] initWithString:shortDateString2];
    
  
    [attString1 addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, shortDateString2.length)];
    [attString1 addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(2, 12)];
    [self.lblRenewDate setAttributedText:attString1];
    //self.lblRenewDate.text = shortDateString2;

}
-(CGFloat)callculateHigestLength:(int)type and:(NSIndexPath*)index {
    CGFloat higestvalue=0;
    NSString *finalstring;
    
    for(int i=0; i<[[TableDataArr objectAtIndex:index.row] count]; i++){
         NSDictionary *currentDict = [[TableDataArr objectAtIndex:index.row] objectAtIndex:i];
        NSString * comment;
        if (type==7) {
            comment = [NSString stringWithFormat:@"%@",[currentDict objectForKey:@"Remarks"]];
        }
        else if (type==1){
          comment =  [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"BodyPart"]];
        }
        else if (type==2){
            comment =  [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"ExerciseName"]];
        }
        else if (type==3){
            comment =  [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Sest"]];
        }
        else if (type==4){
           comment =  [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Repeat"]];
        }
        else if (type==5){
           comment =  [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Times"]];
        }
        else if (type==6){
           comment =  [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Sequence"]];
        }
        
        CGFloat h1 =[comment length] ;
        if (h1>higestvalue) {
            higestvalue =30;
            finalstring = comment;
        }
        else{
            higestvalue = higestvalue;
            finalstring =finalstring;
        }
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
- (CGFloat)widthOfString:(NSString *)string withFont:(NSFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
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
              searchResults = [mainArray1 mutableCopy];
        mainArray1 = searcharray;
        
            }
        else {
        
                NSString *searchName = [name lowercaseString];
        
                NSPredicate *containsPredicate = [NSPredicate predicateWithFormat:@"self.DayArray CONTAINS[cd] %@" , searchName];
       
                searchResults = [[searcharray filteredArrayUsingPredicate:containsPredicate] mutableCopy];
        mainArray1 =searchResults;
            }
        // [self createSections];
    [TableDataArr removeAllObjects];
       [self getValue1];
        
}

-(void)getValue1{
    
    while (TableDataArr.count< 7){
        NSMutableArray *temparr= [[NSMutableArray alloc]init];
        NSArray *dayarr = [[NSArray alloc] initWithObjects:@"Monday",@"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
        NSString *currentDay = [dayarr objectAtIndex:TableDataArr.count];
        for (int i=0; i<mainArray1.count; i++) {
            NSString *daystring = [NSString stringWithFormat:@"%@",[[mainArray1 objectAtIndex:i]valueForKey:@"DayArray"]];
            
            if ([daystring isEqualToString:currentDay]) {
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[mainArray1 objectAtIndex:i]];
                [temparr addObject: dict];
            }
            
        }
        
        
        [TableDataArr addObject:temparr];
        
    }
    for (NSInteger j=[TableDataArr count]-1; j>=0; j--){
        if ([[TableDataArr objectAtIndex:j] count] == 0)
            [TableDataArr removeObjectAtIndex:j];
    }

    NSUInteger index = 0;
    while (index < [TableDataArr count]) {
        BOOL didRemove = false;
        if ([[TableDataArr objectAtIndex: index] count] == 0) {
            [TableDataArr removeObjectAtIndex: index];
            didRemove = true;
            
        }
        if (didRemove == false)
            index += 1;
        
    }

    NSLog(@"HIIIIIIII %@",TableDataArr);
    [self.tableView reloadData];
}

-(CGFloat)compareWidth:(CGFloat)Lenfth{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        if (Lenfth<130 ) {
            return 130
            ;
        }
        else{
            return Lenfth;
        }
        
    }else{
        
        if (Lenfth<60 ) {
            return 60;
        }
        else{
            return Lenfth;
        }
    }
}

@end
