//
//  TableDisplayUtil.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableDisplayUtil : NSObject

//All Activity
+(UITableViewCell *)setUpTableViewCellWithArray:(NSMutableArray *)messageArray fromClass:(id)sentClass forIndexPath:(NSIndexPath *)indexPath andTableView:(UITableView *)tableView;
+(CGFloat)getHeightForRowAtIndexPath:(NSIndexPath*)indexPath arrayUsed:(NSMutableArray *)arrayUsed;

//My Activity
+(UITableViewCell *)setUpTableViewCellWithArrayMy:(NSMutableArray *)messageArray fromClass:(id)sentClass forIndexPath:(NSIndexPath *)indexPath andTableView:(UITableView *)tableView;
+(CGFloat)getHeightForRowAtIndexPathMy:(NSIndexPath*)indexPath arrayUsed:(NSMutableArray *)arrayUsed;

//Utility
+(NSString *)getDateLabel:(NSString *)dateCreated;
+(int)findHeightForString:(NSString *)message withWidth:(int)width;
+(NSString *)getStarSize:(int)starNumber :(int)likes :(int)dislikes;
+(int)findHeightForString13:(NSString *)message withWidth:(int)width;
+(NSString *)getDateLabelReply:(NSString *)dateCreated;
@end