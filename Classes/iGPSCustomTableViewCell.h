//
//  iGPSCustomTableViewCell.h
//  iGPS
//
//  Created by Jakub Petrík on 1/8/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iGPSCustomTableViewCell : UITableViewCell {
    
    IBOutlet UILabel *mainText;
    IBOutlet UILabel *detailText;

}

@property (nonatomic, retain) IBOutlet UILabel *mainText;
@property (nonatomic, retain) IBOutlet UILabel *detailText;

- (void)setMainTextLabel:(NSString *)newMainText;
- (void)setDetailTextLabel:(NSString *)newDetailText;

@end
