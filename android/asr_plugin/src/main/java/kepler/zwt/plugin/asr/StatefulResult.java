package kepler.zwt.plugin.asr;

import android.util.Log;

import io.flutter.plugin.common.MethodChannel;

/**
 * @author ZWT
 */
public class StatefulResult implements MethodChannel.Result {
    private static final String TAG = "StatefulResult";
    private final MethodChannel.Result mResult;
    private boolean called;

    public static StatefulResult of(MethodChannel.Result result){
        return new StatefulResult(result);
    }

    private StatefulResult(MethodChannel.Result result){
        mResult = result;
    }

    @Override
    public void success(Object o) {
        if (called){
            printError();
            return;
        }

        called = true;
        mResult.success(o);
    }

    @Override
    public void error(String s, String s1, Object o) {
        if (called){
            printError();
            return;
        }
        called = true;
        mResult.error(s,s1,o);
    }

    @Override
    public void notImplemented() {
        if (called){
            printError();
            return;
        }
        called = true;
        mResult.notImplemented();
    }

    private void printError(){
        Log.e(TAG, "result has been called" );
    }
}
