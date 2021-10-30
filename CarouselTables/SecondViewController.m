//
//  SecondViewController.m
//  CarouselTables
//
//  Created by xnw on 2021/10/28.
//

#import "SecondViewController.h"
#import "OutlineScrollVIew.h"

@interface SecondViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)OutlineScrollVIew *scrollView;

@end

@implementation SecondViewController

{
    int _currentPage;
}

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setRightItemButton];
    
    [self.view addSubview:self.scrollView];
}


- (void)setRightItemButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"哒哒哒" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    button.frame = CGRectMake(0, 0, 35, 35);
    [button addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)rightItemAction{
    
    [self.scrollView setContentOffsetWithPage:5];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, self.view.safeAreaInsets.top, SCREEN_WIDTH, SCREEN_HEIGHT-self.view.safeAreaInsets.top-self.view.safeAreaInsets.bottom);
        
}



/**
 1.翻页动作结束，计算当前显示第几页，和是否还能上下翻页，调整tableview位置（1，-1页除外）(-1:倒数第一页)
 2. 要保持当前显示页上下始终都有待显示页（1,-1页除外）
 3.初始化后刷新三个tableview，之后每翻页一次，刷新一个滑动方向上将要显示的tableview
 */

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = scrollView.contentOffset.y/scrollView.frame.size.height + 1;
    _currentPage = page;
    
    //初始化的时候设置的总页数是8
    if (page == 1 || page == 8) {
        return;
    }
   
    [_scrollView resetTableviewPositionWithPage:page];
}


-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[OutlineScrollVIew alloc] initWithTotalPage:5];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor systemGray5Color];
    }
    return _scrollView;
}


@end
