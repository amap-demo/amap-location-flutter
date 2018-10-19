package com.amap.location.amaplocationflutterplugin;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationListener;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * 高德地图定位sdkFlutterPlugin
 */
public class AmapLocationFlutterPlugin implements MethodCallHandler, EventChannel.StreamHandler, AMapLocationListener {

    private static final String CHANNEL_METHOD_LOCATION = "amap_location_flutter_plugin";
    private static final String CHANNEL_STREAM_LOCATION = "amap_location_flutter_plugin_stream";
    AMapLocationClient locationClient = null;

    private Context mContext = null;

    private EventChannel.EventSink mEventSink = null;

    AmapLocationFlutterPlugin(Context context) {
        mContext = context;
    }

    /**
     * 注册组件
     */
    public static void registerWith(Registrar registrar) {
        AmapLocationFlutterPlugin plugin = new AmapLocationFlutterPlugin(registrar.context());
        /**
         * 开始、停止定位
         */
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_METHOD_LOCATION);
        channel.setMethodCallHandler(plugin);

        /**
         * 监听onLocationChanged
         */
        final EventChannel eventChannel = new EventChannel(registrar.messenger(), CHANNEL_STREAM_LOCATION);
        eventChannel.setStreamHandler(plugin);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("startLocation")) {
            startLocation();
        } else if(call.method.equals("stopLocation")){
            stopLocation();
        } else {
            result.notImplemented();
        }
    }


    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        mEventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        stopLocation();
    }

    /**
     * 停止定位
     */
    private void stopLocation(){
        if(null != locationClient) {
            locationClient.stopLocation();
            locationClient.onDestroy();
            locationClient = null;
        }
    }

    /**
     * 开始定位
     */
    private void startLocation() {
        if(null == locationClient) {
            locationClient = new AMapLocationClient(mContext);
        }
        locationClient.setLocationListener(this);
        locationClient.startLocation();
    }

    /**
     * 定位回调
     * @param location
     */
    @Override
    public void onLocationChanged(AMapLocation location) {
        if(null == mEventSink) {
            return;
        }
        Map<String,Object> result = new LinkedHashMap<String,Object>();
        result.put("callbackTime", formatUTC(System.currentTimeMillis(),null));
        if(null != location) {
            if(location.getErrorCode() == AMapLocation.LOCATION_SUCCESS) {
                result.put("locTime", formatUTC(location.getTime(), null));
                result.put("latitude", location.getLatitude());
                result.put("longitude", location.getLongitude());
                result.put("address", location.getAddress());
            } else {
                result.put("errorCode", location.getErrorCode());
                result.put("errorInfo", location.getErrorInfo());
                result.put("locationDetail", location.getLocationDetail());
            }
        } else {
            result.put("errorCode", -1);
            result.put("errorInfo", "location is null");
        }
        mEventSink.success(result);
    }

    /**
     * 格式化时间
     * @param time
     * @param strPattern
     * @return
     */
    private String formatUTC(long time, String strPattern) {
        if (TextUtils.isEmpty(strPattern)) {
            strPattern = "yyyy-MM-dd HH:mm:ss";
        }
        SimpleDateFormat sdf = null;
        try {
            sdf = new SimpleDateFormat(strPattern, Locale.CHINA);
            sdf.applyPattern(strPattern);
        } catch (Throwable e) {
        }
        return sdf == null ? "NULL" : sdf.format(time);
    }
}
