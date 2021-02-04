//
//  ObjectClass.m
//  mNivesh-2
//
//  Created by MOHD RAHIB on 21/03/15.
//  Copyright (c) 2015 dmondo. All rights reserved.
//

#import "ObjectClass.h"

@implementation ObjectClass

#pragma mark Singleton Methods

+ (id)sharedManager {
    static ObjectClass *sigleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sigleton = [[self alloc] init];
    });
    return sigleton;
}


@end
