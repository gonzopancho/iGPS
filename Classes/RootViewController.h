//
//  RootViewController.h
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LocationProvider;

@interface RootViewController : UITableViewController <LocationProviderDelegate,SettingsViewControllerDelegate> {
    
}
@property (nonatomic, retain) LocationProvider *locationProvider;
@property (retain) NSMutableArray *values;
@property (retain) NSArray *names;

@end
