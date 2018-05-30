var exec = require('cordova/exec');

 /**
  * @namespace
 */

var Enhance = {
    /**
     * 'resultCallback' is used to handle response from functions like isInterstitialReady, isRewardedAdReady, etc.
     * @callback Enhance~resultCallback
     * @param {boolean} result for example - ad's availability
     */

    serviceName : 'Enhance',

    /**
     * @readonly
     * @enum {string}
     * Rewarded ad available placements
     */

    Placement: {
        NEUTRAL : 'neutral',
        SUCCESS : 'success', 
        HELPER : 'helper'
    },

    /** 
     * @readonly
     * @enum {string}
     * Banner ad available positions 
     */

    Position: {
        TOP : 'top',
        BOTTOM : 'bottom'
    },

    /** 
     * @readonly
     * @enum {string}
     * Possible reward types 
     */

    RewardType: {
        ITEM : 'item',
        COINS : 'coins'
    },
    
    /**
     * Check whether an interstitial ad is ready to be shown
     *
     * @param {resultCallback} resultCallback - callback to handle response(true if ad is ready, false if not)
     * @param {string} [placement] - optional custom placement for the ad
     *
     * @example
     * Enhance.isInterstitialReady(showAdCallback);
     *
     * @example
     * Enhance.isInterstitialReady('my_placement', showAdCallback)
     */

    isInterstitialReady : function(resultCallback, placement) {
        if(typeof placement !== 'string') 
            placement = 'default';

        exec(resultCallback, null, Enhance.serviceName, 'isInterstitialReady', [placement]);
    },

    /**
     * Show an interstitial ad
     *
     * @param {string} [placement] - optional custom placement for the ad
     *
     * @example
     * Enhance.showInterstitialAd();
     *
     * @example
     * Enhance.showInterstitialAd('my_placement');
     */

    showInterstitialAd : function(placement) {
        if(typeof placement !== 'string') 
            placement = 'default';

        exec(null, null, Enhance.serviceName, 'showInterstitialAd', [placement]);
    },

    /**
     * @private
     * Set optional interstitial completion callback.
     * We can't guarantee it will always work, use at your own risk!
     */

    setInterstitialCallback : function(onInterstitialCompletedCallback) {
        exec(onInterstitialCompletedCallback, null, Enhance.serviceName, 'setInterstitialCallback',[]);
    },

    /**
     * Check whether a rewarded ad is ready to be shown 
     *
     * @param {resultCallback} resultCallback - callback to handle response(true if ad is ready, false if not)
     * @param {string} [placement] - optional custom placement for the ad, you can use a predefined one(check 'placement' object)
     *
     * @example
     * Enhance.isRewardedAdReady(showAdCallback);
     * 
     * @example
     * Enhance.isRewardedAdReady(showAdCallback, 'my_placement');
     *
     * @example
     * Enhance.isRewardedAdReady(EshowAdCallback, Enhance.Placement.SUCCESS);
     */

    isRewardedAdReady : function(resultCallback, placement) {
        if(typeof placement !== 'string') 
            placement = Enhance.Placement.NEUTRAL;

        exec(resultCallback, null, Enhance.serviceName, 'isRewardedAdReady', [placement]);
    },

    /**
     * Show a rewarded ad
     *
     * @param {resultCallback} onRewardGrantedCallback - callback to handle situation when reward is granted (gets two parameters - rewardValue and rewardType)
     * @param {resultCallback} onRewardDeclinedCallback - callback to handle situation when reward is declined
     * @param {resultCallback} onRewardUnavailableCallback - callback to handle situation when reward is unavailable
     * @param {string} [placement] - optional custom placement for the ad, you can use a predefined one(check 'placement' object) 
     *
     * @example
     * Enhance.showRewardedAd(onRewardGranted, onRewardDeclined, onRewardUnavailable);
     *
     * @example
     * Enhance.showRewardedAd(onRewardGranted, onRewardDeclined, onRewardUnavailable, Enhance.Placement.NEUTRAL);
     */

    /** @private */
    onRewardGrantedCallback : null,
    /** @private */
    onRewardDeclinedCallback : null,
    /** @private */
    onRewardUnavailableCallback : null,

    showRewardedAd : function(onRewardGrantedCallback, onRewardDeclinedCallback, onRewardUnavailableCallback, placement) {
        if(typeof placement !== 'string') 
            placement = Enhance.Placement.NEUTRAL;

        Enhance.onRewardGrantedCallback = onRewardGrantedCallback;
        Enhance.onRewardDeclinedCallback = onRewardDeclinedCallback;
        Enhance.onRewardUnavailableCallback = onRewardUnavailableCallback;

        exec(Enhance.handleRewardedAdResult, null, Enhance.serviceName, 'showRewardedAd', [placement]);
    },

    /**
     * @private
     * Handle a rewarded ad response and call the right function
     */

    handleRewardedAdResult : function(result) {
        if(result == 'declined') {
            if(Enhance.onRewardDeclinedCallback != null) Enhance.onRewardDeclinedCallback();
        }
        else if(result == 'unavailable') {
            if(Enhance.onRewardUnavailableCallback != null) Enhance.onRewardUnavailableCallback();
        } 
        else if(result != null){
            // Pass rewardValue[0] & rewardType[1]
            if(Enhance.onRewardGrantedCallback != null) Enhance.onRewardGrantedCallback(result[0], result[1]);
        }
    },

    /**
     * Check whether a banner ad is ready to be shown
     *
     * @param {resultCallback} resultCallback - callback to handle response(true if ad is ready, false if not)
     * @param {string} [placement] - optional custom placement for the ad
     *
     * @example
     * Enhance.isBannerAdReady(showAd);
     * 
     * @example
     * Enhance.isBannerAdReady(showAd, 'my_placement')
     */

    isBannerAdReady : function(resultCallback, placement) {
        if(typeof placement !== 'string') 
            placement = 'default';

        exec(resultCallback, null, Enhance.serviceName, 'isBannerAdReady', [placement]);
    },

    /**
     * Show a banner ad
     *
     * @param {string} [position] - position of the banner, see the 'Position' object
     * @param {string} [placement] - optional custom placement for the ad
     *
     * @example
     * Enhance.showBannerAdWithPosition();
     *
     * @example
     * Enhance.showBannerAdWithPosition(Enhance.Position.TOP);
     *
     * @example
     * Enhance.showBannerAdWithPosition(Enhance.Position.BOTTOM, 'my_placement');
     */

    showBannerAdWithPosition : function(position, placement) {
        if(typeof position !== 'string') 
            position = Enhance.Position.BOTTOM;
        if(typeof placement !== 'string') 
            placement = 'default';

        exec(null, null, Enhance.serviceName, 'showBannerAdWithPosition', [position, placement]);
    },

    /**
     * Hide a banner ad, if any is shown
     *
     * @example
     * Enhance.hideBannerAd();
     */

    hideBannerAd : function() {
        exec(null, null, Enhance.serviceName, 'hideBannerAd', []);
    },

    /**
     * @deprecated
     */

    isOverlayAdReady : function(resultCallback, placement) {
        if(typeof placement != 'string') 
            placement = 'default';

        Enhance.isBannerAdReady(resultCallback, placement);
    },

    /**
     * @deprecated
     */

    showOverlayAdWithPosition : function(position, placement) {
        if(typeof position !== 'string') 
            placement = Enhance.Position.BOTTOM;
        if(typeof placement !== 'string') 
            placement = 'default';

        Enhance.showBannerAdWithPosition(position, placement);
    },

    /**
     * @deprecated
     */

    hideOverlayAd : function() {
        Enhance.hideBannerAd();
    },

    /**
     * Check whether a special offer is ready to be shown
     *
     * @param {resultCallback} resultCallback - callback to handle response(true if ad is ready, false if not)
     * @param {string} [placement] - optional custom placement for the ad
     *
     * @example
     * Enhance.isSpeciallOfferReady(showAd);
     *
     * @example
     * Enhance.isSpecialOfferReady(showAd, 'my_placement');
     */

    isSpecialOfferReady : function(resultCallback, placement) {
        if(typeof placement !== 'string') 
            placement = 'default';

        exec(resultCallback, null, Enhance.serviceName, 'isSpecialOfferReady', [placement]);
    },

    /**
     * Show a special offer
     *
     * @param {string} [placement] - optional custom placement for the ad
     *
     * @example
     * Enhance.showSpecialOffer();
     *
     * @example
     * Enhance.showSpecialOffer('my_placement');
     */

    showSpecialOffer : function(placement) {
        if(typeof placement !== 'string') 
            placement = 'default';

        exec(null, null, Enhance.serviceName, 'showSpecialOffer', [placement]);
    },

    /**
     * Check whether an offerwall is ready to be shown
     *
     * @param {resultCallback} resultCallback - callback to handle response(true if ad is ready, false if not)
     * @param {string} [placement] - optional custom placement for the ad
     *
     * @example
     * Enhance.isOfferwallReady(showAd);
     *
     * @example
     * Enhance.isOfferwallReady(showAd, 'my_placement');
     */

    isOfferwallReady : function(resultCallback, placement) {
        if(typeof placement !== 'string') 
            placement = 'default';

        exec(resultCallback, null, Enhance.serviceName, 'isOfferwallReady', [placement]);
    },

    /** @private */
    _currencyReceivedCallback : null,

    /**
     * Show an offerwall
     *
     * @param {string} [placement] - optional custom placement for the ad   
     *
     * @example
     * Enhance.showOfferwall();
     *
     * @example
     * Enhance.showOfferwall('my_placement');
     */

    showOfferwall : function(placement) {
        if(typeof placement !== 'string') 
            placement = 'default';

        exec(Enhance._currencyReceivedCallback, null, Enhance.serviceName, 'setCurrencyReceivedCallback', []);
        exec(null, null, Enhance.serviceName, 'showOfferwall', [placement]);
    },

    /**
     * @deprecated
     * Set the callback to be triggered when currency is received from an offerwall
     * @param {function} onCurrencyReceivedCallback - should accept a single numeric argument which specifies the amount of currency received
     */

    setCurrencyReceivedCallback : function(onCurrencyReceivedCallback) {
        Enhance._currencyReceivedCallback = onCurrencyReceivedCallback;
    },

    /**
     * Set the callback to be triggered when currency is received from an offerwall
     * @param {function} onCurrencyReceivedCallback - should accept a single numeric argument which specifies the amount of currency received
     */

     setReceivedCurrencyCallback : function(onCurrencyReceivedCallback) {
        Enhance._currencyReceivedCallback = onCurrencyReceivedCallback;
    },

    /**
     * Request a permission to schedule local notifications
     *
     * @param {function} [onPermissionGrantedCallback] - callback to handle situation when permission is granted
     * @param {function} [onPermissionRefusedCallback] - callback to handle situation when permission is refused
     *
     * @example
     * Enhance.requestLocalNotificationPermission(onPermissionGranted, onPermissionRefused);
     */

    /** @private */
    _onPermissionGrantedCallback : null,
    /** @private */
    _onPermissionRefusedCallback : null,

    requestLocalNotificationPermission : function(onPermissionGrantedCallback, onPermissionRefusedCallback) {
        Enhance._onPermissionGrantedCallback = onPermissionGrantedCallback;
        Enhance._onPermissionRefusedCallback = onPermissionRefusedCallback;

        exec(Enhance._handleLocalNotificationPermissionResult, null, Enhance.serviceName, 'requestLocalNotificationPermission', []);
    },

    /**
     * @private
     * Handle local notification permission result(granted/refused)
     */

    _handleLocalNotificationPermissionResult : function(result) {
        if(result) {
            if(Enhance._onPermissionGrantedCallback != null) Enhance._onPermissionGrantedCallback();
        } else {
            if(Enhance._onPermissionRefusedCallback != null) Enhance._onPermissionRefusedCallback();
        }
    },

    /**
     * Enable a new local notification
     *
     * @param {string} title - title of the local notification
     * @param {string} message - message of the local notification
     * @param {number} delaySeconds - seconds to wait before showing the local notification (after the app deactivation)
     *
     * @example
     * Enhance.enableLocalNotification('Enhance', 'Local Notification!', 5);
     */

    enableLocalNotification : function(title, message, delaySeconds) {
        if(typeof title !== 'string') 
            title = 'default';
        if(typeof message !== 'string') 
            message = 'default';
        if(typeof delaySeconds !== 'number') 
            delaySeconds = 5;

        exec(null, null, Enhance.serviceName, 'enableLocalNotification', [title, message, delaySeconds]);
    },

    /**
     * Disable any currently scheduled local notification
     *
     * @example
     * Enhance.disableLocalNotification();
     */

    disableLocalNotification : function() {
        exec(null, null, Enhance.serviceName, 'disableLocalNotification', []);
    },

    /**
     * Send an event to the hooked analytics networks
     *
     * @param {string} eventType - type/name of the event
     * @param {string} [paramKey] - optional parameter key
     * @param {string} [paramValue] - optional parameter value 
     *
     * @example
     * Enhance.logEvent('game_start');
     *
     * @example 
     * Enhance.logEvent('game_over', 'level', '2');
     */

    logEvent: function(eventType, paramKey, paramValue) {
        if(typeof eventType !== 'string') 
            eventType = 'default';
        if(typeof paramKey !== 'string') 
            paramKey = '';
        if(typeof paramValue !== 'string') 
            paramValue = '';        

        exec(null, null, Enhance.serviceName, 'logEvent', [eventType, paramKey, paramValue]);
    },

    /**
     * @private
     * Log debug message
     *
     * @param {string} tag - tag of the message
     * @param {string} msg - text of the message 
     */

    logMessage : function(tag, msg) {
        if(typeof tag !== 'string') 
            tag = '';
        if(typeof msg !== 'string') 
            msg = '';

        exec(null, null, Enhance.serviceName, 'logMessage', [tag, msg]);
    },

    requiresDataConsentOptIn : function(onServiceOptInRequirementCallback) {
        exec(onServiceOptInRequirementCallback, null, Enhance.serviceName, "requiresDataConsentOptIn", []);
    },

    serviceTermsOptIn : function(requestedSdks) {
        var requestedSdksAsString = '';

        if(requestedSdks != null && requestedSdks['toString'] != null) {
            requestedSdksAsString = requestedSdks.toString();
        }

        exec(null, null, Enhance.serviceName, "serviceTermsOptIn", [requestedSdksAsString]);
    },

    showServiceOptInDialogs : function(requestedSdks, onDialogCompleteCallback) {
        var requestedSdksAsString = '';

        if(requestedSdks != null && requestedSdks['toString'] != null) {
            requestedSdksAsString = requestedSdks.toString();
        }

        exec(onDialogCompleteCallback, null, Enhance.serviceName, "showServiceOptInDialogs", [requestedSdksAsString]);
    },

    serviceTermsOptOut : function() {
        exec(null, null, Enhance.serviceName, "serviceTermsOptOut", []);
    },

    /** 
     * @private
     * Object containing IAP support
     */

    purchases : {

        /**
         * @private
         * Check if in app purchases are currently enabled
         *
         * @param {resultCallback} resultCallback - handle response (true if IAP supported, false if not)
         */

        isSupported : function(resultCallback) {
            exec(resultCallback, null, Enhance.serviceName, 'isPurchasingSupported', []);
        }, 

        /**
         * @private
         * Starts the purchase flow
         *
         * @param {string} sku - unique product id
         * @param {function} [onPurchaseSuccessCallback] - handle situation when purchase succeeded
         * @param {function} [onPurchaseFailedCallback] - handle situation when purchase failed
         */

         /** @private */
        _onPurchaseFailedCallback : null,
        /** @private */
        _onPurchaseSuccessCallback : null,

        attemptPurchase : function(sku, onPurchaseSuccessCallback, onPurchaseFailedCallback) {
            if(typeof sku !== 'string') 
                sku = '';

            Enhance.purchases._onPurchaseSuccessCallback = onPurchaseSuccessCallback;
            Enhance.purchases._onPurchaseFailedCallback = onPurchaseFailedCallback;

            exec(Enhance.purchases._handleAttemptPurchaseResult, null, Enhance.serviceName, 'attemptPurchase', [sku]);
        },

        /**
         * @private
         * Call a proper function when purchase attempt is done
         */

        _handleAttemptPurchaseResult : function(result) {
            if(result) {
                if(Enhance.purchases._onPurchaseSuccessCallback != null) Enhance.purchases._onPurchaseSuccessCallback();
            } else {
                if(Enhance.purchases._onPurchaseFailedCallback != null) Enhance.purchases._onPurchaseFailedCallback();
            }
        },

        /**
         * @private
         * Get a string containing the localised display price, e.g. "Free", "$1.23", "¥1234", "1234,56 zł"
         *
         * @param {string} sku - unique product id
         * @param {string} defaultPrice - default product price
         * @param {function} resultCallback - receives result string
         */

        getDisplayPrice : function(sku, defaultPrice, resultCallback) {
            if(typeof sku !== 'string') 
                sku = '';
            if(typeof defaultPrice !== 'string') 
                defaultPrice = '';

            exec(resultCallback, null, Enhance.serviceName, 'getDisplayPrice', [sku, defaultPrice]);
        },

        /**
         * @private
         * Check if the user has purchased a certain SKU and still has it in their inventory.
         * 
         * @param {string} sku - unique product id
         * @param {function} resultCallback - receives result boolean (true/false)
         */

        isItemOwned : function(sku, resultCallback) {
            if(typeof sku !== 'string') 
                sku = '';

            exec(resultCallback, null, Enhance.serviceName, 'isItemOwned', [sku]);
        },

        /**
         * @private
         * Get the number of the given SKU the user owns, or 0 if none. This can be useful for consumables.
         *
         * @param {string} sku - unique product id
         * @param {function} resultCallback - receives result integer
         */

        getOwnedItemCount : function(sku, resultCallback) {
            if(typeof sku !== 'string') 
                sku = '';

            exec(resultCallback, null, Enhance.serviceName, 'getOwnedItemCount', [sku]);
        },

        /** @private */
        _onConsumeSuccessCallback : null, 
        /** @private */
        _onConsumeFailedCallback : null,

        /**
         * @private
         * Consume the given SKU from the users inventory
         *
         * @param {string} sku - unique product id
         * @param {function} [onConsumeSuccessCallback] - handle situation when consumption succeeded
         * @param {function} [onConsumeFailedCallback] - handle situation when consumption failed
         */

        consume : function(sku, onConsumeSuccessCallback, onConsumeFailedCallback) {
            if(typeof sku !== 'string')
                sku = '';

            Enhance.purchases._onConsumeSuccessCallback = onConsumeSuccessCallback;
            Enhance.purchases._onConsumeFailedCallback = onConsumeFailedCallback;

            exec(Enhance.purchases._handleConsumeResult, null, Enhance.serviceName, 'consumePurchase', [sku]);
        },

        /**
         * @private
         * call a proper function when consumption attempt is done
         */

        _handleConsumeResult : function(result) {
            if(result) {
                if(Enhance.purchases._onConsumeSuccessCallback != null) Enhance.purchases._onConsumeSuccessCallback();
            } else {
                if(Enhance.purchases._onConsumeFailedCallback != null) Enhance.purchases._onConsumeFailedCallback();
            }
        },

        /** @private */
        _onRestoreSuccessCallback : null,
        /** @private */
        _onRestoreFailedCallback : null,

        /**
         * @private
         * Manually restore purchases information
         *
         * @param {function} [onRestoreSuccessCallback] - handle situation when restore succeeded
         * @param {function} [onRestoreFailedCallback] - handle situation when restore failed
         */

        manuallyRestorePurchases : function(onRestoreSuccessCallback, onRestoreFailedCallback) {
            Enhance.purchases._onRestoreSuccessCallback = onRestoreSuccessCallback;
            Enhance.purchases._onRestoreFailedCallback = onRestoreFailedCallback;

            exec(Enhance.purchases._handleRestoreResult, null, Enhance.serviceName, 'manuallyRestorePurchases', []);
        },

        /** @private */

        _handleRestoreResult : function(result) {
            if(result) {
                if(Enhance.purchases._onRestoreSuccessCallback != null) Enhance.purchases._onRestoreSuccessCallback();
            } else {
                if(Enhance.purchases._onRestoreFailedCallback != null) Enhance.purchases._onRestoreFailedCallback();
            }
        },

        getDisplayTitle : function(sku, defaultTitle, resultCallback) {
            if(typeof sku !== 'string')
                sku = '';

            if(typeof defaultTitle !== 'string')
                defaultTitle = '';

            exec(resultCallback, null, Enhance.serviceName, 'getDisplayTitle', [sku, defaultTitle]);
        },

        getDisplayDescription : function(sku, defaultDescription, resultCallback) {
            if(typeof sku !== 'string')
                sku = '';

            if(typeof defaultDescription !== 'string')
                sku = '';

            exec(resultCallback, null, Enhance.serviceName, 'getDisplayDescription', [sku, defaultDescription]);
        }
    }
};

module.exports = Enhance;
