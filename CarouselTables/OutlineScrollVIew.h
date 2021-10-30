//
//  OutlineScrollVIew.h
//  CarouselTables
//
//  Created by xnw on 2021/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OutlineScrollVIew : UIScrollView


@property(nonatomic,assign) NSArray *dataSource;

- (instancetype)initWithTotalPage:(int)total;
- (void)setContentOffsetWithPage:(int)currentPage;
- (void)resetTableviewPositionWithPage:(int)page;

@end

NS_ASSUME_NONNULL_END
