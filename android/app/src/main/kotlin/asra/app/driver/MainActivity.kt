package asra.app.driver

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
  // private val CHANNEL = "com.example.chat/chat"

  // override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
  //     super.configureFlutterEngine(flutterEngine)
  //     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
  //         if (call.method == "setDefaultCaller") {
  //             try {
  //                 var intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT);
  //                 intent.putExtra(
  //                         Telephony.Sms.Intents.EXTRA_PACKAGE_NAME,
  //                         <the app package name>
  //                 );
  //                 startActivity(intent);
  //                 result.success("Success")
  //             } catch (ex: Exception) {
  //                 result.error("UNAVAILABLE", "Setting default sms.", null)
  //             }
  //         } else {
  //             result.notImplemented()
  //         }
  //     }
  // }
}
