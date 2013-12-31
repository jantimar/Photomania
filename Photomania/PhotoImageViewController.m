//
//  PhotoImageViewController.m
//  Photomania
//
//  Created by Jan Timar on 10/11/13.
//  Copyright (c) 2013 Jan Timar. All rights reserved.
//

#import "PhotoImageViewController.h"
#import "MapViewController.h"
#import "Photo+MKAnnotation.h"

@interface PhotoImageViewController ()

@property(nonatomic,strong) MapViewController *mapViewController;

@end

@implementation PhotoImageViewController

-(void)setPhoto:(Photo *)photo
{
    _photo = photo;
    self.title = photo.title;
    self.imageURL = [NSURL URLWithString:photo.imageURL];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapViewController.mapView addAnnotation:self.photo];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Embed map of Photo"]){
        if([segue.destinationViewController isKindOfClass:[MapViewController class]]){
            self.mapViewController = (MapViewController *)segue.destinationViewController;
        }
    }
}

@end
