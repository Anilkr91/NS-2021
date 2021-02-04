//
//  MyProfileViewController.m
//  NeoFitness
//
//  Created by Sumit Saini on 09/08/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import "MyProfileViewController.h"
#import "SWRevealViewController.h"
@interface MyProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblUserType;
@property (weak, nonatomic) IBOutlet UILabel *lblUserMail;
@property (weak, nonatomic) IBOutlet UILabel *lblUserContactno;
@property (weak, nonatomic) IBOutlet UILabel *lblCompanyname;
@property (weak, nonatomic) IBOutlet UILabel *lblBranchName;
@property (weak, nonatomic) IBOutlet UILabel *lblContactPerson;

@end

@implementation MyProfileViewController

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
    
    
}


    
    
    
    // Do any additional setup after loading the view.


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString * finalString = [NSString stringWithFormat:@"%@ %@",[userdefaults valueForKey:@"FirstName"],[userdefaults valueForKey:@"LastName"]];
    _lblUserType.text = finalString;
    _lblUserMail.text= [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"UserName"]];
    _lblUserContactno.text = [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"BranchContactNo"]];
_lblBranchName.text = [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"BranchName"]];
    _lblCompanyname.text = [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"GymName"]];
    _lblContactPerson.text = [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"BranchContactPerson"]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString * finalString = [NSString stringWithFormat:@"%@ %@",[userdefaults valueForKey:@"FirstName"],[userdefaults valueForKey:@"LastName"]];
    _lblUserType.text = finalString;
    _lblUserMail.text= [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"Email"]];
    _lblUserContactno.text = [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"BranchContactNo"]];
    _lblBranchName.text = [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"BranchName"]];
    _lblCompanyname.text = [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"GymName"]];
    _lblContactPerson.text = [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"BranchContactPerson"]];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
