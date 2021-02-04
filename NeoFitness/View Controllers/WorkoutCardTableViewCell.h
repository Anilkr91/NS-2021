//
//  WorkoutCardTableViewCell.h
//  NeoFitness
//
//  Created by Sumit Saini on 06/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblBodyPart;
@property (weak, nonatomic) IBOutlet UILabel *lblExcercise;
@property (weak, nonatomic) IBOutlet UILabel *lblSets;
@property (weak, nonatomic) IBOutlet UILabel *lblRep;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSeq;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark;

@property (weak, nonatomic) IBOutlet UILabel *lblBodyPartValue;
@property (weak, nonatomic) IBOutlet UILabel *lblExcerciseValue;
@property (weak, nonatomic) IBOutlet UILabel *lblSetsValue;
@property (weak, nonatomic) IBOutlet UILabel *lblRepValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeValue;
@property (weak, nonatomic) IBOutlet UILabel *lblSeqValue;
@property (weak, nonatomic) IBOutlet UILabel *lblRemarkValue;

@end
