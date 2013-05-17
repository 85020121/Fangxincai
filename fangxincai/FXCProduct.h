//
//  FXCProduct.h
//  fangxincai
//
//  Created by Bowen GAO on 5/11/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import <Foundation/Foundation.h>


#define FXCPRODUCT_NAME         @"name"
#define FXCPRODUCT_PRICE        @"price"
#define FXCPRODUCT_FORMAT       @"format"
#define FXCPRODUCT_PICURL       @"url"
#define FXCPRODUCT_ID           @"id"

@interface FXCProduct : NSObject

@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *format;
@property (strong, nonatomic) NSString *picUrl;


- (id)initWith:(NSDictionary *) info;

@end
