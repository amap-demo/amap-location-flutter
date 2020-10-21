package com.amap.location.amaplocationflutterplugin;

import android.text.TextUtils;

import com.amap.api.location.AMapLocation;

import java.text.SimpleDateFormat;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

/**
 * @author whm
 * @date 2020-04-17 17:33
 * @mail hongming.whm@alibaba-inc.com
 * @since
 */
public class Utils {


    public static Map<String, Object> buildLocationResultMap(AMapLocation location) {
        Map<String, Object> result = new LinkedHashMap<String, Object>();
        result.put("callbackTime", formatUTC(System.currentTimeMillis(), null));
        if (null != location) {
            if (location.getErrorCode() == AMapLocation.LOCATION_SUCCESS) {
                result.put("locationTime", formatUTC(location.getTime(), null));
                result.put("locationType", location.getLocationType());
                result.put("latitude", location.getLatitude());
                result.put("longitude", location.getLongitude());
                result.put("accuracy", location.getAccuracy());
                result.put("altitude", location.getAltitude());
                result.put("bearing", location.getBearing());
                result.put("speed", location.getSpeed());
                result.put("country", location.getCountry());
                result.put("province", location.getProvince());
                result.put("city", location.getCity());
                result.put("district", location.getDistrict());
                result.put("street", location.getStreet());
                result.put("streetNumber", location.getStreetNum());
                result.put("cityCode", location.getCityCode());
                result.put("adCode", location.getAdCode());
                result.put("address", location.getAddress());
                result.put("description", location.getDescription());
            } else {
                result.put("errorCode", location.getErrorCode());
                result.put("errorInfo", location.getErrorInfo() + "#" + location.getLocationDetail());
            }
        } else {
            result.put("errorCode", -1);
            result.put("errorInfo", "location is null");
        }
        return result;
    }

    /**
     * 格式化时间
     *
     * @param time
     * @param strPattern
     * @return
     */
    public static String formatUTC(long time, String strPattern) {
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
