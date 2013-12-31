//
//  PhotographerMapViewController.m
//  Photomania
//
//  Created by Jan Timar on 10/10/13.
//  Copyright (c) 2013 Jan Timar. All rights reserved.
//

#import "PhotographerMapViewController.h"
#import <CoreData/CoreData.h>
#import "Photographer+MKAnnotation.h"

@interface PhotographerMapViewController ()

@end

@implementation PhotographerMapViewController

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if(self.view.window) [self reload];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

-(void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = [NSPredicate predicateWithFormat:@"photos.@count > 2"];
    NSError *error;
    NSArray *photographers = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(error) NSLog(@"error %@",[error localizedDescription]);
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:photographers]; 
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setPhotographer:" sender:view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"setPhotographer:"]){
        if([sender isKindOfClass:[MKAnnotationView class]]){
            MKAnnotationView *annotationView = (MKAnnotationView *)sender;
            if([annotationView.annotation isKindOfClass:[Photographer class]]){
                Photographer *photographer = (Photographer *)annotationView.annotation;
                if([segue.destinationViewController respondsToSelector:@selector(setPhotographer:)]){
                    [segue.destinationViewController performSelector:@selector(setPhotographer:) withObject:photographer];
                }
            }
        }
    }
}

@end
