//
//  DLYURLProtocol.m
//  testUrlProtocol
//
//  Created by 董力云 on 2017/9/18.
//  Copyright © 2017年 董力云. All rights reserved.
//

#import "DLYURLProtocol.h"

static NSString *URLProtocolHandledKey = @"handledKey";

@interface DLYURLProtocol()<NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation DLYURLProtocol

+ (void)registerSelf{
    [NSURLProtocol registerClass:self];
}

+ (void)unregisterSelf{
    [NSURLProtocol unregisterClass:self];
}

/// 是否打算处理对应的request
+(BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
        return NO;
    }else{
        return YES;
    }
}
/// 替换
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    if ([request.URL host].length == 0) {
        return request;
    }
    NSMutableURLRequest *newRequest = [request copy];
    
    NSString *originUrlString = [request.URL absoluteString];
    NSString *originHostString = [request.URL host];
    NSRange hostRange = [originUrlString rangeOfString:originHostString];
    if (hostRange.location == NSNotFound) {
        return request;
    }
    NSString *ip = @"github.com";
    NSString *urlString = [originUrlString stringByReplacingCharactersInRange:hostRange withString:ip];
    
    newRequest.URL = [NSURL URLWithString:urlString];
    return newRequest;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading{
    NSLog(@"startLoading");
    NSMutableURLRequest *mutableRequest =[[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableRequest];
    self.connection = [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
}

- (void)stopLoading{
    NSLog(@"stopLoading");
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(nonnull NSURLResponse *)response{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(nonnull NSError *)error{
    [self.client URLProtocol:self didFailWithError:error];
}

@end
