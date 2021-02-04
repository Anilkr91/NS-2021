//
//  SubmitEnquiryViewController.m
//  NeoFitness
//
//  Created by Sumit Saini on 10/08/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import "SubmitEnquiryViewController.h"
#import "SWRevealViewController.h"
#import "VSDropdown.h"
#import "XMLReader.h"
@interface SubmitEnquiryViewController ()<UITextFieldDelegate,VSDropdownDelegate>
{
    VSDropdown *_dropdown;
    UITextField *textField12;
    NSString *genderValue;
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
    NSMutableArray * servicename ;
    NSMutableArray * serviceId;
    NSMutableArray * stateName ;
    NSMutableArray * stateId;
    NSMutableArray * cityName ;
    NSMutableArray * cityId;
    NSString *stateIdWebservice;
    NSMutableArray * enqueryId;
    NSMutableArray * enqueryType;
    NSMutableArray * status;
       NSString *webserviceId;
      NSString *cityIdWebservice;
     NSString *enqueryIdWebservice;
    NSString *errorMessage;

}

@property (weak, nonatomic) IBOutlet UIScrollView *submitEnqScrView;
@property (weak, nonatomic) IBOutlet UIDatePicker *DOBDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *ExpectedJoiningDatePicker;
@property (weak, nonatomic) IBOutlet UIImageView *maleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *FemaleImageView;
@property (weak, nonatomic) IBOutlet UITextField *FirstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *LastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ContNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *EmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *dobTextField;
@property (weak, nonatomic) IBOutlet UITextField *expectedJdateTextField;
@property (weak, nonatomic) IBOutlet UITextField *interestedServiceTextField;
@property (weak, nonatomic) IBOutlet UITextField *StateTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *enquiryTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIView *viewDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *datePickerDoneButton;
@property (weak, nonatomic) IBOutlet UILabel *interestedServiceLbl;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *enquiryTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuslbl;
@property (weak, nonatomic) IBOutlet UITextField *nextFollowUpDate;

@end

@implementation SubmitEnquiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

     servicename = [[NSMutableArray alloc ]init];
     serviceId = [[NSMutableArray alloc ]init];
    stateId = [[NSMutableArray alloc ]init];
    stateName = [[NSMutableArray alloc ]init];
    cityName = [[NSMutableArray alloc ]init];
    cityId = [[NSMutableArray alloc ]init];
    enqueryId = [[NSMutableArray alloc ]init];
    enqueryType = [[NSMutableArray alloc ]init];
     status = [[NSMutableArray alloc ]init];
    [self updateButtonLayers];
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:YES];
    _dropdown.allowMultipleSelection =NO;
    _dropdown.tintColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
  
    self.DOBDatePicker.layer.cornerRadius = 10;
    self.DOBDatePicker.layer.masksToBounds=YES;
   
         _submitEnqScrView.contentSize = CGSizeMake(0, 1050);
    
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
    [_datePickerDoneButton addTarget:self action:@selector(pickerCancelButtontaped:) forControlEvents:UIControlEventTouchUpInside];
    _dropdown.maxDropdownHeight=200;
    [_dropdown setDirection:VSDropdownDirection_Down];
    
    
    
   // _statuslbl.text = @"Open";
     //_stateLabel.text = @"Uttar Pradesh";
     // _enquiryTypeLbl.text = @"Hot";
   // _interestedServiceLbl.text = @"Gym Membership";

}


    // Do any additional setup after loading the view.


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnMaleClicked:(id)sender {
    _maleImageView.image = [UIImage imageNamed:@"check.png"];
    _FemaleImageView.image = [UIImage imageNamed:@"uncheck.png"];
    genderValue = @"Male";
    
   }

    
    
    

- (IBAction)btnFemaleClicked:(id)sender {
    _maleImageView.image = [UIImage imageNamed:@"uncheck.png"];
    _FemaleImageView.image = [UIImage imageNamed:@"check.png"];
    genderValue =@"Female";
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if (textField==_dobTextField) {
        textField12 =_dobTextField;
        _viewDatePicker.hidden = NO;
    }
   else if (textField==_expectedJdateTextField) {
        textField12 =_expectedJdateTextField;
        _viewDatePicker.hidden = NO;
    }
   else if (textField==_nextFollowUpDate) {
       textField12 =_nextFollowUpDate;
       _viewDatePicker.hidden = NO;
   }


}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (textField==_dobTextField || textField==_expectedJdateTextField || textField==_nextFollowUpDate) {
        return NO;
    }
    else
        return YES;
    
}

-(void)updateButtonLayers
{
//    [self.firstButton.layer setCornerRadius:3.0];
//    [self.firstButton.layer setBorderWidth:1.0];
//    [self.firstButton.layer setBorderColor:[self.firstButton.titleLabel.textColor CGColor]];
//    
//    [self.secondButton.layer setCornerRadius:3.0];
//    [self.secondButton.layer setBorderWidth:1.0];
//    [self.secondButton.layer setBorderColor:[self.secondButton.titleLabel.textColor CGColor]];
//    
//    [self.thirdButton.layer setCornerRadius:3.0];
//    [self.thirdButton.layer setBorderWidth:1.0];
//    [self.thirdButton.layer setBorderColor:[self.thirdButton.titleLabel.textColor CGColor]];
//    
//    [self.fourthButton.layer setCornerRadius:3.0];
//    [self.fourthButton.layer setBorderWidth:1.0];
//    [self.fourthButton.layer setBorderColor:[self.fourthButton.titleLabel.textColor CGColor]];
}

- (IBAction)testAction:(id)sender

{
    UIButton *btn = (UIButton *)sender;
    _dropdown.backgroundColor = [UIColor whiteColor];
    _dropdown.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    _dropdown.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];
    _dropdown.separatorType =NO;
    _dropdown.separatorColor = [UIColor whiteColor];
    
    
    if (btn.tag==1) {
        if ([Utility connected]) {
            [self getServiceList];
            [self showDropDownForButton:sender adContents:servicename multipleSelection:NO];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }

        
         }
    else if(btn.tag==2){
               if ([Utility connected]) {
                   [self getStates];
                   
                   
                   [self showDropDownForButton:sender adContents:stateName multipleSelection:NO];
                   

        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        

        

    }
    
    else if(btn.tag==3){
        
        if ([Utility connected]) {
            [self getCity];
            
            
            [self showDropDownForButton:sender adContents:cityName multipleSelection:NO];
            
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        

        
    }
    else if(btn.tag==4){
               if ([Utility connected]) {
                   [self EnquiryType];
                   
                   
                   [self showDropDownForButton:sender adContents:enqueryType multipleSelection:NO];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }

        
    }
    else if(btn.tag==5){
        
        
        if ([Utility connected]) {
            [status removeAllObjects];
            [status addObject:@"Open"];
            [status addObject:@"Close"];
            
            
            [self showDropDownForButton:sender adContents:status multipleSelection:NO];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
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
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    
    NSString *allSelectedItems = nil;
    if (dropDown.selectedItems.count > 1)
    {
        allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
        
    }
    else
    {
        allSelectedItems = [dropDown.selectedItems firstObject];
        
    }
    if (btn.tag==1) {
         _interestedServiceLbl.text=allSelectedItems;
        
        NSInteger anIndex=[servicename indexOfObject:allSelectedItems];
       webserviceId = [serviceId objectAtIndex:anIndex];
    }
   else if (btn.tag==2) {
        _stateLabel.text=allSelectedItems;
     
       NSInteger anIndex=[stateName indexOfObject:allSelectedItems];
       stateIdWebservice = [stateId objectAtIndex:anIndex];
       
       if(NSNotFound == anIndex) {
           NSLog(@"not found");
       }
    }
  else if (btn.tag==3) {
        _cityLabel.text=allSelectedItems;
      NSInteger anIndex=[cityName indexOfObject:allSelectedItems];
      cityIdWebservice = [cityId objectAtIndex:anIndex];
    }

  else if (btn.tag==4) {
      _enquiryTypeLbl.text=allSelectedItems;
      NSInteger anIndex=[enqueryType indexOfObject:allSelectedItems];
      enqueryIdWebservice = [enqueryId objectAtIndex:anIndex];
  }
  
  else if (btn.tag==5) {
      _statuslbl.text=allSelectedItems;
      if ([_statuslbl.text isEqualToString:@"Close"]) {
          _nextFollowUpDate.hidden =YES;
          
      }
      else{
         _nextFollowUpDate.hidden =NO;
      }
  }

    _dropdown.textColor = [UIColor colorWithRed:(35/255.0) green:(48/255.0) blue:(127/255.0) alpha:1];

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
- (IBAction)pickerCancelButtontaped:(id)sender {
    _viewDatePicker.hidden =YES;
    [_dobTextField resignFirstResponder];
    [_expectedJdateTextField resignFirstResponder];
   
    
}
- (IBAction)PickerDoneButtonClicked:(id)sender {
    
    if (textField12==_dobTextField) {
        [self setTExtINtextField:_dobTextField];
       
    }
    
   else if (textField12==_expectedJdateTextField) {
        
        [self setTExtINtextField:_expectedJdateTextField];
           }
   else if (textField12==_nextFollowUpDate) {
       
       [self setTExtINtextField:_nextFollowUpDate];
   }

}

-(void)setTExtINtextField:(UITextField *)textField1{
    _DOBDatePicker.datePickerMode=UIDatePickerModeDate;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_DOBDatePicker.date]];
    
    textField1.text=str;
    _viewDatePicker.hidden =YES;
    [textField1 resignFirstResponder];
    

    
}
- (IBAction)submitBtnClicked:(id)sender {
    NSString * phoneNumber ;
    NSString *firstLetter;
    int days =0;
    int days1 =0;
    
    NSString * status1 = [NSString stringWithFormat:@"%@",_statuslbl.text];
    if (![_ContNoTextField.text isEqualToString:@""] || _ContNoTextField.text== nil) {
         phoneNumber = [NSString stringWithFormat:@"%@",_ContNoTextField.text];
        firstLetter = [phoneNumber substringToIndex:1];
    }else{
      // [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Please enter Phone Number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    if (![_dobTextField.text isEqualToString:@""] || _dobTextField.text== nil || [_expectedJdateTextField.text isEqualToString:@""] || _expectedJdateTextField.text== nil )  {
        NSString
        *DOB = [NSString stringWithFormat:@"%@",_dobTextField.text];
        NSString
        *ExpectedJoiningDate = [NSString stringWithFormat:@"%@",_expectedJdateTextField.text];
        NSString
        *curertDate = [NSString stringWithFormat:@"%@",[NSDate date]];
        NSRange needleRange = NSMakeRange(0, 10);
        NSString *needle = [curertDate substringWithRange:needleRange];
        
        
        
//        NSString *string1 = curertDate ;
//        NSRange range1 = [string1 rangeOfString:@"07:59:19 +0000"];
//        NSString *shortDateString = [string1 substringToIndex:range1.location];
//
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [f dateFromString:DOB];
        NSDate *endDate = [f dateFromString:ExpectedJoiningDate];
        NSDate * currentDate = [f dateFromString:needle];;
        
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
         days= (int) [components day];
        NSDateComponents *components1 = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:currentDate
                                                              toDate:endDate
                                                             options:0];
        days1= (int) [components1 day];
 NSLog(@"hhhhhhhhhhhhhhh%d",days1);

    }
    else{
       // [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Please Fill All Fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    

    if ([_FirstNameTextField.text isEqualToString:@""] || [_LastNameTextField.text isEqualToString:@""]|| [_ContNoTextField.text isEqualToString:@""] || [_EmailTextField.text isEqualToString:@""] ||   [_commentTextField.text isEqualToString:@""]) {
        
            [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Please Fill All Fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
      
        return;
        
    }
    
    if ([genderValue isEqualToString:@""] || genderValue== nil) {
        [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Please Select Gender." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    if ([_interestedServiceLbl.text isEqualToString:@""] || [_stateLabel.text isEqualToString:@""]|| [_cityLabel.text isEqualToString:@""] || [_enquiryTypeLbl.text isEqualToString:@""] ||   [_statuslbl.text isEqualToString:@""] || _interestedServiceLbl.text==nil || _stateLabel.text==nil || _cityLabel.text==nil || _enquiryTypeLbl.text==nil){
        [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Please Select." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
   
    if ([firstLetter isEqualToString:@""] || [firstLetter isEqualToString:@"0"]){
        [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Please Don't Enter Zero At beginning of Contact NO." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
    
    if(days<=0){
        [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Expected Joining Date Should Be Greater Than D.O.B." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
}
    if(days1<0){
        [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Expiry Date not allowed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }

    
    if (!(_EmailTextField.text==nil)) {
  bool isvalid =      [self IsValidEmail:_EmailTextField.text];
       
        if (isvalid==false) {
            [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Please Check E-Mail Id." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            return;
        }
    }
    if (_nextFollowUpDate.hidden == NO) {
        if ([_nextFollowUpDate.text isEqualToString:@""] || _nextFollowUpDate==nil) {
            [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Please select NextFollowUpDate." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            return;
        }
        
    }
if ([status1 isEqualToString:@"Close"]) {
        _nextFollowUpDate.hidden =YES;
        
    }
    
    
        

    
    
    
        if ([Utility connected]) {
            [self Submit];
            //[self LoginWebService];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }

 }

-(void)getServiceList{
    [servicename removeAllObjects];
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
     NSString *  password =    [userdefaults valueForKey:@"Pass"];
     NSString *  MemberID =    [userdefaults valueForKey:@"MemberID"];
    NSString *post =[NSString stringWithFormat:@"strXML=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><AssessmentList><Assessment><customerid>%@</customerid></Assessment></AssessmentList></NeoFitnes>",UserName,password,MemberID];
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetServiceList"]]];
    
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


//initiate the request

-(void)getStates{
    [ stateName removeAllObjects];
    [ stateId removeAllObjects];
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *post =[NSString stringWithFormat:@"strXML=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><StateList><State><CountryId>727</CountryId></State></StateList></NeoFitnes>",UserName,password];
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetStateList"]]];
    
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



-(void)getCity{
    [ cityName removeAllObjects];
    [ cityId removeAllObjects];
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *post =[NSString stringWithFormat:@"strXML=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><CityList><City><StateId>%@</StateId></City></CityList></NeoFitnes>",UserName,password,stateIdWebservice];
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetCityList"]]];
    
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

-(void)EnquiryType{
    [ enqueryType removeAllObjects];
    [ enqueryId removeAllObjects];
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *post =[NSString stringWithFormat:@"strXML=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password>+</Credential></NeoFitnes>",UserName,password];
    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/GetInquiryType"]]];
    
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
    if( [elementName isEqualToString:@"ServiceName"]||[elementName isEqualToString:@"ServiceId"] ||[elementName isEqualToString:@"StateName"] ||[elementName isEqualToString:@"StateId"] ||[elementName isEqualToString:@"CityName"] ||[elementName isEqualToString:@"CityId"] ||[elementName isEqualToString:@"InquiryName"] ||[elementName isEqualToString:@"InquiryId"]||[elementName isEqualToString:@"ErrorMessage"])
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
    
    if( [elementName isEqualToString:@"ServiceName"])
    {
        xmlResults = FALSE;
        [servicename addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"ServiceId"])
    {
        xmlResults = FALSE;
        [serviceId addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"StateName"])
    {
        xmlResults = FALSE;
        [stateName addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"StateId"])
    {
        xmlResults = FALSE;
        [stateId addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"CityName"])
    {
        xmlResults = FALSE;
        [cityName addObject:soapResults];
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"CityId"])
    {
        xmlResults = FALSE;
        [cityId addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"InquiryName"])
    {
        xmlResults = FALSE;
        [enqueryType addObject:soapResults];
        soapResults = nil;
       
    }
    
    if( [elementName isEqualToString:@"InquiryId"])
    {
        xmlResults = FALSE;
        [enqueryId addObject:soapResults];
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"ErrorMessage"])
    {
        xmlResults = FALSE;
        errorMessage=soapResults;
        //[enqueryId addObject:soapResults];
        soapResults = nil;
        [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

    
}
-(void)Submit{
    
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString * nextFollowUpDate;
    if (_nextFollowUpDate.hidden==NO) {
         nextFollowUpDate = [NSString stringWithFormat:@"%@",_nextFollowUpDate.text];
    }
    else{
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        // or @"yyyy-MM-dd HH:mm:ss a" if you prefer the time with AM/PM
        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
        nextFollowUpDate = [dateFormatter stringFromDate:[NSDate date]];
    }
    NSString * stutus;
    if([_statuslbl.text isEqualToString:@"Open"]){
        stutus = @"True";
    }
    else{
        stutus = @"False";
    }
  
     NSString *post =[NSString stringWithFormat:@"strXMLs=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><InquiryType><Inquiry><FirstName>%@</FirstName><LastName>%@</LastName><Gender>%@</Gender><ContactNo>%@</ContactNo><EmailId>%@</EmailId><DOB>%@</DOB><ExpectedJoiningDate>%@</ExpectedJoiningDate><InterestesServices>%@</InterestesServices><StateId>%@</StateId><CityId>%@</CityId><InquiryType>%@</InquiryType><Comment>%@</Comment><NextFollowUpDate>%@</NextFollowUpDate><Status>%@</Status><CreatedBy>%@</CreatedBy></Inquiry></InquiryType> </NeoFitnes>",UserName,password,_FirstNameTextField.text,_LastNameTextField.text,genderValue,_ContNoTextField.text,_EmailTextField.text,_dobTextField.text,_expectedJdateTextField.text,webserviceId,stateIdWebservice,cityIdWebservice,enqueryIdWebservice,_commentTextField.text,nextFollowUpDate,stutus,UserName];
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/InsertInquery"]]];
    
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






-(BOOL)IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
 bool rej  =[emailTest evaluateWithObject:checkString];
   
    
    
    return [emailTest evaluateWithObject:checkString];
}

@end
