//
//  WebManager.m
//  CRST Driver SVC
//
//  Created by canvasm on 7/28/17.
//  Copyright © 2017 STI. All rights reserved.
//

#import "WebXMLParser.h"
#import "XMLDictionary.h"

@implementation WebXMLParser

+ (NSDictionary *)parseXML:(NSData *)xmlData
{
    NSDictionary *fullDictionary = [NSDictionary dictionaryWithXMLData:xmlData];
    return fullDictionary;
}

@end
