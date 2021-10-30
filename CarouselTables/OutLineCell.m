//
//  OutLineCell.m
//  CarouselTables
//
//  Created by 杨天礼 on 2021/10/29.
//

#import "OutLineCell.h"

@interface OutLineCell()

@property (nonatomic,copy) UILabel *theLabel;

@end


@implementation OutLineCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView addSubview:self.theLabel];
    }
    return self;
}


- (void)setTitleStr:(NSString *)titleStr{
    self.theLabel.text = titleStr;
    
    [self setNeedsLayout];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.theLabel sizeToFit];
    self.theLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UILabel *)theLabel{
    if (!_theLabel) {
        _theLabel = [[UILabel alloc] init];
        _theLabel.textColor = [UIColor redColor];
        _theLabel.font = [UIFont systemFontOfSize:15];
    }
    return _theLabel;
}

@end
