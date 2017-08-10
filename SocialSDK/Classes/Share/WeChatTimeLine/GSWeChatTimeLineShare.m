//
//  GSWeChatTimeLineShare.m
//  SocialSDKDemo
//
//  Created by lvjialin on 2016/12/20.
//  Copyright © 2016年 GagSquad. All rights reserved.
//

#import "GSWeChatTimeLineShare.h"
#import "WXApi.h"

@interface GSWeChatTimeLineShare ()<WXApiDelegate>

@end

@implementation GSWeChatTimeLineShare

+ (void)load
{
    [[GSShareManager share] addChannelWithChannelType:[GSWeChatTimeLineShare channelType] channel:[GSWeChatTimeLineShare class]];
}

+ (GSPlatformType)platformType
{
    return GSPlatformTypeWeChat;
}

+ (GSShareChannelType)channelType
{
    return GSShareChannelTypeWechatTimeLine;
}

- (void)shareSimpleText:(NSString *)text
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.scene = WXSceneTimeline;
    req.text = text;
    [WXApi sendReq:req];
}

- (void)shareSingleImage:(id)image thumb:(id)thumb title:(NSString *)title description:(NSString *)description
{
    NSData *imageData = [image isKindOfClass:[NSData class]]?image:([image isKindOfClass:[UIImage class]]?UIImagePNGRepresentation(image):nil);
    NSData *thumbData = [thumb isKindOfClass:[NSData class]]?thumb:([thumb isKindOfClass:[UIImage class]]?UIImagePNGRepresentation(thumb):nil);

    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = imageData;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.thumbData = thumbData;
    message.title = title;
    message.description = description;
    message.mediaObject = ext;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = WXSceneTimeline;
    req.message = message;
    [WXApi sendReq:req];
}

- (void)shareURL:(NSString *)url title:(NSString *)title description:(NSString *)description thumbnail:(id)thumbnail
{
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = ext;
    
    if ([thumbnail isKindOfClass:[NSData class]]) {
        message.thumbData = thumbnail;
    } else if ([thumbnail isKindOfClass:[UIImage class]]) {
        message.thumbData = UIImagePNGRepresentation(thumbnail);
    }

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = WXSceneTimeline;
    req.message = message;
    [WXApi sendReq:req];
}

- (void)shareMusicURL:(NSString *)musicURL
      musicLowBandURL:(NSString *)musicLowBandURL
         musicDataURL:(NSString *)musicDataURL
  musicLowBandDataURL:(NSString *)musicLowBandDataURL
                title:(NSString *)title
          description:(NSString *)description
            thumbnail:(id)thumbnail
{
    WXMusicObject *musicObject = [WXMusicObject object];
    musicObject.musicUrl = musicURL;
    musicObject.musicLowBandUrl = musicLowBandURL;
    musicObject.musicDataUrl = musicDataURL;
    musicObject.musicLowBandDataUrl = musicLowBandDataURL;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = musicObject;
    
    if ([thumbnail isKindOfClass:[NSData class]]) {
        message.thumbData = thumbnail;
    } else if ([thumbnail isKindOfClass:[UIImage class]]) {
        message.thumbData = UIImagePNGRepresentation(thumbnail);
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = WXSceneTimeline;
    req.message = message;
    [WXApi sendReq:req];
}

- (void)shareVideoURL:(NSString *)videoURL
      videoLowBandURL:(NSString *)videoLowBandURL
       videoStreamURL:(NSString *)videoStreamURL
videoLowBandStreamURL:(NSString *)videoLowBandStreamURL
                title:(NSString *)title
          description:(NSString *)description
            thumbnail:(id)thumbnail
{
    WXVideoObject *videoObject = [WXVideoObject object];
    videoObject.videoUrl = videoURL;
    videoObject.videoLowBandUrl = videoLowBandURL;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = videoObject;
    
    if ([thumbnail isKindOfClass:[NSData class]]) {
        message.thumbData = thumbnail;
    } else if ([thumbnail isKindOfClass:[UIImage class]]) {
        message.thumbData = UIImagePNGRepresentation(thumbnail);
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = WXSceneTimeline;
    req.message = message;
    [WXApi sendReq:req];
}

- (void)onResp:(BaseResp *)resp
{
    [self completionWithResult:[self createResultWithResponse:resp]];
}

- (id<GSShareResultProtocol>)createResultWithResponse:(BaseResp *)response
{
    int errCode = response.errCode;
    GSShareResult *res = [[GSShareResult alloc] init];
    res.sourceCode = errCode;
    res.soucreMessage = @"";
    res.status = GSShareResultStatusFailing;
    switch (errCode) {
        case WXSuccess: {
            res.status = GSShareResultStatusSuccess;
            break;
        }
        case WXErrCodeUserCancel: {
            res.status = GSShareResultStatusCancel;
            break;
        }
        default:
            break;
    }
    return res;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
   return [WXApi handleOpenURL:url delegate:self];
}
@end
