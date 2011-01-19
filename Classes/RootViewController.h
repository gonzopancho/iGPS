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
        //dorobit nastavenia h a v accuracy
        //inicializacia selektorov h a v accuracy
        //upravit nacitavanie dat do tabulky
        //spravit selectory privatne!
}

@property (nonatomic, retain) LocationProvider *locationProvider;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSArray *names;


- (void)setStringValue:(NSString *)value atIndex:(NSIndexPath *)index;
- (void)setupSpeedUnitsSelectorByDefaults;
- (void)setupAltitudeUnitsSelelectorByDefaults;
- (void)setupHeadingSelectorByDefaults;
- (void)setupCourseSelectorByDefaults;


- (IBAction)showSettings:(id)sender;

@end
