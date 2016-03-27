//
//  NetRequest.h
//  L20-三方网络请求Demo
//
//  Created by Iracle Zhang on 9/8/15.
//  Copyright (c) 2015 Iracle Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetRequest : NSObject
//GET请求
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id resposeObject)) success failure:(void(^)(NSError *error)) failure;

//POST请求
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id resposeObject)) success failure:(void(^)(NSError *error)) failure;

@end
























