//
//  PDViewController.m
//  PathDrawer
//
//  Created by Robby Cohen on 10/3/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import "PDViewController.h"
#import "MapPin.h"
#import "Polyline.h"
@interface PDViewController ()
{
    int oneTime;
    PDSegment kCurrentSegment;
    UITextField *titleField;
    //    MKPinAnnotationView *lastView;
    NSMutableArray *choicePoints;
    NSMutableArray *paths;
    UISegmentedControl *control;
    NSMutableArray *currentPath;
}
@end

@implementation PDViewController
@synthesize mkView = _mkView;

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if(userLocation.location.horizontalAccuracy > 80.0 || userLocation.location.verticalAccuracy > 80.0){
        return;
    }
    if (oneTime == 0){
        oneTime = 1;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_mkView.userLocation.location.coordinate, 5, 5);
        MKCoordinateRegion adjustedRegion = [_mkView regionThatFits:viewRegion];
        [_mkView setRegion:adjustedRegion animated:YES];
        _mkView.showsUserLocation = NO;
    }
    
}



- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay
{
    if([overlay isKindOfClass:[Polyline class]]){
        MKPolylineView *view;
        view = [[MKPolylineView alloc] initWithPolyline:overlay];
        view.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:.5f];
        view.strokeColor = [UIColor redColor];
        view.lineWidth = 20;
        return view;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    lastView = nil;
    oneTime = 0;
    kCurrentSegment = kChoicePoint;
    _mkView.showsUserLocation = YES;
    [_mkView setMapType:MKMapTypeHybrid];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTouch:)];
    [gesture setAllowableMovement:0];
    [_mkView addGestureRecognizer:gesture];
    
    control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Choice Points",@"Path Connector", nil]];
    [control setSelectedSegmentIndex:kCurrentSegment];
    [control addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:control];
    [self.navigationItem setRightBarButtonItem:item];
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    titleField.backgroundColor = [UIColor blackColor];
    titleField.textColor = [UIColor whiteColor];
    titleField.placeholder = @"Title of Point";
    titleField.borderStyle = UITextBorderStyleRoundedRect;
    titleField.font = [UIFont boldSystemFontOfSize:28];
    UIBarButtonItem *textfield = [[UIBarButtonItem alloc] initWithCustomView:titleField];
    
    UIButton *deleteLastPin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteLastPin.titleLabel.text = @"Delete Last Pin";
    deleteLastPin.titleLabel.textColor = [UIColor blackColor];
    [deleteLastPin setFrame:CGRectMake(0, 0, 100, 30)];
    [deleteLastPin addTarget:self action:@selector(deleteLast) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithCustomView:deleteLastPin];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:textfield,delete,nil]];
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Choice"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    //    return;
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"Choice"]){
        choicePoints = [NSMutableArray array];
    } else {
        choicePoints = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"Choice"]];
        for (MapPin *pin in choicePoints) {
            MKPinAnnotationView *pinLocation = [[MKPinAnnotationView alloc] initWithAnnotation:pin reuseIdentifier:@"identifier"];
            [pinLocation setAnimatesDrop:YES];
            //        [pinLocation setCanShowCallout:NO];
            [pinLocation setDraggable:NO];
            [pinLocation setPinColor:MKPinAnnotationColorRed];
            [_mkView addAnnotation:pinLocation.annotation];
        }
    }
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"Paths"]){
        paths = [NSMutableArray array];
    } else {
        paths = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"Paths"]];
        [_mkView addOverlays:paths];
    }
    currentPath = [NSMutableArray new];
}

-(void)deleteLast {
    if(choicePoints.count > 0){
        [_mkView removeAnnotation:((MapPin*)[choicePoints lastObject])];
        NSLog(@"b4 = %i",[choicePoints count]);
        [choicePoints removeLastObject];
        NSLog(@"afR = %i", [choicePoints count]);
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:choicePoints] forKey:@"Choice"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        //        lastView = nil;
    }
}

-(void)segmentedControlChange:(UISegmentedControl *)_control{
    kCurrentSegment = _control.selectedSegmentIndex;
}

-(void)handleLongTouch:(UIGestureRecognizer *)gest {
    
    switch (control.selectedSegmentIndex) {
        case kChoicePoint:
            [self choicePointActions:gest];
            break;
            
        case kPathConnector:
            [self pathConnectorActions:gest];
            break;
        default:
            break;
    }
    
    
    
}

-(void)pathConnectorActions:(UIGestureRecognizer*)gest{
    /*  DEBUGGING STATE
    NSLog(@"state: %i",gest.state);
    CGPoint location = [gest locationInView:_mkView];
    CLLocationCoordinate2D coord= [_mkView convertPoint:location toCoordinateFromView:_mkView];
    NSLog(@"<%f, %f>",coord.latitude,coord.longitude);
     */
    NSLog(@"%@",[NSDate date]);
    CGPoint location = [gest locationInView:_mkView];
    CLLocationCoordinate2D coord= [_mkView convertPoint:location toCoordinateFromView:_mkView];
    CLLocation *tempLoc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    if(gest.state == UIGestureRecognizerStateBegan){ // Path Began -- Finger down
        [currentPath addObject:tempLoc];
    } else if(gest.state == UIGestureRecognizerStateChanged){ // Path being drawn
        [currentPath addObject:tempLoc];
    } else if(gest.state == UIGestureRecognizerStateEnded){ // Path Ended -- Finger up
        [currentPath addObject:tempLoc];
        CLLocationCoordinate2D coordinates[currentPath.count];
        for (int i = 0; i < currentPath.count; i++) {
            coordinates[i] = ((CLLocation*)[currentPath objectAtIndex:i]).coordinate;
        }
//        MKPolyline *newPath = [MKPolyline polylineWithCoordinates:coordinates count:currentPath.count];
        Polyline *newPath = [[Polyline alloc] initWithCoordinates:coordinates count:currentPath.count];
        [_mkView addOverlay:newPath];
        [paths addObject:newPath];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:paths] forKey:@"Paths"];
        currentPath = [NSMutableArray new];
        // TEMP
        
    }
    
}

-(void)choicePointActions:(UIGestureRecognizer*)gest{
    if (gest.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [gest locationInView:_mkView];
        CLLocationCoordinate2D coord= [_mkView convertPoint:location toCoordinateFromView:_mkView];
        NSLog(@"<%f, %f>",coord.latitude,coord.longitude);
        MapPin *pin = [[MapPin alloc] initWithCoordinates:coord placeName:titleField.text description:[[NSString alloc] initWithFormat:@"<%f, %f>",coord.latitude,coord.longitude]];
        MKPinAnnotationView *pinLocation = [[MKPinAnnotationView alloc] initWithAnnotation:pin reuseIdentifier:@"identifier"];
        [pinLocation setAnimatesDrop:YES];
        //        [pinLocation setCanShowCallout:NO];
        [pinLocation setDraggable:NO];
        [pinLocation setPinColor:MKPinAnnotationColorRed];
        [_mkView addAnnotation:pinLocation.annotation];
        [choicePoints addObject:pin];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:choicePoints] forKey:@"Choice"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //        lastView = nil;
        //        lastView = pinLocation;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
