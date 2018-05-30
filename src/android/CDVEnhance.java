package co.enhance.cordova.enhance;

import java.util.Arrays;
import java.util.Map;
import java.util.List;
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

import co.enhance.Enhance;
import co.enhance.EnhanceInAppPurchases;

// Cordova plugin class

public class CDVEnhance extends CordovaPlugin {
   // Tag for logging
   public static final String TAG = "EnhanceCordova";
   
   // Cordova connector version
   private static final String CORDOVA_CONNECTOR_VERSION = "3.0.0";
      
   // Initialize connector
   
   @Override
   public void initialize (CordovaInterface cordova, CordovaWebView webView) {
        super.initialize (cordova, webView);
        Activity activity = cordova.getActivity ();
        Log.d (TAG, "initialize Cordova connector version " + CORDOVA_CONNECTOR_VERSION + " with activity " + activity);
        Enhance.initialize (activity);
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
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, Enhance.isInterstitialReady(strPlacementType.toLowerCase())));
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
                Enhance.showInterstitialAd(strPlacementType.toLowerCase());
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
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, Enhance.isRewardedAdReady(strPlacement)));
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

                Enhance.showRewardedAd (new Enhance.RewardCallback() {
                    @Override
                    public void onRewardGranted(int rewardValue, Enhance.RewardType rewardType) {
                        // Reward granted
                        String strRewardType = "";

                        // Match reward type in cordova connector
                        if(rewardType == Enhance.RewardType.ITEM) strRewardType = "item";
                        else if(rewardType == Enhance.RewardType.COINS) strRewardType = "coins";

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
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, Enhance.isBannerAdReady(placement)));
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
            
                Enhance.Position pos = Enhance.Position.TOP;

                if (strPosition != null && strPosition.toUpperCase().equals("BOTTOM"))
                    pos = Enhance.Position.BOTTOM;

                Enhance.showBannerAdWithPosition(placement, pos);
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
                Enhance.hideBannerAd();
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
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, Enhance.isSpecialOfferReady(placement)));
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

                Enhance.showSpecialOffer(placement);
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
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, Enhance.isOfferwallReady(placement)));
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

                Enhance.showOfferwall(placement);
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
                Enhance.setReceivedCurrencyCallback (new Enhance.CurrencyCallback() {
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
                    Enhance.logEvent(eventType, eventParamKey, eventParamValue);
                else // Use the simplified version of event logging
                    Enhance.logEvent(eventType);
            
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
                Enhance.requestLocalNotificationPermission(new Enhance.PermissionCallback() {
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

                Enhance.enableLocalNotification(title,  message, delay);
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
                Enhance.disableLocalNotification();
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

                Enhance.purchases.attemptPurchase(sku, new EnhanceInAppPurchases.PurchaseCallback() {
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

                Enhance.purchases.consume(sku, new EnhanceInAppPurchases.ConsumeCallback() {
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
                String displayPrice = Enhance.purchases.getDisplayPrice(sku, defaultPrice);
            
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
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, Enhance.purchases.isItemOwned(sku)));
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
                int ownedItemCount = Enhance.purchases.getOwnedItemCount(sku);

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ownedItemCount)); 
                return true;    
            } catch(Exception e) {
                Log.e(TAG, "exception in getOwnedItemCount: " + e.toString());
                e.printStackTrace();

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        else if(action.equals("manuallyRestorePurchases")) {
            try {
                Enhance.purchases.manuallyRestorePurchases(new EnhanceInAppPurchases.RestoreCallback() {
                    @Override
                    public void onRestoreSuccess() 
                    {
                        Log.i(TAG, "onRestoreSuccess");                
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, true));
                    }

                    @Override 
                    public void onRestoreFailed()
                    {
                        Log.i(TAG, "onRestoreFailed");
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
                    }
                });
                return true;
            } catch (Exception e) {
                Log.e(TAG, "exception in manuallyRestorePurchases: " + e.toString());
                e.printStackTrace();

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        else if(action.equals("getDisplayTitle")) {
            try {
                String sku = args.getString(0);
                String defaultTitle = args.getString(1);

                String result = Enhance.purchases.getDisplayTitle(sku, defaultTitle);

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
                return true;
            } catch (Exception e) {
                Log.e(TAG, "exception in getDisplayTitle: " + e.toString());
                e.printStackTrace();

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        else if(action.equals("getDisplayDescription")) {
            try {
                String sku = args.getString(0);
                String defaultDescription = args.getString(1);

                String result = Enhance.purchases.getDisplayDescription(sku, defaultDescription);

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
                return true;
            } catch (Exception e) {
                Log.e(TAG, "exception in getDisplayDescription: " + e.toString());
                e.printStackTrace();

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        else if(action.equals("requiresDataConsentOptIn")) {
            try {
                Enhance.requiresDataConsentOptIn(new Enhance.OptInRequiredCallback() {
                    public void onServiceOptInRequirement(boolean isUserOptInRequired)
                    {
                        Log.d(TAG, "onServiceOptInRequirement");
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, isUserOptInRequired));
                    }
                });
                return true;
            } catch (Exception e) {
                Log.e(TAG, "exception in requiresDataConsentOptIn: " + e.toString());
                e.printStackTrace();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        else if(action.equals("serviceTermsOptIn")) {
            try {
                String sdks = args.getString(0);

                if(sdks != null && !sdks.isEmpty()) {
                    Log.d(TAG, "serviceTermsOptIn: " + sdks);
                    List<String> requestedSdks = Arrays.asList(sdks.split(","));
                    Enhance.serviceTermsOptIn(requestedSdks);
                } else {
                    Log.d(TAG, "serviceTermsOptIn: all");
                    Enhance.serviceTermsOptIn();
                }

                callbackContext.success();
                return true;
            } catch (Exception e) {
                Log.e(TAG, "exception in serviceTermsOptIn: " + e.toString());
                e.printStackTrace();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        else if(action.equals("showServiceOptInDialogs")) {
            try {
                final Enhance.OnDataConsentOptInComplete callback = new Enhance.OnDataConsentOptInComplete() {
                    public void onDialogComplete() {
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, true));
                    }
                };

                String sdks = args.getString(0);

                if(sdks != null && !sdks.isEmpty()) {
                    Log.d(TAG, "showServiceOptInDialogs: " + sdks);
                    List<String> requestedSdks = Arrays.asList(sdks.split(","));
                    Enhance.showServiceOptInDialogs(requestedSdks, callback);
                } else {
                    Log.d(TAG, "showServiceOptInDialogs: all");
                    Enhance.showServiceOptInDialogs(callback);
                }
                return true;
            } catch (Exception e) {
                Log.e(TAG, "exception in showServiceOptInDialogs: " + e.toString());
                e.printStackTrace();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
            }
        }

        else if(action.equals("serviceTermsOptOut")) {
            try {
                Log.d(TAG, "serviceTermsOptOut");
                Enhance.serviceTermsOptOut();
                callbackContext.success();
                return true;
            } catch (Exception e) {
                Log.e(TAG, "exception in serviceTermsOptOut: " + e.toString());
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
