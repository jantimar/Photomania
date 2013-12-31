//
//  PhotographerMapViewController.h
//  Photomania
//
//  Created by Jan Timar on 10/10/13.
//  Copyright (c) 2013 Jan Timar. All rights reserved.
//

#import "MapViewController.h"

@interface PhotographerMapViewController : MapViewController

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;

-(void)reload;

@end
