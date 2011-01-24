//
//  SettingsViewController.h
//  iGPS
//
//  Created by Jakub Petrík on 12/30/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate;

@class SettingsBundleReader;

@interface SettingsViewController : UITableViewController {


}
    //@property (nonatomic, retain) IBOutlet UINavigationController *nc;
@property (nonatomic, assign) id <SettingsViewControllerDelegate> delegate;
@property (retain) SettingsBundleReader *reader;

    //- (id)initWithCoder:(NSCoder *)coder;
- (IBAction)done:(id)sender;

    //setup Methods
    //- (void)performSetupOnBackgroundThread;
    //- (void)setupData;
    //- (void)setupTableData;
    //- (void)setUpDefaultValues;
    //- (void)setupRowsForAllSections;
    //- (void)setupSections;

@end


@protocol SettingsViewControllerDelegate <NSObject>
@required
- (void)settingsViewControllerDidFinish;
@end