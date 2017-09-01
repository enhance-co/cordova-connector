#import "CDVEnhance.h"
#import <Cordova/CDVPlugin.h>

@interface CDVEnhance ()
@end

@implementation CDVEnhance {
   NSString* _tag;
   FglEnhance* _enhance;
   FglEnhancePlus* _enhancePlus;
   FglEnhanceInAppPurchases* _enhanceIAP;

   NSString* _onInterstitialCompletedCallbackId;
   NSString* _onRewardedAdCompletedCallbackId;
   NSString* _onLocalNotificationPermissionResponseCallbackId;
   NSString* _onCurrencyGrantedCallbackId;
   NSString* _OnPurchaseAttemptedCallbackId;
}

- (void)pluginInitialize {
   _tag = @"Enhance Cordova Plugin: %@";
   _enhance = [FglEnhance sharedInstance];
   _enhancePlus = [FglEnhancePlus sharedInstance];
   _enhanceIAP = [FglEnhanceInAppPurchases sharedInstance];

   NSLog(_tag, @"initialized");
}

- (void)isInterstitialReady:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isInterstitialReady");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];

   bool success = [_enhance isInterstitialReady:[placement lowercaseString]];
   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];

   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showInterstitialAd:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"showInterstitialAd");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];

   [_enhance showInterstitial:[placement lowercaseString]];
   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setInterstitialCallback:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"setInterstitialCallback");

   _onInterstitialCompletedCallbackId = command.callbackId;

   [_enhance setInterstitialDelegate:self];
}

- (void)isRewardedAdReady:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isRewardedAdReady");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];  
   
   bool success = [_enhance isRewardedAdReady:[placement uppercaseString]];
   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];

   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showRewardedAd:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"showRewardedAd");

   NSString* placement = [command.arguments objectAtIndex:0];  
   _onRewardedAdCompletedCallbackId = command.callbackId;

   [_enhance showRewardedAd:self placement:[placement uppercaseString]];
}

- (void)isBannerAdReady:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isBannerAdReady");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];

   bool success = [_enhance isBannerAdReady:[placement lowercaseString]];    
   
   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];  
}

- (void)showBannerAdWithPosition:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"showBannerAdWithPosition");

   CDVPluginResult* pluginResult = nil;
   NSString* positionStr = [command.arguments objectAtIndex:0];
   NSString* placement = [command.arguments objectAtIndex:1];
   Position position;

   if([[positionStr lowercaseString] isEqualToString:@"top"]) 
      position = POSITION_TOP;
   else 
      position = POSITION_BOTTOM;

   [_enhance showBannerAd:placement position:position];

   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId]; 
}

- (void)hideBannerAd:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"hideBannerAd");

   [_enhance hideBannerAd];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)isSpecialOfferReady:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isSpecialOfferReady");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];

   bool success = [_enhance isSpecialOfferReady:[placement lowercaseString]];    
   
   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];     
}

- (void)showSpecialOffer:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"showSpecialOffer");

   NSString* placement = [command.arguments objectAtIndex:0];  

   [_enhance showSpecialOffer:[placement lowercaseString]];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)isOfferwallReady:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isOfferwallReady");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];

   bool success = [_enhance isOfferwallReady:[placement lowercaseString]];    
   
   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];    
}

- (void)showOfferwall:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"showOfferwall");

   NSString* placement = [command.arguments objectAtIndex:0];  

   [_enhance showOfferwall:[placement lowercaseString]];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)requestLocalNotificationPermission:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"requestLocalNotificationPermission");

   _onLocalNotificationPermissionResponseCallbackId = command.callbackId;

   [_enhance requestLocalNotificationPermission:self];
}

- (void)enableLocalNotification:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"enableLocalNotification");

   NSString* title = [command.arguments objectAtIndex:0];
   NSString* msg = [command.arguments objectAtIndex:1];
   NSNumber* delaySeconds = [command.arguments objectAtIndex:2];

   [_enhance enableLocalNotificationWithTitle:title message:msg delay:(int)[delaySeconds integerValue]];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];   
}

- (void)disableLocalNotification:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"disableLocalNotification");

   [_enhance disableLocalNotification];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId]; 
}

- (void)logEvent:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"logEvent");

   NSString* eventName = [command.arguments objectAtIndex:0];
   NSString* eventParamKey = [command.arguments objectAtIndex: 1];
   NSString* eventParamValue = [command.arguments objectAtIndex: 2];

   if(![eventParamKey isEqualToString:@""] && ![eventParamValue isEqualToString:@""])
      [_enhance logEvent:eventName withParameter:eventParamKey andValue:eventParamValue];
   else
      [_enhance logEvent:eventName];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId]; 
}

- (void)setCurrencyReceivedCallback:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"setCurrencyReceivedCallback");

   _onCurrencyGrantedCallbackId = command.callbackId;

   [_enhance setCurrencyGrantedDelegate:self];
}

- (void)logMessage:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"logMessage");

   NSString* tag = [command.arguments objectAtIndex: 0];
   NSString* msg = [command.arguments objectAtIndex: 1];

   if(![tag isEqualToString:@""] && ![msg isEqualToString:@""]) 
      [_enhancePlus logMessage:tag message:msg];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId]; 
}

- (void)isPurchasingSupported:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isPurchasingSupported");

   bool success = [_enhanceIAP isSupported];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];  
}  

- (void)attemptPurchase:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"attemptPurchase");

   NSString* sku = [command.arguments objectAtIndex: 0];

   _OnPurchaseAttemptedCallbackId = command.callbackId;

   [_enhanceIAP attemptPurchase:sku delegate:self];
}

- (void)getDisplayPrice:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"getDisplayPrice");

   NSString* sku = [command.arguments objectAtIndex: 0];
   NSString* defaultPrice = [command.arguments objectAtIndex: 1];

   NSString* displayPrice = [_enhanceIAP getDisplayPrice:sku defaultPrice:defaultPrice];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:displayPrice];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];     
}

- (void)isItemOwned:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isItemOwned");

   NSString* sku = [command.arguments objectAtIndex: 0];

   bool success = [_enhanceIAP isItemOwned:sku];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];      
}

// Interstitial callbacks

- (void)onInterstitialCompleted {
   NSLog(_tag, @"onInterstitialCompleted");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:_onInterstitialCompletedCallbackId];
}

// Rewarded Ad callbacks

- (void)onRewardGranted:(int)rewardValue rewardType:(RewardType)rewardType {
   NSLog(_tag, @"onRewardGranted");

   NSNumber* rewardValueNum = [NSNumber numberWithInt:rewardValue];
   NSString* rewardTypeStr = @"item";
   if(rewardType == REWARDTYPE_COINS) rewardTypeStr = @"coins";

   NSArray* resultArray = [NSArray arrayWithObjects:rewardValueNum, rewardTypeStr, nil];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultArray];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onRewardedAdCompletedCallbackId];
}

- (void)onRewardDeclined {
   NSLog(_tag, @"onRewardDeclined");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"declined"];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onRewardedAdCompletedCallbackId];
}

- (void)onRewardUnavailable {
   NSLog(_tag, @"onRewardUnavailable");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"unavailable"];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onRewardedAdCompletedCallbackId];   
}

// Local Notification Permission callbacks

- (void)onPermissionGranted {
   NSLog(_tag, @"onPermissionGranted");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onLocalNotificationPermissionResponseCallbackId];     
}

- (void)onPermissionRefused {
   NSLog(_tag, @"onPermissionRefused");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:NO];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onLocalNotificationPermissionResponseCallbackId];     
}

// Currency callbacks

- (void)onCurrencyGranted:(int)amount {
   NSLog(_tag, @"onCurrencyGranted");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:amount];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onCurrencyGrantedCallbackId];     
}

// Purchase callbacks

- (void)onPurchaseSuccess {
   NSLog(_tag, @"onPurchaseSuccess");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _OnPurchaseAttemptedCallbackId];    
}

- (void)onPurchaseFailed {
   NSLog(_tag, @"onPurchaseFailed");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:NO];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _OnPurchaseAttemptedCallbackId];   
}

@end
