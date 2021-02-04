//
//  ObecityReportDetailTableViewCell.h
//  NeoFitness
//
//  Created by Sumit on 18/05/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObecityReportDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *lbl_createdDate;
@property (strong, nonatomic) IBOutlet UILabel *lbl_CreatedBy;
@property (strong, nonatomic) IBOutlet UILabel *lbl_MBR;
@property (strong, nonatomic) IBOutlet UILabel *lbl_BodyFat;
@property (strong, nonatomic) IBOutlet UILabel *VisceralFat;
@property (strong, nonatomic) IBOutlet UILabel *lbl_BodyAge;
@property (strong, nonatomic) IBOutlet UILabel *lbl_BMI;
@property (strong, nonatomic) IBOutlet UILabel *lbl_RestingMetabolism;
@property (strong, nonatomic) IBOutlet UIScrollView *scrview;
@property (strong, nonatomic) IBOutlet UIButton *btn_back;

@end
