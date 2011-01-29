//
//  iGPSTimer.h
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import <Foundation/Foundation.h>

//  trieda sluzi ako casovac na meranie casu od poslednej
//  aktualizacie LocationProvidera
@interface iGPSTimer : NSObject {

}

//  urcuje pozadovany interval aktualizacie
@property (nonatomic, retain) NSTimer *scheduler;

//  cas od spustenia casomiery  
@property (assign) NSTimeInterval startInterval;

//  cas od zastavenia casomiery
@property (assign) NSTimeInterval stopInterval;

//  Metoda zacne merat cas a nastavi instanciu na posielanie 
//  sprav s menon “elapsedTime” a objektom NSNumber reprezentujucim 
//  cas od volania tejto metody. 
- (void)start;

@end
