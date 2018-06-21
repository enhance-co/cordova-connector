# Enhance Drag & Drop Library by Enhance, Inc.
# https://enhance.co/documentation
# 
# CORDOVA

Setup
-----

Include the provided plugin into your Cordova project. There are different ways to do that, depending on which tools you use. 

Cordova CLI:

Run the following lines in the terminal:
cd path/to/my/project
cordova plugin add enhance-cordova-connector

Cocoon.IO:

Go to the Settings page and switch to the Plugins section. From the list on the left side, pick the Custom option and enter the following Git Url and press the Install button: 

https://github.com/enhance-co/cordova-connector.git

Others:

You can obtain the connector directly from the NPM and GitHub:
https://www.npmjs.com/package/enhance-cordova-connector
https://github.com/enhance-co/cordova-connector.git


Interstitial Ads
----------------

Interstitial Ads are short static or video ads, usually shown between levels or when game is over. 


Example Usage:

var callback = function(result) {
    if(!result) {
        app.writeLog('Interstitial ad is not ready');
        return;
    }

    Enhance.showInterstitialAd();
};

Enhance.isInterstitialReady(callback);


Methods:

void Enhance.isInterstitialReady(
    resultCallback,
    placement = 'default'
)

Check if an interstitial ad from any of the included SDK providers is ready to be shown.
Placement is optional and specifies an internal placement (from the Enhance mediation editor). 
Returns true to callback if any ad is ready, false otherwise.


void Enhance.showInterstitialAd(
    placement = 'default'
)

Display a new interstitial ad if any is currently available. The ad provider is selected based on your app's mediation settings. 
Placement is an optional internal placement (from the Enhance mediation editor).
Returns nothing.


Rewarded Ads
------------

Rewarded Ads are usually full-screen video ads which users can view to receive a reward inside the application, like an additional in-game currency or a health bonus.


Example Usage:

var callback = function(result) {
    if(!result) {
        app.writeLog('Rewarded ad is not ready');
        return;
    }

    // The ad is ready
    var onRewardGranted = function(rewardValue, rewardType) {
        if(rewardType == Enhance.RewardType.ITEM) 
            app.writeLog("Reward granted (item)");

        else if(rewardType == Enhance.RewardType.COINS)
            app.writeLog("Reward granted (coins), value: " + rewardValue);
    };

    var onRewardDeclined = function() {
        app.writeLog('Reward declined');
    };

    var onRewardUnavailable = function() {
        app.writeLog('Reward unavailable');
    };

    Enhance.showRewardedAd(onRewardGranted, onRewardDeclined, onRewardUnavailable);
};

Enhance.isRewardedAdReady(callback);


Methods:

void Enhance.isRewardedAdReady(
    resultCallback,
    placement = 'neutral'
)

Check if a rewarded ad from any of the included SDK providers is ready to be shown.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns true to callback if any ad is ready, false otherwise.


void Enhance.showRewardedAd(
    onRewardGrantedCallback,
    onRewardDeclinedCallback,
    onRewardUnavailableCallback,
    placement = 'neutral'
)

Display a new rewarded ad if any is currently available. The ad provider is selected based on your app's mediation settings.
Callbacks specify functions which are invoked when reward is granted, declined or unavailable.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns nothing.


Members:

string Enhance.RewardType.ITEM
The granted reward is a game-defined item.

string Enhance.RewardType.COINS
The granted reward is a specified number of coins.

Banner Ads
----------

Banner Ads are small sized ads displayed on the screen as a rectangle filled with content without interrupting the flow of the app.


Example Usage:

// Toggle banner ad

if(isBannerAdVisible) {
    isBannerAdVisible = false;
    Enhance.hideBannerAd();
}

var callback = function(result) {
    if(!result) {
        app.writeLog('Banner ad is not ready');
        return;
    }

    isBannerAdVisible = true;
    Enhance.showBannerAdWithPosition(Enhance.Position.BOTTOM);
};

Enhance.isBannerAdReady(callback);


Methods:

void Enhance.isBannerAdReady(
    resultCallback,
    placement = 'default'
)

Check if a banner ad from any of the included SDK providers is ready to be shown.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns true to callback if any ad is ready, false otherwise.


void Enhance.showBannerAdWithPosition(
    position,
    placement = 'default'
)

Display a new banner ad if any is currently available. The ad provider is selected based on your app's mediation settings.
Position specifies the position of the ad on the screen.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns nothing.


void Enhance.hideBannerAd()

Hide the banner ad which is currently visible, if any.
Returns nothing.


Members:

string Enhance.Position.TOP
The top of the screen, use to set banner ads position.

string Enhance.Position.BOTTOM
The bottom of the screen, use to set banner ads position.


Offer Walls
-----------

Example usage:

var callback = function(result) {
    if(!result) {
        app.writeLog('Offerwall is not ready');
        return;
    }

    Enhance.setReceivedCurrencyCallback(function(amount) {
        app.writeLog('Currency received: ' + amount);
    });

    Enhance.showOfferwall();
};

Enhance.isOfferwallReady(callback);


Methods:

void Enhance.setReceivedCurrencyCallback(
    onCurrencyReceivedCallback
)

Specify the function which is called every time the user receives a reward from any offerwall. We recommend that you use this function at the beginning of your app’s logic to be sure the callback is ready as soon as an offerwall sends the reward. This could happen at different times, even right after your app starts! As a parameter, this callback will receive an amount of the granted currency (int).
Returns nothing.


void Enhance.isOfferwallReady(
    resultCallback,
    placement = 'default'
)

Check if an offerwall from any of the included SDK providers is ready to be shown.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns true to callback if any offerwall is ready, false otherwise.


void Enhance.showOfferwall(
    placement = 'default'
)

Display a new offerwall if any is currently available. The offerwall provider is selected based on your app's mediation settings.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns nothing.


Special Offers
--------------

Special offers are real world offers (e.g. surveys). They are available through Enhance ZeroCode, but you can also request them manually from code.


Example Usage:

var callback = function(result) {
    if(!result) {
        app.writeLog('Special offer is not ready');
        return;
    }

    Enhance.showSpecialOffer();
};

Enhance.isSpecialOfferReady(callback);


Methods:

void Enhance.isSpecialOfferReady(
    resultCallback,
    placement = 'default'
)

Check if a special offer from any of the included SDK providers is ready to be shown.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns true to callback if any offer is ready, false otherwise.


void Enhance.showSpecialOffer(
    placement = 'default'
)

Display a new special offer if any is currently available. The offer provider is selected based on your app's mediation settings.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns nothing.


Analytics
---------

The connector library allows you to send custom events to the hooked analytics networks.


Example Usage:

Enhance.logEvent('game_over', 'level', '2');
Enhance.logEvent('exit');


Methods:

void Enhance.logEvent(
    eventType,
    paramKey,
    paramValue
)

Send an event with an additional parameter (optional).


Local Notifications
-------------------

Local Notifications are reminders which show up on your screen after the app becomes inactive for a specific amount of time.


Example Usage:

var onPermissionGranted = function() {
    // Success
    Enhance.enableLocalNotification('Game', 'Play me!', 60);
};

var onPermissionRefused = function() {
    // Failure
};

Enhance.requestLocalNotificationPermission(OnPermissionGranted, OnPermissionRefused);


Methods:

void Enhance.requestLocalNotificationPermission(
    onPermissionGrantedCallback,
    onPermissionRefusedCallback
)

Request a permission from the user to show local notifications. This won't have any effect on Android devices as you don't need a permission to schedule local notifications there (onPermissionGrantedCallback will be still fired).
Returns nothing.


void Enhance.enableLocalNotification(
    title,
    message,
    delaySeconds
)

Schedule a new local notification, if possible. The notification will persist until you disable it manually. For example, if you set a notification for 60 seconds, it will invoke this notification 60 seconds after the app is closed every time.
Returns nothing.


void Enhance.disableLocalNotification()
Disable any local notification that was previously enabled.


In-App Purchases
-------------------

The connector library provides a set of functions which help you to make use of different In-App Purchases SDKs in your application.


Example Usage:

var callback = function() {
    var onPurchaseSuccess = function() {
        Enhance.purchases.getDisplayTitle('my_product', 'My product', function(result) {
            alert(result);
        });
    };

    var onPurchaseFailed = function() {
        // Failure
    };

    Enhance.purchases.attemptPurchase('my_product', onPurchaseSuccess, onPurchaseFailed);
};

Enhance.purchases.isSupported(callback);


Methods:

void Enhance.purchases.isSupported(
    resultCallback
)

Check if the In-App Purchasing is currently available in your application.
Returns true to callback if purchasing is available, false otherwise.


void Enhance.purchases.attemptPurchase(
    productName,
    onPurchaseSuccessCallback,
    onPurchaseFailedCallback
)

Start the purchase flow for the given product.
Product name is the reference name which you entered during the Enhance flow. 
Callbacks specify functions which are invoked when purchase is successful or not.
Returns nothing.


void Enhance.purchases.consume(
    productName,
    onConsumeSuccessCallback,
    onConsumeFailedCallback
)

Consume the given product, if applicable (depends on the SDK provider).
Product name is the reference name which you entered during the Enhance flow.
Callbacks specify functions which are invoked when consume is successful or not.
Returns nothing.


void Enhance.purchases.isItemOwned(
    productName,
    resultCallback
)


Check if the given product is already owned. The result may be inaccurate, depending on whether the SDK provider stores the information about your products or not.
Product name is the reference name which you entered during the Enhance flow.
Returns true to callback if the item is owned, false otherwise.


void Enhance.purchases.getOwnedItemCount(
    productName,
    resultCallback
)

Get a number of the given product that user owns, or 0 if none. The result may be inaccurate, depending on whether the SDK provider stores the information about your products or not.
Product name is the reference name which you entered during the Enhance flow.
Returns a number of the given product copies to callback.


void Enhance.purchases.manuallyRestorePurchases(
    onRestoreSuccessCallback,
    onRestoreFailedCallback
)

Manually restore purchases and update the user's inventory, if applicable (availability of this feature depends on the SDK provider).
Callbacks specify functions which are invoked when restore is successful or not.
Returns nothing.


void Enhance.purchases.getDisplayPrice(
    productName,
    defaultPrice,
    resultCallback
)

Get a localized display price of the given product, for example: "100zł", "100¥".
Product name is the reference name which you entered during the Enhance flow.
Default price will be used if a real one can't be fetched. 
Returns a string containing the localized display price to callback.


void Enhance.purchases.getDisplayTitle(
    productName,
    defaultTitle,
    resultCallback
)

Get a localized display title of the given product.
Product name is the reference name which you entered during the Enhance flow.
Default title will be used if a real one can't be fetched.
Returns a string containing the localized display title to callback.


void Enhance.purchases.getDisplayDescription(
    productName,
    defaultDescription,
    resultCallback
)

Get a localized display description of the given product.
Product name is the reference name which you entered during the Enhance flow.
Default description will be used if a real one can't be fetched.
Returns a string containing the localized display description to callback.


Demo Project
--------------

For a full implementation example, please see the demo project which can be found in the 'demo_project' directory within the distribution package.

