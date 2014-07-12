#import "StreamTableViewController.h"
#import "TWSCApi.h"
#import "JSAttributedStringTableViewCell.h"
#import "JSTableViewRowModel.h"
#import "JSTableViewSectionModel.h"
#import "NSAttributedString+JS.h"
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

- (void)reloadWithTracks:(NSArray *)tracks {
    [self resetSections];
    
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:tracks.count];
    
    __weak StreamTableViewController *weakSelf = self;
    
    for (Track *track in tracks) {
        [rows addObject:
         [JSTableViewRowModel withModel:
          [JSAttributedStringTableViewCellModel withText:
           [NSAttributedString withString:track.title
                                     font:[UIFont systemFontOfSize:14.f]
                                    color:[UIColor blackColor]]]
                              cellClass:[JSAttributedStringTableViewCell class]
                                onClick:^{
                                    StreamTableViewController *strongSelf = weakSelf;
                                    [strongSelf openTrack:track];
                                }]
         ];
    }
    
    [self addSection:[JSTableViewSectionModel sectionWithRows:rows.copy]];
    
    [self.tableView reloadData];
}

- (void)openTrack:(Track *)track {
    
}

@end