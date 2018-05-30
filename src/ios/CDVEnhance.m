#import "CDVEnhance.h"
#import <Cordova/CDVPlugin.h>

@interface CDVEnhance ()
@end

@implementation CDVEnhance {
   NSString* _tag;

   NSString* _onInterstitialCompletedCallbackId;
   NSString* _onRewardedAdCompletedCallbackId;
   NSString* _onLocalNotificationPermissionResponseCallbackId;
   NSString* _onCurrencyGrantedCallbackId;
   NSString* _onPurchaseAttemptedCallbackId;
   NSString* _onConsumeAttemptedCallbackId;
   NSString* _onManualRestoreCallbackId;
   NSString* _onOptInRequiredCallbackId;
   NSString* _onDialogCompleteCallbackId;
}

- (void)pluginInitialize {
   _tag = @"Enhance Cordova Plugin: %@";
   NSLog(_tag, @"initialized");
}

- (void)isInterstitialReady:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isInterstitialReady");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];

   bool success = [Enhance isInterstitialReady:[placement lowercaseString]];
   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];

   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showInterstitialAd:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"showInterstitialAd");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];

   [Enhance showInterstitialAd:[placement lowercaseString]];
   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

// deprecated

- (void)setInterstitialCallback:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"setInterstitialCallback");
   _onInterstitialCompletedCallbackId = command.callbackId;

   [[FglEnhance sharedInstance] setInterstitialDelegate:self];
}

- (void)isRewardedAdReady:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isRewardedAdReady");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];  
   
   bool success = [Enhance isRewardedAdReady:[placement uppercaseString]];
   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];

   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showRewardedAd:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"showRewardedAd");

   NSString* placement = [command.arguments objectAtIndex:0];  
   _onRewardedAdCompletedCallbackId = command.callbackId;

   [Enhance showRewardedAd:self placement:[placement uppercaseString]];
}

- (void)isBannerAdReady:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isBannerAdReady");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];

   bool success = [Enhance isBannerAdReady:[placement lowercaseString]];    
   
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

   [Enhance showBannerAdWithPosition:placement position:position];

   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId]; 
}

- (void)hideBannerAd:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"hideBannerAd");

   [Enhance hideBannerAd];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)isSpecialOfferReady:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isSpecialOfferReady");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];

   bool success = [Enhance isSpecialOfferReady:[placement lowercaseString]];    
   
   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];     
}

- (void)showSpecialOffer:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"showSpecialOffer");

   NSString* placement = [command.arguments objectAtIndex:0];  

   [Enhance showSpecialOffer:[placement lowercaseString]];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)isOfferwallReady:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isOfferwallReady");

   CDVPluginResult* pluginResult = nil;
   NSString* placement = [command.arguments objectAtIndex:0];

   bool success = [Enhance isOfferwallReady:[placement lowercaseString]];    
   
   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];    
}

- (void)showOfferwall:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"showOfferwall");

   NSString* placement = [command.arguments objectAtIndex:0];  

   [Enhance showOfferwall:[placement lowercaseString]];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)requestLocalNotificationPermission:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"requestLocalNotificationPermission");

   _onLocalNotificationPermissionResponseCallbackId = command.callbackId;

   [Enhance requestLocalNotificationPermission:self];
}

- (void)enableLocalNotification:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"enableLocalNotification");

   NSString* title = [command.arguments objectAtIndex:0];
   NSString* msg = [command.arguments objectAtIndex:1];
   NSNumber* delaySeconds = [command.arguments objectAtIndex:2];

   [Enhance enableLocalNotificationWithTitle:title message:msg delay:(int)[delaySeconds integerValue]];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];   
}

- (void)disableLocalNotification:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"disableLocalNotification");

   [Enhance disableLocalNotification];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId]; 
}

- (void)logEvent:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"logEvent");

   NSString* eventName = [command.arguments objectAtIndex:0];
   NSString* eventParamKey = [command.arguments objectAtIndex: 1];
   NSString* eventParamValue = [command.arguments objectAtIndex: 2];

   if(![eventParamKey isEqualToString:@""] && ![eventParamValue isEqualToString:@""])
      [Enhance logEvent:eventName withParameter:eventParamKey andValue:eventParamValue];
   else
      [Enhance logEvent:eventName];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId]; 
}

- (void)setCurrencyReceivedCallback:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"setCurrencyReceivedCallback");

   _onCurrencyGrantedCallbackId = command.callbackId;

   [Enhance setCurrencyGrantedDelegate:self];
}

// deprecated

- (void)logMessage:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"logMessage");

   NSString* tag = [command.arguments objectAtIndex: 0];
   NSString* msg = [command.arguments objectAtIndex: 1];

   if(![tag isEqualToString:@""] && ![msg isEqualToString:@""]) 
      [[FglEnhancePlus sharedInstance] logMessage:tag message:msg];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId]; 
}

- (void)isPurchasingSupported:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isPurchasingSupported");

   bool success = [[Enhance purchases] isSupported];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];
   [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];  
}  

- (void)attemptPurchase:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"attemptPurchase");

   NSString* sku = [command.arguments objectAtIndex: 0];
   _onPurchaseAttemptedCallbackId = command.callbackId;

   [[Enhance purchases] attemptPurchase:sku delegate:self];
}

- (void)getDisplayPrice:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"getDisplayPrice");

   NSString* sku = [command.arguments objectAtIndex: 0];
   NSString* defaultPrice = [command.arguments objectAtIndex: 1];

   NSString* displayPrice = [[Enhance purchases] getDisplayPrice:sku defaultPrice:defaultPrice];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:displayPrice];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];     
}

- (void)isItemOwned:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"isItemOwned");

   NSString* sku = [command.arguments objectAtIndex: 0];

   bool success = [[Enhance purchases] isItemOwned:sku];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];      
}

- (void)getOwnedItemCount:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"getOwnedItemCount");

   NSString* sku = [command.arguments objectAtIndex: 0];
   int result = [[Enhance purchases] getOwnedItemCount:sku];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:result];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)consumePurchase:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"consumePurchase");

   NSString* sku = [command.arguments objectAtIndex: 0];
   _onConsumeAttemptedCallbackId = command.callbackId;

   [[Enhance purchases] consume:sku delegate:self];
}

- (void)manuallyRestorePurchases:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"manuallyRestorePurchases");

   _onManualRestoreCallbackId = command.callbackId;
   [[Enhance purchases] manuallyRestorePurchases:self];
}

- (void)getDisplayTitle:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"getDisplayTitle");

   NSString* sku = [command.arguments objectAtIndex: 0];
   NSString* defaultTitle = [command.arguments objectAtIndex: 1];

   NSString* displayTitle = [[Enhance purchases] getDisplayTitle:sku defaultTitle:defaultTitle];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:displayTitle];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];   
}

- (void)getDisplayDescription:(CDVInvokedUrlCommand*)command {
   NSLog(_tag, @"getDisplayDescription");

   NSString* sku = [command.arguments objectAtIndex: 0];
   NSString* defaultDesc = [command.arguments objectAtIndex: 1];

   NSString* displayDesc = [[Enhance purchases] getDisplayDescription:sku defaultDescription:defaultDesc];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:displayDesc];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

// GDPR

- (void)requiresDataConsentOptIn:(CDVInvokedUrlCommand*)command {
    NSLog(_tag, @"requiresDataConsentOptIn");

    _onOptInRequiredCallbackId = command.callbackId;
    [Enhance requiresDataConsentOptIn:self];
}

- (void)serviceTermsOptIn:(CDVInvokedUrlCommand*)command {
    NSLog(_tag, @"serviceTermsOptIn");

    if([command.arguments count] > 0) {
        NSString* sdksString = [command.arguments objectAtIndex: 0];
        
        if(![sdksString isEqualToString:@""]) {
            NSArray* requestedSdks = [sdksString componentsSeparatedByString:@","];
            NSLog(@"For SDKs: %@", [requestedSdks description]);
            [Enhance serviceTermsOptIn:requestedSdks];

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            return;
        }
    }
    
    NSLog(_tag, @"For all SDKs");
    [Enhance serviceTermsOptIn];

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showServiceOptInDialogs:(CDVInvokedUrlCommand*)command {
    NSLog(_tag, @"showServiceOptInDialogs");
    _onDialogCompleteCallbackId = command.callbackId;

    if([command.arguments count] > 0) {
        NSString* sdksString = [command.arguments objectAtIndex: 0];

        if(![sdksString isEqualToString:@""]) {
            NSArray* requestedSdks = [sdksString componentsSeparatedByString:@","];
            NSLog(@"For SDKs: %@", [requestedSdks description]);
            [Enhance showServiceOptInDialogs:requestedSdks delegate:self];
            return;
        }
    }

    NSLog(_tag, @"For all SDKs");
    NSArray* empty = [NSArray new];
    [Enhance showServiceOptInDialogs:empty delegate:self];
}

- (void)serviceTermsOptOut:(CDVInvokedUrlCommand*)command {
    NSLog(_tag, @"serviceTermsOptOut");
    [Enhance serviceTermsOptOut];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
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
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onPurchaseAttemptedCallbackId];    
}

- (void)onPurchaseFailed {
   NSLog(_tag, @"onPurchaseFailed");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:NO];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onPurchaseAttemptedCallbackId];   
}

// Consume callbacks

- (void)onConsumeSuccess {
   NSLog(_tag, @"onConsumeSuccess");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onConsumeAttemptedCallbackId];     
}

- (void)onConsumeFailed {
   NSLog(_tag, @"onConsumeSuccess");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:NO];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onConsumeAttemptedCallbackId]; 
}

// Restore callbacks

- (void)onRestoreSuccess {
   NSLog(_tag, @"onRestoreSuccess");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onManualRestoreCallbackId];   
}

- (void)onRestoreFailed {
   NSLog(_tag, @"onRestoreFailed");

   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:NO];
   [self.commandDelegate sendPluginResult:pluginResult callbackId: _onManualRestoreCallbackId]; 
}

// GDPR callbacks

-(void)onServiceOptInRequirement:(BOOL)isUserOptInRequired {
    NSLog(_tag, @"onServiceOptInRequirement");

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isUserOptInRequired];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_onOptInRequiredCallbackId];
}

-(void)onOptInDialogComplete {
    NSLog(_tag, @"onOptInDialogComplete");

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_onDialogCompleteCallbackId];
}

@end
