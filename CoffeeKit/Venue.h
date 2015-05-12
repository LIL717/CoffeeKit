//
//  Venue.h
//  CoffeeKit
//
//  Created by Lori Hill on 5/11/15.
//  Copyright (c) 2015 Lori Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Location;
@class Stats;

@interface Venue : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Location *location;
@property (strong, nonatomic) Stats *stats;


@end
