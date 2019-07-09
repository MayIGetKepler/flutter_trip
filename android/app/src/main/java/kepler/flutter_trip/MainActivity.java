package kepler.flutter_trip;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import kepler.zwt.plugin.asr.AsrPlugin;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    registerSelfPlugin();
  }

  private void registerSelfPlugin() {
    AsrPlugin.registerWith(registrarFor("kepler.zwt.plugin.asr.AsrPlugin"));
  }
}
