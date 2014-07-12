#import "StreamTableViewController.h"
#import "TWSCApi.h"
#import "JSAttributedStringTableViewCell.h"
#import "JSTableViewRowModel.h"
#import "JSTableViewSectionModel.h"
#import "NSAttributedString+JS.h"




@interface StreamTableViewController ()

@end



@implementation StreamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    __weak StreamTableViewController *weakSelf = self;
    
    for (NSDictionary *track in tracks) {
        [rows addObject:
         [JSTableViewRowModel withModel:
          [JSAttributedStringTableViewCellModel withText:
           [NSAttributedString withString:track[@"origin"][@"title"]
                                     font:[UIFont systemFontOfSize:14.f]
                                    color:[UIColor blackColor]]]
                              cellClass:[JSAttributedStringTableViewCell class]
                                onClick:^{
                                    StreamTableViewController *strongSelf = weakSelf;
                                    [strongSelf openSound];
                                }]
         ];
    }
    
    [self addSection:[JSTableViewSectionModel sectionWithRows:rows.copy]];
    
    [self.tableView reloadData];
}

- (void)openSound {
    
}

@end