#import "TrackTableViewCell.h"
#import "Track.h"



@implementation TrackTableViewCell

+ (CGFloat)heightForModel:(__unused Track *)track
              inTableView:(__unused UITableView *)tableView {
    return 88.f;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    
    self.configureBlock = ^(Track *track) {
        titleLabel.text = track.title;
    };
    
    self.prepareForReuseBlock = ^{
        titleLabel.text = nil;
    };
    
    return self;
}

@end
