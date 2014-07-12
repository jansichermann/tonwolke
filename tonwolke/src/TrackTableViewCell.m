#import "TrackTableViewCell.h"
#import "Track.h"
#import "JSImageView.h"
#import "UIFont+TWSC.h"
#import "UIColor+TWSC.h"
#import "UIView+JS.h"
#import "UIColor+JS.h"
#import "NSAttributedString+JS.h"


static const CGFloat titleMarginLeft = 8.f;
static const CGFloat bottomPadding = 8.f;
static const CGFloat topPadding = 4.f;
@implementation TrackTableViewCell

+ (CGSize)_waveFormSize __attribute__((const)){
    return CGSizeMake(1800.f, 280.f);
}

+ (CGFloat)_waveFormHeightForWidth:(CGFloat)width __attribute__((const)) {
    return [TrackTableViewCell _waveFormSize].height / ([TrackTableViewCell _waveFormSize].width / width);
}

+ (CGFloat)_heightForTrackTitle:(Track *)track maxWidth:(CGFloat)width {
    return [[TrackTableViewCell _attributedTitleForTrack:track] boundingRectWithSize:
            CGSizeMake(width - titleMarginLeft,
                       CGFLOAT_MAX)
                                                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                             context:nil].size.height;
}

+ (CGFloat)heightForModel:(Track *)track
              inTableView:(UITableView *)tableView {
    return
    [self _waveFormHeightForWidth:tableView.width]
    + [self _heightForTrackTitle:track
                        maxWidth:tableView.width]
    + topPadding
    + bottomPadding;
}

+ (NSAttributedString *)_attributedTitleForTrack:(Track *)track {
    return [NSAttributedString withString:track.title
                                     font:[UIFont fontWithSize:22.f]
                                    color:[UIColor darkGrayColor]];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    self.contentView.backgroundColor = [UIColor colorWithHex:0xefefef];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.numberOfLines = 0;
    titleLabel.top = topPadding;
    titleLabel.width = self.contentView.width - titleMarginLeft;
    titleLabel.left = titleMarginLeft;
    [self.contentView addSubview:titleLabel];
    
    JSImageView *iv = [[JSImageView alloc] initWithFrame:CGRectZero];
    iv.backgroundColor = [UIColor TWSCBackgroundColor];
    iv.width = self.contentView.width;
    iv.height = [TrackTableViewCell _waveFormHeightForWidth:self.contentView.width];
    [self.contentView addSubview:iv];
    
    UIView *bottomRule = [[UIView alloc] initWithFrame:CGRectMake(0.f,
                                                                  self.contentView.height - 1.f,
                                                                  self.contentView.width,
                                                                  1.f)];
    bottomRule.backgroundColor = [UIColor lightGrayColor];
    bottomRule.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:bottomRule];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    CGFloat contentViewWidth = self.contentView.width;
    
    self.configureBlock = ^(Track *track) {
        titleLabel.attributedText = [TrackTableViewCell _attributedTitleForTrack:track];
        [iv loadImageFromUrlString:track.waveform_url
                       withSession:session];
        titleLabel.height = [TrackTableViewCell _heightForTrackTitle:track
                                                            maxWidth:contentViewWidth - titleMarginLeft];
        iv.top = titleLabel.bottom;
    };
    
    self.prepareForReuseBlock = ^{
        titleLabel.text = nil;
        [iv cancelLoad];
    };
    
    return self;
}

@end
