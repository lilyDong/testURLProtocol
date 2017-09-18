//
//  DLYURLProtocol.h
//  testUrlProtocol
//
//  Created by 董力云 on 2017/9/18.
//  Copyright © 2017年 董力云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLYURLProtocol : NSURLProtocol

+ (void)registerSelf;

+ (void)unregisterSelf;

@end
