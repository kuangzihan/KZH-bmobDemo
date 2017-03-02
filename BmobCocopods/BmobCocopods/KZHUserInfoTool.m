//
//  KZHUserInfoTool.m
//  LittleSure
//
//  Created by 邝子涵 on 2017/3/2.
//  Copyright © 2017年 邝子涵. All rights reserved.
//

#import "KZHUserInfoTool.h"

@implementation KZHUserInfoTool

#pragma mark - 单例
+ (instancetype)sharedManager {
    static KZHUserInfoTool * tool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[KZHUserInfoTool alloc]init];
    });
    return tool;
}

#pragma mark - 添加注册用户
- (void)addUser:(NSString*)user {
    BmobObject *score = [BmobObject objectWithClassName:@"LittleSure_UserInfo"];
    [score setObject:user forKey:@"userName"];
    [score setObject:@"1" forKey:@"iconURL"];
    [score setObject:@"暂未设置" forKey:@"nickName"];
    [score setObject:[NSNumber numberWithBool:NO] forKey:@"isOnline"];
    [score saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"添加成功");
        } else {
            NSLog(@"添加失败");
        }
        
        NSLog(@"添加用户信息失败:%@   code:%ld", error.domain, error.code);
    }];
}

#pragma mark - 修改用户个人头像
- (void)changeUserIcon:(UIImage*)iconImg withUserName:(NSString *)userName {
    NSData *imageData = UIImagePNGRepresentation(iconImg);
    BmobFile *bfile = [[BmobFile alloc] initWithFileName:@"icon.png" withFileData:imageData];
    [bfile saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"上传成功");
            NSLog(@"图片上传成功之后的地址: %@ 文件的名字: %@ 文件的组名: %@",bfile.url,bfile.name,bfile.group);
            //查找LittleSure_UserInfo表
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"LittleSure_UserInfo"];
            [bquery whereKey:@"userName" equalTo:userName];
            // 比较查询userName并进行修改
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (!error && array.count > 0) {
                    BmobObject *gameScore = array.firstObject;
                    [gameScore setObject:bfile.url forKey:@"iconURL"];
                    [gameScore updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (!error) {
                            NSLog(@"上传成功");
                        }else{
                            NSLog(@"上传失败");
                        }
                    }];
                }else{
                    NSLog(@"修改用户个人头像查询失败");
                }
            }];
            
        } else {
            NSLog(@"上传文件发生了错误 错误信息%@",error);
        }
    } withProgressBlock:^(CGFloat progress) {
        NSLog(@"%lf", progress);
    }];
}

#pragma mark - 修改昵称
- (void)changeNickName:(NSString*)nickName withUserName:(NSString *)userName {
    BmobQuery * query = [BmobQuery queryWithClassName:@"LittleSure_UserInfo"];
    [query whereKey:@"userName" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            BmobObject * gameScore = array.firstObject;
            [gameScore setObject:nickName forKey:@"nickName"];
            [gameScore updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"修改成功");
                }else{
                    NSLog(@"修改失败");
                }
            }];
        } else {
            NSLog(@"修改昵称查询失败");
        }
    }];
}

#pragma mark - 获取所有好友个人信息
- (void)getFriendPersionInfo:(NSArray*)list
                     success:(void(^)(NSArray *array))success
                     failure:(void(^)(NSError *error))failure {
    BmobQuery * query = [BmobQuery queryWithClassName:@"LittleSure_UserInfo"];
    [query whereKey:@"userName" containedIn:list];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            success(array);
        } else {
            failure(error);
            NSLog(@"获取所有好友个人信息查询失败");
        }
    }];
}

#pragma mark - 根据昵称查询用户信息
- (void)getUserInfoWithNickName:(NSString*)nickName
                        success:(void(^)(NSArray *array))success
                        failure:(void(^)(NSError *error))failure {
    BmobQuery *query = [BmobQuery queryWithClassName:@"LittleSure_UserInfo"];
    [query whereKey:@"nickName" equalTo:nickName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            success(array);
        } else {
            failure(error);
            NSLog(@"根据账号查询用户信息查询失败");
        }
    }];
    
}

#pragma mark - 根据账号查询用户信息
- (void)getUserInfoWithUserName:(NSString*)userName
                        success:(void(^)(NSArray *array))success
                        failure:(void(^)(NSError *error))failure {
    BmobQuery *query = [BmobQuery queryWithClassName:@"LittleSure_UserInfo"];
    [query whereKey:@"userName" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            success(array);
        } else {
            failure(error);
            NSLog(@"根据账号查询用户信息查询失败");
        }
    }];
}

#pragma mark - 改变当前的状态是否在线
- (void)changeMyStates:(BOOL)isOnline withUserName:(NSString *)userName {
    BmobQuery *query = [BmobQuery queryWithClassName:@"LittleSure_UserInfo"];
    [query whereKey:@"userName" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            BmobObject * gameScore = array.firstObject;
            [gameScore setObject:[NSNumber numberWithBool:isOnline] forKey:@"isOnline"];
            [gameScore updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"更改状态成功");
                }else{
                    NSLog(@"更改状态失败");
                }
            }];
        } else {
            NSLog(@"查找用户失败");
        }
    }];
}

@end
