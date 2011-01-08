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
    
    IBOutlet iGPSCustomTableViewCell *tableCell;
    
        // !!!!! ZOMBIES SU ZAPNUTE !!!!!
}

@property (nonatomic, retain) LocationProvider *locationProvider;
@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, assign) SEL altitudeUnitsSelelector;
@property (nonatomic, assign) SEL speedUnitsSelector;
@property (nonatomic, assign) SEL headingSelector;


- (void)setupSpeedUnitsSelectorByDefaults;
- (void)setupAltitudeUnitsSelelectorByDefaults;
- (void)setupHeadingSelectorByDefaults;


- (IBAction)showSettings:(id)sender;

@end
