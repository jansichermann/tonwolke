#import "StreamTableViewController.h"
#import "TWSCApi.h"
#import "TrackTableViewCell.h"
#import "JSTableViewRowModel.h"
#import "JSTableViewSectionModel.h"
#import "Track.h"
#import "UIBarButtonItem+JSButton.h"
#import "JSAlertView.h"
#import "AppDelegate.h"

@interface StreamTableViewController ()

@end



@implementation StreamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshWithCursor:nil];
    
    self.
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem barButtonItemWithTitle:@"Logout"
                                       font:[UIFont systemFontOfSize:14.f]
                                 clickBlock:
     ^{
         [[JSAlertView withTitle:@"Logout?"
                         message:@"Really want to log out?"
          jsAlertViewButtonItems:
           @[
             [JSAlertViewButtonItem withTitle:@"Yes"
                                 onClickBlock:^{
                                     [(AppDelegate *)[UIApplication sharedApplication].delegate logoutWithMessage:nil];
                                 }],
             [JSAlertViewButtonItem withTitle:@"No"
                                 onClickBlock:nil],
             ]
           ] show];
     }];
}

- (void)refreshWithCursor:(NSString *)cursor {
    
    __weak StreamTableViewController *weakSelf = self;
    
    [TWSCApi meActivitiesWithCursor:cursor
                  completionHandler:^(NSArray *objects,
                                      NSError *error) {
                      StreamTableViewController *strongSelf = weakSelf;
                      [strongSelf reloadWithTracks:objects];
                  }];
}

+ (JSTableViewRowModel *)_rowModelForTrack:(Track *)track {
    return [JSTableViewRowModel withModel:track
                         cellClass:[TrackTableViewCell class]
                           onClick:^{
                               [StreamTableViewController openTrack:track];
                           }];
}

- (void)reloadWithTracks:(NSArray *)tracks {
    [self resetSections];
    
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:tracks.count];
    
    for (Track *track in tracks) {
        [rows addObject:[self.class _rowModelForTrack:track]];
    }
    
    [self addSection:[JSTableViewSectionModel sectionWithRows:rows.copy]];
    
    [self.tableView reloadData];
}

+ (void)openTrack:(Track *)track {
    
}

@end