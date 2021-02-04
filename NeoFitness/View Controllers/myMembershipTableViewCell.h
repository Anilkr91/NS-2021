//
//  myMembershipTableViewCell.h
//  NeoFitness
//
//  Created by Sumit Saini on 27/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myMembershipTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblStartdate;
@property (weak, nonatomic) IBOutlet UILabel *lblExperyDate;
@property (weak, nonatomic) IBOutlet UIView *viewShow;
@property (weak, nonatomic) IBOutlet UILabel *lblmain;

@end
