package de.bonify.reactnativematomo;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import org.matomo.sdk.Matomo;
import org.matomo.sdk.Tracker;
import org.matomo.sdk.TrackerBuilder;
import org.matomo.sdk.extra.TrackHelper;
import android.support.annotation.NonNull;


public class MatomoModule extends ReactContextBaseJavaModule implements LifecycleEventListener {

    private static final String LOGGER_TAG = "MatomoModule";

    public MatomoModule(ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addLifecycleEventListener(this);
    }

    private Matomo matomo;
    private Tracker mMatomoTracker;

    private String campaignName;
    private String campaignKeyword;
    private String version;
    private String userType;

    @ReactMethod
    public void initTracker(String url, int id) {
        TrackerBuilder builder = TrackerBuilder.createDefault(url, id);
        mMatomoTracker = builder.build(Matomo.getInstance(getReactApplicationContext()));
    }

    @ReactMethod
    public void setAppOptOut(Boolean isOptedOut) {
        mMatomoTracker.setOptOut(isOptedOut);
    }

    @ReactMethod
    public void setUserId(String userId) {
        mMatomoTracker.setUserId(userId);
    }

    @ReactMethod
    public void trackScreen(@NonNull String screen, String title) {
        if (mMatomoTracker == null) {
            throw new RuntimeException("Tracker must be initialized before usage");
        }
        if (campaignName != null) {
          TrackHelper.track().screen(screen).campaign(campaignName, campaignKeyword).title(title).with(mMatomoTracker);

          // only send this with one screen view after campaign info is set
          campaignName = null;
          campaignKeyword = null;
        } else {
          TrackHelper.track().screen(screen).title(title).dimension(1, version).dimension(2, userType).with(mMatomoTracker);
        }
    }

    @ReactMethod
    public void trackEvent(@NonNull String category, @NonNull String action, ReadableMap values) {
        if (mMatomoTracker == null) {
            throw new RuntimeException("Tracker must be initialized before usage");
        }
        String name = null;
        Float value = null;
        if (values.hasKey("name") && !values.isNull("name")) {
            name = values.getString("name");
        }
        if (values.hasKey("value") && !values.isNull("value")) {
            value = (float)values.getDouble("value");
        }
        TrackHelper.track().event(category, action).name(name).value(value).dimension(1, version).dimension(2, userType).with(mMatomoTracker);
    }

    @ReactMethod
    public void trackGoal(int goalId, ReadableMap values) {
        if (mMatomoTracker == null) {
            throw new RuntimeException("Tracker must be initialized before usage");
        }
        Float revenue = null;
        if (values.hasKey("revenue") && !values.isNull("revenue")) {
            revenue = (float)values.getDouble("revenue");
        }
        TrackHelper.track().goal(goalId).revenue(revenue).dimension(1, version).dimension(2, userType).with(mMatomoTracker);
    }

    @ReactMethod
    public void trackCampaign(String name, String keyword) {
      campaignName = name;
      campaignKeyword = keyword;
    }

    @ReactMethod
    public void trackCampaign(String name, String keyword) {
      campaignName = name;
      campaignKeyword = keyword;
    }

    public void setVersion (String appVersion) {
      version = appVersion;
    }

    public void setUserType (String newUserType) {
      userType = newUserType;
    }

    @ReactMethod
    public void trackContentImpression(@NonNull String name, @NonNull ReadableMap values) {}

    @ReactMethod
    public void trackContentInteraction(@NonNull String name, @NonNull ReadableMap values) {}

    @ReactMethod
    public void trackSearch(@NonNull String query, @NonNull ReadableMap values) {}

    @ReactMethod
    public void trackAppDownload() {
        if (mMatomoTracker == null) {
            throw new RuntimeException("Tracker must be initialized before usage");
        }
        TrackHelper.track().download().with(mMatomoTracker);
    }

    @Override
    public String getName() {
        return "Matomo";
    }

    @Override
    public void onHostResume() {}

    @Override
    public void onHostPause() {
        if (mMatomoTracker != null) {
            mMatomoTracker.dispatch();
        }
    }

    @Override
    public void onHostDestroy() {}

}
