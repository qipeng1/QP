//
//  NetWorkController.m
//  RTsheech
//
//  Created by telsafe-macpc1 on 12-11-14.
//  Copyright (c) 2012年 telsafe-macpc1. All rights reserved.
//

#import "NetWorkController.h"
#import "MainViewController.h"

@implementation NetWorkController

-(void)initWithFile:(NSString*)file{
    NSURL *recordedFile = [NSURL fileURLWithPath:file];
    NSData * data = [[NSData alloc]initWithContentsOfURL:recordedFile];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    [request setURL:[NSURL URLWithString:@"http://192.168.1.218:9999/"]];
    [request setHTTPMethod:@"POST"];     //
    [request setHTTPBody:data];
    
//    NSString* filepath = [[NSString alloc] initWithFormat:@"%@/body.txt",realPath];
 
 //   NSData *body = [NSData dataWithContentsOfFile:filepath];
    

//    NSURL * url1 = [[NSURL alloc]initWithString:@"http://192.168.1.218:9999/"];
//    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url1];
    NSURLConnection * connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    finished = false;
//    while(!finished) {
//		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//	}
    [connection release];
//    [url1 release];
    [request release];
    [data release];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}

-(void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL{
    [connection release];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"connectionDidReceiveData");
    NSString *newText = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (newText != NULL) {
        MainViewController * view = [MainViewController alloc];
       // view.mtextview.text = newText;
       [view.mtextview setText:newText];
        NSLog(@"%@",newText);
        [newText release];
        [view release];
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }

NSLog(@"get the whole response");
////[receivedData setLength:0];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection{
    return NO;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

@end
