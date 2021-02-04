//
//  DrObservationTableViewCell.h
//  NeoFitness
//
//  Created by Sumit on 17/04/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrObservationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cellDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellObservationLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellObservationByLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *cellMainScrView;
@property (strong, nonatomic) IBOutlet UIView *cellMainView;
@property (weak, nonatomic) IBOutlet UIButton *btn_comment;
@property (weak, nonatomic) IBOutlet UIButton *btn_viewcomment;


@end
