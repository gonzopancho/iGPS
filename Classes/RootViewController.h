//
//  RootViewController.h
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationProvider.h"
#import "SettingsViewController.h"
#import "iGPSCustomTableViewCell.h"


@interface RootViewController : UITableViewController <LocationProviderDelegate,SettingsViewControllerDelegate> {
    
}
@property (nonatomic, retain) UINavigationController *nc;
@property (nonatomic, retain) LocationProvider *locationProvider;
@property (retain) NSMutableArray *values;
@property (retain) NSArray *names;


- (void)setStringValue:(NSString *)value atIndex:(NSIndexPath *)index;
- (IBAction)showSettings:(id)sender;

@end
