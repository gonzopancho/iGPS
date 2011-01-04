//
//  SettingsViewController.h
//  iGPS
//
//  Created by Jakub Petrík on 12/30/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate;


@interface SettingsViewController : UITableViewController {


}

@property (nonatomic, assign) id <SettingsViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, retain) NSArray *rowsForAllSections;
@property (nonatomic, retain) NSArray *sections;


- (IBAction)done:(id)sender;

@end


@protocol SettingsViewControllerDelegate <NSObject>
@required
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;
@end