// This file contains all of the constants for the bidfresh app
#import <Foundation/Foundation.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// For the apps displaying dates format
extern NSString* const ISO_FORMAT;
extern NSString* const DATE_VIEW_FORMAT;

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

// Keys for rest responses
extern NSString *const AUCTIONS_KEY;
extern NSString *const AUCTION_ITEMS_KEY;
extern NSString *const RECORDS_KEY;
extern NSString *const NAME_KEY;
extern NSString *const ITEM_KEY;

extern NSString *const AUCTION_START_KEY;
extern NSString *const AUCTION_END_KEY;
extern NSString *const AUCTION_LOCATION_KEY;
extern NSString *const AUCTION_STATUS_KEY;

extern NSString *const AUCTION_ITEM_DESC_KEY;
extern NSString *const ID_KEY;
extern NSString *const AUCTION_ITEM_START_BID_KEY;
extern NSString *const AUCTION_ITEM_CUR_BID_KEY;
extern NSString *const AUCTION_ITEM_FEATURED_KEY;
extern NSString *const AUCTION_ITEM_IMAGE_KEY;
extern NSString *const AUCTION_ITEM_SPONSOR_KEY;
extern NSString *const AUCTION_ITEM_AUCTION_KEY;
extern NSString *const AUCTION_ITEM_STATUS_KEY;

extern NSString *const SUCCESS_KEY;

extern NSString *const BIDS_KEY;
extern NSString *const BID_ID_KEY;
extern NSString *const BID_WINNING_KEY;
extern NSString *const BID_AUCTION_NAME_KEY;
extern NSString *const BID_AMOUNT_KEY;
extern NSString *const BID_IMAGE_KEY;

// Keys for User Defaults
extern NSString *const USER_ID_KEY;
extern NSString *const USER_FIRST_KEY;
extern NSString *const USER_LAST_KEY;
extern NSString *const USER_CODE_KEY;

// Amount of time for http requests to try for
extern int const TIMEOUT;
