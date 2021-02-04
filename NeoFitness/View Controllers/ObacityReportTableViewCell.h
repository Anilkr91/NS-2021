//
//  ObacityReportTableViewCell.h
//  NeoFitness
//
//  Created by Sumit on 17/05/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObacityReportTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_PackageName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TotalSessionAttended;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Treatment;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ConsultantName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_InitialWeight;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TargetWeightLoss;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TargetInchLoss;
@property (strong, nonatomic) IBOutlet UILabel *lbl_CreatedBy;
@property (strong, nonatomic) IBOutlet UILabel *lbl_CreatedDate;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TargetStatus;
@property (strong, nonatomic) IBOutlet UILabel *lbl_DiticianName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TrainerName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Comments;
@property (weak, nonatomic) IBOutlet UILabel *lbl_totalInchLoss;
@property (weak, nonatomic) IBOutlet UILabel *lbl_totalWeightLossAchieved;
@property (weak, nonatomic) IBOutlet UILabel *lbl_totalInchLossAchieved;

@end
