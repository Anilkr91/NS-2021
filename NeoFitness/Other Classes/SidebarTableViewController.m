//
//  SidebarTableViewController.m
//  NeoFitness
//
//  Created by smitra on 7/25/16.
//  Copyright © 2016 dmondo. All rights reserved.
//


#import "SidebarTableViewController.h"
#import "SWRevealViewController.h"
#import "MyProfileViewController.h"
#import "LoginViewController.h"
#import "MainGridViewController.h"
#import "SideTableViewCell.h"
#import "SalesEnquiryViewController.h"
#import "SubmitEnquiryViewController.h"
#import <MessageUI/MessageUI.h>
#import "GroupClassesViewController.h"
#import "WorkoutCardViewController.h"
#import "DietCardViewController.h"
#import "fitnessSummaryViewController.h"
#import "SupportViewController.h"
#import "MyAttendanceViewController.h"
#import "medicalHistoryViewController.h"
#import "myMembershipViewController.h"
#import "DrObservationViewController.h"
#import "ObecityReportViewController.h"
#import "TodayTrainersViewController.h"
@interface SidebarTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
NSArray * customerSideMenuList;
NSArray *  customerSideMenuImage;
    NSArray * salesSideMenuList;
    NSArray *  salesSideMenuImage;
    NSArray *  adminSideMenuImage;
    NSArray * adminSideMenuList;
    NSString *userType;
    NSString *roleId;
    long int selectedIndex ;
}

@property (weak, nonatomic) IBOutlet UITableView *sideTableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SidebarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndex = -1;
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString * finalString;
    if (![userdefaults valueForKey:@"LastName"]) {
        
   
     finalString = [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"FirstName"]];
    }
    else{
          finalString = [NSString stringWithFormat:@"%@ %@",[userdefaults valueForKey:@"FirstName"],[userdefaults valueForKey:@"LastName"]];
    }
    
    _nameLabel.text = finalString;
    customerSideMenuList = @[@"Home",/*@"Group Class Schedule",*/@"Workout Card",@"Diet Card",@"Fitness Assesment",@"Attendance",@"Medical Assesment",@"Dr's Observation",@"Today’s Trainer",@"Book Appointment",@"Membership",/*@"Obesity Report"*/@"Change Password",@"Call",@"Support",@"Logout"];
    customerSideMenuImage =   @[@"home-1.png",/*@"group_class.png",*/@"workout_card.png",@"dietcard.png",@"fitness_summary.png",@"attendance.png",@"medical_history.png",@"online.png",@"today's_trainer_drawer.png",@"book.png",@"membership--1.png",/*@"obesity_report.png",*/@"change_password.png",@"call.png",@"support.png",@"logout.png"];
    salesSideMenuList = @[@"Home",@"Enquiry",@"Change Password",@"Call Branch",@"Incentive",@"My Profile",@"Logout"];
    salesSideMenuImage =   @[@"home-1.png",@"enquiry_en.png",@"change_password.png",@"call.png",@"insentive.png",@"membership--1.png",@"logout.png"];
    // controllersId = [[NSArray alloc]initWithObjects:@"",@"MainGridViewController",@"LoginViewController","MainPortalViewController", nil];
    adminSideMenuList = @[@"Home",@"My Profile", @"Package Wise Collection",@"Last 3days Absent Report",@"Customer Membership",@"Payment Defaulter Report",@"Membership Defaulter",@"Logout"];
    adminSideMenuImage =   @[@"home-1.png",@"enquiry_en.png",@"change_password.png",@"call.png",@"call.png",@"insentive.png",@"membership--1.png",@"logout.png"];
    self.sideTableView.tableFooterView = [UIView new];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString * finalString;
    if (![userdefaults valueForKey:@"LastName"]) {
        
        
        finalString = [NSString stringWithFormat:@"%@",[userdefaults valueForKey:@"FirstName"]];
        
        if ( ( ![finalString isEqual:[NSNull null]] ) && ( [finalString length] != 0 ) ) {
            // definitely empty!
            _nameLabel.userInteractionEnabled = YES;
            _nameLabel.text = @"Please Login/Register";
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateLabel:)];
            [_nameLabel setUserInteractionEnabled:YES];
            [_nameLabel addGestureRecognizer:tap];
            //[tap release]; //
            
        } else {
            _nameLabel.text = finalString;
        }
        
    }
    else{
        
        finalString = [NSString stringWithFormat:@"%@ %@",[userdefaults valueForKey:@"FirstName"],[userdefaults valueForKey:@"LastName"]];
        
        if ([finalString length] == 0) {
            // definitely empty!
            _nameLabel.userInteractionEnabled = YES;
             _nameLabel.text = @"Please Login/Register";
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateLabel:)];
            [_nameLabel setUserInteractionEnabled:YES];
            [_nameLabel addGestureRecognizer:tap];
            //[tap release]; //
            
        } else {
            _nameLabel.text = finalString;
        }
    }
   
    [self.sideTableView reloadData];
    NSLog(@"%@",finalString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    roleId =    [userdefaults valueForKey:@"RoleId"];
    userType =    [userdefaults valueForKey:@"USERTYPE"];
    if ([userType isEqualToString:@"S"]) {
        
        if ([roleId isEqualToString:@"2"]) {
           return adminSideMenuList.count;
        } else {
           return salesSideMenuList.count;
        }
       
    }
    else {
        if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
             return customerSideMenuList.count;
            //       return
            
        } else {
             return customerSideMenuList.count - 1;
        }
    }
    
    // Return the number of rows in the section.
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    NSString *CellIdentifier = @"slideOptionCell";
    SideTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([userType isEqualToString:@"S"]) {
        
        if ([roleId isEqualToString:@"2"]) {
           cell.cellLabel.text = [adminSideMenuList objectAtIndex:indexPath.row];
           cell.cellImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[adminSideMenuImage objectAtIndex:indexPath.row]]];
            
        } else {
        cell.cellLabel.text = [salesSideMenuList objectAtIndex:indexPath.row];
        cell.cellImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[salesSideMenuImage objectAtIndex:indexPath.row]]];
        }
    }
    else
    {
    cell.cellLabel.text = [customerSideMenuList objectAtIndex:indexPath.row];
    cell.cellImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[customerSideMenuImage objectAtIndex:indexPath.row]]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    
        NSLog(@"%ld", indexPath.row);
        userType =    [userdefaults valueForKey:@"USERTYPE"];
        
        if ([userType isEqualToString:@"S"]) {
            
            if ([roleId isEqualToString:@"2"]) {
                [self didSelectAdminAt:indexPath];
                return;
            }
            
            if(indexPath.row == 1){
                 if ([Utility connected]) {
                SWRevealViewController *revealViewController = self.revealViewController;
                
                UIViewController *selectedViewController;
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SubmitEnquiryViewController"];
                else
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SubmitEnquiryViewController"];
                
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                
                [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                [navController setViewControllers: @[selectedViewController] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                
                [self.navigationController pushViewController:selectedViewController animated:YES];
                if ( revealViewController )
                {
                    [revealViewController revealToggleEnd];
                }
                return;
                 }
                 else{
                     [self gohome];
                      return;
                 }
            }
            
            if(indexPath.row == 0){
                
                SWRevealViewController *revealViewController = self.revealViewController;
                
                UIViewController *selectedViewController;
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
                else
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
                
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                
                [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                [navController setViewControllers: @[selectedViewController] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                
                [self.navigationController pushViewController:selectedViewController animated:YES];
                if ( revealViewController )
                {
                    [revealViewController revealToggleEnd];
                }
                return;
            }
            
            
            if(indexPath.row == 10){
                
                
                SWRevealViewController *revealViewController = self.revealViewController;
                
                MainGridViewController *selectedViewController;
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
                else
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
                
                selectedViewController.identifier =@"Change Password";
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                
                [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                [navController setViewControllers: @[selectedViewController] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                
                [self.navigationController pushViewController:selectedViewController animated:YES];
                if ( revealViewController )
                {
                    [revealViewController revealToggleEnd];
                }
                return;
                
            }
            if(indexPath.row == 3){
                
                SWRevealViewController *revealViewController = self.revealViewController;
                
                MainGridViewController *selectedViewController;
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
                else
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
                
                selectedViewController.identifier =@"Call Branch";
                selectedViewController.userType =@"sales";
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                
                [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                [navController setViewControllers: @[selectedViewController] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                
                [self.navigationController pushViewController:selectedViewController animated:YES];
                if ( revealViewController )
                {
                    [revealViewController revealToggleEnd];
                }
                return;
                
            }
            
            if(indexPath.row == 4){
                
                SWRevealViewController *revealViewController = self.revealViewController;
                
                MainGridViewController *selectedViewController;
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
                else
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
                
                selectedViewController.identifier = @"incentive";
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                
                [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                [navController setViewControllers: @[selectedViewController] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                
                [self.navigationController pushViewController:selectedViewController animated:YES];
                if ( revealViewController )
                {
                    [revealViewController revealToggleEnd];
                }
                return;
            }
            
            
            
            if(indexPath.row == 5){
                
                SWRevealViewController *revealViewController = self.revealViewController;
                
                UIViewController *selectedViewController;
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
                else
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
                
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                
                [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                [navController setViewControllers: @[selectedViewController] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                
                [self.navigationController pushViewController:selectedViewController animated:YES];
                if ( revealViewController )
                {
                    [revealViewController revealToggleEnd];
                }
                return;
            }
            
            
            
            
            if(indexPath.row == 6 ){
                
                NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
                NSDictionary * dict = [userDef dictionaryRepresentation];
                for (id key in dict) {
                    [userDef removeObjectForKey:key];
                }
                [userDef synchronize];
                
                
                
                SWRevealViewController *revealViewController = self.revealViewController;
                UIViewController *selectedViewController;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
                else
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                
                [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                [navController setViewControllers: @[selectedViewController] animated: YES];
                
                [self.revealViewController setFrontViewController:navController];
                
                [self.navigationController pushViewController:selectedViewController animated:YES];
                if ( revealViewController )
                {
                    [revealViewController revealToggleEnd];
                }
                return;
            }
        }
        
#pragma for customer view
    
        else{
//             UIViewController *selectedViewController;
//             SWRevealViewController *revealViewController = self.revealViewController;
            NSLog(@"%ld", selectedIndex);
//            if (selectedIndex == indexPath.row) {
//             [revealViewController revealToggleEnd];
//                return ;
//            }
            
            if(indexPath.row == 0) {
                 selectedIndex = indexPath.row;
               // if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                   
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                
                UIViewController *selectedViewController;
                SWRevealViewController *revealViewController = self.revealViewController;
                
                   
//                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
//                    else
                        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTableViewController"];

                   
                    UITabBarController *TABVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTabbarController"];
                    
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];

                    [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                    [navController setViewControllers: @[selectedViewController] animated: YES];

                    [self.revealViewController setFrontViewController:TABVC];
                    
                    [TABVC.navigationController pushViewController:selectedViewController animated:YES];
                    if ( revealViewController )
                    {
                        [revealViewController revealToggleEnd];
                    }
                    return;
                    
               // }
                
//                else {
//                    [self showAlert];
//                }
            }
            
            if(indexPath.row == 1){
                 selectedIndex = indexPath.row;
                if ([Utility connected]) {
                    
                     if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                         
                         SWRevealViewController *revealViewController = self.revealViewController;
                         
                         UIViewController *selectedViewController;
                         
//                         if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) //GroupClassesViewController
//                             selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"WorkoutCardViewController"];
//                         else
                             selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"WorkoutCardViewController"];
                         
                         
                         UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                         
                         [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                         [navController setViewControllers: @[selectedViewController] animated: YES];
                         
                         [self.revealViewController setFrontViewController:navController];
                         
                         [self.navigationController pushViewController:selectedViewController animated:YES];
                         if ( revealViewController )
                         {
                             [revealViewController revealToggleEnd];
                         }
                         return;
                         
                     } else  {
                         [self showAlert];
                     }
            }
                else{
                    [self gohome];
                     return;
            }
            
            }
            if(indexPath.row == 2) {
                
                 if ([Utility connected]) {
                      selectedIndex = indexPath.row;
                         if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                             
                             SWRevealViewController *revealViewController = self.revealViewController;
                             
                             UIViewController *selectedViewController;
                             
//                             if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) //WorkoutCardViewController
//                                        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DietCardViewController"];
//                                    else
                                        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DietCardViewController"];
                             
                             
                             UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                             
                             [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                             [navController setViewControllers: @[selectedViewController] animated: YES];
                             
                             [self.revealViewController setFrontViewController:navController];
                             
                             [self.navigationController pushViewController:selectedViewController animated:YES];
                             if ( revealViewController )
                             {
                                 [revealViewController revealToggleEnd];
                             }
                             return;
                             
                         } else  {
                             [self showAlert];
                         }
                     }
//
                 else{
                   [self gohome];
                      return;
                 }
            }
            if(indexPath.row == 3){
                
                if ([Utility connected]) {
                     selectedIndex = indexPath.row;
                    
                    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                       
                        SWRevealViewController *revealViewController = self.revealViewController;
                        
                        UIViewController *selectedViewController;
                        
//                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"fitnessSummaryViewController"];
//                        else
                            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"fitnessSummaryViewController"];
                        
                        
                        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                        
                        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                        [navController setViewControllers: @[selectedViewController] animated: YES];
                        
                        [self.revealViewController setFrontViewController:navController];
                        
                        [self.navigationController pushViewController:selectedViewController animated:YES];
                        if ( revealViewController )
                        {
                            [revealViewController revealToggleEnd];
                        }
                        return;
                    } else {
                         [self showAlert];
                    }
                    }
                
                else{
                    [self gohome];
                     return;
                }
                
            }
            
            
            
            if(indexPath.row == 4){
                if ([Utility connected]) {
                     selectedIndex = indexPath.row;
                    
                     if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                       
                         SWRevealViewController *revealViewController = self.revealViewController;
                         
                         UIViewController *selectedViewController;
                         
//                         if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                             selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MyAttendanceViewController"];
//                         else
                             selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MyAttendanceViewController"];
                         
                         
                         UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                         
                         [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                         [navController setViewControllers: @[selectedViewController] animated: YES];
                         
                         [self.revealViewController setFrontViewController:navController];
                         
                         [self.navigationController pushViewController:selectedViewController animated:YES];
                         if ( revealViewController )
                         {
                             [revealViewController revealToggleEnd];
                         }
                         return;
                         
                     } else {
                         [self showAlert];
                     }
              
            }
                else{
                    [self gohome];
                     return;
                }
            }
            
            
            if(indexPath.row == 5){
                
                if ([Utility connected]) {
                     selectedIndex = indexPath.row;
                    
                     if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                         SWRevealViewController *revealViewController = self.revealViewController;
                         
                         UIViewController *selectedViewController;
                         
//                         if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                             selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"medicalHistoryViewController"];
//                         else
                             selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"medicalHistoryViewController"];
                         
                         
                         UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                         
                         [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                         [navController setViewControllers: @[selectedViewController] animated: YES];
                         
                         [self.revealViewController setFrontViewController:navController];
                         
                         [self.navigationController pushViewController:selectedViewController animated:YES];
                         if ( revealViewController )
                         {
                             [revealViewController revealToggleEnd];
                         }
                         return;
                     } else {
                         [self showAlert];
                     }
                }
              
                else{
                    [self gohome];
                     return;
                }
            }
            if(indexPath.row == 6){
                
                
                if ([Utility connected]) {
                     selectedIndex = indexPath.row;
                    
                     if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                         SWRevealViewController *revealViewController = self.revealViewController;
                         
                         UIViewController *selectedViewController;
                         
//                         if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                             selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DrObservationViewController"];
//                         else
                             selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DrObservationViewController"];
                         
                         
                         UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                         
                         [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                         [navController setViewControllers: @[selectedViewController] animated: YES];
                         
                         [self.revealViewController setFrontViewController:navController];
                         
                         [self.navigationController pushViewController:selectedViewController animated:YES];
                         if ( revealViewController )
                         {
                             [revealViewController revealToggleEnd];
                         }
                         return;
                     } else {
                        [self showAlert];
                     }
                
                }
                else{
                    [self gohome];
                     return;
                }
            }
            if(indexPath.row == 7){
                
                
                if ([Utility connected]) {
                    
                     selectedIndex = indexPath.row;
                     if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                         SWRevealViewController *revealViewController = self.revealViewController;
                         
                         UIViewController *selectedViewController;
                         
//                         if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                             selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TodayTrainersViewController"];
//                         else
                             selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TodayTrainersViewController"];
                         
                         
                         UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                         
                         [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                         [navController setViewControllers: @[selectedViewController] animated: YES];
                         
                         [self.revealViewController setFrontViewController:navController];
                         
                         [self.navigationController pushViewController:selectedViewController animated:YES];
                         if ( revealViewController )
                         {
                             [revealViewController revealToggleEnd];
                         }
                         return;
                         
                     } else {
                        [self showAlert];
                         
                     }
                }
                else{
                    [self gohome];
                     return;
                }

            }
            
            
            
            if(indexPath.row == 8){
                
//                 if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
//                     SWRevealViewController *revealViewController = self.revealViewController;
//
//                     MainGridViewController *selectedViewController;
//
//                     if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                         selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
//                     else
//                         selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
//
//                     selectedViewController.identifier =@"Change Password";
//                     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
//
//                     [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
//                     [navController setViewControllers: @[selectedViewController] animated: YES];
//
//                     [self.revealViewController setFrontViewController:navController];
//
//                     [self.navigationController pushViewController:selectedViewController animated:YES];
//                     if ( revealViewController )
//                     {
//                         [revealViewController revealToggleEnd];
//                     }
//                     return;
//                 } else {
//                     [self showAlert];
//                 }
                [self comingSoonAlert];
                
            }
            
            
            if(indexPath.row == 9){
                
                selectedIndex = indexPath.row;
                
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURL]];
                
                 //[self isLoggedInUser:tableView];

                if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                   SWRevealViewController *revealViewController = self.revealViewController;
                   
                   UIViewController *selectedViewController;

//                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"myMembershipViewController"];
//                    else
                        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"myMembershipViewController"];

//                    selectedViewController.identifier =@"Call Branch";
//                    selectedViewController.userType =@"customer";
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];

                    [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                    [navController setViewControllers: @[selectedViewController] animated: YES];

                    [self.revealViewController setFrontViewController:navController];

                    [self.navigationController pushViewController:selectedViewController animated:YES];
                    if ( revealViewController )
                    {
                        [revealViewController revealToggleEnd];
                    }
                    return;


                } else {
                    [self showAlert];
                }
            
            }
            
            
            if(indexPath.row == 10){
                            
                            //selectedIndex = indexPath.row;

            //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURL]];

                             //[self isLoggedInUser:tableView];

                            if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                               SWRevealViewController *revealViewController = self.revealViewController;
                                [self showComing];
                                
//
//                               UIViewController *selectedViewController;
//
//                                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"myMembershipViewController"];
//                                else
//                                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"myMembershipViewController"];
//
//            //                    selectedViewController.identifier =@"Call Branch";
//            //                    selectedViewController.userType =@"customer";
//                                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
//
//                                [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
//                                [navController setViewControllers: @[selectedViewController] animated: YES];
//
//                                [self.revealViewController setFrontViewController:navController];

//                                [self.navigationController pushViewController:selectedViewController animated:YES];
                                if ( revealViewController )
                                {
                                    [revealViewController revealToggleEnd];
                                }
                                return;
                            } else {
                                [self showAlert];
                            }
                        }
            

             if(indexPath.row == 11  ){
                 
                 
                   NSString * phone = [[NSUserDefaults standardUserDefaults] objectForKey: @"BranchContactNo"];
                    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",phone];
                    NSURL *phoneURL = [NSURL URLWithString:phoneStr];
                    [[UIApplication sharedApplication] openURL:phoneURL];
                 
                 
//                  if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
//
//                      SWRevealViewController *revealViewController = self.revealViewController;
//                      UIViewController *selectedViewController;
//
//                      if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                          selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
//                      else
//                          selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
//
//
//                      UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
//
//                      [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
//                      [navController setViewControllers: @[selectedViewController] animated: YES];
//
//                      [self.revealViewController setFrontViewController:navController];
//
//                      [self.navigationController pushViewController:selectedViewController animated:YES];
//                      if ( revealViewController )
//                      {
//                          [revealViewController revealToggleEnd];
//                      }
//
//                      [[[UIAlertView alloc] initWithTitle:@"Neo Fitness" message:@"Coming Soon...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//
//                      return;
//
//                  } else {
//                      [self showAlert];
//                  }
                 
             }
            
            if(indexPath.row == 12){
                 selectedIndex = indexPath.row;
                 if ([Utility connected]) {
                      if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                          SWRevealViewController *revealViewController = self.revealViewController;
                          
                          UIViewController *selectedViewController;
                          
//                          if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                              selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SupportViewController"];
//                          else
                              selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SupportViewController"];
                          
                          
                          UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                          
                          [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                          [navController setViewControllers: @[selectedViewController] animated: YES];
                          
                          [self.revealViewController setFrontViewController:navController];
                          
                          [self.navigationController pushViewController:selectedViewController animated:YES];
                          if ( revealViewController )
                          {
                              [revealViewController revealToggleEnd];
                          }
                          return;
                      } else {
                          [self showAlert];
                      }
                 }
                else{
                    [self gohome];
                     return;
                }

            }
            
            
            if(indexPath.row == 7 ){
            if ([Utility connected]) {
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                    SWRevealViewController *revealViewController = self.revealViewController;
                    
                    UIViewController *selectedViewController;
                    
//                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DrObservationViewController"];
//                    else
                        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DrObservationViewController"];
                    
                    
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                    
                    [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                    [navController setViewControllers: @[selectedViewController] animated: YES];
                    
                    [self.revealViewController setFrontViewController:navController];
                    
                    [self.navigationController pushViewController:selectedViewController animated:YES];
                    if ( revealViewController )
                    {
                        [revealViewController revealToggleEnd];
                    }
                    return;
                } else {
                    [self showAlert];
                }
                
              
            }
            else{
                [self gohome];
                return;
            }

            }
            
            if(indexPath.row == 11 ){
//                if ([Utility connected]) {
//
//                    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
//                        SWRevealViewController *revealViewController = self.revealViewController;
//
//                        UIViewController *selectedViewController;
//
//                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ObecityReportViewController"];
//                        else
//                            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ObecityReportViewController"];
//
//
//                        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
//
//                        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
//                        [navController setViewControllers: @[selectedViewController] animated: YES];
//
//                        [self.revealViewController setFrontViewController:navController];
//
//                        [self.navigationController pushViewController:selectedViewController animated:YES];
//                        if ( revealViewController )
//                        {
//                            [revealViewController revealToggleEnd];
//                        }
//                        return;
//                    } else {
//                        [self showAlert];
//                    }
//
//
//                }
//                else{
//                    [self gohome];
//                    return;
//                }
                
            }

            if(indexPath.row == 8 ){
                if ([Utility connected]) {
                    
                    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                    
                        SWRevealViewController *revealViewController = self.revealViewController;
                        
                        UIViewController *selectedViewController;
                        
//                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TodayTrainersViewController"];
//                        else
                            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TodayTrainersViewController"];
                        
                        
                        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
                        
                        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
                        [navController setViewControllers: @[selectedViewController] animated: YES];
                        
                        [self.revealViewController setFrontViewController:navController];
                        
                        [self.navigationController pushViewController:selectedViewController animated:YES];
                        if ( revealViewController )
                        {
                            [revealViewController revealToggleEnd];
                        }
                        return;
                    } else {
                        [self showAlert];
                    }
             
                }
                else{
                    [self gohome];
                    return;
                }
                
            }
            
            if(indexPath.row == 13 ){
                [self isLoggedInUser:tableView];
                NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
                NSDictionary * dict = [userDef dictionaryRepresentation];
                    for (id key in dict) {
                        [userDef removeObjectForKey:key];
                    }
                [userDef synchronize];
                
                [self.sideTableView reloadData];
              
            }
        }
    }

-(void)gohome{
    SWRevealViewController *revealViewController = self.revealViewController;
    
    UIViewController *selectedViewController;
    
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
//    else
        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainGridViewController"];
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
    
    [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
    [navController setViewControllers: @[selectedViewController] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    
    [self.navigationController pushViewController:selectedViewController animated:YES];
    if ( revealViewController )
    {
        [revealViewController revealToggleEnd];
    }
    [[[UIAlertView alloc] initWithTitle:@"Neo Fitnes" message:@"Please Check Your Internet Connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

-(void) isLoggedInUser: (UITableView*)tableview {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
        
        [self goToHome];
        
//       return
        
    } else {
        [self showAlert];
    }
  
}


-(void) comingSoonAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Feature is coming soon."
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button one");
                                                          }]; // 2
//    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Login"
//                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                               if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
//                                                                   [self goToHome];
//
//                                                               } else {
//                                                                   [self goToLogin];
//                                                               }
//
//
//                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
//    [alert addAction:secondAction]; // 5
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
    
}


-(void) showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Authorized User"
                                                                   message:@"Please login to use this feature."
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
            {
                [revealViewController revealToggleEnd];
                }
        }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Login"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               if ([[NSUserDefaults standardUserDefaults] boolForKey: @"currentUser"]) {
                                                                   [self goToHome];
                                                                   
                                                               } else {
                                                                   [self goToLogin];
                                                               }
                                                               
                                                              
                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
    
}


-(void) showComing {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"NEO"
                                                                   message:@"Dear user you can change and retrieve your password by log in at www.rightsoft.in or mail us. \nThanks \n Team Neo fitnes."
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              
                                                          }]; // 2
   
    
    [alert addAction:firstAction]; // 4
    [self presentViewController:alert animated:YES completion:nil]; // 6
    
}




-(void) goToHome {
    
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [userDef dictionaryRepresentation];
    for (id key in dict) {
        [userDef removeObjectForKey:key];
    }
    [userDef setBool:false forKey: @"currentUser"];
    [userDef removeObjectForKey:@"selectedBranchId"];
    [userDef synchronize];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    UIViewController *selectedViewController;
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
//    else
        selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
     
     UITabBarController *TABVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeTabbarController"];
     
     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];

     [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
     [navController setViewControllers: @[selectedViewController] animated: YES];

     [self.revealViewController setFrontViewController:TABVC];
     
     [TABVC.navigationController pushViewController:selectedViewController animated:YES];
     if ( revealViewController )
     {
         [revealViewController revealToggleEnd];
     }
     return;
    
    
    
//    selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//          
//          UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
//          
//          [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
//          [navController setViewControllers: @[selectedViewController] animated: YES];
//          
//          [self.revealViewController setFrontViewController:navController];
//          
//          [self.navigationController pushViewController:selectedViewController animated:YES];
//          if ( revealViewController )
//          {
//              [revealViewController revealToggleEnd];
//          }
//          
//          return;
    

    
    
//
//    [self.navigationController pushViewController:selectedViewController animated:YES];
//    if ( revealViewController )
//    {
//        [revealViewController revealToggleEnd];
//    }
    
//    return;
}


- (void)updateLabel:(UIGestureRecognizer*)recognizer
{
    // Only respond if we're in the ended state (similar to touchupinside)
    if( [recognizer state] == UIGestureRecognizerStateEnded ) {
        // the label that was tapped
       // UILabel* label = (UILabel*)[recognizer view];
        
//        NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
//        NSDictionary * dict = [userDef dictionaryRepresentation];
//        for (id key in dict) {
//            [userDef removeObjectForKey:key];
//        }
//        [userDef synchronize];
        
        SWRevealViewController *revealViewController = self.revealViewController;
        UIViewController *selectedViewController;
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        else
            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
        
        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[selectedViewController] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        
        [self.navigationController pushViewController:selectedViewController animated:YES];
        if ( revealViewController )
        {
            [revealViewController revealToggleEnd];
        }
        
        return;
        // do things with your label
    }
}
    
    
    - (void)goToLogin {
        
      
        SWRevealViewController *revealViewController = self.revealViewController;
        UIViewController *selectedViewController;
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        else
            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
        
        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[selectedViewController] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
    
        [self.navigationController pushViewController:selectedViewController animated:YES];
        if ( revealViewController )
        {
            [revealViewController revealToggleEnd];
        }
        return;
    }


- (void)didSelectAdminAt:(NSIndexPath *)indexPath {
    
    switch(indexPath.row) {
    
        case 0 :
        [self goToSelectedViewController:@"BAHome"];
         break;
      
        case 1 :
        [self goToSelectedViewController:@"BAProfile"];
        break;
            
      case 2 :
        [self goToSelectedViewController:@"BAPackageCollection"];
         break;
      
        case 3 :
           [self goToSelectedViewController:@"BAAttendence"];
         break;
      
        case 4 :
        [self goToSelectedViewController:@"BACustomerMembership"];
         break;
            
        case 5 :
        [self goToSelectedViewController:@"BAPaymentDefaulters"];
        break;
            
        case 6 :
        [self goToSelectedViewController:@"BAMembershipDefaulters"];
            break;
        case 7 :
        [self goToHome];
        break;
            
      default :
         NSLog(@"Invalid grade\n" );
      }
}

- (void)goToSelectedViewController:(NSString *)VC {
        
      
        SWRevealViewController *revealViewController = self.revealViewController;
        UIViewController *selectedViewController;
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        else
            selectedViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier: VC];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
        
        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[selectedViewController] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
    
        [self.navigationController pushViewController:selectedViewController animated:YES];
        if ( revealViewController )
        {
            [revealViewController revealToggleEnd];
        }
        return;
    }

    

@end
