//
//  ImageFilterViewController.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ImageFilterViewController.h"
@interface ImageFilterViewController ()

@end

@implementation ImageFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [testBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [testBtn setTitle:@"pop" forState:UIControlStateNormal];
    testBtn.frame = CGRectMake(100, 100, 100, 30);
    [self.view addSubview:testBtn];
    NSLog(@"self.view.height == %f",self.view.frame.size.height);
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
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
