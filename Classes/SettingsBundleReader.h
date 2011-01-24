//
//  SettingsBundleReader.h
//  iGPS
//
//  Created by Jakub Petrík on 1/24/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsBundleReader : NSObject {

}
@property (retain) NSArray *rows;
@property (retain) NSArray *sections;
@property (retain) NSArray *defaultValues;

- (void)setup;
- (void)loadRowsAndSections;
- (void)loadDefaultValues;


@end
