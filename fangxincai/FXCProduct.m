//
//  FXCProduct.m
//  fangxincai
//
//  Created by Bowen GAO on 5/11/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCProduct.h"

@implementation FXCProduct

@synthesize productID = _productID, name = _name, price = _price, format = _format, picUrl = _picUrl;

- (id)initWith:(NSDictionary *) info
{
    if (self = [super init]) {
        _productID = [info objectForKey:FXCPRODUCT_ID];
        _name = [info objectForKey:FXCPRODUCT_NAME];
        _price = [info objectForKey:FXCPRODUCT_PRICE];
        _format = [info objectForKey:FXCPRODUCT_FORMAT];
        _picUrl = [info objectForKey:FXCPRODUCT_PICURL];
    }
    return self;
}


@end
