//
//  SupportViewController.m
//  NeoFitness
//
//  Created by Sumit Saini on 26/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import "SupportViewController.h"
#import "XMLReader.h"
#import "SWRevealViewController.h"
#import "MainGridViewController.h"
@interface SupportViewController ()<UITextViewDelegate>
{
    
   
    
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
  
    NSString *errorMessage;
 
   }
@property (weak, nonatomic) IBOutlet UITextField *text_fieldSubject;
@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;

@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _text_fieldSubject.delegate=self;
    _textViewMessage.delegate=self;
    _textViewMessage.layer.borderWidth = 1.0f;
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer: tapRec];
    _textViewMessage.layer.borderColor = [[UIColor grayColor] CGColor];
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
    
    
   

}
-(void)tap:(UITapGestureRecognizer *)tapRec{
    [self moveViewUpOrDown:@"down"];
    [self moveViewUpOrDown1:@"down"];
    [_textViewMessage resignFirstResponder];
    [_text_fieldSubject resignFirstResponder];
}
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  
    [textField resignFirstResponder];
    [self moveViewUpOrDown:@"Down"];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self moveViewUpOrDown:@"UP"];
        return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self moveViewUpOrDown1:@"UP"];
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
     [self moveViewUpOrDown1:@"Down"];
      [textView resignFirstResponder];
}
-(BOOL)textViewShouldReturn:(UITextView *)textView{
    [textView resignFirstResponder];
    [self moveViewUpOrDown1:@"Down"];
    return YES;
}

-(void)moveViewUpOrDown:(NSString *)string{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return;
    CGFloat upDownValue = 0;
    if ([string isEqualToString:@"UP"])
        upDownValue = -70;
    else
        upDownValue = 0;
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.view.frame = CGRectMake(0, upDownValue,[[self view] bounds].size.width, [[self view] bounds].size.height);
                     }
                     completion:^(BOOL finished){
                     }];
    
    
}
-(void)moveViewUpOrDown1:(NSString *)string{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return;
    CGFloat upDownValue = 0;
    if ([string isEqualToString:@"UP"])
        upDownValue = -200;
    else
        upDownValue = 0;
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.view.frame = CGRectMake(0, upDownValue, [[self view] bounds].size.width, [[self view] bounds].size.height);
                     }
                     completion:^(BOOL finished){
                     }];
    
    
}


- (IBAction)submitClicked:(id)sender {
    [self moveViewUpOrDown:@"down"];
     [self moveViewUpOrDown1:@"down"];
    NSString* SubjectString = _text_fieldSubject.text;
    NSString* MessageString = _textViewMessage.text;
    if ([SubjectString isEqualToString:@""] || [MessageString isEqualToString:@""]) {
        if ([SubjectString isEqualToString:@""] && [MessageString isEqualToString:@""])
            [[[UIAlertView alloc] initWithTitle:@"Neo Fitnes" message:@"Please enter  Subject and Message both." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        else if ([SubjectString isEqualToString:@""])
            [[[UIAlertView alloc] initWithTitle:@"Neo Fitnes" message:@"Subject field is empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        else if ([MessageString isEqualToString:@""])
            [[[UIAlertView alloc] initWithTitle:@"Neo Fitnes" message:@"Message field is empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        else;
        
    }
    else{
        if ([Utility connected]) {
            [self submit];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        [_text_fieldSubject resignFirstResponder];
        [_textViewMessage resignFirstResponder];
        [self moveViewUpOrDown:@"Down"];
        
    }

}


-(void)submit{
       NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *  UserName =    [userdefaults valueForKey:@"UserName"];
    NSString *  password =    [userdefaults valueForKey:@"Pass"];
    NSString *  GymId =    [userdefaults valueForKey:@"GymId"];
    NSString *  BranchId =    [userdefaults valueForKey:@"BranchId"];
    
    
    
    
    NSString *post =[NSString stringWithFormat:@"support=<NeoFitnes><Credential><UserName>%@</UserName><Password>%@</Password></Credential><SupportMail><Support><GymId>%@</GymId><BranchId>%@</BranchId><FromEmailId>%@</FromEmailId><ToEmailId>contactus@neofitnes.com</ToEmailId><subject>%@</subject><message>%@</message></Support></SupportMail></NeoFitnes>",UserName,password,GymId,BranchId,UserName,_text_fieldSubject.text,_textViewMessage.text];

    
    // NSData *postData = [@"authentican=<NeoFitnes><Users><UserName>dwarkasales@gmail.com</UserName><Password>123456</Password></Users></NeoFitnes>" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.rightsoft.in/NeoFitnessService.asmx/Support"]]];
    
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
    if( [elementName  isEqualToString:@"ErrorMessage"])
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
 
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"ServiceId"])
    {
        xmlResults = FALSE;
        
        soapResults = nil;
    }
        if( [elementName isEqualToString:@"ErrorMessage"])
    {
        xmlResults = FALSE;
        errorMessage=soapResults;
        //[enqueryId addObject:soapResults];
        soapResults = nil;
        [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
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


@end
