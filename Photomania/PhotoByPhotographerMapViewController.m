//
//  PhotoByPhotographerMapViewController.m
//  Photomania
//
//  Created by Jan Timar on 10/10/13.
//  Copyright (c) 2013 Jan Timar. All rights reserved.
//

#import "PhotoByPhotographerMapViewController.h"
#import "Photo+MKAnnotation.h"

@interface PhotoByPhotographerMapViewController ()

@end

@implementation PhotoByPhotographerMapViewController

- (void)setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    if(self.view.window) [self reload];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setPhoto:" sender:view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"setPhoto:"]){
        if([sender isKindOfClass:[MKAnnotationView class]]){
            MKAnnotationView *annotationView = (MKAnnotationView *)sender;
            if([annotationView.annotation isKindOfClass:[Photo class]]){
                Photo *photo = (Photo *)annotationView.annotation;
                if([segue.destinationViewController respondsToSelector:@selector(setPhoto:)]){
                    [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:photo];
                }
            }
        }
    }
}

-(void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@",self.photographer];
    NSError *error;
    NSArray *photos = [self.photographer.managedObjectContext executeFetchRequest:request error:&error];
    if(error) NSLog(@"error %@",[error localizedDescription]);
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:photos];
    
    Photo *photo = [photos lastObject];
    if(photo) self.mapView.centerCoordinate = [photo coordinate];
}

@end
