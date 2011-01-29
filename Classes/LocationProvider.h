//
//  LocationProvider.h
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 11/23/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//  Protokol LocationProviderDelegate
//  Protokol informuje svojho delegata (triedu implementujucu protokol) o
//  zmenach v ziskanej polohe, zemepisnej sirke a vyske, rychlosti, smeru,
//  vertikalnej a horizontalnej presnosti, kurze a nadmorskej vyske prostrednictvom
//  nasledujucich sprav. Jedinou nevyhnutnou metodou pre implementovanie 
//  protokolu je sprava LocationProviderDidUpdateLocation.
@protocol LocationProviderDelegate <NSObject>

- (void)locationProviderDidUpdateLocation;
	
@optional
- (void)locationProviderDidUpdateLatitude;
- (void)locationProviderDidUpdateLongitude;
- (void)locationProviderDidUpdateAltitude;
- (void)locationProviderDidUpdateSpeed;
- (void)locationProviderDidUpdateCourse;
- (void)locationProviderDidUpdateHeading;
- (void)locationProviderDidUpdateHorizontalAccuracy;
- (void)locationProviderDidUpdateVerticalAccuracy;
@end

@interface LocationProvider : NSObject <CLLocationManagerDelegate>  {

}
//  atribut delegata protokolu LocationProviderDelegate.
@property (nonatomic, retain) id <LocationProviderDelegate> delegate;


//  Konstruktor triedy. Inicializuje instanciu.
- (id)init;

//  Metoda nastavi location managera.
- (void)setupLocationManager;

//  Metody spustaju / zastavuju aktualizaciu polohy a smeru
- (void)startUpdatingLocationAndHeading;
- (void)stopUpdatingLocationAndHeading;
- (void)startUpdatingHeading;
- (void)stopUpdatingHeading;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;


//  Metoda nastavuje pozadovanu presnost. 
//  Argumentom je nova presnost vseobecneho typu id.
- (void)setAccuracy:(id)newAccuracy;

//  Metoda nastavuje pozadovanu hodnotu filtra vzdialenosti. 
//  Argumentom je nova hodnota filtra vseobecneho typu id.
- (void)setDistanceFilter:(id)newFilter;

//  Metoda nastavuje sukromny atribut userDefaultsValue, co je slovnikovy kontajner, 
//  kluc je meno notifikacie a objektom je objekt notifikacie. 
//  Argumentom je potom objekt triedy NSNotification
- (void)updateDefaults:(NSNotification *)aNotification;

//  Metoda konvertuje zemepisnu sirku predanu ako argument typu float
//  na objektovy retazec formatu DMS a pridava zempisnu stranu.
- (NSString *)convertLatitudeToDMS:(float)latitude;

//  Metoda vracia zemepisnu sirku v stupnoch v podobe objektoveho retazca.
- (NSString *)latitudeInDegDec;

//  Metoda vracia zempisnu sirku ziskanu od metody convertLatitudeToDMS:.
- (NSString *)latitudeInDMS;

//  Metoda vracia zemepisnu sirku v podobe objektoveho retazca v zavislosti 
//  od uzivatelskych nastaveni.
- (NSString *)latitudeByUserDefaults;

//  Metody obdobne metodam pre zemepisnu sirku, s tym rozdielom ze vracaju 
//  zemepisnu vysku.
- (NSString *)convertLongitudeToDMS:(float)longitude;
- (NSString *)longitudeInDegDec;
- (NSString *)longitudeInDMS;
- (NSString *)longitudeByUserDefaults;

//  Metoda vracia nadmorsku vysku v metroch v podobe objektoveho retazca.
- (NSString *)altitudeInMetres;

//  Metoda vracia nadmorsku vysku v kilometroch v podobe objektoveho retazca.
- (NSString *)altitudeInKilometres;

//  Metoda vracia nadmorsku vysku v stopach v podobe objektoveho retazca.
- (NSString *)altitudeInFeet;

//  Metoda vracia nadmorsku vysku v milach v podobe objektoveho retazca.
- (NSString *)altitudeInMiles;

//  Metoda vracia nadmorsku vysku v podobe objektoveho retazca v zavislosti 
//  od uzivatelskych nastaveni.
- (NSString *)altitudeByUserDefaults;

//  Metoda vracia rychlost v kilometroch za hodinu v podobe objektoveho retazca.
- (NSString *)speedInKilometersPerHour;

//  Metoda vracia rychlost v metroch za sekundu v podobe objektoveho retazca.
- (NSString *)speedInMetresPerSecond;

//  Metoda vracia rychlost v milach za hodinu v podobe objektoveho retazca.
- (NSString *)speedInMilesPerHour;

//  Metoda vracia rychlost v uzloch v podobe objektoveho retazca.
- (NSString *)speedInKnots;

//  Metoda vracia rychlost v stopach za sekundu v podobe objektoveho retazca.
- (NSString *)speedInFeetPerSecond;

//  Metoda vracia rychlost v podobe objektoveho retazca v zavislosti od 
//  uzivatelskych nastaveni.
- (NSString *)speedByUserDefaults;

//  Metoda vracia smer podla magnetickeho severu v podobe objektoveho retazca.
- (NSString *)magneticHeading;

//  Metoda vracia smer podla geografickeho severu v podobe objektoveho retazca.
- (NSString *)trueHeading;

//  Metoda vracia smer v zavislosti od uzivatelskych nastaveni.
- (NSString *)headingByUserDefaults;

//  Metoda vracia kurz v stupnoch v podobe objektoveho retazca.
- (NSString *)courseInDegrees;

//  Metoda vracia kurz v stupnoch spolu s zemepisnou stranou v podobe objektoveho retazca.
- (NSString *)courseMixed;

//  Metoda vracia kurz v podobe objektoveho retazca v zavislosti od uzivatelskych nastaveni.
- (NSString *)courseByUserDefaults;

//  Metody obdobne metodam pre nadmorsku vysku, s tym rozdielom ze vracaju 
//  vertikalnu presnost zamerania.
- (NSString *)verticalAccuracyInMeters;
- (NSString *)verticalAccuracyInKilometres;
- (NSString *)verticalAccuracyInFeet;
- (NSString *)verticalAccuracyInMiles;
- (NSString *)veritcalAccuracyByUserDefaults;

//  Metody obdobne metodam pre nadmorsku vysku, s tym rozdielom ze vracaju
//  horizontalnu presnost zamerania.
- (NSString *)horizontalAccuracyInMeters;
- (NSString *)horizontalAccuracyInKilometres;
- (NSString *)horizontalAccuracyInFeet;
- (NSString *)horizontalAccuracyInMiles;
- (NSString *)horizontalAccuracyByUserDefaults;

@end


