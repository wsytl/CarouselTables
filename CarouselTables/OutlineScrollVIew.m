//
//  OutlineScrollVIew.m
//  CarouselTables
//
//  Created by xnw on 2021/10/28.
//

#import "OutlineScrollVIew.h"
#import "OutLineCell.h"

@interface OutlineScrollVIew()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)NSMutableArray *tablesArray;  //在数组中的位置和在scrollview上的位置相对应

@end


@implementation OutlineScrollVIew

{
    int _total;       //总页数
    int _currentPage; //当前显示的第几页
}
/**
  contentSize可以写死，height是 n+2 个单元数
  1.先判断是否有上下页，来设置是否可以上下滑动
  2.tableview和scrollview滑动衔接处的滑动问题
 */


- (instancetype)initWithTotalPage:(int)total{  //总页数
    self = [self init];
    if (self) {
        _total = total;
        
        if (_total >= 3) {
            _tablesArray = [NSMutableArray arrayWithCapacity:3];
        }else{
            _tablesArray = [NSMutableArray arrayWithCapacity:_total];
        }
        
        [self addTableViews];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.pagingEnabled = YES;
 
    }
    return self;
}


- (void)addTableViews{
    int n = 3;
    if (_total < 3) {
        n = _total;
    }
    int i = 0;
    while (i < n) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        tableView.tag = i;
    
        if (i == 0) {
            tableView.backgroundColor = [UIColor redColor];
        }
        if (i == 1) {
            tableView.backgroundColor = [UIColor greenColor];
        }
        if (i == 2) {
            tableView.backgroundColor = [UIColor lightGrayColor];
        }
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.sectionHeaderTopPadding = 0;
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        [_tablesArray addObject:tableView];
        [self addSubview:tableView];
        
        [tableView registerClass:[OutLineCell class] forCellReuseIdentifier:@"outline"];
        
        i++;
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height*_total);
    
}


/**
 初始化之后，scrollview滑动到指定的页数
 刷新三个tableview，调整位置，根据指定页数来设置tag
 例如当前显示第一页或最后一页，则找到tag最小或者最大的tableview，设置其frame为第一页或最后一页，其他两个tableview依排开，
 然后再重新给tag赋值
 */

- (void)setContentOffsetWithPage:(int)currentPage{
    
    [self setContentOffset:CGPointMake(0, (currentPage-1)*self.frame.size.height)];
    
    [self setTablesPositionWithStartPage:currentPage];
    
}

/**
  设置偏移量后确定tableview位置
 */
- (void)setTablesPositionWithStartPage:(int)startPage{
    
    _currentPage = startPage;
    
    int n = 3;
    if (_total < 3) {
        n = _total;
    }
    
    if (startPage == 1) {
        for (int i = 0; i < n; i++) {
            UITableView *table = [_tablesArray objectAtIndex:i];
                    
            table.frame = CGRectMake(0, i*self.frame.size.height, self.frame.size.width, self.frame.size.height);
        }
    }else if (startPage == _total) {
        for (int i = 0; i < n; i++) {
            UITableView *table = [_tablesArray objectAtIndex:i];
                    
            table.frame = CGRectMake(0, self.contentOffset.y + (i-2)*self.frame.size.height, self.frame.size.width, self.frame.size.height);
        }
    }else{
        for (int i = 0; i < n; i++) {
            UITableView *table = [_tablesArray objectAtIndex:i];
                    
            table.frame = CGRectMake(0, self.contentOffset.y + (i-1)*self.frame.size.height, self.frame.size.width, self.frame.size.height);
        }
    }
        
    
}

/**
 除了第一页和最后一页，当前显示的都是中间的tableview
 调整tableview同时修改  tablesArray下边，一一对应，下次调整的时候就可以直接根据tablesArray下标判断
 找出当前显示的tableview，使其前后都有tableview
 */
- (void)resetTableviewPositionWithPage:(int)page{
        
    if (page > _currentPage) { //向上滑动翻页，显示下一页
        //向上翻页第2页不用处理
        if (page == 2 || page == _total) {
            return;
        }
        //把下标为0的元素挪到2
        [_tablesArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
        [_tablesArray exchangeObjectAtIndex:1 withObjectAtIndex:2];
        
        //移动frame，从最上边移动到最下边,即当前scrollview偏移量+fram.height*2
        UITableView * bottomTableView = [_tablesArray objectAtIndex:2];
        UITableView * midTableView = [_tablesArray objectAtIndex:1];
        
        bottomTableView.frame = CGRectMake(0, midTableView.frame.origin.y + bottomTableView.frame.size.height, bottomTableView.frame.size.width, bottomTableView.frame.size.height);
        
        [bottomTableView reloadData];
    }else if (page < _currentPage){//向下滑动翻页，显示上一页
        //向上翻页第totle-1页不用处理
        if (page == _total-1) {
            return;
        }
        //把下标为2的元素挪到0
        [_tablesArray exchangeObjectAtIndex:2 withObjectAtIndex:1];
        [_tablesArray exchangeObjectAtIndex:1 withObjectAtIndex:0];
        
        //移动frame，从最上边移动到最下边,即当前scrollview偏移量-fram.height
        UITableView * topTableView = [_tablesArray objectAtIndex:0];
        UITableView * midTableView = [_tablesArray objectAtIndex:1];
        
        topTableView.frame = CGRectMake(0, midTableView.frame.origin.y-topTableView.frame.size.height, topTableView.frame.size.width, topTableView.frame.size.height);
        [topTableView reloadData];
        
    }
    
    _currentPage = page;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int page = tableView.frame.origin.y/tableView.frame.size.height + 1;
    
    OutLineCell *cell = (OutLineCell *)[tableView dequeueReusableCellWithIdentifier:@"outline" forIndexPath:indexPath];
    cell.titleStr = [NSString stringWithFormat:@"%d-----%ld",page,(long)indexPath.row];
    return cell;
//    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  20;
}



@end
