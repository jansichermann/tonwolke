#import "StreamTableViewController.h"
#import "TWSCApi.h"
#import "TrackTableViewCell.h"
#import "JSTableViewRowModel.h"
#import "JSTableViewSectionModel.h"
#import "Track.h"
#import "UIBarButtonItem+JSButton.h"
#import "JSAlertView.h"
#import "AppDelegate.h"
#import "UIFont+TWSC.h"


@interface StreamTableViewController ()

@end



@implementation StreamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.leftBarButtonItem = [self.class _logoutBarButtonItem];
    
    [self refreshWithCursor:nil];

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

- (void)reloadWithTracks:(NSArray *)tracks {
    [self resetSections];
    
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:tracks.count];
    
    for (Track *track in tracks) {
        [rows addObject:[self.class _rowModelForTrack:track]];
    }
    
    [self addSection:[JSTableViewSectionModel sectionWithRows:rows.copy]];
    
    [self.tableView reloadData];
}

+ (JSTableViewRowModel *)_rowModelForTrack:(Track *)track {
    return [JSTableViewRowModel withModel:track
                                cellClass:[TrackTableViewCell class]
                          backgroundColor:[UIColor clearColor]
                           selectionStyle:UITableViewCellSelectionStyleNone
                                  onClick:^{
                                      [StreamTableViewController openTrack:track];
                                  }
            ];
}

+ (UIBarButtonItem *)_logoutBarButtonItem {
    return [UIBarButtonItem barButtonItemWithTitle:@"Logout"
                                              font:[UIFont fontWithSize:14.f]
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

+ (void)openTrack:(Track *)track {
    if (!track) {
        return;
    }
    NSURL *appUrl =
    [NSURL URLWithString:[NSString stringWithFormat:@"soundcloud://sounds/%@", track.objectId]];
    
    [[UIApplication sharedApplication] canOpenURL:appUrl] ?
    [[UIApplication sharedApplication] openURL:appUrl] :
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:track.permalinkUrl]];
}

@end