//
//  AppDelegate.m
//  LoveMusic
//
//  Created by kevin xu on 15/12/26.
//  Copyright © 2015年 kevin xu. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "MyMusicViewController.h"
#import "SettingsViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) HomeViewController *homeController;
@property (nonatomic, strong) MyMusicViewController *myMusicController;
@property (nonatomic, strong) SettingsViewController *settingController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //init root tabcontroller
    self.tabController = [[UITabBarController alloc] init];
    
    //add root tab to window
    self.window.rootViewController = self.tabController;
    
    //set tab viewcontrolls
    self.tabController.viewControllers = [self tabViewControllerArray];
    [self initTabBarItems];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (NSArray *)tabViewControllerArray
{
    return [NSMutableArray arrayWithObjects:[[UINavigationController alloc] initWithRootViewController:self.homeController],[[UINavigationController alloc] initWithRootViewController:self.myMusicController],[[UINavigationController alloc] initWithRootViewController:self.settingController], nil];
}

- (void)initTabBarItems
{
    NSArray *imageNames = @[@"tabicon_home_gray",
                            @"tabicon_destination_gray",
                            @"tabicon_discovery_gray"
                            ];
    NSArray *selectedImageNames = @[@"tabicon_home_green",
                                    @"tabicon_destination_green",
                                    @"tabicon_discovery_green"
                                    ];
    NSArray *titleArray = @[@"发现音乐",@"我的音乐",@"设置"];
    [self.tabController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        item.title = titleArray[idx];
//        item.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        item.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
}

- (HomeViewController *)homeController
{
    if (!_homeController) {
        self.homeController = [[HomeViewController alloc] init];
        self.homeController.hidesBottomBarWhenPushed = NO;
    }
    return _homeController;
}

- (MyMusicViewController *)myMusicController
{
    if (!_myMusicController) {
        self.myMusicController = [[MyMusicViewController alloc] init];
        self.myMusicController.hidesBottomBarWhenPushed = NO;
    }
    return _myMusicController;
}

- (SettingsViewController *)settingController
{
    if (!_settingController) {
        self.settingController = [[SettingsViewController alloc] init];
        self.settingController.hidesBottomBarWhenPushed = NO;
    }
    return _settingController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
