//
//  PolylineArray.h
//  PathDrawer
//
//  Created by Robby Cohen on 11/1/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PolylineArray : NSObject <NSCoding>
@property (nonatomic, retain) NSString *startPoint;
@property (nonatomic, retain) NSString *endPoint;
@property (nonatomic, retain) NSArray *points;
-(id)initWithStart:(NSString*)start end:(NSString*)end andPointsArray:(NSArray*)points;
@end
