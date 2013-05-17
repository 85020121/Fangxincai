//
//  FXCAppDelegate.h
//  fangxincai
//
//  Created by Bowen GAO on 5/10/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
