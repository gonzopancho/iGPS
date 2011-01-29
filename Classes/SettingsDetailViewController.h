//
//  SettingsDetailViewController.h
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>

//  Trieda SettingsDetailViewController
//  Je riadiacou triedou tretieho rámca zobrazujúceho konkrétnu
//  ponuku nastavení pre danú položku. Inštancia tejto triedy sa 
//  registruje na príjem správ týkajýcich sa zmeny v užívateľských
//  nastaveniach. Zároveň posiela správy, ktorých meno je kľúčová
//  položka vo svojom dátovom modeli – slovníkového kontajnera a
//  objektom je novo zvolená hodnota. 
@interface SettingsDetailViewController : UITableViewController {

}
// Datove modely.
@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, retain) NSString *keyForData;
@property (nonatomic, retain) NSNumber *selectedRow;

@end
