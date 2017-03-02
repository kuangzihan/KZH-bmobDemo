//
//  KZHUserInfoTool.h
//  LittleSure
//
//  Created by 邝子涵 on 2017/3/2.
//  Copyright © 2017年 邝子涵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZHUserInfoTool : NSObject

// 单例
+ (instancetype)sharedManager;

// 添加注册用户
- (void)addUser:(NSString*)user;

// 修改用户个人头像
- (void)changeUserIcon:(UIImage*)iconImg withUserName:(NSString *)userName;

// 修改昵称
- (void)changeNickName:(NSString*)nickName withUserName:(NSString *)userName;

// 获取所有好友个人信息
- (void)getFriendPersionInfo:(NSArray*)list
                     success:(void(^)(NSArray *array))success
                     failure:(void(^)(NSError *error))failure;

// 根据昵称查询用户信息
- (void)getUserInfoWithNickName:(NSString*)nickName
                        success:(void(^)(NSArray *array))success
                        failure:(void(^)(NSError *error))failure;

// 根据账号查询用户信息
- (void)getUserInfoWithUserName:(NSString*)userName
                        success:(void(^)(NSArray *array))success
                        failure:(void(^)(NSError *error))failure;

// 改变当前的状态是否在线
- (void)changeMyStates:(BOOL)isOnline withUserName:(NSString *)userName;








@end
