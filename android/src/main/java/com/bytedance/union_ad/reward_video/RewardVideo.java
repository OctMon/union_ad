package com.bytedance.union_ad.reward_video;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.bytedance.sdk.openadsdk.AdSlot;
import com.bytedance.sdk.openadsdk.TTAdConstant;
import com.bytedance.sdk.openadsdk.TTAdManager;
import com.bytedance.sdk.openadsdk.TTAdNative;
import com.bytedance.sdk.openadsdk.TTAppDownloadListener;
import com.bytedance.sdk.openadsdk.TTRewardVideoAd;
import com.bytedance.union_ad.TToast;
import com.bytedance.union_ad.config.TTAdManagerHolder;

public class RewardVideo {

    private static final String TAG = "RewardVideo";
    /**视频是否加载完成*/
    private boolean mIsLoaded = false; 
    /**是否请求模板广告*/
    private boolean mIsExpress = false;
    /**收否有正在下载的apk*/
    private boolean mHasShowDownloadActive = false;
    
    private TTRewardVideoAd mttRewardVideoAd;
    private TTAdNative mTTAdNative;
    private Context context;

    private RewardVideoCallback callback;

    public RewardVideo(Context con,RewardVideoCallback call){
        this.context = con;
        TTAdManager ttAdManager = TTAdManagerHolder.get();
        mTTAdNative = ttAdManager.createAdNative(context.getApplicationContext());
        callback = call;
    }

    /**
     * 加载广告
     * @param codeId
     */
    public void loadAd(final String codeId) {
        //step4:创建广告请求参数AdSlot,具体参数含义参考文档
        AdSlot adSlot;
        if (mIsExpress) {
            //个性化模板广告需要传入期望广告view的宽、高，单位dp，
            adSlot = new AdSlot.Builder()
                    .setCodeId(codeId)
                    //模板广告需要设置期望个性化模板广告的大小,单位dp,激励视频场景，只要设置的值大于0即可
                    .setExpressViewAcceptedSize(500,500)
                    .build();
        } else {
            //模板广告需要设置期望个性化模板广告的大小,单位dp,代码位是否属于个性化模板广告，请在穿山甲平台查看
            adSlot = new AdSlot.Builder()
                    .setCodeId(codeId)
                    .build();
        }
        ///step5:请求广告
        mTTAdNative.loadRewardVideoAd(adSlot, new TTAdNative.RewardVideoAdListener() {
            @Override
            public void onError(int code, String message) {
                if (TTAdManagerHolder.debug){
                    Log.e(TAG, "Callback --> onError: " + code + ", " + String.valueOf(message));
                    TToast.show(context, message);
                }
                if (callback != null){
                    callback.loadError();
                }

            }

            //视频广告加载后，视频资源缓存到本地的回调，在此回调后，播放本地视频，流畅不阻塞。
            @Override
            public void onRewardVideoCached() {
                if (TTAdManagerHolder.debug){
                    Log.e(TAG, "Callback --> onRewardVideoCached");
                    TToast.show(context, "Callback --> rewardVideoAd video cached");
                }
                mIsLoaded = true;
                if (callback != null){
                    callback.cached();
                }
            }

            //视频广告的素材加载完毕，比如视频url等，在此回调后，可以播放在线视频，网络不好可能出现加载缓冲，影响体验。
            @Override
            public void onRewardVideoAdLoad(TTRewardVideoAd ad) {
                if (TTAdManagerHolder.debug){
                    Log.e(TAG, "Callback --> onRewardVideoAdLoad");
                    TToast.show(context, "rewardVideoAd loaded 广告类型：" + getAdType(ad.getRewardVideoAdType()));
                }
                if (callback != null){
                    callback.loaded();
                }
                mIsLoaded = false;
                mttRewardVideoAd = ad;
                mttRewardVideoAd.setRewardAdInteractionListener(new TTRewardVideoAd.RewardAdInteractionListener() {

                    @Override
                    public void onAdShow() {
                        if (TTAdManagerHolder.debug){
                            Log.d(TAG, "Callback --> rewardVideoAd show");
                            TToast.show(context, "rewardVideoAd show");
                        }
                        if (callback != null){
                            callback.showed();
                        }

                    }

                    @Override
                    public void onAdVideoBarClick() {
                        if (TTAdManagerHolder.debug){
                            Log.d(TAG, "Callback --> rewardVideoAd bar click");
                            TToast.show(context, "rewardVideoAd bar click");
                        }

                    }

                    @Override
                    public void onAdClose() {
                        if (TTAdManagerHolder.debug){
                            Log.d(TAG, "Callback --> rewardVideoAd close");
                            TToast.show(context, "rewardVideoAd close");
                        }

                        if (callback != null){
                            callback.closed();
                        }

                    }

                    //视频播放完成回调
                    @Override
                    public void onVideoComplete() {
                        if (TTAdManagerHolder.debug){
                            Log.d(TAG, "Callback --> rewardVideoAd complete");
                            TToast.show(context, "rewardVideoAd complete");
                        }
                        if (callback != null){
                            callback.playComplete();
                        }

                    }

                    @Override
                    public void onVideoError() {
                        if (TTAdManagerHolder.debug){
                            Log.e(TAG, "Callback --> rewardVideoAd error");
                            TToast.show(context, "rewardVideoAd error");
                        }

                    }

                    //视频播放完成后，奖励验证回调，rewardVerify：是否有效，rewardAmount：奖励梳理，rewardName：奖励名称
                    @Override
                    public void onRewardVerify(boolean rewardVerify, int rewardAmount, String rewardName, int errorCode, String errorMsg) {

                        if (TTAdManagerHolder.debug){
                            String logString = "verify:" + rewardVerify + " amount:" + rewardAmount +
                                    " name:" + rewardName + " errorCode:" + errorCode + " errorMsg:" + errorMsg;
                            Log.e(TAG, "Callback --> " + logString);
                            TToast.show(context, logString);
                        }

                        if (callback != null){
                            callback.rewarded();
                        }

                    }

                    @Override
                    public void onSkippedVideo() {
                        if (TTAdManagerHolder.debug){
                            Log.e(TAG, "Callback --> rewardVideoAd has onSkippedVideo");
                            TToast.show(context, "rewardVideoAd has onSkippedVideo");
                        }
                        if (callback != null){
                            callback.skip();
                        }
                    }
                });
                mttRewardVideoAd.setDownloadListener(new TTAppDownloadListener() {
                    @Override
                    public void onIdle() {
                        mHasShowDownloadActive = false;
                    }

                    @Override
                    public void onDownloadActive(long totalBytes, long currBytes, String fileName, String appName) {


                        if (TTAdManagerHolder.debug){
                            Log.d("DML", "onDownloadActive==totalBytes=" + totalBytes + ",currBytes=" + currBytes + ",fileName=" + fileName + ",appName=" + appName);
                        }
                        
                        if (!mHasShowDownloadActive) {
                            mHasShowDownloadActive = true;
                            if (TTAdManagerHolder.debug){
                                TToast.show(context, "下载中，点击下载区域暂停", Toast.LENGTH_LONG);
                            }
                        }
                    }

                    @Override
                    public void onDownloadPaused(long totalBytes, long currBytes, String fileName, String appName) {
                        if (TTAdManagerHolder.debug){
                            Log.d("DML", "onDownloadPaused===totalBytes=" + totalBytes + ",currBytes=" + currBytes + ",fileName=" + fileName + ",appName=" + appName);
                            TToast.show(context, "下载暂停，点击下载区域继续", Toast.LENGTH_LONG);
                        }
                       
                    }

                    @Override
                    public void onDownloadFailed(long totalBytes, long currBytes, String fileName, String appName) {
                        if (TTAdManagerHolder.debug){
                            Log.d("DML", "onDownloadFailed==totalBytes=" + totalBytes + ",currBytes=" + currBytes + ",fileName=" + fileName + ",appName=" + appName);
                            TToast.show(context, "下载失败，点击下载区域重新下载", Toast.LENGTH_LONG);
                        }
                      
                    }

                    @Override
                    public void onDownloadFinished(long totalBytes, String fileName, String appName) {
                        if (TTAdManagerHolder.debug){
                            Log.d("DML", "onDownloadFinished==totalBytes=" + totalBytes + ",fileName=" + fileName + ",appName=" + appName);
                            TToast.show(context, "下载完成，点击下载区域重新下载", Toast.LENGTH_LONG);
                        }
                       
                    }

                    @Override
                    public void onInstalled(String fileName, String appName) {
                        if (TTAdManagerHolder.debug){
                            Log.d("DML", "onInstalled==" + ",fileName=" + fileName + ",appName=" + appName);
                            TToast.show(context, "安装完成，点击下载区域打开", Toast.LENGTH_LONG);
                        }
                       
                    }
                });
            }
        });
    }

    private String getAdType(int type) {
        switch (type) {
            case TTAdConstant.AD_TYPE_COMMON_VIDEO:
                return "普通激励视频，type=" + type;
            case TTAdConstant.AD_TYPE_PLAYABLE_VIDEO:
                return "Playable激励视频，type=" + type;
            case TTAdConstant.AD_TYPE_PLAYABLE:
                return "纯Playable，type=" + type;
        }

        return "未知类型+type=" + type;
    }

    /**
     * 展示广告
     */
    public void showAd(){
        if (mttRewardVideoAd != null&&mIsLoaded) {
            //展示广告，并传入广告展示的场景
            mttRewardVideoAd.showRewardVideoAd((Activity) context, TTAdConstant.RitScenes.CUSTOMIZE_SCENES, "scenes_test");
            mttRewardVideoAd = null;
            mIsLoaded = false;
        } else {
           if (TTAdManagerHolder.debug){
               TToast.show(context, "请先加载广告");
           }
        }
    }

    /**
     * 激励视频加载及播放监听
     */
    public interface RewardVideoCallback{
        public void loadError();
        public void loaded();
        public void cached();
        public void showed();
        public void skip();
        public void rewarded();
        public void playComplete();
        public void closed();
    }

}
