//
//  IMNotificationDefine.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/24.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTIFICATION_REFRESH_USER_LOCATION  @"NOTIFICATION_REFRESH_USER_LOCATION"
#define NOTIFICATION_AUDIO_PLAY_DONE        @"NOTIFICATION_AUDIO_PLAY_DONE"

//IM发送新消息
#define NOTIFICATION_SEND_NEWMESSAGE                    @"NOTIFICATION_SEND_NEWMESSAGE"
//IM收到新消息
#define NOTIFICATION_RECEIVED_NEWMESSAGE                @"NOTIFICATION_RECEIVED_NEWMESSAGE"
//IM刷新会话列表
#define NOTIFICATION_UPDATE_CONVERSATIONLIST            @"NOTIFICATION_UPDATE_CONVERSATIONLIST"
//IM同步网络与本地的会话列表
#define NOTIFICATION_SYNC_CONVERSATIONLIST              @"NOTIFICATION_SYNC_CONVERSATIONLIST"
//IM刷新消息状态（更新为正在发送，发送成功，发送失败等状态）
#define NOTIFICATION_REFRESH_MESSAGE_STATUS             @"NOTIFICATION_REFRESH_MESSAGE_STATUS"
//IM刷新消息列表
#define NOTIFICATION_REFRESH_MESSAGE_LIST               @"NOTIFICATION_REFRESH_MESSAGE_LIST"
//还原会话列表滑动
#define NOTIFICATION_RESET_CONVERSATION_PAN             @"NOTIFICATION_RESET_CONVERSATION_PAN"
//重新刷新搜索列表数据
#define NOTIFICATION_REFRESH_SEARCH_LIST                @"NOTIFICATION_REFRESH_SEARCH_LIST"
