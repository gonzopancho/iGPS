//
//  SettingsViewController.h
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsBundleReader;

//  Trieda SettingsViewController
//  Je riadiacou triedou rámca nastavení. Riadi 
//  zobrazovanie údajov získaných zo súboru Root.plist a
//  tiež zobrazenie rámca detailných nastavení. Inštancia 
//  triedy sa registruje na príjem notifikácie pri zmene 
//  užívateľských nastavení prostredníctvom mechanizmu KVO 
//  sprostredkovaného singleton inštanciou triedy NSNotificationCentre.

@interface SettingsViewController : UITableViewController {

}

// Datovy model.
@property (retain) SettingsBundleReader *reader;


@end

