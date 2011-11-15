//
//  TableDisplayUtil.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TableDisplayUtil.h"
#import "FeedTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Activity.h"
#import "Base64.h"
#import "MessageThreadInbox.h"
#import "MessageThreadOutbox.h"

@implementation TableDisplayUtil

//Set up the view for each cell Everyone
+(UITableViewCell *)setUpTableViewCellWithArray:(NSMutableArray *)messageArray fromClass:(id)sentClass forIndexPath:(NSIndexPath *)indexPath andTableView:(UITableView *)tableView{
    
    NSUInteger row = [indexPath row];
        
    NSMutableArray *arrayToUse = [NSMutableArray arrayWithArray:messageArray];
    
    static NSString *customCell=@"customCell";
    
    FeedTableCell *cell = (FeedTableCell *)[tableView dequeueReusableCellWithIdentifier:customCell];
    
    
    if (cell == nil) {
        
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"FeedTableCell" owner:nil options:nil];
        
        for (id currentObject in nibObjects) {
            if ([currentObject isKindOfClass:[FeedTableCell class]]) {
                cell = (FeedTableCell *)currentObject;
            }
        }
        
    }else{
        
    }
    
    UIImageView *profileImageView = (UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:3];
    UITextView *messageText = (UITextView *)[cell.contentView viewWithTag:4];
    UILabel *teamLabel = (UILabel *)[cell.contentView viewWithTag:5];
    UIImageView *starOne = (UIImageView *)[cell.contentView viewWithTag:6];
    UIImageView *starTwo = (UIImageView *)[cell.contentView viewWithTag:7];
    UIImageView *starThree = (UIImageView *)[cell.contentView viewWithTag:8];
    UIView *imageBack = (UIView *)[cell.contentView viewWithTag:14];
    ImageButton *insideImageView = (ImageButton *)[cell.contentView viewWithTag:11];

    
    imageBack.backgroundColor = [UIColor blackColor];
    imageBack.layer.masksToBounds = YES;
    imageBack.layer.cornerRadius = 4.0;
    insideImageView.layer.masksToBounds = YES;
    insideImageView.layer.cornerRadius = 4.0;
    
    imageBack.autoresizingMask = UIViewAutoresizingNone;    
    profileImageView.autoresizingMask = UIViewAutoresizingNone;
    nameLabel.autoresizingMask = UIViewAutoresizingNone;
    dateLabel.autoresizingMask = UIViewAutoresizingNone;
    messageText.autoresizingMask = UIViewAutoresizingNone;
    insideImageView.autoresizingMask = UIViewAutoresizingNone;
    teamLabel.autoresizingMask = UIViewAutoresizingNone;
    starOne.autoresizingMask = UIViewAutoresizingNone;
    starTwo.autoresizingMask = UIViewAutoresizingNone;
    starThree.autoresizingMask = UIViewAutoresizingNone;

    
    messageText.font = [UIFont fontWithName:@"Helvetica" size:14];
    messageText.textColor = [UIColor blackColor];
    messageText.backgroundColor = [UIColor clearColor];
    
       
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    nameLabel.textColor = [UIColor blueColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    
    dateLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    
    teamLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    teamLabel.textColor = [UIColor blueColor];
    teamLabel.backgroundColor = [UIColor clearColor];
    
    if ([arrayToUse count] == 0) {
        
        profileImageView.hidden = YES;
        dateLabel.hidden = YES;
        messageText.hidden = YES;
        insideImageView.hidden = YES;
        imageBack.hidden = YES;
        teamLabel.hidden = YES;
        starTwo.hidden = YES;
        starOne.hidden = YES;
        starThree.hidden = YES;
    
        
        nameLabel.frame = CGRectMake(0, 0, 310, 35);
        nameLabel.text = @"No messages found...";
        nameLabel.textAlignment = UITextAlignmentCenter;
        
        
    }else{
        
        profileImageView.hidden = NO;
        dateLabel.hidden = NO;
        messageText.hidden = NO;
        insideImageView.hidden = NO;
        imageBack.hidden = NO;
        starOne.hidden = NO;
        starTwo.hidden = NO;
        starThree.hidden = NO;

   
        
        nameLabel.textAlignment = UITextAlignmentLeft;
        
        Activity *result = [arrayToUse objectAtIndex:row];
        
        //Profile Image
        profileImageView.frame = CGRectMake(5, 5, 40, 40);
        profileImageView.image = [UIImage imageNamed:@"profile.png"];
            
      
        
        //Like stars       
        starOne.frame = CGRectMake(260, 5, 15, 14);
        starTwo.frame = CGRectMake(280, 5, 15, 14);
        starThree.frame = CGRectMake(300, 5, 15, 14);

        NSString *starImageOne = [TableDisplayUtil getStarSize:1 :result.numLikes :result.numDislikes];
        NSString *starImageTwo = [TableDisplayUtil getStarSize:2 :result.numLikes :result.numDislikes];
        NSString *starImageThree = [TableDisplayUtil getStarSize:3 :result.numLikes :result.numDislikes];
        

        starOne.contentMode = UIViewContentModeScaleAspectFit;
        starThree.contentMode = UIViewContentModeScaleAspectFit;
        starTwo.contentMode = UIViewContentModeScaleAspectFit;

		starOne.image = [UIImage imageNamed:starImageOne];
        starTwo.image = [UIImage imageNamed:starImageTwo];
        starThree.image = [UIImage imageNamed:starImageThree];
        
        

        
        
        //Name Label
        nameLabel.frame = CGRectMake(55, 5, 210, 18);
        
        NSString *senderString = @"rTeam";
        
        if ((result.senderName != nil) && ![result.senderName isEqualToString:@""]) {
            senderString = result.senderName;
        }
      
        nameLabel.text = senderString;
        
        //Date Label
        dateLabel.frame = CGRectMake(55, 23, 100, 18);
        dateLabel.text = [TableDisplayUtil getDateLabel:result.createdDate];
        
        //Team Label
        teamLabel.frame = CGRectMake(155, 23, 250, 18);
        teamLabel.text = result.teamName;
        
        //Message Text       
        //NSString *theText = result.activityText;
        messageText.text = result.activityText;
        messageText.frame = CGRectMake(50, 42, 265, 100);
        CGRect frame = messageText.frame;
        frame.size.height = [TableDisplayUtil findHeightForString:result.activityText withWidth:messageText.frame.size.width - 15] + 15;
        messageText.frame = frame;
        int imageStart = 41 + messageText.frame.size.height;
        
 
        //Inside Image 
        NSString *tmpThumbnail = result.thumbnail;
        bool isImage = false;

        for (UIView *view in [imageBack subviews]) {
            [view removeFromSuperview];
        }
        
        for (UIView *view in [insideImageView subviews]) {
            [view removeFromSuperview];
        }
        
        //remove all targets
        [insideImageView removeTarget:nil 
                           action:NULL 
                 forControlEvents:UIControlEventAllEvents]; 
        
        if ((tmpThumbnail != nil)  && (![tmpThumbnail isEqualToString:@""])){
            isImage = true;
      
            NSData *profileData = [Base64 decode:tmpThumbnail];
            insideImageView.hidden = NO;
            insideImageView.messageId = result.activityId;
            
         
  

            if (result.isVideo) {
                [insideImageView addTarget:sentClass action:@selector(videoSelected:) forControlEvents:UIControlEventTouchUpInside];

            }else{
                [insideImageView addTarget:sentClass action:@selector(imageSelected:) forControlEvents:UIControlEventTouchUpInside];

            }
            
            imageBack.hidden = NO;
            imageBack.backgroundColor = [UIColor blackColor];
            
            
            UIImage *tmpImage = [UIImage imageWithData:profileData];
            imageBack.frame = CGRectMake(52, imageStart, 82, 82);

            UIImageView *myImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:profileData]];

            if (tmpImage.size.height > tmpImage.size.width) {
            
                imageBack.frame = CGRectMake(66, imageStart, 60, 82);
            }else{
                imageBack.frame = CGRectMake(60, imageStart + 14, 82, 60);
            }
            
            myImage.frame = CGRectMake(1, 1, imageBack.frame.size.width -2, imageBack.frame.size.height - 2);
            
            if (result.isVideo) {
                UIImageView *playButton = [[UIImageView alloc] initWithFrame:CGRectMake(myImage.frame.size.width/2 - 15, myImage.frame.size.height/2 -15, 30, 30)];
                playButton.image = [UIImage imageNamed:@"playButtonSmall.png"];
                [myImage addSubview:playButton];
            }
            
            [imageBack addSubview:myImage];
            
            imageBack.layer.masksToBounds = YES;
            imageBack.layer.cornerRadius = 4.0;
            myImage.layer.masksToBounds = YES;
            myImage.layer.cornerRadius = 4.0;
            
            
            insideImageView.frame = CGRectMake(52, imageStart, 82, 82);
            insideImageView.backgroundColor = [UIColor clearColor];
            
           
        
            
            
            [cell.contentView bringSubviewToFront:insideImageView];
   
        }else{
            insideImageView.hidden = YES;
            imageBack.hidden = YES;

        } 
        
                
    }
    
    
    return cell;
    
    
}

//Height for each cell All Activity
+(CGFloat)getHeightForRowAtIndexPath:(NSIndexPath*)indexPath arrayUsed:(NSMutableArray *)arrayUsed{
    
        
    NSUInteger row = [indexPath row];
    
    NSMutableArray *arrayToUse = [NSMutableArray arrayWithArray:arrayUsed];
    
    
    if ([arrayToUse count] > 0){
        
        Activity *result = [arrayToUse objectAtIndex:row];
        
        NSString *lengthMessage = result.activityText;
        
        int messageHeight = [TableDisplayUtil findHeightForString:lengthMessage withWidth:250];
        
   
        
        int messageTotal = messageHeight + 15;
        
        int imageHeight = 0;
        
        if ((result.thumbnail != nil) && (![result.thumbnail isEqualToString:@""])) {
            
            imageHeight = 90;
        }
     
        
        int cellHeight = (42 + messageTotal +  imageHeight);
        
        
        return cellHeight;
    }
    return 35;
    
    
}


//Set up the view for each cell My
+(UITableViewCell *)setUpTableViewCellWithArrayMy:(NSMutableArray *)messageArray fromClass:(id)sentClass forIndexPath:(NSIndexPath *)indexPath andTableView:(UITableView *)tableView{
    
    NSUInteger row = [indexPath row];
    
    NSMutableArray *arrayToUse = [NSMutableArray arrayWithArray:messageArray];
    
    static NSString *customCell=@"customCell";
    
    FeedTableCell *cell = (FeedTableCell *)[tableView dequeueReusableCellWithIdentifier:customCell];
    
    
    if (cell == nil) {
        
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"FeedTableCell" owner:nil options:nil];
        
        for (id currentObject in nibObjects) {
            if ([currentObject isKindOfClass:[FeedTableCell class]]) {
                cell = (FeedTableCell *)currentObject;
            }
        }
        
    }else{
        
    }
    
    UIImageView *profileImageView = (UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:3];
    UITextView *messageText = (UITextView *)[cell.contentView viewWithTag:4];
    UILabel *teamLabel = (UILabel *)[cell.contentView viewWithTag:5];
    UIImageView *starOne = (UIImageView *)[cell.contentView viewWithTag:6];
    UIImageView *starTwo = (UIImageView *)[cell.contentView viewWithTag:7];
    UIImageView *starThree = (UIImageView *)[cell.contentView viewWithTag:8];
    UIView *imageBack = (UIView *)[cell.contentView viewWithTag:14];
    ImageButton *insideImageView = (ImageButton *)[cell.contentView viewWithTag:11];
    
    
    imageBack.backgroundColor = [UIColor blackColor];
    imageBack.layer.masksToBounds = YES;
    imageBack.layer.cornerRadius = 4.0;
    insideImageView.layer.masksToBounds = YES;
    insideImageView.layer.cornerRadius = 4.0;
    
    imageBack.autoresizingMask = UIViewAutoresizingNone;    
    profileImageView.autoresizingMask = UIViewAutoresizingNone;
    nameLabel.autoresizingMask = UIViewAutoresizingNone;
    dateLabel.autoresizingMask = UIViewAutoresizingNone;
    messageText.autoresizingMask = UIViewAutoresizingNone;
    insideImageView.autoresizingMask = UIViewAutoresizingNone;
    teamLabel.autoresizingMask = UIViewAutoresizingNone;
    starOne.autoresizingMask = UIViewAutoresizingNone;
    starTwo.autoresizingMask = UIViewAutoresizingNone;
    starThree.autoresizingMask = UIViewAutoresizingNone;
    
    
    messageText.font = [UIFont fontWithName:@"Helvetica" size:14];
    messageText.textColor = [UIColor blackColor];
    messageText.backgroundColor = [UIColor clearColor];
    
    
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    nameLabel.textColor = [UIColor blueColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    
    dateLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    
    teamLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    teamLabel.textColor = [UIColor blueColor];
    teamLabel.backgroundColor = [UIColor clearColor];
    
    if ([arrayToUse count] == 0) {
        
        profileImageView.hidden = YES;
        dateLabel.hidden = YES;
        messageText.hidden = YES;
        insideImageView.hidden = YES;
        imageBack.hidden = YES;
        teamLabel.hidden = YES;
        starTwo.hidden = YES;
        starOne.hidden = YES;
        starThree.hidden = YES;
        
        
        nameLabel.frame = CGRectMake(0, 0, 310, 35);
        nameLabel.text = @"No messages found...";
        nameLabel.textAlignment = UITextAlignmentCenter;
        
        
    }else{
        
        profileImageView.hidden = NO;
        dateLabel.hidden = NO;
        messageText.hidden = NO;
        insideImageView.hidden = NO;
        imageBack.hidden = NO;
        starOne.hidden = YES;
        starTwo.hidden = YES;
        starThree.hidden = YES;
        
        
        
        nameLabel.textAlignment = UITextAlignmentLeft;
        
        //Activity *result = [arrayToUse objectAtIndex:row];
        NSString *senderName = @"";
        NSString *sentDate = @"";
        NSString *sentTeam = @"";
        NSString *sentMessage = @"";
        bool isMessage;
        bool isInbox;
        
        if ([[arrayToUse objectAtIndex:row] class] == [MessageThreadInbox class]) {
            //inbox
        
            MessageThreadInbox *tmpInbox = [arrayToUse objectAtIndex:row];
            senderName = tmpInbox.senderName;
            sentDate = tmpInbox.createdDate;
            sentTeam = tmpInbox.teamName;
            sentMessage = tmpInbox.body;
            isInbox = true;
            if ([tmpInbox.pollChoices count] > 0) {
                isMessage = false;
            }else{
                isMessage = true;
            }
        }else{
            //MessageThreadOutbox
            
            MessageThreadOutbox *tmpOutbox = [arrayToUse objectAtIndex:row];
            
            sentDate = tmpOutbox.createdDate;
            sentTeam = tmpOutbox.teamName;
            sentMessage = tmpOutbox.body;
            isInbox = false;
            if ([tmpOutbox.messageType isEqualToString:@"poll"]) {
                isMessage = false;
                senderName = @"Sent Poll";
            }else{
                isMessage = true;
                senderName = @"Sent Message";
            }
        }
        
     
        
        //Profile Image
        profileImageView.frame = CGRectMake(5, 5, 40, 40);
        profileImageView.image = [UIImage imageNamed:@"profile.png"];
        
        
        //Name Label
        nameLabel.frame = CGRectMake(55, 5, 210, 18);
        
        if (![senderName isEqualToString:@""] && (senderName != nil)) {
            nameLabel.text = senderName;
        }else{
            nameLabel.text = @"rTeam";
        }
        
        //Date Label
        dateLabel.frame = CGRectMake(55, 23, 100, 18);
        dateLabel.text = [TableDisplayUtil getDateLabel:sentDate];
        
        //Team Label
        teamLabel.frame = CGRectMake(155, 23, 250, 18);
        teamLabel.text = sentTeam;
        
        //Message Text            
        messageText.frame = CGRectMake(50, 42, 265, 100);
        
        messageText.text = sentMessage;
        if (isInbox) {
            if (!isMessage) {
                messageText.text = [NSString stringWithFormat:@"Poll: %@", sentMessage];
            }
        }else{
            if (isMessage) {
                messageText.text = [NSString stringWithFormat:@"Message Sent: %@", sentMessage];

            }else{
                messageText.text = [NSString stringWithFormat:@"Poll Sent: %@", sentMessage];

            }
        }
        CGRect frame = messageText.frame;
        frame.size.height = [TableDisplayUtil findHeightForString:messageText.text withWidth:messageText.frame.size.width - 15] + 15;
        messageText.frame = frame;
        //int imageStart = 41 + messageText.frame.size.height;
        
        
        imageBack.hidden = YES;
        /*Inside Image - messages don't support images yet
         
        NSString *tmpThumbnail = result.thumbnail;
        bool isImage = false;
        
        for (UIView *view in [imageBack subviews]) {
            [view removeFromSuperview];
        }
        
        if ((tmpThumbnail != nil)  && (![tmpThumbnail isEqualToString:@""])){
            isImage = true;
            
            NSData *profileData = [Base64 decode:tmpThumbnail];
            insideImageView.hidden = NO;
            insideImageView.messageId = result.activityId;
            
            
            [insideImageView addTarget:sentClass action:@selector(imageSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            imageBack.hidden = NO;
            imageBack.backgroundColor = [UIColor blackColor];
            
            
            UIImage *tmpImage = [UIImage imageWithData:profileData];
            imageBack.frame = CGRectMake(52, imageStart, 82, 82);
            
            UIImageView *myImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:profileData]];
            
            if (tmpImage.size.height > tmpImage.size.width) {
                
                imageBack.frame = CGRectMake(66, imageStart, 54, 82);
            }else{
                imageBack.frame = CGRectMake(54, imageStart + 14, 82, 54);
            }
            
            myImage.frame = CGRectMake(1, 1, imageBack.frame.size.width -2, imageBack.frame.size.height - 2);
            
            [imageBack addSubview:myImage];
            
            imageBack.layer.masksToBounds = YES;
            imageBack.layer.cornerRadius = 4.0;
            myImage.layer.masksToBounds = YES;
            myImage.layer.cornerRadius = 4.0;
            
            
            insideImageView.frame = CGRectMake(52, imageStart, 82, 82);
            insideImageView.backgroundColor = [UIColor clearColor];
            [cell.contentView bringSubviewToFront:insideImageView];
            
        }else{
            insideImageView.hidden = YES;
            imageBack.hidden = YES;
            
        } 
        
        */
    }
    
    
    return cell;
    
    
}

//Set up the height for each cell My Messages
+(CGFloat)getHeightForRowAtIndexPathMy:(NSIndexPath*)indexPath arrayUsed:(NSMutableArray *)arrayUsed{
    
    
    NSUInteger row = [indexPath row];
    
    NSMutableArray *arrayToUse = [NSMutableArray arrayWithArray:arrayUsed];
    
    
    if ([arrayToUse count] > 0){
        
 
        NSString *sentMessage = @"";
        bool isMessage;
        bool isInbox;
        
        if ([[arrayToUse objectAtIndex:row] class] == [MessageThreadInbox class]) {
            //inbox
            
            MessageThreadInbox *tmpInbox = [arrayToUse objectAtIndex:row];
       
            sentMessage = tmpInbox.body;
            isInbox = true;
            if ([tmpInbox.pollChoices count] > 0) {
                isMessage = false;
            }else{
                isMessage = true;
            }
        }else{
            //MessageThreadOutbox
            
            MessageThreadOutbox *tmpOutbox = [arrayToUse objectAtIndex:row];
        
            sentMessage = tmpOutbox.body;
            isInbox = false;
            if ([tmpOutbox.messageType isEqualToString:@"poll"]) {
                isMessage = false;
            }else{
                isMessage = true;
            }
        }
        
        
        NSString *lengthMessage = sentMessage;
        
        if (isInbox) {
            if (!isMessage) {
                lengthMessage = [NSString stringWithFormat:@"Poll: %@", sentMessage];
            }
        }else{
            if (isMessage) {
                lengthMessage = [NSString stringWithFormat:@"Message Sent: %@", sentMessage];
                
            }else{
                lengthMessage = [NSString stringWithFormat:@"Poll Sent: %@", sentMessage];
                
            }
        }
        
        int messageHeight = [TableDisplayUtil findHeightForString:lengthMessage withWidth:250];
        
        
        
        int messageTotal = messageHeight + 15;
        
        int imageHeight = 0;
        
        //if ((result.thumbnail != nil) && (![result.thumbnail isEqualToString:@""])) {
            
          //  imageHeight = 90;
        //}
        
        
        int cellHeight = (42 + messageTotal +  imageHeight);
        
        
        return cellHeight;
    }
    return 35;
    
    
}


//---Utility Methods----

//Sends back the dateLabel (5 minutes ago, 3 days ago, etc) of the post from the created date
+(NSString *)getDateLabel:(NSString *)dateCreated{
    //date created format: yyyy-MM-dd HH:mm  
    
    NSDate *todaysDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"]; 
    NSDate *createdDateOrig = [dateFormatter dateFromString:dateCreated];
    
    NSTimeInterval interval = [todaysDate timeIntervalSinceDate:createdDateOrig];
    
    if (interval <  3600) {
        //Less than an hour, do minutes
        
        int minutes = floor(interval/60.0);
        
        if (minutes == 0) {
            return @"< 1 minute ago";
        }
        return [NSString stringWithFormat:@"%d minutes ago", minutes];
        
    }else if (interval < 86400){
        //less than a day, do hours
        
        int hours = floor(interval/3600.0);
        
        if (hours == 1) {
            return @"1 hour ago";
        }
        return [NSString stringWithFormat:@"%d hours ago", hours];
        
    }else{
        //do days
        
        int days = floor(interval/86400.0);
        
        if (days == 1) {
            return @"1 day ago";
        }
        return [NSString stringWithFormat:@"%d days ago", days];
    }
    
}

//Finds the height of a string constrained by the input width
+(int)findHeightForString:(NSString *)message withWidth:(int)width{
    
    CGSize constraints = CGSizeMake(width, 900);
    CGSize totalSize = [message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraints];
    
    return totalSize.height;
    
}


+(NSString *)getStarSize:(int)starNumber :(int)likes :(int)dislikes{
		
	
	if (likes == 0) {
		return @"emptyStar.png";
	}else {
		
		float percent = (float)likes/((float)dislikes + (float)likes);
		percent = percent * 100;
		
		
        if (percent < 33.3) {
            
            if (starNumber == 1) {
                
                if (percent < 8.3) {
                    return @"emptyStar.png";
                }else if (percent < 16.6){
                    return @"quartStar.png";
                }else if (percent < 25.0){
                    return @"halfStar.png";
                }else{
                    return @"threeQuartStar.png";
                }
                
            }else if (starNumber == 2){
                return @"emptyStar.png";
            }else{
                return @"emptyStar.png";
            }
        }else if (percent < 66.6){
            
            if (starNumber == 1) {
                return @"fullStar.png";

            }else if (starNumber == 2){

                if (percent < 41.6) {
                    return @"emptyStar.png";
                }else if (percent < 50.0){
                    return @"quartStar.png";
                }else if (percent < 58.3){
                    return @"halfStar.png";
                }else{
                    return @"threeQuartStar.png";
                }
                
            }else{
                return @"emptyStar.png";
            }
            
        }else{
            
            if (starNumber == 1) {
                return @"fullStar.png";

            }else if (starNumber == 2){
                return @"fullStar.png";
            }else{
                if (percent < 75) {
                    return @"emptyStar.png";
                }else if (percent < 83.3){
                    return @"quartStar.png";
                }else if (percent < 91.6){
                    return @"halfStar.png";
                }else if (percent < 98){
                    return @"threeQuartStar.png";
                }else{
                    return @"fullStar.png";
                }
            }
            
        }
        
		
		
		
		
		
	}
    
	
	return @"emptyStar.png";
	
	
}


@end