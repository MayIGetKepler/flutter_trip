package kepler.zwt.plugin.asr;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.util.Log;

import java.util.ArrayList;
import java.util.Map;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * @author ZWT
 */
public class AsrPlugin implements MethodChannel.MethodCallHandler {
    private static final String TAG = "AsrPlugin";
    private static final String ASR_CHANNEL = "asr_plugin";
    private final Activity mActivity;
    private StatefulResult mStatefulResult;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        MethodChannel methodChannel = new MethodChannel(registrar.messenger(), ASR_CHANNEL);
        AsrPlugin instance = new AsrPlugin(registrar);
        methodChannel.setMethodCallHandler(instance);
    }

    private AsrPlugin(PluginRegistry.Registrar registrar) {
        mActivity = registrar.activity();
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        initPermission();
        switch (methodCall.method) {
            case "start":
                mStatefulResult = StatefulResult.of(result);
                start(methodCall, mStatefulResult);
                break;
            case "stop":
                stop();
                break;
            case "cancel":
                cancel();
                break;
            case "release":
                release();
            default:
                result.notImplemented();
        }
    }

    @SuppressWarnings("unchecked")
    private void start(MethodCall call, StatefulResult result) {
        if (mActivity == null) {
            Log.e(TAG, "Ignored start, current activity is null");
            result.error("Ignored start, current activity is null", null, null);
            return;
        }
        if (getAsrManager() == null) {
            Log.e(TAG, "Ignored start, can not get AsrManager");
            result.error("Ignored start, can not get AsrManager", null, null);
            return;
        }
        getAsrManager().start(call.arguments instanceof Map ? (Map) call.arguments : null);
    }

    private void stop() {
        if (getAsrManager() != null) {
            getAsrManager().stop();
        }
    }

    private void cancel() {
        if (getAsrManager() != null) {
            getAsrManager().cancel();
        }
    }

    private void release() {
        if (getAsrManager() != null) {
            getAsrManager().release();
        }
    }


    private AsrManager mAsrManager;

    private AsrManager getAsrManager() {
        if (mAsrManager == null) {
            mAsrManager = new AsrManager(mActivity, mOnAsrListener);
        }
        return mAsrManager;
    }

    private IOnAsrListener mOnAsrListener = new IOnAsrListener() {
        @Override
        public void onAsrReady() {

        }

        @Override
        public void onAsrBegin() {

        }

        @Override
        public void onAsrEnd() {

        }

        @Override
        public void onAsrPartialResult(String[] results, RecogResult recogResult) {

        }

        @Override
        public void onAsrOnlineNluResult(String nluResult) {

        }

        @Override
        public void onAsrFinalResult(String[] results, RecogResult recogResult) {
            if (mStatefulResult != null) {
                mStatefulResult.success(results[0]);
            }
        }

        @Override
        public void onAsrFinish(RecogResult recogResult) {

        }

        @Override
        public void onAsrFinishError(int errorCode, int subErrorCode, String descMessage, RecogResult recogResult) {
            if (mStatefulResult != null) {
                mStatefulResult.error(descMessage, null, null);
            }
        }

        @Override
        public void onAsrLongFinish() {

        }

        @Override
        public void onAsrVolume(int volumePercent, int volume) {

        }

        @Override
        public void onAsrAudio(byte[] data, int offset, int length) {

        }

        @Override
        public void onAsrExit() {

        }

        @Override
        public void onOfflineLoaded() {

        }

        @Override
        public void onOfflineUnLoaded() {

        }
    };


    /**
     * android 6.0 以上需要动态申请权限
     */
    private void initPermission() {
        String[] permissions = {Manifest.permission.RECORD_AUDIO,
                Manifest.permission.ACCESS_NETWORK_STATE,
                Manifest.permission.INTERNET,
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
        };

        ArrayList<String> toApplyList = new ArrayList<>();

        for (String perm : permissions) {
            if (PackageManager.PERMISSION_GRANTED != ContextCompat.checkSelfPermission(mActivity, perm)) {
                toApplyList.add(perm);
                //进入到这里代表没有权限.

            }
        }
        String[] tmpList = new String[toApplyList.size()];
        if (!toApplyList.isEmpty()) {
            ActivityCompat.requestPermissions(mActivity, toApplyList.toArray(tmpList), 123);
        }

    }
}
