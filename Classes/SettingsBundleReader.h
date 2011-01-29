//
//  SettingsBundleReader.h
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import <Foundation/Foundation.h>

//  Je datovym modelom triedy SVC. 
//  Nacitava a sprostredkuje data ziskane zo suboroveho
//  balika Settings.bundle.

@interface SettingsBundleReader : NSObject {

}

//  reprezenteje data pre riadky tabulky
@property (retain) NSArray *rows;

//  reprezentuje data pre sekcie tabulky
@property (retain) NSArray *sections;

//  reprezentuje hodnoty z NSUserDefaults pre detail text
//  tabulky.
@property (retain) NSArray *defaultValues;


//  Volitelny konstruktor, ktory inicializuje instanciu a 
//  nacita potrebne data zo suboru Root.plist.
- (id)initAndSetup;

//  Metody nacitaju potrebne data zo suboru Root.plist a 
//  priradia ich atributom instancie.
- (void)setup;
- (void)loadRowsAndSections;
- (void)loadDefaultValues;

//  Metoda vrati slovnikovy kontajner pre predany objekt 
//  triedy NSIndexPath, ktora reprezentuje specificky uzol v viacrozmernych poliach
- (NSDictionary *)dataForIndexPath:(NSIndexPath *)indexPath;



@end
