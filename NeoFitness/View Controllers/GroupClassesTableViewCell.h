//
//  GroupClassesTableViewCell.h
//  NeoFitness
//
//  Created by Sumit Saini on 05/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupClassesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblClassName;
@property (weak, nonatomic) IBOutlet UILabel *lblTrainer;
@property (weak, nonatomic) IBOutlet UILabel *lblstartTime;
@property (weak, nonatomic) IBOutlet UILabel *LblEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lblVanue;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end
