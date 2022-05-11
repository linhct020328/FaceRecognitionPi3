package viethoang.truong.smarthome;

import android.media.MediaPlayer;
import android.os.AsyncTask;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.File;
import java.io.IOException;
import java.lang.ref.WeakReference;

import edu.cmu.pocketsphinx.Assets;
import edu.cmu.pocketsphinx.Hypothesis;
import edu.cmu.pocketsphinx.SpeechRecognizerSetup;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

enum VoskStatus {
    INITED,
    LISTENING,
    WAKEUP,
    STOPPED,
    CANCEL,
    TIMEOUT,
    ERROR
}


public class MainActivity extends FlutterActivity implements edu.cmu.pocketsphinx.RecognitionListener {
    private edu.cmu.pocketsphinx.SpeechRecognizer recognizer;  // library listen voice
    private MediaPlayer mediaPlayer;  // play ring


    /* Named searches allow to quickly reconfigure the decoder */
    private static final String KWS_SEARCH = "wakeup";  // key chọn đánh thức thiết bị
    private static final String MENU_SEARCH = "menu";   // key chọn thiết bị thực hiện theo menu

    /* Keyword we are looking for to activate menu */
    private static final String KEYPHRASE = "ok sunday";  // từ khởi đầu để đánh thức thiết bị

    EventChannel.EventSink voskEvents;

    public static final String voskChannel = "attendance_app/vosk";
    private String initMethod = "initVosk";

    //////// WAKEUP CHANNEL ////////////
    // stable channel
    private static final String voskWakupChannel = "attendance_app/vosk/wakeup";
    // stream channel
    private static final String wakeupStreamChannel = "attendance_app/vosk/wakeup/listen";
    // method channel
    private String startVoskWakeupMethod = "startVoskWakeup",
            stopVoskWakeupMethod = "stopVoskWakeup",
            cancelVoskWakeupMethod = "cancelVoskWakeup";

    //////////////////////////////////

    BinaryMessenger getFlutterView() {
        return getFlutterEngine().getDartExecutor().getBinaryMessenger();
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        // init vosk channel
        initVoskMethodChannel();

        // wakeup listener
        wakeupMethodChannel();
        controlVoskWakeupMethodChannel();

    }

    public void initVoskMethodChannel() {
        new MethodChannel(getFlutterView(), voskChannel).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                final String method = call.method;
                if (method.equals(initMethod)) {
                    initMethodChannel(result);
                }
            }
        });
    }

    // init cmu
    private void initMethodChannel(MethodChannel.Result result) {
        new SetupTask(MainActivity.this, result).execute();
    }

    // FOR WAKEUP CHANNEL
    public void wakeupMethodChannel() {
        new EventChannel(getFlutterView(), wakeupStreamChannel).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        voskEvents = events;
                        switchSearch(KWS_SEARCH);
                        voskEvents.success(VoskStatus.LISTENING.name());
                    }

                    @Override
                    public void onCancel(Object arguments) {

                    }
                }
        );
    }

    public void controlVoskWakeupMethodChannel() {
        new MethodChannel(getFlutterView(), voskWakupChannel)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        final String method = call.method;
                        if (method.equals(stopVoskWakeupMethod)) {
                            stopVoskWakeupMethodChannel(result);
                        } else if (method.equals(startVoskWakeupMethod)) {
                            startVoskWakeupMethodChannel(result);
                        }
                    }
                });
    }

    private void stopVoskWakeupMethodChannel(MethodChannel.Result result) {
        recognizer.stop();
        result.success(VoskStatus.STOPPED.name());
    }

    private void startVoskWakeupMethodChannel(MethodChannel.Result result) {
        switchSearch(KWS_SEARCH);
        result.success(VoskStatus.LISTENING.name());
    }

    @Override
    public void onBeginningOfSpeech() {

    }

    @Override
    public void onEndOfSpeech() {
        if (recognizer != null && !recognizer.getSearchName().equals(KWS_SEARCH))
            switchSearch(KWS_SEARCH);
    }

    @Override
    public void onPartialResult(Hypothesis hypothesis) {
        if (hypothesis == null) {
            return;
        }
        String text = hypothesis.getHypstr();
        if (text.equals(KEYPHRASE)) {
            switchSearch(MENU_SEARCH);
        }
    }

    @Override
    public void onResult(Hypothesis hypothesis) {
        if (hypothesis != null) {
            String action = hypothesis.getHypstr();  // chuyển giọng ghi âm thành string để xử lý
            // Nếu action chứa key : ok sunday thì nghe tiếp
            // nếu sai thì xét các trường hợp còn lại
            if (action.contains(KEYPHRASE)) {
                voskEvents.success(VoskStatus.WAKEUP.name());
//                System.out.println("Đang nghe...");
            } else {
                mediaPlayer = MediaPlayer.create(MainActivity.this, R.raw.f);
                mediaPlayer.start();
                voskEvents.success(action);
            }
        }
    }

    @Override
    public void onError(Exception e) {
        System.out.println(e.getMessage());
    }

    // Sau thời gian lắng nghe tiếp tục trở lại key wakeup
    @Override
    public void onTimeout() {
        Log.e("TIMEOUT", "TIEP TUC");
        switchSearch(KWS_SEARCH);
    }

    // Task setup voice control
// use static
    private static class SetupTask extends AsyncTask<Void, Void, Exception> {
        private static final String TAG = "SetupTask";
        MethodChannel.Result resultChannel;


        WeakReference<MainActivity> activityReference;

        SetupTask(MainActivity activity, MethodChannel.Result result) {
            this.activityReference = new WeakReference<>(activity);
            this.resultChannel = result;
        }

        @Override
        protected Exception doInBackground(Void... params) {
            try {
                Assets assets = new Assets(activityReference.get());
                File assetDir = assets.syncAssets();
                activityReference.get().setupRecognizer(assetDir);
            } catch (IOException e) {
                return e;
            }
            return null;
        }

        @Override
        protected void onPostExecute(Exception result) {
            if (result != null) {
                resultChannel.error("0", "Error onPostExecute", VoskStatus.ERROR.name());
            } else {
                Log.e(TAG, "TIEP TUC");
                resultChannel.success(VoskStatus.INITED.name());
            }
        }
    }

    // Cài đặt file thư viện tiếng anh
    private void setupRecognizer(File assetsDir) throws IOException {
        recognizer = SpeechRecognizerSetup.defaultSetup()
                .setAcousticModel(new File(assetsDir, "en-us-ptm"))
                .setDictionary(new File(assetsDir, "cmudict-en-us.dict"))
                // Disable this line if you don't want recognizer to save raw
                // audio files to app's storage
                .setRawLogDir(assetsDir)
                .getRecognizer();
        recognizer.addListener(this);

        // Create keyword-activation search.
        recognizer.addKeyphraseSearch(KWS_SEARCH, KEYPHRASE);

        // Create your custom grammar-based search
        File menuGrammar = new File(assetsDir, "menu.gram");   // File menu chứa các key chức năng
        recognizer.addGrammarSearch(MENU_SEARCH, menuGrammar);

    }


    // Chuyền đổi giữa nhận dạng key wakeup và key word menu chức năng
    private void switchSearch(String kwsSearch) {
        if (recognizer != null) {
            recognizer.stop();


            if (kwsSearch.equals(KWS_SEARCH)) {
                recognizer.startListening(kwsSearch);
                voskEvents.success(VoskStatus.LISTENING.name());
                // Toast.makeText(MainActivity.this, kwsSearch, Toast.LENGTH_LONG).show();
            } else {
                mediaPlayer = MediaPlayer.create(MainActivity.this, R.raw.wakeup);
                mediaPlayer.start();
                recognizer.startListening(kwsSearch, 5000);
                voskEvents.success(VoskStatus.WAKEUP.name());
            }
        }

    }

}
