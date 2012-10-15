//
//  MapPin.m
//  VandyWalkingMaps
//
//  Created by Robby Cohen on 9/27/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import "MapPin.h"


@implementation MapPin

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    self = [super init];
    if (self != nil) {
        coordinate = location;
        title = placeName;
        subtitle = description;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:coordinate.latitude forKey:@"latitude"];
    [aCoder encodeDouble:coordinate.longitude forKey:@"longitude"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:subtitle forKey:@"subtitle"];
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    double latitude = [aDecoder decodeDoubleForKey:@"latitude"];
    double longitude = [aDecoder decodeDoubleForKey:@"longitude"];
    NSString *title1 = [aDecoder decodeObjectForKey:@"title"];
    NSString *subtitle1 = [aDecoder decodeObjectForKey:@"subtitle"];
    return [self initWithCoordinates:CLLocationCoordinate2DMake(latitude, longitude) placeName:title1 description:subtitle1];
}


@end
