//
//  AppDelegate.h
//  LeftOrRightSelect
//
//  Created by Sun on 2019/4/8.
//  Copyright © 2019 Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

