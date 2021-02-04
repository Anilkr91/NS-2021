//
//  ObesitySessionDetailTableViewCell.h
//  NeoFitness
//
//  Created by Sumit on 18/05/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObesitySessionDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIScrollView *scrview;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *Lbl_session;
@property (strong, nonatomic) IBOutlet UILabel *Lbl_cretedDate;
@property (strong, nonatomic) IBOutlet UILabel *Lbl_Therepistname;
@property (strong, nonatomic) IBOutlet UILabel *Lbl_totalweightLoss;
@property (strong, nonatomic) IBOutlet UILabel *Lbl_totalInchLoss;

@property (strong, nonatomic) IBOutlet UIButton *btn_detailedView;


@end
