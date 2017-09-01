package com.fgl.enhance.cordova;

import java.util.Arrays;
import java.util.Map;
import android.app.Activity;
import android.util.Log;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CordovaInterface;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import com.fgl.enhance.connector.FglEnhance;
import com.fgl.enhance.connector.FglEnhance.Position;
import com.fgl.enhance.connector.FglEnhanceInAppPurchases.PurchaseCallback;
import com.fgl.enhance.connector.FglEnhanceInAppPurchases.ConsumeCallback;
import com.fgl.enhance.connector.FglEnhanceInAppPurchases;
import com.fgl.enhance.connector.FglEnhancePlus;

// Cordova plugin class

public class CDVEnhance extends CordovaPlugin {
   // Tag for logging
   public static final String TAG = "FglEnhanceCordova";
   
   // Cordova connector version
   private static final String CORDOVA_CONNECTOR_VERSION = "2.5.5";
      
   // Initialize connector
   
   @Override
   public void initialize (CordovaInterface cordova, CordovaWebView webView) {
        super.initialize (cordova, webView);
        Activity activity = cordova.getActivity ();
        Log.d (TAG, "initialize Cordova connector version " + CORDOVA_CONNECTOR_VERSION + " with activity " + activity);
        FglEnhance.initialize (activity);
    }
   
   // Execute Enhance command
   
   @Override
   public boolean execute (String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        // Set interstitial callback

        if (action.equals ("setInterstitialCallback")) {
            try {
                FglEnhance.setInterstitialCallback(new FglEnhance.InterstitialCallback() {
                    @Override
                    public void onInterstitialCompleted() {
                        Log.i (TAG, "onInterstitialCompleted");
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, true));
                    }
                });
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in setInterstitialCallback: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Is interstitial ad ready

        else if (action.equals ("isInterstitialReady")) {
            try {
                String strPlacementType = args.getString (0);
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, FglEnhance.isInterstitialReady(strPlacementType.toLowerCase())));
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in isInterstitialReady: " + e.toString());
                e.printStackTrace ();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        // Show interstitial ad

        else if (action.equals ("showInterstitialAd")) {
            try {
                String strPlacementType = args.getString (0);
                FglEnhance.showInterstitialAd(strPlacementType.toLowerCase());
                callbackContext.success();
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in showInterstitialAd: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Is rewarded ad ready

        else if (action.equals ("isRewardedAdReady")) {
            try {
                String strPlacement = args.getString(0).toLowerCase();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, FglEnhance.isRewardedAdReady(strPlacement)));
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in isRewardedAdReady: " + e.toString());
                e.printStackTrace ();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        // Show rewarded ad

        else if (action.equals ("showRewardedAd")) {
            try {
                String strPlacementType = args.getString (0);

                FglEnhance.showRewardedAd (new FglEnhance.RewardCallback() {
                    @Override
                    public void onRewardGranted(int rewardValue, FglEnhance.RewardType rewardType) {
                        // Reward granted
                        String strRewardType = "";

                        // Match reward type in cordova connector
                        if(rewardType == FglEnhance.RewardType.ITEM) strRewardType = "item";
                        else if(rewardType == FglEnhance.RewardType.COINS) strRewardType = "coins";

                        JSONArray resultArray = new JSONArray();
                        resultArray.put(rewardValue);
                        resultArray.put(strRewardType);

                        Log.i (TAG, "onRewardGranted");
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, resultArray));
                    }
               
                    @Override
                    public void onRewardDeclined() {
                        // Reward declined
                        Log.i (TAG, "onRewardDeclined");
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, "declined"));
                    }
               
                    @Override
                    public void onRewardUnavailable() {
                        // Reward unavailable
                        Log.i (TAG, "onRewardUnavailable");
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, "unavailable"));
                    }
                }, strPlacementType.toUpperCase());
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in showRewardedAd: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Is banner ad ready

        else if (action.equals ("isBannerAdReady")) {
            try {
                String placement = args.getString(0).toLowerCase();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, FglEnhance.isBannerAdReady(placement)));
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in isBannerAdReady: " + e.toString());
                e.printStackTrace ();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        // Show banner ad

        else if (action.equals ("showBannerAdWithPosition")) {
            try {
                String strPosition = args.getString (0);
                String placement = args.getString(1).toLowerCase();
            
                Position pos = Position.TOP;

                if (strPosition != null && strPosition.toUpperCase().equals("BOTTOM"))
                    pos = Position.BOTTOM;

                FglEnhance.showBannerAdWithPosition(placement, pos);
                callbackContext.success();
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in showBannerAdWithPosition: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Hide banner ad

        else if (action.equals ("hideBannerAd")) {
            try {
                FglEnhance.hideBannerAd();
                callbackContext.success();
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in hideBannerAd: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Is special offer ready

        else if (action.equals ("isSpecialOfferReady")) {
            try {
                String placement = args.getString(0).toLowerCase();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, FglEnhance.isSpecialOfferReady(placement)));
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in isSpecialOfferReady: " + e.toString());
                e.printStackTrace ();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        // Show special offer

        else if (action.equals ("showSpecialOffer")) {
            try {
                String placement = args.getString(0).toLowerCase();

                FglEnhance.showSpecialOffer(placement);
                callbackContext.success();
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in showSpecialOffer: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Is offerwall ready

        else if (action.equals ("isOfferwallReady")) {
            try {
                String placement = args.getString(0).toLowerCase();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, FglEnhance.isOfferwallReady(placement)));
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in isOfferwallReady: " + e.toString());
                e.printStackTrace ();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        // Show offerwall

        else if (action.equals ("showOfferwall")) {
            try {
                String placement = args.getString(0).toLowerCase();

                FglEnhance.showOfferwall(placement);
                callbackContext.success();
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in showOfferwall: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Set currency received callback (offerwall)

        else if(action.equals("setCurrencyReceivedCallback")) {
            try {
                FglEnhance.setCurrencyCallback (new FglEnhance.CurrencyCallback() {
                    @Override
                    public void onCurrencyGranted(int currencyAmount) {
                        Log.i (TAG, "onCurrencyGranted");
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, currencyAmount));
                    }
                });
                return true;
            } catch(Exception e) {
                Log.e(TAG, "exception in setCurrencyCallback: " + e.toString());
                e.printStackTrace();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        // Log analytics event

        else if (action.equals ("logEvent")) {
            try {
                String eventType = args.getString (0);
                String eventParamKey = args.getString (1);
                String eventParamValue = args.getString (2);

                if (eventParamKey != "" && eventParamValue != "")
                    FglEnhance.logEvent(eventType, eventParamKey, eventParamValue);
                else // Use the simplified version of event logging
                    FglEnhance.logEvent(eventType);
            
                callbackContext.success();
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in logEvent: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Log message (debug)

        else if (action.equals ("logMessage")) {
            try {
                String msgTag = args.getString (0);
                String msgMessage = args.getString (1);

                FglEnhancePlus.logMessage(msgTag, msgMessage);
                callbackContext.success();
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in logMessage: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Request local notification permission

        else if (action.equals ("requestLocalNotificationPermission")) {
            try {
                FglEnhance.requestLocalNotificationPermission(new FglEnhance.PermissionCallback() {
                    @Override
                    public void onPermissionGranted() {
                        Log.i (TAG, "onPermissionGranted");               
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, true));
                    }

                    @Override
                    public void onPermissionRefused() {
                        Log.i (TAG, "onPermissionRefused");               
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));;
                    }         
                });

                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in requestLocalNotificationsPermission: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Enable local notification

        else if (action.equals ("enableLocalNotification")) {
            try {
                String title = args.getString (0);
                String message = args.getString (1);
                int delay = args.getInt (2);

                FglEnhance.enableLocalNotification(title,  message, delay);
                callbackContext.success();
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in logMessage: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Disable local notification

        else if (action.equals ("disableLocalNotification")) {
            try {
                FglEnhance.disableLocalNotification();
                callbackContext.success();
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in disableLocalNotifications: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Is purchasing supported

        else if (action.equals ("isPurchasingSupported")) {
            try {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, FglEnhanceInAppPurchases.isSupported()));
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in isPurchasingSupported: " + e.toString());
                e.printStackTrace ();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        // Attempt purchase

        else if (action.equals ("attemptPurchase")) {
            try {
                String sku = args.getString (0);

                FglEnhanceInAppPurchases.attemptPurchase(sku, new PurchaseCallback() {
                    @Override
                    public void onPurchaseSuccess() {                       
                        Log.i (TAG, "onPurchaseSuccess");               
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, true));
                    }

                    @Override
                    public void onPurchaseFailed() {
                        Log.i (TAG, "onPurchaseFailed");                
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
                    }                 
                });      

                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in attemptPurchase: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Purchase consumption

        else if (action.equals ("consumePurchase")) {
            try {
                String sku = args.getString (0);

                FglEnhanceInAppPurchases.consume(sku, new ConsumeCallback() {
                    @Override
                    public void onConsumeSuccess() {                        
                        Log.i (TAG, "onConsumeSuccess");                
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, true));
                    }

                    @Override
                    public void onConsumeFailed() {
                        Log.i (TAG, "onConsumeFailed");             
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
                    }                   
                });      

                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in consumePurchase: " + e.toString());
                e.printStackTrace ();
                callbackContext.success();
            }
        }

        // Get display price

        else if (action.equals ("getDisplayPrice")) {
            try {
                String sku = args.getString (0);
                String defaultPrice = args.getString (1);
                String displayPrice = FglEnhanceInAppPurchases.getDisplayPrice(sku, defaultPrice);
            
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, displayPrice));
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in getDisplayPrice: " + e.toString());
                e.printStackTrace ();

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        // Is item owned

        else if (action.equals ("isItemOwned")) {
            try {
                String sku = args.getString (0);
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, FglEnhanceInAppPurchases.isItemOwned(sku)));
                return true;
            } catch (Exception e) {
                Log.e (TAG, "exception in isItemOwned: " + e.toString());
                e.printStackTrace ();   
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }  

        // Get owned item count

        else if(action.equals("getOwnedItemCount")) {
            try {
                String sku = args.getString(0);
                int ownedItemCount = FglEnhanceInAppPurchases.getOwnedItemCount(sku);

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ownedItemCount)); 
                return true;    
            } catch(Exception e) {
                Log.e(TAG, "exception in getOwnedItemCount: " + e.toString());
                e.printStackTrace();

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        // Unknown action

        else {
            Log.e (TAG, "Unknown action requested: \"" + action + "\", args: " + args);
        }

        return false;
    }
}
