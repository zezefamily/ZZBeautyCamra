//
//  MainViewController.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/18.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "MainViewController.h"
#import "CamraViewController.h"
@interface MainViewController ()
{
    UIImageView *_bannerImgView;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
    
}

- (void)loadUI
{
    _bannerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2 + 30)];
    _bannerImgView.backgroundColor = [UIColor systemGreenColor];
    [self.view addSubview:_bannerImgView];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-30, self.view.frame.size.width, self.view.frame.size.height/2)];
    contentView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:.95];
    [self.view addSubview:contentView];
    //相机
    UIButton *camraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    camraBtn.frame = CGRectMake(self.view.frame.size.width/2 - 40, contentView.frame.size.height - 80 - 15, 80, 80);
    camraBtn.backgroundColor = ThemeColor;
    [camraBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    camraBtn.layer.cornerRadius = 40;
    [camraBtn addTarget:self action:@selector(camraClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:camraBtn];
    //菜单
    UIView *menuView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, contentView.frame.size.width - 30, contentView.frame.size.height - 15 - 80 - 30)];
//    menuView.backgroundColor = [UIColor systemPinkColor];
    [contentView addSubview:menuView];
    
    float margin = 15;
    float width = menuView.frame.size.width/2 - 7.5;
    float height = 100;
    int colum = 2;
    for(int i = 0;i<4;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i%colum * (width + margin), (height+margin)*(i / colum), width, height);
        btn.backgroundColor = [UIColor colorWithRed:0.91f green:0.51f blue:0.91f alpha:1.00f];;
        btn.layer.cornerRadius = 15.0f;
        [btn setTitle:@[@"图片精修",@"视频滤镜",@"构建中",@"构建中"][i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 400 + i;
        [menuView addSubview:btn];
    }
}

- (void)camraClick
{
    CamraViewController *camraVC = [[CamraViewController alloc]init];
//    [self presentViewController:camraVC animated:YES completion:nil];
    [self.navigationController pushViewController:camraVC animated:YES];
}

- (void)menuClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 400;
    
    switch (tag) {
        case 0:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
