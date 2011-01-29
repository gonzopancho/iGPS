//
//  RootViewController.h
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationProvider.h"

//  Trieda RootViewController
//  Je riadiacou triedou hlavného rámca. Posiela informácie získané od 
//  atribútu locationProvider typu LP za pomoci správ protokolu 
//  LocationProviderDelegate hlavnému rámcu, teda UITableView. Vytvára 
//  tabuľku rámca. Registruje sa na prímanie správ z inštancie triedy 
//  iGPSTimer. Jej dátovými modelmi okrem spomínaného locationProvider-ra 
//  sú aj dve polia (values, names), ktoré slúžia ako prvotný dátový zdroj 
//  tabuľky rámca. Pomocou akcie changeLanguage: prepína jazyk aplikácie.


@interface RootViewController : UITableViewController <LocationProviderDelegate> {
    
}

//  Datove modely.
@property (nonatomic, retain) LocationProvider *locationProvider;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSArray *names;

@end
