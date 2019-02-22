package ielettronica.it.websocketeasy;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.WebSocket;
import okhttp3.WebSocketListener;

import static com.google.android.gms.internal.zzid.runOnUiThread;


/**
 * Created by GNARDELLI on 29/11/2015.
 *
 */
public class tabController extends Fragment implements View.OnTouchListener{

    private static final String TAG = "test1";
    private static WebSocket mConnection;
    private TextView textView;
    private TextView txtChannel;
    private TextView txtVolume;
    private Button btnRadioOnOff;

    //final private String wsuri = "ws://192.168.2.124:9876";
    final private String wsuri = "ws://192.168.2.124:8000";   // this is to comunicate with raspberry PI
    //final private String wsuri = "ws://192.168.2.117:9001";     // this is to comunicate with server on mac




    private Context mContext;
    private OkHttpClient client;


    private Button start;




    @Override
    public void onResume() {
        super.onResume();



    }

    //public void getArgument(WebSocketConnection mConnection, Context mContext) {
    //    this.mConnection=mConnection;
    //    this.mContext = mContext;
    //}


    public boolean onTouch(View v, MotionEvent event) {
        String message;



        if (v.getId() == R.id.pushpull) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    message = "Led On";
                    textView.setText(message);
                    try {
                        mConnection.send("ledon");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("ledon");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
                case MotionEvent.ACTION_UP:
                    message = "Led Off";
                    textView.setText(message);
                    try {
                        mConnection.send("ledoff");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("ledoff");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
            }
            return true;
        } else if (v.getId() == R.id.btnLedOn) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    message = "Led On";
                    textView.setText(message);



                    try {
                        mConnection.send("ledon");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("ledon");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
            }
            return true;
        } else if (v.getId() == R.id.btnLedOff) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    message = "Led Off";
                    textView.setText(message);
                    try {
                        mConnection.send("ledoff");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("ledoff");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
            }
            return true;
        } else if (v.getId() == R.id.btnLoop) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    message = "Loop";
                    textView.setText(message);
                    try {
                        mConnection.send("loop");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("loop");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
            }
            return true;
        } else if (v.getId() == R.id.btnStopLoop) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    message = "Stop Loop";
                    textView.setText(message);
                    try {
                        mConnection.send("stoploop");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("stoploop");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
            }
            return true;
        } else if (v.getId() == R.id.btnConnect) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    message = "Connect";
                    textView.setText(message);
                    start();
                    break;
            }
            return true;
        }else if (v.getId() == R.id.btnLeft) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    message = "Led Left On";
                    textView.setText(message);
                    try {
                        if (MainActivity.channelValue > 1) {
                            MainActivity.channelValue = MainActivity.channelValue - 1;
                        }
                        txtChannel.setText(String.valueOf(MainActivity.channelValue));
                        mConnection.send("ledlefton");
                        mConnection.send("default");
                        mConnection.send("{channel:" + String.valueOf(MainActivity.channelValue) + "}");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("ledlefton");
                            mConnection.send("default");
                            mConnection.send("{channel:" + String.valueOf(MainActivity.channelValue) + "}");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
                case MotionEvent.ACTION_UP:
                    message = "Led Left Off";
                    textView.setText(message);
                    try {
                        mConnection.send("ledleftoff");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("ledleftoff");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
            }
            return true;
        } else if (v.getId() == R.id.btnUp) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    message = "Led Up On";
                    textView.setText(message);
                    if (MainActivity.volumeValue < 100) {
                        MainActivity.volumeValue = MainActivity.volumeValue + 5;
                    }
                    txtVolume.setText(String.valueOf(MainActivity.volumeValue));
                    try {
                        mConnection.send("ledupon");
                        mConnection.send("{volume:" + String.valueOf(MainActivity.volumeValue) + "}");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("ledupon");
                            mConnection.send("{volume:" + String.valueOf(MainActivity.volumeValue) + "}");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
                case MotionEvent.ACTION_UP:
                    message = "Led Up Off";
                    textView.setText(message);
                    try {
                        mConnection.send("ledupoff");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("ledupoff");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
            }
            return true;
        } else if (v.getId() == R.id.btnDown) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    message = "Led Down On";
                    textView.setText(message);
                    if (MainActivity.volumeValue > 0) {
                        MainActivity.volumeValue = MainActivity.volumeValue - 5;
                    }
                    txtVolume.setText(String.valueOf(MainActivity.volumeValue));
                    try {
                        mConnection.send("leddownon");
                        mConnection.send("{volume:" + String.valueOf(MainActivity.volumeValue) + "}");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("leddownon");
                            mConnection.send("{volume:" + String.valueOf(MainActivity.volumeValue) + "}");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
                case MotionEvent.ACTION_UP:
                    message = "Led Down Off";
                    textView.setText(message);
                    try {
                        mConnection.send("leddownoff");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("leddownoff");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
            }
            return true;
        } else if (v.getId() == R.id.btnDefault) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    message = "Default";
                    textView.setText(message);
                    try {
                        mConnection.send("default");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("default");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
            }
            return true;
        } else if (v.getId() == R.id.btnRadioOnOff) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    if (btnRadioOnOff.getText().toString().compareTo("RADIO ON") == 0) {
                        message = "RadioOn";
                        textView.setText(message);
                        btnRadioOnOff.setText("RADIO OFF");
                        try {
                            mConnection.send("radioon");
                        } catch (Exception e) {
                            try {
                                start();
                                mConnection.send("radioon");
                            } catch (Exception ex) {
                                System.out.println("Connection Problem");
                            }
                        }
                    } else {
                        message = "RadioOff";
                        textView.setText(message);
                        btnRadioOnOff.setText("RADIO ON");
                        try {
                            mConnection.send("radiooff");
                        } catch (Exception e) {
                            try {
                                start();
                                mConnection.send("radioff");
                            } catch (Exception ex) {
                                System.out.println("Connection Problem");
                            }
                        }
                    }

                    break;
            }
            return true;
        } else if (v.getId() == R.id.btnRight) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    message = "Led Right On";
                    textView.setText(message);
                    if (MainActivity.channelValue < MainActivity.channelValueMax) {
                        MainActivity.channelValue = MainActivity.channelValue + 1;
                    }
                    txtChannel.setText(String.valueOf(MainActivity.channelValue));
                    try {
                        mConnection.send("ledrighton");
                        mConnection.send("default");
                        mConnection.send("{channel:" + String.valueOf(MainActivity.channelValue) + "}");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("ledrighton");
                            mConnection.send("default");
                            mConnection.send("{channel':" + String.valueOf(MainActivity.channelValue) + "}");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
                case MotionEvent.ACTION_UP:
                    message = "Led Right Off";
                    textView.setText(message);
                    try {
                        mConnection.send("ledrightoff");
                    } catch (Exception e) {
                        try {
                            start();
                            mConnection.send("ledrightoff");
                        } catch (Exception ex) {
                            System.out.println("Connection Problem");
                        }
                    }
                    break;
            }
            return true;
        } else {
            return false;
        }

    }


    private void start() {

        client = new OkHttpClient();

        Request request = new Request.Builder().url(wsuri).build();

        EchoWebSocketListener listener = new EchoWebSocketListener();
        mConnection = client.newWebSocket(request, listener);
        client.dispatcher().executorService().shutdown();

    }
    private void output(final String txt) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                txtChannel.setText(txtChannel.getText().toString() + "\n\n" + txt);
            }
        });
    }



    private final class EchoWebSocketListener extends WebSocketListener {

        private static final int NORMAL_CLOSURE_STATUS = 1000;

        @Override
        public void onOpen(WebSocket webSocket, Response response) {
            Log.d(TAG, "Status: Connected to " + wsuri);
            webSocket.send("Connection Opened");
        }

        @Override
        public void onMessage(WebSocket webSocket, String text) {
            Log.d(TAG, "Got echo: " + text);
        }

        @Override
        public void onClosing(WebSocket webSocket, int code, String reason) {
            webSocket.close(NORMAL_CLOSURE_STATUS, null);
            Log.d(TAG, "Connection lost.  " + reason);
        }

        @Override
        public void onFailure(WebSocket webSocket, Throwable t, Response response) {
            output("Error : " + t.getMessage());
        }
    }





    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View view =inflater.inflate(R.layout.tabcontroller,container,false);

        //smplexternal = new SitesXmlPullParser("StackSites.xml");
        //smplLocal = new SitesXmlPullParser("PlayList.xml");

        //lblChannel= (TextView)findViewById(R.id.channelSelected);

        Button pushpull;
        ImageButton btnLeft;
        ImageButton btnUp;
        ImageButton btnDown;
        ImageButton btnRight;
        Button btnDefault;


        textView = (TextView) view.findViewById(R.id.text_view);
        txtVolume = (TextView) view.findViewById(R.id.txtVolume);
        txtChannel = (TextView) view.findViewById(R.id.txtChannel);
        pushpull = (Button) view.findViewById(R.id.pushpull);
        btnLeft = (ImageButton) view.findViewById(R.id.btnLeft);
        btnRight = (ImageButton) view.findViewById(R.id.btnRight);
        btnUp = (ImageButton) view.findViewById(R.id.btnUp);
        btnDown = (ImageButton) view.findViewById(R.id.btnDown);
        btnRadioOnOff = (Button) view.findViewById(R.id.btnRadioOnOff);
        btnDefault = (Button) view.findViewById(R.id.btnDefault);

        Button LedOn = (Button) view.findViewById(R.id.btnLedOn);
        Button LedOff= (Button) view.findViewById(R.id.btnLedOff);
        Button Loop = (Button) view.findViewById(R.id.btnLoop);
        Button StopLoop = (Button) view.findViewById(R.id.btnStopLoop);
        Button Connect = (Button) view.findViewById(R.id.btnConnect);


        pushpull.setOnTouchListener(tabController.this);

        btnLeft.setOnTouchListener(tabController.this);
        btnRight.setOnTouchListener(tabController.this);
        btnUp.setOnTouchListener(tabController.this);
        btnDown.setOnTouchListener(tabController.this);
        btnRadioOnOff.setOnTouchListener(tabController.this);
        btnDefault.setOnTouchListener(tabController.this);


        LedOn.setOnTouchListener(tabController.this);
        LedOff.setOnTouchListener(tabController.this);
        Loop.setOnTouchListener(tabController.this);
        StopLoop.setOnTouchListener(tabController.this);
        Connect.setOnTouchListener(tabController.this);



        txtChannel.setText(String.valueOf(MainActivity.channelValue));
        txtVolume.setText(String.valueOf(MainActivity.volumeValue));

        start();

        return view;

    }
}
