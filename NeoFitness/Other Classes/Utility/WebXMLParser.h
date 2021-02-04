//
//  GetAllPaxOnBookingParser.h
//  BAFlights
//
//  Created by Chris Nordberg on 16/07/2014.
//  Copyright British Airways 2014. All rights reserved.
//



@interface WebXMLParser : NSObject
+ (NSDictionary *)parseXML:(NSData *)xmlData;
@end
