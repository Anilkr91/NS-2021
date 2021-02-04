//
//  GroupClassesViewController.m
//  NeoFitness
//
//  Created by Sumit Saini on 05/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import "GroupClassesViewController.h"
#import "GroupClassesTableViewCell.h"
#import "SWRevealViewController.h"
#import "MainGridViewController.h"
#import "XMLReader.h"
@interface GroupClassesViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    NSMutableArray *ClassNameArray;

    NSMutableArray *TrainerNameArray;

    NSMutableArray *StartTimeArray;

    NSMutableArray *EndTimeArray;

    NSMutableArray *VenueArray;
 NSMutableArray *ErrorMessage;
    NSMutableArray *CreatedDateArray;
    NSMutableArray *mainArray;
    NSMutableArray *TableDataArr;
    CGFloat hieght;
    int h;
}
@property (weak, nonatomic) IBOutlet UIView *view_norecord;

@property (weak, nonatomic) IBOutlet UILabel *lblCreatedDate;


@property (weak, nonatomic) IBOutlet UITableView *tblView;
@end

@implementation GroupClassesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DayArray =[[NSMutableArray alloc]init];
    ClassNameArray =[[NSMutableArray alloc]init];
    TrainerNameArray =[[NSMutableArray alloc]init];
    StartTimeArray =[[NSMutableArray alloc]init];
    EndTimeArray =[[NSMutableArray alloc]init];
    VenueArray =[[NSMutableArray alloc]init];
    mainArray =[[NSMutableArray alloc]init];
     ErrorMessage =[[NSMutableArray alloc]init];
    CreatedDateArray =[[NSMutableArray alloc]init];
   
    
    TableDataArr =[[NSMutableArray alloc]init];

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
    if ([Utility connected]) {
        [self getGroupClass];
        
        
        for (int i=0; i<DayArray.count; i++) {
            NSDictionary *dict = @{@"DayArray" : DayArray[i],
                                   @"ClassName"   : ClassNameArray[i],
                                   @"TrainerName"   : TrainerNameArray[i],
                                   @"StartTimeArray"   : StartTimeArray[i],
                                   @"EndTime"   : EndTimeArray[i],
                                   @"Venue"   : VenueArray[i],
                                   @"CreatedDate"   : CreatedDateArray[i],
                                   
                                   };
            
            [mainArray addObject: dict];
        }
        if (!(ErrorMessage.count==0)) {
            _view_norecord.hidden=NO;
            NSString*string = [NSString stringWithFormat:@"%@",[ErrorMessage objectAtIndex:0]];
            [[[UIAlertView alloc] initWithTitle:@"" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            return;
        }
         _view_norecord.hidden=YES;
        [self getValue];
    
    }
    else{
      [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"NO Internate Connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];  
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
      if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
          
           return ([[TableDataArr objectAtIndex:indexPath.row] count]*30)+70;
      }
    else
    
    
    return ([[TableDataArr objectAtIndex:indexPath.row] count]*30)+54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TableDataArr.count;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =@"GroupClassesCell";
    GroupClassesTableViewCell *cell =(GroupClassesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
//    for (UIView *view in [cell.mainView subviews]){
//        if(view.tag != 1004 && view.tag != 1003 && view.tag != 1002 && view.tag != 1001 && view.tag != 1000 && view.tag != 999 ){
//            [view removeFromSuperview];
//        }
//    }

    
    [self showView:(GroupClassesTableViewCell *)cell and:indexPath];
    
    
    
       return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)getGroupClass{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  BranchId =    [userdefaults valueForKey:@"BranchId"];
     NSString *  GymId =    [userdefaults valueForKey:@"GymId"];
    
    
    NSString *post =[NSString stringWithFormat:@"BranchDetail=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><WorkoutCard><Workout> <BranchId>%@</BranchId><GymId>%@</GymId></Workout></WorkoutCard></NeoFitnes>",UserName,password,BranchId,GymId];
    
    
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetGroupClasses"]]];
    
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
   
    if( [elementName isEqualToString:@"DayName"]||[elementName isEqualToString:@"ClassName"] ||[elementName isEqualToString:@"TrainerName"] ||[elementName isEqualToString:@"StartTime"] ||[elementName isEqualToString:@"EndTime"] ||[elementName isEqualToString:@"Venue"] ||[elementName isEqualToString:@"CreatedDate"] ||[elementName isEqualToString:@"ErrorMessage"])
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
    if( [elementName isEqualToString:@"ClassName"])
    {
        xmlResults = FALSE;
        [ClassNameArray addObject:soapResults];
                soapResults = nil;
    }
    if( [elementName isEqualToString:@"TrainerName"])
    {
        xmlResults = FALSE;
        [TrainerNameArray addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"StartTime"])
    {
        xmlResults = FALSE;
       [StartTimeArray addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"EndTime"])
    {
        xmlResults = FALSE;
       [EndTimeArray addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"ErrorMessage"])
    {
        xmlResults = FALSE;
        [ErrorMessage addObject:soapResults];
        soapResults = nil;
    }
    

    
    if( [elementName isEqualToString:@"Venue"])
    {
        xmlResults = FALSE;
      [VenueArray addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"CreatedDate"])
    {
        xmlResults = FALSE;
        [CreatedDateArray addObject:soapResults];
        soapResults = nil;
    }
   
    
}

-(void)getValue{
    while (TableDataArr.count< 7){
        NSMutableArray *temparr= [[NSMutableArray alloc]init];
        NSArray *dayarr = [[NSArray alloc] initWithObjects:@"Sunday",@"Monday",@"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday",  nil];
        NSString *currentDay = [dayarr objectAtIndex:TableDataArr.count];
    for (int i=0; i<mainArray.count; i++) {
        NSString *daystring = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i]valueForKey:@"DayArray"]];
        
        if ([daystring isEqualToString:currentDay]) {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[mainArray objectAtIndex:i]];
            [temparr addObject: dict];
        }
         
        }
        [TableDataArr addObject:temparr];
        
        
    }
    for (NSInteger j=[TableDataArr count]-1; j>=0; j--){
        if ([[TableDataArr objectAtIndex:j] count] == 0)
            [TableDataArr removeObjectAtIndex:j];
    }
    NSLog(@"%@",TableDataArr);
    [self.tblView reloadData];
}

-(void)showView:(GroupClassesTableViewCell *)cell and:(NSIndexPath*)indexPath{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        
        CGFloat   highestLengthOfText1 =[self callculateHigestLength:1 and:indexPath];
        CGFloat   highestLengthOfText2 =[self callculateHigestLength:2 and:indexPath];
        CGFloat   highestLengthOfText3 =[self callculateHigestLength:3 and:indexPath];
        CGFloat   highestLengthOfText4 =[self callculateHigestLength:4 and:indexPath];
        CGFloat   highestLengthOfText5 =[self callculateHigestLength:5 and:indexPath];
        
        highestLengthOfText1=[self compareWidth:highestLengthOfText1];
        highestLengthOfText2=[self compareWidth:highestLengthOfText2];
        highestLengthOfText3=[self compareWidth:highestLengthOfText3];
        highestLengthOfText4=[self compareWidth:highestLengthOfText4];
        highestLengthOfText5=[self compareWidth:highestLengthOfText5];
        
        
        
        
        CGFloat X1=highestLengthOfText1;
        CGFloat X2=highestLengthOfText1+highestLengthOfText2;
        CGFloat X3=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3;
        CGFloat X4=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4;
        CGFloat X5=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4+highestLengthOfText5;
        CGFloat X6 =X5+35;

        NSString *datestring = [NSString stringWithFormat:@"  Created Date : %@",[[mainArray objectAtIndex:0] objectForKey:@"CreatedDate"]];
        NSString *string = datestring ;
        NSRange range = [string rangeOfString:@"12:00:00 AM"];
        NSString *shortDateString = [string substringToIndex:range.location];
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:shortDateString];
        
        UIFont *font_regular=[UIFont fontWithName:@"Helvetica" size:11.0f];
        UIFont *font_bold=[UIFont fontWithName:@"Helvetica-Bold" size:11.0f];
        [attString addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, shortDateString.length)];
        [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(2, 12)];
        [self.lblCreatedDate setAttributedText:attString];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblDay.text =[NSString stringWithFormat:@" %@", [[[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"DayArray"]];
        CGRect frame = cell.mainView.frame;
        frame.size.height = ([[TableDataArr objectAtIndex:indexPath.row] count]*30)+58;
        cell.mainView.frame = frame;
        [cell.mainView.layer setBorderColor:[UIColor  colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainView.layer setBorderWidth:1.0f];

        UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:frame];

               [cell.mainView addSubview:scrollview];
        scrollview.backgroundColor = [UIColor clearColor];
        
        for(int i=0; i<[[TableDataArr objectAtIndex:indexPath.row] count]; i++){
            
            NSDictionary *currentDict = [[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:i];
           
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, 25*(i+2)+5, frame.size.width, 27)];
            UILabel *classNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, highestLengthOfText1, 25)];
            cell.lblClassName.frame =CGRectMake(8, 26, highestLengthOfText1, 21);
            [self setPropertyoflabel:classNameLbl];
            classNameLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"ClassName"]];
            
            UILabel *trainerNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(X1+5, 0, highestLengthOfText2, 25)];
            cell.lblTrainer.frame =CGRectMake(X1+13, 26, highestLengthOfText2, 21);
            [self setPropertyoflabel:trainerNameLbl];
            NSString * trainerName = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"TrainerName"]];
            if ([trainerName isEqualToString:@" "]||[trainerName isEqualToString:@"  "]||[trainerName isEqualToString:@""]||trainerName==nil) {
                trainerNameLbl.text = @"  0";
            }
            else{
                
                trainerNameLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"TrainerName"]];
            }
            UILabel *startTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(X2+10, 0, highestLengthOfText3, 25)];
            cell.lblstartTime.frame =CGRectMake(X2+18, 26, highestLengthOfText3, 21);
            [self setPropertyoflabel:startTimeLbl];
            startTimeLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"StartTimeArray"]];
            
            UILabel *endTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(X3+15, 0, highestLengthOfText4, 25)];
            cell.LblEndTime.frame =CGRectMake(X3+23, 26, highestLengthOfText4, 21);
            [self setPropertyoflabel:endTimeLbl];
            endTimeLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"EndTime"]];
            
            UILabel *venueLbl = [[UILabel alloc] initWithFrame:CGRectMake(X4+20,0, highestLengthOfText5, 25)];
            cell.lblVanue.frame =CGRectMake(X4+28,26, highestLengthOfText5, 21);
            [self setPropertyoflabel:venueLbl];
            venueLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"Venue"]];
            
            
            
            [view addSubview:classNameLbl];
            [view addSubview:trainerNameLbl];
            [view addSubview:startTimeLbl];
            [view addSubview:endTimeLbl];
            [view addSubview:venueLbl];
            
            [scrollview addSubview:view];
        }
        [scrollview addSubview:cell.lblClassName];
        [scrollview addSubview:cell.lblTrainer];
        [scrollview addSubview:cell.lblstartTime];
        [scrollview addSubview:cell.LblEndTime];
        [scrollview addSubview:cell.lblVanue];
        
        scrollview.contentSize = CGSizeMake(X6, 0);
        scrollview.scrollEnabled = YES;

        
    }
    
    else{
        
        
        CGFloat   highestLengthOfText1 =[self callculateHigestLength:1 and:indexPath];
        CGFloat   highestLengthOfText2 =[self callculateHigestLength:2 and:indexPath];
        CGFloat   highestLengthOfText3 =[self callculateHigestLength:3 and:indexPath];
        CGFloat   highestLengthOfText4 =[self callculateHigestLength:4 and:indexPath];
        CGFloat   highestLengthOfText5 =[self callculateHigestLength:5 and:indexPath];
        
        highestLengthOfText1=[self compareWidth:highestLengthOfText1];
        highestLengthOfText2=[self compareWidth:highestLengthOfText2];
        highestLengthOfText3=[self compareWidth:highestLengthOfText3];
        highestLengthOfText4=[self compareWidth:highestLengthOfText4];
        highestLengthOfText5=[self compareWidth:highestLengthOfText5];
        
        
        
       
        CGFloat X1=highestLengthOfText1;
        CGFloat X2=highestLengthOfText1+highestLengthOfText2;
        CGFloat X3=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3;
        CGFloat X4=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4;
        CGFloat X5=highestLengthOfText1+highestLengthOfText2+highestLengthOfText3+highestLengthOfText4+highestLengthOfText5;
        CGFloat X6 =X5+35;
    
    
        NSString *datestring = [NSString stringWithFormat:@"  Created Date : %@",[[mainArray objectAtIndex:0] objectForKey:@"CreatedDate"]];
        NSString *string = datestring ;
        NSRange range = [string rangeOfString:@"12:00:00 AM"];
        NSString *shortDateString = [string substringToIndex:range.location];
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:shortDateString];
        
       UIFont *font_regular=[UIFont fontWithName:@"Helvetica" size:11.0f];
        UIFont *font_bold=[UIFont fontWithName:@"Helvetica-Bold" size:11.0f];
       [attString addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, shortDateString.length)];
        [attString addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(2, 12)];
        [self.lblCreatedDate setAttributedText:attString];
     
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblDay.text =[NSString stringWithFormat:@" %@", [[[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"DayArray"]];
        CGRect frame = cell.mainView.frame;
        frame.size.height = ([[TableDataArr objectAtIndex:indexPath.row] count]*30)+51;
        cell.mainView.frame = frame;
        [cell.mainView.layer setBorderColor:[UIColor  colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1].CGColor];
        [cell.mainView.layer setBorderWidth:1.0f];
   
        UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:frame];
        [cell.mainView addSubview:scrollview];
        
        scrollview.backgroundColor = [UIColor clearColor];
        for(int i=0; i<[[TableDataArr objectAtIndex:indexPath.row] count]; i++){
            NSDictionary *currentDict = [[TableDataArr objectAtIndex:indexPath.row] objectAtIndex:i];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, 25*(i+2)+1, frame.size.width, 27)];
            UILabel *classNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, highestLengthOfText1, 25)];
            cell.lblClassName.frame =CGRectMake(8, 26, highestLengthOfText1, 21);
            [self setPropertyoflabel:classNameLbl];
            classNameLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"ClassName"]];
            
            UILabel *trainerNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(X1+5, 0, highestLengthOfText2, 25)];
            cell.lblTrainer.frame =CGRectMake(X1+13, 26, highestLengthOfText2, 21);
            [self setPropertyoflabel:trainerNameLbl];
            NSString * trainerName = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"TrainerName"]];
            if ([trainerName isEqualToString:@" "]||[trainerName isEqualToString:@"  "]||[trainerName isEqualToString:@""]||trainerName==nil) {
                trainerNameLbl.text = @"  0";
            }
            else{
                
                trainerNameLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"TrainerName"]];
            }
            UILabel *startTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(X2+10, 0, highestLengthOfText3, 25)];
            cell.lblstartTime.frame =CGRectMake(X2+18, 26, highestLengthOfText3, 21);
            [self setPropertyoflabel:startTimeLbl];
            startTimeLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"StartTimeArray"]];
            
            UILabel *endTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(X3+15, 0, highestLengthOfText4, 25)];
            cell.LblEndTime.frame =CGRectMake(X3+23, 26, highestLengthOfText4, 21);
            [self setPropertyoflabel:endTimeLbl];
            endTimeLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"EndTime"]];
            
            UILabel *venueLbl = [[UILabel alloc] initWithFrame:CGRectMake(X4+20,0, highestLengthOfText5, 25)];
             cell.lblVanue.frame =CGRectMake(X4+28,26, highestLengthOfText5, 21);
            [self setPropertyoflabel:venueLbl];
            venueLbl.text = [NSString stringWithFormat:@"  %@",[currentDict objectForKey:@"Venue"]];
            
            
            
            [view addSubview:classNameLbl];
            [view addSubview:trainerNameLbl];
            [view addSubview:startTimeLbl];
            [view addSubview:endTimeLbl];
            [view addSubview:venueLbl];
            
            [scrollview addSubview:view];
        }
        
        [scrollview addSubview:cell.lblClassName];
        [scrollview addSubview:cell.lblTrainer];
        [scrollview addSubview:cell.lblstartTime];
        [scrollview addSubview:cell.LblEndTime];
        [scrollview addSubview:cell.lblVanue];
        scrollview.contentSize = CGSizeMake(X6, 0);
        scrollview.scrollEnabled = YES;
    
    }
    
   }
-(void)setPropertyoflabel:(UILabel*)label{
    [label setFont:[UIFont systemFontOfSize:10]];

    label.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];

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
-(CGFloat)callculateHigestLength:(int)type and:(NSIndexPath*)index {
    CGFloat higestvalue=0;
    NSString *finalstring;
    
    for(int i=0; i<[[TableDataArr objectAtIndex:index.row] count]; i++){
        NSDictionary *currentDict = [[TableDataArr objectAtIndex:index.row] objectAtIndex:i];
        NSString * comment;
        if (type==1) {
            comment = [NSString stringWithFormat:@"%@",[currentDict objectForKey:@"ClassName"]];
        }
        else if (type==2){
            comment =  [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"TrainerName"]];
        }
        else if (type==3){
            comment =  [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"StartTimeArray"]];
        }
        else if (type==4){
            comment =  [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"EndTime"]];
        }
        else if (type==5){
            comment =  [NSString stringWithFormat:@" %@",[currentDict objectForKey:@"Venue"]];
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
-(CGFloat)compareWidth:(CGFloat)Lenfth{
    
     if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
         if (Lenfth<200 ) {
             return 200
             ;
         }
         else{
             return Lenfth;
         }

     }else{
    
    if (Lenfth<70 ) {
        return 70;
    }
    else{
        return Lenfth;
    }
}
}
@end
