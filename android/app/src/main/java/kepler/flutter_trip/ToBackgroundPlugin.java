package kepler.flutter_trip;

import android.app.Activity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * @author ZWT
 */
public class ToBackgroundPlugin implements MethodChannel.MethodCallHandler {
    private static final String PLUGIN_NAME = "to_background_plugin";
    private final Activity mActivity;
    public static void registerWith(PluginRegistry.Registrar registrar){
        MethodChannel methodChannel = new MethodChannel(registrar.messenger(),PLUGIN_NAME);
        ToBackgroundPlugin instance = new  ToBackgroundPlugin(registrar.activity());
        methodChannel.setMethodCallHandler(instance);
    }

    private ToBackgroundPlugin(Activity activity){
        mActivity = activity;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if ("toBackground".equals(methodCall.method)) {
            mActivity.moveTaskToBack(false);
            result.success(null);
        } else {
            result.notImplemented();
        }
    }
}
