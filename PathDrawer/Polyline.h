//
//  Polyline.h
//  PathDrawer
//
//  Created by Robby Cohen on 10/23/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface Polyline : MKPolyline <NSCoding>

-(id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;
-(id)initWithArray:(NSArray*)array count:(NSInteger)count;

@property (nonatomic, readonly) NSArray* coordinates;
@property (nonatomic, readonly) NSInteger count;
@end
