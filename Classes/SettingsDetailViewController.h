//
//  SettingsDetailViewController.h
//  iGPS
//
//  Created by Jakub Petrík on 12/31/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsDetailViewController : UITableViewController {

}

@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, retain) NSString *keyForData;
@property (nonatomic, retain) NSNumber *selectedRow;

@end
