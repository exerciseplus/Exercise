//
//  RootController.m
//  Exercise+
//
//  Created by wzy on 16/1/28.
//  Copyright © 2016年 王振宇. All rights reserved.
//

#import "RootController.h"
#import "UserUtility.h"
#import "RunActivityNavigationViewController.h"
@interface RootController ()

@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
    RunActivityNavigationViewController* runActivityConatroller = [[UIStoryboard storyboardWithName:@"RunActivity" bundle:nil] instantiateViewControllerWithIdentifier:@"runActivity"];
    self.viewControllers = [NSArray arrayWithObjects:runActivityConatroller ,nil];
    //[self initTabBarItem];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    if ([[UserUtility sharedUserUtility] isLogIn]) {
        
    }else {
        [self performSegueWithIdentifier: @"showLoginView" sender:self];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initTabBarItem {
    UITabBar *tabbar = self.tabBar;
    //    self.tabBarController.tabBar;
    UITabBarItem *item0 = [tabbar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabbar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabbar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabbar.items objectAtIndex:3];
    UITabBarItem *item4 = [tabbar.items objectAtIndex:4];
    
    item0.selectedImage = [[UIImage imageNamed:@"icon_tab_shouye_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.image = [[UIImage imageNamed:@"icon_tab_shouye_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [[UIImage imageNamed:@"icon_tab_fujin_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"icon_tab_fujin_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item2.selectedImage = [[UIImage imageNamed:@"tabbar_voice_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"tabbar_voice_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);//注意这里的两个值
    
    item3.selectedImage = [[UIImage imageNamed:@"tab_icon_selection_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"tab_icon_selection_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"icon_tab_wode_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"icon_tab_wode_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //改变UITabBarItem字体颜色
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:navigationBarColor,UITextAttributeTextColor, nil] forState:UIControlStateSelected];
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
