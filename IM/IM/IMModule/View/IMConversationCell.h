//
//  IMMessageCenterCell.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/26.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMConversationCellDelegate <NSObject>

- (void)conversationCellClickedMoreFunctionButtonWithConversationAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface IMConversationCell : UITableViewCell

@property(nonatomic,strong) IMConversation * conversation;

@property (nonatomic,strong) NSIndexPath * indexPath;

@property (nonatomic,weak) id<IMConversationCellDelegate> delegate;

@end
