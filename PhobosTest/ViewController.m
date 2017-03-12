//
//  ViewController.m
//  PhobosTest
//
//  Created by user on 11.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "ViewController.h"
#import "OSDate.h"
#import "OSServerManager.h"
#import "OSTransactionTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) NSArray<OSDate*>* dates;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) NSCache<NSString*, NSArray*>* cache;

@end

@implementation ViewController

static NSString* keyForCache = @"dates";

typedef enum {
    OSTypeCellDate=0,
    OSTypeCellTransaction=1,
} OSTypeCell;

- (void)viewDidLoad {
    
    NSLog(@"DiskCache: %@ of %@", @([[NSURLCache sharedURLCache] currentDiskUsage]), @([[NSURLCache sharedURLCache] diskCapacity]));
    NSLog(@"MemoryCache: %@ of %@", @([[NSURLCache sharedURLCache] currentMemoryUsage]), @([[NSURLCache sharedURLCache] memoryCapacity]));
    
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents: UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self initData];
}

-(void) initData {
    [[OSServerManager sharedManager] getTransactionList:^(NSArray * dates, NSInteger balance) {
        self.dates = dates;
        self.balance.text = [NSString stringWithFormat:@"Balance: %li ₽", (long)balance];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingIndicator stopAnimating];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    } onError:^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingIndicator stopAnimating];
            self.balance.text = @"Что-то пошло не так :c";
        });
    }];
}

-(void) reloadData {
    [[OSServerManager sharedManager] getRefreshedTransactionList:^(NSArray* dates, NSInteger balance) {
        self.dates = dates;
        self.balance.text = [NSString stringWithFormat:@"Balance: %li ₽", (long)balance];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingIndicator stopAnimating];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    } onError:^() {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UICollectionViewDataSource>

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dates.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dates[section].transactions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"CellDate" forIndexPath:indexPath];
        cell.textLabel.text = self.dates[indexPath.section].date;
        return cell;
    } else {
        OSTransactionTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell fillCellWithModel:self.dates[indexPath.section].transactions[indexPath.row]];
        return cell;
    }
}



@end
