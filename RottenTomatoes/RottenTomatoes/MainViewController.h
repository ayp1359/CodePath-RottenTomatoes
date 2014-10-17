//
//  MainViewController.h
//  RottenTomatoes
//
//  Created by Ali YAZDAN PANAH on 10/16/14.
//  Copyright (c) 2014 Ali YAZDAN PANAH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *moviesSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) NSMutableArray* allTableData;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (nonatomic, assign) bool isFiltered;
@end
