//
//  PDViewController.h
//  PathDrawer
//
//  Created by Robby Cohen on 10/3/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface PDViewController : UIViewController <MKMapViewDelegate>
typedef enum {
    kChoicePoint = 0,
    kPathConnector
} PDSegment;
@property (nonatomic, retain) IBOutlet MKMapView *mkView;
@end
