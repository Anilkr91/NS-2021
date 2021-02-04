//
//  ObesitySessionPopupViewTableViewCell.h
//  NeoFitness
//
//  Created by Sumit on 19/05/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObesitySessionPopupViewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *CellMainLabel;
@property (strong, nonatomic) IBOutlet UITextField *textfield_before;
@property (strong, nonatomic) IBOutlet UITextField *textfield_after;
@property (strong, nonatomic) IBOutlet UITextField *textfield_difference;

@end
