//
//  medicalHistoryTableViewCell.h
//  NeoFitness
//
//  Created by Sumit Saini on 27/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface medicalHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblpackagename1;
@property (weak, nonatomic) IBOutlet UILabel *lblpackagename;
@property (weak, nonatomic) IBOutlet UILabel *lbltestdate1;
@property (weak, nonatomic) IBOutlet UILabel *lbltestdate;
@property (weak, nonatomic) IBOutlet UILabel *lbltestatus1;
@property (weak, nonatomic) IBOutlet UILabel *lbltestatus;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrView;
@end
