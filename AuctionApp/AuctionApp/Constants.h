// This file contains all of the constants for the bidfresh app
#import <Foundation/Foundation.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// URLs for http requests
extern NSString* const REGISTER_URL;
extern NSString* const BIDDER_URL;
extern NSString* const LOGIN_URL;
extern NSString* const ITEM_URL;
extern NSString* const NONPROFIT_URL;
extern NSString* const AUCTION_URL;

// Auction Statuses
extern int const BEFORE;
extern int const IN_PROGRESS;
extern int const COMPLETE;

// Amount of time for http requests to try for
extern int const TIMEOUT;
