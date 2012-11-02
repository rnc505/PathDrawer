//
//  PolylineArray.m
//  PathDrawer
//
//  Created by Robby Cohen on 11/1/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import "PolylineArray.h"

@implementation PolylineArray
@synthesize startPoint = _startPoint, endPoint = _endPoint, points = _points;
-(id)initWithStart:(NSString *)start end:(NSString *)end andPointsArray:(NSArray *)points {
    self = [super init];
    if(self){
        _startPoint = start;
        _endPoint = end;
        _points = points;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithStart:[aDecoder decodeObjectForKey:@"start"] end:[aDecoder decodeObjectForKey:@"end"] andPointsArray:[aDecoder decodeObjectForKey:@"points"]];
}
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_points forKey:@"points"];
    [aCoder encodeObject:_startPoint forKey:@"start"];
    [aCoder encodeObject:_endPoint forKey:@"end"];
    
}
@end
