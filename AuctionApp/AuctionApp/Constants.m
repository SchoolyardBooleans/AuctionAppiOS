#import "Constants.h"

NSString *const REGISTER_URL = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/bidfresh/register";
NSString *const BIDDER_URL = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/bidfresh/bidders";
NSString *const LOGIN_URL = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/bidfresh/login";
NSString *const ITEM_URL = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/bidfresh/auctionitems";
NSString *const NONPROFIT_URL = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/bidfresh/nonprofits";
NSString *const AUCTION_URL = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/bidfresh/auctions";

NSString *const AUCTION_ITEMS_KEY=@"bidfresh__Auction_Items__r";
NSString *const RECORDS_KEY = @"records";
NSString *const AUCTIONS_KEY = @"auctions";
NSString *const NAME_KEY = @"Name";
NSString *const ITEM_KEY = @"item";

NSString *const AUCTION_START_KEY = @"Start_Time";
NSString *const AUCTION_END_KEY = @"End_Time";
NSString *const AUCTION_LOCATION_KEY = @"location";
NSString *const AUCTION_STATUS_KEY = @"Status";

NSString *const AUCTION_ITEM_DESC_KEY = @"bidfresh__Description__c";
NSString *const ID_KEY = @"Id";
NSString *const AUCTION_ITEM_START_BID_KEY = @"bidfresh__Starting_Bid__c";
NSString *const AUCTION_ITEM_CUR_BID_KEY = @"bidfresh__Current_Bid__c";
NSString *const AUCTION_ITEM_FEATURED_KEY = @"bidfresh__Featured__c";
NSString *const AUCTION_ITEM_IMAGE_KEY = @"bidfresh__Image_URL__c";
NSString *const AUCTION_ITEM_SPONSOR_KEY = @"bidfresh__Item_Sponsor__r";
NSString *const AUCTION_ITEM_AUCTION_KEY = @"bidfresh__Auction__r";
NSString *const AUCTION_ITEM_STATUS_KEY = @"bidfresh__Status__c";

NSString *const SUCCESS_KEY = @"success";

NSString *const BID_ID_KEY = @"ItemId";
NSString *const BID_WINNING_KEY = @"isWinning";
NSString *const BID_AUCTION_NAME_KEY = @"AuctionName";
NSString *const BID_AMOUNT_KEY = @"amount";
NSString *const BID_IMAGE_KEY = @"ImageURL";

int const BEFORE = 0;
int const IN_PROGRESS = 1;
int const COMPLETE = 2;
int const TIMEOUT = 30;
