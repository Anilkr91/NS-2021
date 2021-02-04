//
//  DietFeedbackTableViewCell.h
//  NeoFitness
//
//  Created by Sumit on 16/02/18.
//  Copyright © 2018 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DietFeedbackTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblcreatedDate;
@property (weak, nonatomic) IBOutlet UILabel *lblfeedbackDate;
@property (weak, nonatomic) IBOutlet UILabel *lblfeedback;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrView;
@property (strong, nonatomic) IBOutlet UILabel *lblFeedbackBy;



@end
