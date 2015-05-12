//
//  VenueCell.h
//  CoffeeKit
//
//  Created by Lori Hill on 5/11/15.
//  Copyright (c) 2015 Lori Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkInLabel;

@end
