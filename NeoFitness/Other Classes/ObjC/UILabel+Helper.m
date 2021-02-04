//
//  UILabel+Helper.m
//  NeoFitness
//
//  Created by Sumit on 10/10/17.
//  Copyright © 2017 dmondo. All rights reserved.
//

#import "UILabel+Helper.h"

@implementation UILabel (Helper)
- (void)setSubstituteFontName:(NSString *)name UI_APPEARANCE_SELECTOR {
    self.font = [UIFont fontWithName:name size:self.font.pointSize]; } 
@end
