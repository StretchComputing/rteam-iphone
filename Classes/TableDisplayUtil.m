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
#import "rTeamAppDelegate.h"
#import "ReplyButtonBackView.h"
#import "ScoreButton.h"

@implementation TableDisplayUtil

//Set up the view for each cell Everyone
+(UITableViewCell *)setUpTableViewCellWithArray:(NSMutableArray *)messageArray fromClass:(id)sentClass forIndexPath:(NSIndexPath *)indexPath andTableView:(UITableView *)tableView{
    
    rTeamAppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
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
    
    UIView *replyBackView = (UIView *)[cell.contentView viewWithTag:15];
    UIView *replyFrontView = (UIView *)[cell.contentView viewWithTag:16];
    UILabel *replyLabel = (UILabel *)[cell.contentView viewWithTag:25];
    UIView *replyTextView = (UIView *)[cell.contentView viewWithTag:18];
    UIView *replySeparator = (UIView *)[cell.contentView viewWithTag:19];
    UIImageView *arrowView = (UIImageView *)[cell.contentView viewWithTag:20];
    UIView *scoreView = (UIImageView *)[cell.contentView viewWithTag:21];



    
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
    replyLabel.autoresizingMask = UIViewAutoresizingNone;
    replyBackView.autoresizingMask = UIViewAutoresizingNone;
    replyFrontView.autoresizingMask = UIViewAutoresizingNone;
    replyTextView.autoresizingMask = UIViewAutoresizingNone;
    replySeparator.autoresizingMask = UIViewAutoresizingNone;
    arrowView.autoresizingMask = UIViewAutoresizingNone;
    scoreView.autoresizingMask = UIViewAutoresizingNone;

    
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
    
    replyTextView.backgroundColor = [UIColor clearColor];
    
    replyLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    replyLabel.textColor = [UIColor blackColor];
    replyLabel.backgroundColor = [UIColor clearColor];
    replyLabel.textAlignment = UITextAlignmentCenter;
    
    replySeparator.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];

    scoreView.backgroundColor = [UIColor clearColor];
    
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
        replyBackView.hidden = YES;
        arrowView.hidden = YES;
        scoreView.hidden = YES;
 
        
        
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
        teamLabel.hidden = NO;
        scoreView.hidden = NO;

        replyBackView.hidden = YES;

        
        nameLabel.textAlignment = UITextAlignmentLeft;
        
        Activity *result = [arrayToUse objectAtIndex:row];
                    
        //Profile Image
        profileImageView.frame = CGRectMake(5, 5, 40, 40);
        profileImageView.image = [UIImage imageNamed:@"profileNew.png"];
            
      
        
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
        frame.size.height = [TableDisplayUtil findHeightForString:result.activityText withWidth:messageText.frame.size.width - 20] + 15;
        messageText.frame = frame;
        int imageStart = 41 + messageText.frame.size.height;
        int replyStart = 47 + messageText.frame.size.height;

        if ([result.activityText length] > 12) {
            if ([[result.activityText substringToIndex:11] isEqualToString:@"Final score"]) {
                imageStart = 41 + 90;
                replyStart = 47 + 90;
            }
        }
 
        //Inside Image 
        NSString *tmpThumbnail = [mainDelegate.messageImageDictionary valueForKey:result.activityId];
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
      
            replyStart += 90;
            NSData *profileData = [Base64 decode:tmpThumbnail];
            insideImageView.hidden = NO;
            insideImageView.messageId = result.activityId;
   
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
                [insideImageView addTarget:sentClass action:@selector(videoSelected:) forControlEvents:UIControlEventTouchUpInside];

            }else{
                [insideImageView addTarget:sentClass action:@selector(imageSelected:) forControlEvents:UIControlEventTouchUpInside];
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
        
        //Check For Replies
        
        //Replies
        replyBackView.frame = CGRectMake(5, 0, 310, 20);
        replyLabel.hidden= YES;
        replySeparator.hidden = YES;
        replyFrontView.hidden = YES;
        
        for (UIView *view in replyBackView.subviews) {
            [view removeFromSuperview];
        }
        
        arrowView.hidden = YES;
        
        bool areOlderReplies = false;
        
        
        NSArray *resultReplies = [mainDelegate.replyDictionary valueForKey:result.activityId];
        
        if ([resultReplies count] > 0) {
            
            replyBackView.hidden = NO;
            
            replyBackView.frame = CGRectMake(5, replyStart, 310, 100);
            
            int totalImgAdjust = 0;
            
            int totalLoopCount = 0;
            
            if ([resultReplies count] > 3) {
                areOlderReplies = true;
                totalLoopCount = 3;
            }else{
                totalLoopCount = [resultReplies count];
            }
            
            for (int i = 0; i < totalLoopCount; i++) {
                
                if (areOlderReplies) {
                    
                    UIView *replyBack = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 300, 25)];
                    replyBack.backgroundColor= [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
                    //replyBackView.contentMode = UIViewContentModeScaleToFill;
                    //replyBack.image = [UIImage imageNamed:@"middleRow.png"];
                    totalImgAdjust += 25;
                    
                    UIView *replyFront = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 298, 23)];
                    replyFront.backgroundColor= [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
                    
                    [replyBack addSubview:replyFront];
                    
                    UILabel *otherReplyLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 275, 25)];
                    otherReplyLabel.textColor = [UIColor darkTextColor];
                    otherReplyLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
                    otherReplyLabel.backgroundColor = [UIColor clearColor];
                    int count = [resultReplies count] - 3;
                    
                    if (count == 1) {
                        otherReplyLabel.text = @"1 older reply";
                    }else{
                        otherReplyLabel.text = [NSString stringWithFormat:@"%d older replies", count];
                    }
                    
                    [replyBack addSubview:otherReplyLabel];
                    
                    [replyBackView addSubview:replyBack];
                    
                    areOlderReplies = false;
                    i--;
                    
                }else{
                    
                    Activity *theReply = [resultReplies objectAtIndex:i];
                    
                    NSString *currentReplyText = [NSString stringWithFormat:@"%@", theReply.activityText];
                                        
                    int subHeight = [TableDisplayUtil findHeightForString13:currentReplyText withWidth:260];
                    //subHeight += 16;
                    
                    if (subHeight < 25) {
                        subHeight = 25;
                    }
                    
                    if (subHeight >= 32) {
                        subHeight = 45;
                    }
                    
                    
                    int addImageHeight = 0;
                    
                   
                    if ([mainDelegate.messageImageDictionary valueForKey:theReply.activityId] != nil) {
                        
                        NSString *tmpThumbnail = [mainDelegate.messageImageDictionary valueForKey:theReply.activityId];
                        
                        if ([tmpThumbnail length] > 0) {
                                
                            addImageHeight = 50;
                        }
                        
                    }
                    
                    
                    //Pull the y-origin down if its a one liner
                    int plusY = 0;
                    if (subHeight == 25) {
                        plusY = 2;
                    }
                    UIView *replyBack = [[UIView alloc] initWithFrame:CGRectMake(5, totalImgAdjust, 300, 15 + subHeight + addImageHeight)];
  
                    replyBack.backgroundColor= [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
                    
                    totalImgAdjust += subHeight + 15 + addImageHeight;
                    
                    UIView *replyFront = [[UIView alloc] initWithFrame:CGRectMake(1, 1, replyBack.frame.size.width -2 , replyBack.frame.size.height - 2)];
                    replyFront.backgroundColor= [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
                    
                    [replyBack addSubview:replyFront];
                    
                    UIImageView *replyProfile = [[UIImageView alloc] initWithFrame:CGRectMake(3, 5, 30, 30)];
                    
                    //if ([mainDelegate.imageDictionary valueForKey:theReply.profile] != nil) {
                        
                      //  NSData *tmpData = [mainDelegate.imageDictionary valueForKey:theReply.profile];
                        //UIImage *myImage = [UIImage imageWithData:tmpData];
                        //replyProfile.image = myImage;
                    //}else{

                    replyProfile.image = [UIImage imageNamed:@"profileNew.png"];
                        
                    //}
                    
                    
                    UILabel *newReplyTextView = [[UILabel alloc] initWithFrame:CGRectMake(37, 12 + plusY, 261, subHeight)];
                    newReplyTextView.font = [UIFont fontWithName:@"Helvetica" size:13];
                    newReplyTextView.textColor = [UIColor blackColor];
                    newReplyTextView.backgroundColor = [UIColor clearColor];
                    newReplyTextView.text = currentReplyText;
                    newReplyTextView.userInteractionEnabled = NO;
                    newReplyTextView.numberOfLines = 2;
                    newReplyTextView.adjustsFontSizeToFitWidth = NO;                    
                    
                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 2, 195, 18)];
                    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
                    nameLabel.textColor = [UIColor blackColor];
                    nameLabel.text = theReply.senderName;
                    nameLabel.backgroundColor = [UIColor clearColor];

                    CGSize constr = CGSizeMake(195, 100);
                    CGSize sizeForWidth = [nameLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13] constrainedToSize:constr];
                    UILabel *botDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35 + sizeForWidth.width + 5, 2, 29, 18)];
                    botDateLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
                    botDateLabel.text = [NSString stringWithFormat:@"• %@", [TableDisplayUtil getDateLabelReply:theReply.createdDate]];
                    botDateLabel.backgroundColor = [UIColor clearColor];
                    botDateLabel.textColor = [UIColor grayColor];
                    
                    
                    
                    if ([mainDelegate.messageImageDictionary valueForKey:theReply.activityId] != nil) {
                        
                        NSString *tmpThumbnail = [mainDelegate.messageImageDictionary valueForKey:theReply.activityId];
                        
                        if ([tmpThumbnail length] > 0) {
                            
                                
                                ReplyButtonBackView *replyBackOne = [[ReplyButtonBackView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
                                replyBackOne.backgroundColor = [UIColor blackColor];
                                
                                ImageButton *replyImageOne = [ImageButton buttonWithType:UIButtonTypeCustom];
                                replyImageOne.messageId = theReply.activityId;
                                replyImageOne.frame = CGRectMake(1, 1, 48, 48);
                                
                                
                                [replyImageOne setImage:[UIImage imageWithData:[Base64 decode:tmpThumbnail]] forState:UIControlStateNormal];
                                
                                replyBackOne.frame = CGRectMake(38,12 + subHeight, 50, 50);
                                
                                [replyBackOne addSubview:replyImageOne];
                                replyBackOne.autoresizingMask = UIViewAutoresizingNone;
                                
                                
                                replyBackOne.layer.masksToBounds = YES;
                                replyBackOne.layer.cornerRadius = 4.0;
                                replyImageOne.layer.masksToBounds = YES;
                                replyImageOne.layer.cornerRadius = 4.0; 
                                
                                [replyBack addSubview:replyBackOne];
                                
                                replyImageOne.userInteractionEnabled = YES;
                                replyBackOne.userInteractionEnabled = YES;
                                
                            if (theReply.isVideo) {
                                UIImageView *playButton = [[UIImageView alloc] initWithFrame:CGRectMake(replyBackOne.frame.size.width/2 - 9, replyBackOne.frame.size.height/2 - 9, 18, 18)];
                                playButton.image = [UIImage imageNamed:@"playButtonSmall.png"];
                                [replyBackOne addSubview:playButton];
                                [replyImageOne addTarget:sentClass action:@selector(videoSelected:) forControlEvents:UIControlEventTouchUpInside];
                                
                            }else{
                                [replyImageOne addTarget:sentClass action:@selector(imageSelected:) forControlEvents:UIControlEventTouchUpInside];
                            }
                            
                                /*
                                if ([arrayOfData count] > 1) {
                                    
                                    if ([[arrayOfData objectAtIndex:0] length] > 0) {
                                        
                                        ReplyButtonBackView *replyBackTwo = [[ReplyButtonBackView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
                                        replyBackTwo.backgroundColor = [UIColor blackColor];
                                        
                                        ImageButton *replyImageTwo = [ImageButton buttonWithType:UIButtonTypeCustom];
                                        replyImageTwo.messageId = theReply.activityId;
                                        replyImageTwo.frame = CGRectMake(1, 1, 48, 48);
                                        
                                        
                                        
                                        
                                        [replyImageTwo setImage:[UIImage imageWithData:[arrayOfData objectAtIndex:1]] forState:UIControlStateNormal];
                                        [replyImageTwo addTarget:sentClass action:@selector(imageSelected:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                        replyBackTwo.frame = CGRectMake(98,12 + subHeight, 50, 50);
                                        
                                        [replyBackTwo addSubview:replyImageTwo];
                                        replyBackTwo.autoresizingMask = UIViewAutoresizingNone;
                                        
                                        
                                        replyBackTwo.layer.masksToBounds = YES;
                                        replyBackTwo.layer.cornerRadius = 4.0;
                                        replyImageTwo.layer.masksToBounds = YES;
                                        replyImageTwo.layer.cornerRadius = 4.0; 
                                        
                                        [replyBack addSubview:replyBackTwo];
                                        
                                        replyImageTwo.userInteractionEnabled = YES;
                                        replyBackTwo.userInteractionEnabled = YES;
                                        
                                        
                                    }
                                    
                                }
                                 */ 
                            
                        }
                        
                    }
                    
                    [replyBack addSubview:botDateLabel];
                    [replyBack addSubview:nameLabel];
                    [replyBack addSubview:newReplyTextView];
                    [replyBack addSubview:replyProfile];
                    
                    [replyBackView addSubview:replyBack];
                    
                    replyBack.userInteractionEnabled = YES;
                    
                }
                
                
            }
            
            CGRect frame3 = replyBackView.frame;
            
            
            frame3.size.height = totalImgAdjust;
            
            
            replyBackView.frame = frame3;
            
            replyBackView.userInteractionEnabled = NO;
            
            
            
            if (isImage) {
                arrowView.frame = CGRectMake(35, replyStart - 13, 20, 20);
                
            }else{
                arrowView.frame = CGRectMake(43, replyStart - 13, 20, 20);
            }
            
            arrowView.image = [UIImage imageNamed:@"replyArrow.png"];
            arrowView.hidden = NO;
            
            replyBackView.userInteractionEnabled = YES;
            replyBackView.clipsToBounds = YES;
        }else{
            replyBackView.hidden = YES;
        
        }
        

        scoreView.hidden = YES;
        
        for (UIView *subview in [scoreView subviews]) {
            [subview removeFromSuperview];
        }
        
        if ([result.activityText length] > 12) {
            if ([[result.activityText substringToIndex:11] isEqualToString:@"Final score"]) {
                
                @try {
                    scoreView.hidden = NO;
                    messageText.text = @"Game Over!  Final Score:";
                    
                    NSRange first = [result.activityText rangeOfString:@"="];
                    first.location++;
                    first.length++;
                    
                    NSRange second = [result.activityText rangeOfString:@"=" options:NSBackwardsSearch];
                    second.location++;
                    second.length++;
                    
                    if ((second.location + second.length) > [result.activityText length]) {
                        second.length = [result.activityText length] - second.location;
                    }
                    
                    NSString *scoreUs = [result.activityText substringWithRange:first];
                    NSString *scoreThem = [result.activityText substringWithRange:second];
                    
                    
                    
                    
                    scoreUs =  [scoreUs stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    scoreThem = [scoreThem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    scoreView.frame = CGRectMake(55, 70, 92, 55);
                    
                    ScoreButton *tmp1Button = [[ScoreButton alloc] initWithFrame:CGRectMake(0, 0, 92, 55)];
                    
                    [tmp1Button addTarget:sentClass action:@selector(viewScore:) forControlEvents:UIControlEventTouchUpInside];
                    
                    tmp1Button.activity = result;
                    tmp1Button.yesCount.text = scoreUs;
                    tmp1Button.noCount.text = scoreThem;
                    
                    tmp1Button.qLabel.text = @"F";
                    
                    [scoreView addSubview:tmp1Button];

                }
                @catch (NSException *exception) {
                    
                }
               
                
            }
        }
        

    }

    
    return cell;
    
    
}

//Height for each cell All Activity
+(CGFloat)getHeightForRowAtIndexPath:(NSIndexPath*)indexPath arrayUsed:(NSMutableArray *)arrayUsed{
    
    rTeamAppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
        
    NSUInteger row = [indexPath row];
    
    NSMutableArray *arrayToUse = [NSMutableArray arrayWithArray:arrayUsed];
    
    
    if ([arrayToUse count] > 0){
        
        Activity *result = [arrayToUse objectAtIndex:row];
        
        NSString *lengthMessage = result.activityText;
        
        int messageHeight = [TableDisplayUtil findHeightForString:lengthMessage withWidth:245];      
   
        
        int messageTotal = messageHeight + 15;
        
        if ([result.activityText length] > 12) {
            if ([[result.activityText substringToIndex:11] isEqualToString:@"Final score"]) {
                messageTotal = 90;
            }
        }
        
        int imageHeight = 0;
        
        
        NSString *tmpThumbnail = [mainDelegate.messageImageDictionary valueForKey:result.activityId];
        
        if ((tmpThumbnail != nil) && (![tmpThumbnail isEqualToString:@""])) {
            
            imageHeight = 90;
        }
     
        int replyHeight = 0;
        
        NSArray *resultReplies = [mainDelegate.replyDictionary valueForKey:result.activityId];
        
        if ([resultReplies count] > 0) {
            replyHeight = 10;
            
            int totalLoopCount = 0;
            if ([resultReplies count] > 3) {
                totalLoopCount = 3;
                replyHeight +=25;
            }else{
                totalLoopCount = [resultReplies count];
            }
            
            for (int i = 0; i < totalLoopCount; i++) {
                int replyImgAdjust = 0;
                
                Activity *theReply = [resultReplies objectAtIndex:i];
                
                NSString *replyString = theReply.activityText;
                int subHeight = [TableDisplayUtil findHeightForString13:replyString withWidth:260];
                
                if (subHeight < 25) {
                    subHeight = 25;
                }
                
                if (subHeight >= 32) {
                    subHeight = 45;
                }
                
                
                if ([mainDelegate.messageImageDictionary valueForKey:theReply.activityId] != nil) {
                    replyImgAdjust = 50;
                }
                
                
                replyHeight += subHeight + 15 + replyImgAdjust;
                
                
                
            }
            
        }

        
        int cellHeight = (42 + messageTotal +  imageHeight + replyHeight);
        
        
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
    UIView *scoreView = (UIImageView *)[cell.contentView viewWithTag:21];

    scoreView.hidden = YES;
    
    UIView *replyBackView = (UIView *)[cell.contentView viewWithTag:15];

    
    replyBackView.hidden = YES;

    
    
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
            if ([tmpOutbox.messageType isEqualToString:@"poll"] || [tmpOutbox.messageType isEqualToString:@"whoiscoming"]) {
                isMessage = false;
                senderName = @"Sent Poll";
            }else{
                isMessage = true;
                senderName = @"Sent Message";
            }
        }
        
     
        
        //Profile Image
        profileImageView.frame = CGRectMake(5, 5, 40, 40);
        profileImageView.image = [UIImage imageNamed:@"profileNew.png"];
        
        
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
        frame.size.height = [TableDisplayUtil findHeightForString:messageText.text withWidth:messageText.frame.size.width - 20] + 15;
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
        
        int messageHeight = [TableDisplayUtil findHeightForString:lengthMessage withWidth:245];
        
        
        
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


+(int)findHeightForString13:(NSString *)message withWidth:(int)width{
    
    
    CGSize constraints = CGSizeMake(width, 900);
    CGSize totalSize = [message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13] constrainedToSize:constraints];
    
    return totalSize.height;
    
}

+(NSString *)getDateLabelReply:(NSString *)dateCreated{
    //date created format: YYYY-MM-dd HH:mm:ss  
    
    NSDate *todaysDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"]; 
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *createdDateOrig = [dateFormatter dateFromString:dateCreated];
    
    NSTimeInterval interval = [todaysDate timeIntervalSinceDate:createdDateOrig];
    
    if (interval <  3600) {
        //Less than an hour, do minutes
        
        int minutes = floor(interval/60.0);
        
        if (minutes == 0) {
            return @"1m";
        }
        return [NSString stringWithFormat:@"%dm", minutes];
        
    }else if (interval < 86400){
        //less than a day, do hours
        
        int hours = floor(interval/3600.0);
        
        if (hours == 1) {
            return @"1h";
        }
        return [NSString stringWithFormat:@"%dh", hours];
        
    }else{
        //do days
        
        int days = floor(interval/86400.0);
        
        if (days == 1) {
            return @"1d";
        }
        return [NSString stringWithFormat:@"%dd", days];
    }
    
}





@end