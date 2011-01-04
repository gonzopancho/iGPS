//
//  SettingsData.h
//  iGPS
//
//  Created by Jakub Petrík on 1/1/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsData : NSObject {

}

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) NSArray *rows;
@property (nonatomic, assign) BOOL isChild;
@property (nonatomic, assign) int row;

@end
