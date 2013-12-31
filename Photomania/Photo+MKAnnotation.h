//
//  Photo+MKAnnotation.h
//  Photomania
//
//  Created by Jan Timar on 10/10/13.
//  Copyright (c) 2013 Jan Timar. All rights reserved.
//

#import "Photo.h"
#import <MapKit/MapKit.h>

@interface Photo (MKAnnotation) <MKAnnotation>

-(UIImage *)thumbnail;

@end
