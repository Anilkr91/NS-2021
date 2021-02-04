//
//  DietCardTableViewCell.h
//  NeoFitness
//
//  Created by Sumit Saini on 19/09/16.
//  Copyright © 2016 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DietCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDietList;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrView;
@property (weak, nonatomic) IBOutlet UILabel *lblDietList1;
@property (weak, nonatomic) IBOutlet UILabel *lblTime1;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail1;
@property (strong, nonatomic) IBOutlet UIView *view_DietBottom;
@property (strong, nonatomic) IBOutlet UILabel *lbl_remark;
@property (strong, nonatomic) IBOutlet UIView *view_diet;

@end
