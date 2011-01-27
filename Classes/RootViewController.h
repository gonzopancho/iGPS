//
//  RootViewController.h
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationProvider.h"


@interface RootViewController : UITableViewController <LocationProviderDelegate> {
    
}
@property (nonatomic, retain) LocationProvider *locationProvider;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSArray *names;

@end
