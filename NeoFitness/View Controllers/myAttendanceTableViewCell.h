//
//  myAttendanceTableViewCell.h
//  NeoFitness
//
//  Created by Sumit Saini on 26/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myAttendanceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Lbldate1;
@property (weak, nonatomic) IBOutlet UILabel *Lbldate;
@property (weak, nonatomic) IBOutlet UILabel *Lblmor1;
@property (weak, nonatomic) IBOutlet UILabel *Lblmor;
@property (weak, nonatomic) IBOutlet UILabel *Lblaftr1;
@property (weak, nonatomic) IBOutlet UILabel *Lblaftr;
@property (weak, nonatomic) IBOutlet UILabel *Lblaleve1;
@property (weak, nonatomic) IBOutlet UILabel *Lblaleve;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end
