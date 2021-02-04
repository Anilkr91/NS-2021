//
//  SocketConnect.m
//  ServerConnection
//
//  Created by Harsh Duggal on 11/06/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerConnect.h"

@implementation ServerConnect

@synthesize _delegate;
@synthesize _connection;

#pragma mark- establishing connection b/w server and client

#pragma mark -Connection Delegates-
#pragma mark- creating connection with url
-(void)createConnectionRequestToURL:(NSString*)urlStr withJsonString:(NSString *)jsonStringToServer
{
    _appDelegateObj = (CmnzWiFiFaceAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *getString = [NSString stringWithFormat:@"%@",jsonStringToServer];
    
    NSData *getData = [getString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
      
    NSString *getLength = [NSString stringWithFormat:@"%lu", (unsigned long)[getData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setURL:[NSURL URLWithString:urlStr]];
    //[request setHTTPMethod:@"GET"];
    [request setHTTPMethod:@"POST"];
    [request setValue:getLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:getData];
    
   _connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    if (_connection) {
               _recievedData = [NSMutableData data] ;
    }
    else {
        NSLog(@"Connection not created");
    }
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
   
    
}

-(void)sendImageToURL:(NSString*)urlStr withImage:(UIImage *)image withImageName:(NSString *)imageName withCoordinates:(NSString*)coord
{
    NSLog(@"Image name is %@",imageName);
    NSData *imageData = UIImageJPEGRepresentation(image,1);
    NSString *urlString = [NSString stringWithFormat:@"%@",urlStr];
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = [[NSString alloc]init];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"test.png\"rn" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/%@.jpg\r\n\r\n",imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[coord dataUsingEncoding:NSUTF8StringEncoding]];

    [request setHTTPBody:body];
    
    _connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (_connection) {
        _recievedData = [NSMutableData data] ;
    }
    else {
        NSLog(@"Connection not created");
    }
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    
}

#pragma mark- Connection Delegates-

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response // This method is called when the server has determined that it has enough information to create the NSURLResponse. It can be called multiple times, for example in the case of a redirect, so each time we reset the data.
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString * tempResponseStatus =  @"";
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"ConnectionDidReceiveResponse %ld", (long)[httpResponse statusCode]);
    if ([httpResponse statusCode] >= 400)
    {
        tempResponseStatus =[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]];
        NSLog(@"remote url returned error %ld %@",(long)[httpResponse statusCode],tempResponseStatus);
    }

    // receivedData is an instance variable declared elsewhere.
    [_recievedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"connection:didReceiveData");
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [_recievedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    // inform the user
    NSString * tempErrorMsg = [NSString stringWithFormat:@"Error - %@ %@",[error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];

    NSLog(@"Connection failed!%@",tempErrorMsg);
    [_delegate dataLoadRequestFailedWithError:error andMsg:tempErrorMsg];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //NSLog(@"Succeeded! Received %d bytes of data",[_recievedData length]);

    NSError* error;
    id object = [NSJSONSerialization
                 JSONObjectWithData:_recievedData
                 options:kNilOptions
                 error:&error];
    if (error)
    {
        //NSLog(@"Error in rx data:%@",[error description]);
        NSString * temp = [[NSString alloc]initWithData:_recievedData encoding:NSASCIIStringEncoding];
        //NSString * temp = [[NSString alloc]initWithData:_recievedData encoding:NSUTF8StringEncoding];
        NSLog(@"Error String :%@",temp);
        [_delegate dataLoadRequestFailedWithError:error andMsg:@"Error"];
        return;
    }
    // oject of class string
    if([object isKindOfClass:[NSString class]] == YES)
    {
        //NSLog(@"String rx from server");
        [_delegate stringLoadedFromServer:object];
    }
    // object of class dictionary
    else if ([object isKindOfClass:[NSDictionary class]] == YES)
    {
        //NSLog(@"Dictionary rx from server: %@",object);
        [_delegate dictLoadedFromServer:object];
    }
    // object of class array
    else if ([object isKindOfClass:[NSArray class]] == YES)
    {
        //NSLog(@"Array rx from server");
        [_delegate arrayLoadedFromServer:object];
    }
}

@end
