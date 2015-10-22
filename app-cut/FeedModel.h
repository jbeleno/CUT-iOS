//
//  FeedModel.h
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 10/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "Mensajes.h"

@interface FeedModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) UIActivityIndicatorView * indicator;
@property (strong, nonatomic) UILabel * lblError;
@property NSInteger offset;
@property (strong, nonatomic) Mensajes * mensajes;

- (void)populateDataSource:(UITableView*)tabla inView:(UIView *) view;
-(void)clearTable:(UITableView *)tabla inView:(UIView *)view;

@end
