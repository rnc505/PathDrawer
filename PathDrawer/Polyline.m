//
//  Polyline.m
//  PathDrawer
//
//  Created by Robby Cohen on 10/23/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import "Polyline.h"

@implementation Polyline
@synthesize coordinates = _coordinates, count = _count;


-(id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count {
    self = [super init];
    if(self){
        NSMutableArray *retVal = [NSMutableArray new];
        for (int i = 0; i < sizeof(coords); i++) {
            [retVal addObject:[[CLLocation alloc]initWithLatitude:coords[i].latitude longitude:coords[i].longitude]];
        }
        _coordinates = retVal;
        _count = [_coordinates count];
    }
    return self;
    
}


-(id)initWithArray:(NSArray *)array count:(NSInteger) count {
    CLLocationCoordinate2D coords[count];
    for(int i = 0; i < count; i++){
        coords[i] = ((CLLocation*)[array objectAtIndex:i]).coordinate;
    }
    return [self initWithCoordinates:coords count:count];
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_coordinates forKey:@"coordinates"];
    [aCoder encodeInteger:_count forKey:@"count"];
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    NSArray *coordinates = [aDecoder decodeObjectForKey:@"coordinates"];
    NSInteger count = [aDecoder decodeIntegerForKey:@"count"];
    return [self initWithArray:coordinates count:count];
}


@end
