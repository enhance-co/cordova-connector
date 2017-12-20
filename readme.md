# Enhance Drag & Drop Library by Enhance, Inc.
# www.enhance.co
# 
# CORDOVA

Setup
-----

Include the provided plugin into your Cordova project.

Note:
You can also obtain the latest version of this plugin on NPM and GitHub:

https://www.npmjs.com/package/enhance-cordova-connector
https://github.com/enhance-co/cordova-connector.git

This can be handy if you use external tool for packing your app, Cocoon.IO for example.

Introduction
------------

Due to nature of JavaScript, most of Enhance functions are based on callbacks. These callbacks can receive different values. If you check ad's availability, it is usually one boolean(true or false), which tells you whether the ad is ready or not. If you are unsure how you should handle a response, please refer to the demo project or documentation.


Interstitial Ads
----------------

Interstitial Ads are short static or video ads, usually shown between levels or when game is over.

1) Check whether any ad is available:

    Enhance.isInterstitialReady(isReadyCallback);

2) Show the ad:
    
    Enhance.showInterstitialAd();

Note:
Interstitial ads will automatically interrupt the flow of your application until the user completes interaction with the ad.


Rewarded Ads
------------

Rewarded Ads are usually video ads which pay high CPM for the users who view them in return for an in-game reward.

1) Check whether any ad is available:

    Enhance.isRewardedAdReady(isReadyCallback);

2) Show the ad

    Enhance.showRewardedAd(onRewardGranted, onRewardDeclined, onRewardUnavailable);

Note:
Rewarded ads will automatically interrupt the flow of your application until the user completes interaction with the ad.


Banner Ads
----------

Banner Ads are small sized ads displayed in the top or bottom of the app.

1) Check whether any ad is available:

    Enhance.isBannerAdReady(isReadyCallback);

2) Display the ad:

    Enhance.showBannerAdWithPosition(Enhance.Position.BOTTOM);

    Available positions:

    Enhance.Position.TOP
    Enhance.Position.BOTTOM

3) Hide the ad:

    Enhance.hideBannerAd();

Note:
You can also integrate Fixed Banner Ads through Enhance ZeroCode with no coding at all.


Offer Walls
-----------

Offer Walls show full screen of real world offers(e.g. surveys), usually with reward offered in return for a completion.

1) Set currency callback. It's called whenever the user receives a reward from offerwall. It's important to do it in the 'deviceready' event.

    Enhance.setReceivedCurrencyCallback(onCurrencyReceived);

2) Check whether any offer wall is available:

    Enhance.isOfferwallReady(isReadyCallback);

3) Display the offer wall:

    Enhance.showOfferwall();

Note:
Offer walls will automatically interrupt the flow of your application until the user completes interaction with the offer wall.


Special Offers
--------------

Special offers are real world offers(e.g. surveys). They are available through Enhance ZeroCode, but now you can also request them from code.

1) Check whether any special offer is available:

    Enhance.isSpecialOfferReady(isReadyCallback);

2) Display the special offer:

    Enhance.showSpecialOffer();

Note:
Special Offers will automatically interrupt the flow of your application until the user completes interaction with the special offer.


Analytics
---------

Enhance can hook into various analytics networks. By default it will track sessions, users and retention.

1) Send a simple analytics event:

    Enhance.logEvent('event_type');

2) Send a detailed analytics event:

    Enhance.logEvent('event_type', 'event_param_key', 'event_param_value');


Local Notifications
-------------------

Local Notifications are reminders displayed on your mobile device's screen after the app becomes inactive.

1) Ask for local notifications permission:

    Enhance.requestLocalNotificationPermission(onPermissionGranted, onPermissionRefused);

2) Enable a new local notification:

    Enhance.enableLocalNotification('title', 'message', 5);

3) Disable the local notification:

    Enhance.disableLocalNotification();

In-App Purchases
----------------

Enhance library provides a set of functions which help you to easily make use of different In-App Purchases SDKs in your application.

1) Check if In-App purchasing is currently supported:

    Enhance.purchases.isSupported(isSupportedCallback);

2) Start the purchase flow for the given product:

    Enhance.purchases.attemptPurchase('product_name', onPurchaseSuccess, onPurchaseFailed);

3) Try to consume the given product from the user's inventory:

    Enhance.purchases.consume('product_name', onConsumeSuccess, onConsumeFailed);

4) Check if item is already owned:

    Enhance.purchases.isItemOwned('product_name', resultCallback);

5) Get the number of the given product that user owns, or 0 if none:

    Enhance.purchases.getOwnedItemCount('product_name', resultCallback);

6) Get the string containing the localized display title:
    
    Enhance.purchases.getDisplayTitle('product_name', 'default_title', resultCallback);

7) Get the string containing the localized display description:

    Enhance.purchases.getDisplayDescription('product_name', 'default_description', resultCallback);

8) Get the string containing the localized display price:

    Enahnce.purchases.getDisplayPrice('product_name', 'default_price', resultCallback);

9) Manually restore purchases and update the user's inventory, if applicable:

    Enhance.purchases.manuallyRestorePurchases(onRestoreSuccess, onRestoreFailed);


Advanced Usage
--------------

Most of Enhance functions accept additional parameters which can be useful for advanced users. For example, instead of simple Enhance.isInterstitialReady(isReadyCallback); you can use Enhance.isInterstitialReady(isReadyCallback, 'my_placement').


Demo Project
--------------

For a full implementation example, please see the demo project which can be found in the 'demo_project' directory within the distribution package.

Please remember that none of these features will work properly before Enhancing your application on our website.