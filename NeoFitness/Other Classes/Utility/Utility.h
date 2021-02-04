//
//  Utility.h
//  Publication App
//
//  Created by 􏰀«†Harsh Duggal†«􏰀 on 20/03/13.
//
//

// 􏰀  « † † «  􏰀

#import <Foundation/Foundation.h>


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define SHKdegreesToRadians(x) (M_PI * x / 180.0)

#define kNetworkError @"Please check data connectivity !"



@interface Utility : NSObject


+ (UIColor *)colorWithHex:(UInt32)col;// takes @"#123456"
+ (UIColor *)colorWithHexString:(NSString *)str;// takes 0x123456


+(NSString*) convertDictionaryToString:(NSMutableDictionary*) dict;
+(NSString*)convertDateToString:(NSDate*)selectedDate;
+(NSDate*)dateFromString:(NSString*)dateStr;
+(int)daysBetweenFromDate:(NSDate*)fromDateTime toDate:(NSDate*)toDateTime;


//+(UIImageView*)convertToRoundedImage:(UIImageView *)image withDiameter:(float)newSize;

+ (BOOL) validateUrl: (NSString *) candidate;
+ (BOOL) validateEmail: (NSString *) candidate;
+ (BOOL) validateStringContainsAlphabetsOnly:(NSString*)strng;
+ (BOOL) validateStringContainsNumbersOnly:(NSString*)strng;
+ (BOOL)validateStringContainsDecimalNumbersOnly:(NSString*)strng;
+ (BOOL)connected;
//+ (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize;

// ResizeImage-
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
