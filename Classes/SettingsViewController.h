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
@property (nonatomic, retain) NSArray *defaultValues;


- (IBAction)done:(id)sender;

    //setup Methods
- (void)setupAndLoadTable;
- (void)setupTableData;
- (void)setUpDefaultValues;
- (void)setupRowsForAllSections;
- (void)setupSections;

@end


@protocol SettingsViewControllerDelegate <NSObject>
@required
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;
@end