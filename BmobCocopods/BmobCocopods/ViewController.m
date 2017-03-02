//
//  ViewController.m
//  BmobCocopods
//
//  Created by 邝子涵 on 2017/3/2.
//  Copyright © 2017年 邝子涵. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 添加
- (IBAction)addClick:(id)sender {
    [[KZHUserInfoTool sharedManager] addUser:@"kzh"];
}


// 修改
- (IBAction)reviseClick:(id)sender {
    [[KZHUserInfoTool sharedManager] changeNickName:@"123" withUserName:@"kzh"];
}

// 查询
- (IBAction)query:(id)sender {
    [[KZHUserInfoTool sharedManager] getUserInfoWithUserName:@"kzh" success:^(NSArray *array) {
        NSLog(@"%@", array);
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

// 上传图片
- (IBAction)addPicture:(id)sender {
    UIImage *image = [UIImage imageNamed:@"logo_LittleSure"];
    [[KZHUserInfoTool sharedManager] changeUserIcon:image withUserName:@"kzh"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
