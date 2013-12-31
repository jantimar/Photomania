//
//  MapViewController.m
//  Photomania
//
//  Created by Jan Timar on 10/10/13.
//  Copyright (c) 2013 Jan Timar. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (nonatomic) BOOL needUpdateRegion;

@end

@implementation MapViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.needUpdateRegion = YES;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseId = @"MapViewController";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    
    if(!view){
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        view.canShowCallout = YES;
        // prida button iba ak maview ma implementovanu funkciu calloutAccessoryControlTapped
        if([mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]){
            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    
    if([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]){
        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        imageView.image = nil;
    }
    
    return view;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]){
        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        if([view.annotation respondsToSelector:@selector(thumbnail)]){
            imageView.image = [view.annotation performSelector:@selector(thumbnail)];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.needUpdateRegion) [self updateRegion];
}

- (void)updateRegion
{
    self.needUpdateRegion = NO;
    CGRect boundingRect;
    BOOL started = NO;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        CGRect annotationRect = CGRectMake(annotation.coordinate.latitude, annotation.coordinate.longitude, 0, 0);
        if (!started) {
            started = YES;
            boundingRect = annotationRect;
        } else {
            boundingRect = CGRectUnion(boundingRect, annotationRect);
        }
    }
    if (started) {
        boundingRect = CGRectInset(boundingRect, -0.2, -0.2);
        if ((boundingRect.size.width < 20) && (boundingRect.size.height < 20)) {
            MKCoordinateRegion region;
            region.center.latitude = boundingRect.origin.x + boundingRect.size.width / 2;
            region.center.longitude = boundingRect.origin.y + boundingRect.size.height / 2;
            region.span.latitudeDelta = boundingRect.size.width;
            region.span.longitudeDelta = boundingRect.size.height;
            [self.mapView setRegion:region animated:YES];
        }
    }
}

@end
