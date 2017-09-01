#import <Cordova/CDVPlugin.h>
#import "FglEnhance.h"
#import "FglEnhancePlus.h"
#import "FglEnhanceInAppPurchases.h"

@interface CDVEnhance : CDVPlugin<InterstitialDelegate, RewardDelegate, PermissionDelegate, CurrencyGrantedDelegate, PurchaseDelegate>

- (void)isInterstitialReady:(CDVInvokedUrlCommand*)command;
- (void)showInterstitialAd:(CDVInvokedUrlCommand*)command;
- (void)setInterstitialCallback:(CDVInvokedUrlCommand*)command;
- (void)isRewardedAdReady:(CDVInvokedUrlCommand*)command;
- (void)showRewardedAd:(CDVInvokedUrlCommand*)command;
- (void)isBannerAdReady:(CDVInvokedUrlCommand*)command;
- (void)showBannerAdWithPosition:(CDVInvokedUrlCommand*)command;
- (void)hideBannerAd:(CDVInvokedUrlCommand*)command;
- (void)isSpecialOfferReady:(CDVInvokedUrlCommand*)command;
- (void)showSpecialOffer:(CDVInvokedUrlCommand*)command;
- (void)isOfferwallReady:(CDVInvokedUrlCommand*)command;
- (void)showOfferwall:(CDVInvokedUrlCommand*)command;
- (void)requestLocalNotificationPermission:(CDVInvokedUrlCommand*)command;
- (void)enableLocalNotification:(CDVInvokedUrlCommand*)command;
- (void)disableLocalNotification:(CDVInvokedUrlCommand*)command;
- (void)logEvent:(CDVInvokedUrlCommand*)command;
- (void)setCurrencyReceivedCallback:(CDVInvokedUrlCommand*)command;
- (void)logMessage:(CDVInvokedUrlCommand*)command;
- (void)isPurchasingSupported:(CDVInvokedUrlCommand*)command;
- (void)attemptPurchase:(CDVInvokedUrlCommand*)command;
- (void)getDisplayPrice:(CDVInvokedUrlCommand*)command;
- (void)isItemOwned:(CDVInvokedUrlCommand*)command;

@end
