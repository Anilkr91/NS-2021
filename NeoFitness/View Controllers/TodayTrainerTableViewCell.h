//
//  TodayTrainerTableViewCell.h
//  NeoFitness
//
//  Created by Sumit on 20/09/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTrainerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_TrainerName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CreatedBy;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CreatedDate;
@property (weak, nonatomic) IBOutlet UILabel *Status;
@property (weak, nonatomic) IBOutlet UIImageView *imageview1;
@property (weak, nonatomic) IBOutlet UIImageView *imageview2;

@property (weak, nonatomic) IBOutlet UIImageView *imageview3;
@property (weak, nonatomic) IBOutlet UIImageView *imageview4;
@property (weak, nonatomic) IBOutlet UIImageView *imageview5;
@property (weak, nonatomic) IBOutlet UIButton *btn_addRating;
@property (weak, nonatomic) IBOutlet UIView *cellMainView;
@property (weak, nonatomic) IBOutlet UIView *cellLineView;

@end
