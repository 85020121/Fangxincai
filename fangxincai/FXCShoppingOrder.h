//
//  FXCShoppingOrder.h
//  fangxincai
//
//  Created by Bowen GAO on 5/16/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FXCShoppingOrder : NSManagedObject

@property (nonatomic, retain) NSString * productID;
@property (nonatomic, retain) NSNumber * orderQuantity;
@property (nonatomic, retain) NSDate * date;

@end
