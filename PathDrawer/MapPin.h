//
//  MapPin.h
//  VandyWalkingMaps
//
//  Created by Robby Cohen on 9/27/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

@interface MapPin : NSObject<MKAnnotation, NSCoding> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description;

@end