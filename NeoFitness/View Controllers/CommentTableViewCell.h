//
//  CommentTableViewCell.h
//  NeoFitness
//
//  Created by Sumit on 25/09/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_comment;
@property (weak, nonatomic) IBOutlet UIView *cellview_gap;
@property (weak, nonatomic) IBOutlet UIView *view_commentMain;

@end
