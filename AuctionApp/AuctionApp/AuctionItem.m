#import "AuctionItem.h"

@implementation AuctionItem

@synthesize currentBid = _currentBid;

-(NSNumber *)currentBid {
    // If there is no current bid or it's less than the minimum bid return the minimum bid
    if (_currentBid == nil || [self.minBid doubleValue] > [_currentBid doubleValue]) {
        return self.minBid;
    } else {
        return _currentBid;
    }
}

@end
