//
//  PickNonprofitController.h
//  AuctionApp
//
//  Created by Jon Vazquez on 12/2/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickNonprofitModel.h"

@interface PickNonprofitController : UITableViewController

@property (nonatomic) PickNonprofitModel* model;
@property (nonatomic) NSArray* nonprofits;

@end
