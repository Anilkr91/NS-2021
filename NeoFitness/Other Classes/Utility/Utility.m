//
//  Utility.m
//  Publication App
//
//  Created by Harsh Duggal on 20/03/13.
//
//

#import "Utility.h"
#import "Reachability.h"
@implementation Utility

+ (NSString*) convertDictionaryToString:(NSMutableDictionary*) dict
{
    NSError* error;
    NSDictionary* tempDict = [dict copy];
    // giving error as it takes dic, array,etc only. not custom object.
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:tempDict
                                                       options:NSJSONReadingMutableLeaves error:&error];
    NSString* nsJson=  [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
    return nsJson;
}
+(NSString*)convertDateToString:(NSDate*)selectedDate //Used in to do list
{
	//NSString *message = [[NSString alloc] initWithFormat:@"%@",selectedDate];
    //NSArray *myWords = [message componentsSeparatedByString:@" "];
    //NSLog(@"%@",myWords);
    
    //    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    //    timeFormatter.dateFormat = @"HH:mm";
    //    timeFormatter.dateFormat = @"hh:mm a";
    //    NSString* stringForNewTime = [timeFormatter stringFromDate:selectedDate];
    
    NSDateFormatter *monthformatter = [[NSDateFormatter alloc] init];
    [monthformatter setDateFormat:@"LLLL"];
    NSString *monthFromDate = [monthformatter stringFromDate:selectedDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d"];
    NSString *dateFromDate = [dateFormatter stringFromDate:selectedDate];
    
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"yyyy"];
    NSString *yearFromDate = [yearFormatter stringFromDate:selectedDate];
    
    NSLog(@"Selected Date:%@ converted to:  %@ %@,%@",selectedDate.description,monthFromDate,dateFromDate,yearFromDate);
    NSString* dateStr = [NSString stringWithFormat:@"%@ %@,%@",monthFromDate,dateFromDate,yearFromDate];
    NSLog(@"dateStr:%@",dateStr);
    return dateStr;
    
}

+(NSDate*)dateFromString:(NSString*)dateStr
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"LLLL d,yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSLog(@"String:%@: date:%@",dateStr, date.description);
    
    //    // Convert date object to desired output format
    //    [dateFormat setDateFormat:@"MMMM d, YYYY"];
    //    dateStr = [dateFormat stringFromDate:date];
    
    return date;
    
}

// takes @"#123456"
+ (UIColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [Utility colorWithHex:x];
}

// takes 0x123456
+ (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

//+(UIImageView*)convertToRoundedImage:(UIImageView *)image withDiameter:(float)newSize;
//{
//    UIImageView* roundedView = image;
//    CGPoint saveCenter = roundedView.center;
//    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
//    roundedView.frame = newFrame;
//    roundedView.layer.cornerRadius = newSize / 2.0;
//    roundedView.center = saveCenter;
//    return roundedView;
//}
//
//+ (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
//    CGSize scaledSize = newSize;
//    float scaleFactor = 1.0;
//    if( image.size.width > image.size.height ) {
//        scaleFactor = image.size.width / image.size.height;
//        scaledSize.width = newSize.width;
//        scaledSize.height = newSize.height / scaleFactor;
//    }
//    else {
//        scaleFactor = image.size.height / image.size.width;
//        scaledSize.height = newSize.height;
//        scaledSize.width = newSize.width / scaleFactor;
//    }
//
//    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
//    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
//    [image drawInRect:scaledImageRect];
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return scaledImage;
//}


+(NSDateFormatter*)DateFormatter
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return dateFormat;
}

+(NSDateFormatter*)yearDateFormatter
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy"];
    return dateFormat;
}

+(NSDateFormatter*)monthDateFormatter
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    return dateFormat;
}

+(NSDateFormatter*)dayDateFormatter
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return dateFormat;
}

+(NSDateFormatter*)timeDateFormat
{
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    return timeFormat;
}

+ (int)daysBetweenFromDate:(NSDate*)fromDateTime toDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    //initialize the calender
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //Returns by reference the starting time and duration of a given calendar unit that contains a given date.
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    //Returns, as an NSDateComponents object using specified components, the difference between two supplied dates.
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

#pragma mark - validate Email And Phone number
+ (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL) validateUrl: (NSString *) candidate
{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

+ (BOOL) validateStringContainsAlphabetsOnly:(NSString*)strng
{
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "];//with space
    //1234567890_"];
    
    s = [s invertedSet];
    //And you can then use a string method to find if your string contains anything in the inverted set:
    
    NSRange r = [strng rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return NO;
    }
    else
        return YES;
}
+(BOOL) validateStringContainsNumbersOnly:(NSString*)strng
{
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    
    s = [s invertedSet];
    //And you can then use a string method to find if your string contains anything in the inverted set:
    
    NSRange r = [strng rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return NO;
    }
    else
        return YES;
}
+(BOOL)validateStringContainsDecimalNumbersOnly:(NSString*)strng
{
    //NSCharacterSet *s = [NSCharacterSet decimalDigitCharacterSet];//
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"1234567890."];
    
    s = [s invertedSet];
    //And you can then use a string method to find if your string contains anything in the inverted set:
    
    NSRange r = [strng rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return NO;
    }
    else
        return YES;
}


- (BOOL) textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered
{
    if(textField)
    {
        NSUInteger currentLength = textField.text.length;
        NSCharacterSet *numbers = [NSCharacterSet decimalDigitCharacterSet];
        if (range.length == 1)
        {
            return YES;
        }
        if ([numbers characterIsMember:[textEntered characterAtIndex:0]])
        {
            if ( currentLength == 3 )
            {
                if (range.length != 1)
                {
                    NSString *firstThreeDigits = [textField.text substringWithRange:NSMakeRange(0, 3)];
                    NSString *updatedText;
                    if ([textEntered isEqualToString:@"-"])
                    {
                        updatedText = [NSString stringWithFormat:@"%@",firstThreeDigits];
                    }
                    else
                    {
                        updatedText = [NSString stringWithFormat:@"%@-",firstThreeDigits];
                    }
                    [textField setText:updatedText];
                }
            }
            else if ( currentLength > 3 && currentLength < 8 )
            {
                if ( range.length != 1 )
                {
                    NSString *firstThree = [textField.text substringWithRange:NSMakeRange(0, 3)];
                    NSString *dash = [textField.text substringWithRange:NSMakeRange(3, 1)];
                    
                    NSUInteger newLenght = range.location - 4;
                    
                    NSString *nextDigits = [textField.text substringWithRange:NSMakeRange(4, newLenght)];
                    
                    NSString *updatedText = [NSString stringWithFormat:@"%@%@%@",firstThree,dash,nextDigits];
                    
                    [textField setText:updatedText];
                }
            }
            else if ( currentLength == 8 )
            {
                if ( range.length != 1 )
                {
                    NSString *areaCode = [textField.text substringWithRange:NSMakeRange(0, 3)];
                    
                    NSString *firstThree = [textField.text substringWithRange:NSMakeRange(4, 3)];
                    
                    NSString *nextDigit = [textField.text substringWithRange:NSMakeRange(7, 1)];
                    
                    [textField setText:[NSString stringWithFormat:@"%@-%@-%@",areaCode,firstThree,nextDigit]];
                }
            }
            NSUInteger proposedNewLength = textField.text.length - range.length + textEntered.length;
            if (proposedNewLength > 12) return NO;
            return YES;
        }
        else
        {
            return NO;
        }
        return YES;
    }
    return YES;
}


// ResizeImage-
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (BOOL)connected
{
	//return NO; // force for offline testing
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
	return !(netStatus == NotReachable);
}


@end
