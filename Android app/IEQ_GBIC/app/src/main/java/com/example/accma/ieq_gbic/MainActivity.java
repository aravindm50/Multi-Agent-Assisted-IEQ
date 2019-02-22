package com.example.accma.ieq_gbic;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.SeekBar;
import android.widget.TextView;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.WebSocket;
import okhttp3.WebSocketListener;
import okio.ByteString;
import android.widget.EditText;
//import android.widget.Toast;
import java.util.regex.Pattern;
import java.util.regex.Matcher;




public class MainActivity extends AppCompatActivity {

    private Button start;
    private Button set2;

    private TextView output;
    private TextView textView;
    private OkHttpClient client;
    public  static WebSocket WS;
    public EditText editText1;
    private SeekBar sb1;
    public static Request request;
    public static final String URL_REGEX = "^((www|ws).//|\\.)?[a-z0-9-]+(\\.[a-z0-9-]+)+([/?].*)?$";

    private final class EchoWebSocketListener extends WebSocketListener {
        private static final int NORMAL_CLOSURE_STATUS = 4999;



        @Override
        public void onOpen(WebSocket webSocket, Response response) {
            webSocket.send("28");

            //webSocket.close(NORMAL_CLOSURE_STATUS, "Goodbye !");
        }

        @Override
        public void onMessage(WebSocket webSocket, String text) {
            //output("Receiving : " + text);
        }

        @Override
        public void onMessage(WebSocket webSocket, ByteString bytes) {
            //output("Receiving bytes : " + bytes.hex());
        }

        @Override
        public void onClosing(WebSocket webSocket, int code, String reason) {
            //webSocket.close(NORMAL_CLOSURE_STATUS, null);
            //output("Closing : " + code + " / " + reason);
        }

        @Override
        public void onFailure(WebSocket webSocket, Throwable t, Response response) {
            //output("Error : " + t.getMessage());
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        start = (Button) findViewById(R.id.SET_TEMPERATURE);
        set2 = (Button) findViewById(R.id.set1);

        output = (TextView) findViewById(R.id.output);
        client = new OkHttpClient();

        sb1 = (SeekBar) findViewById(R.id.seekBar);

        View view = getLayoutInflater().inflate(R.layout.activity_main, null, false);

        editText1 = view.findViewById(R.id.editText);

        start.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                start();
            }
        });

        set2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EditText text1 = (EditText)findViewById(R.id.editText);
                String urlws = text1.getText().toString();
                Pattern p = Pattern.compile(URL_REGEX);
                Matcher m = p.matcher(urlws);//replace with string to compare
                //if(m.find()) {
                    set2(urlws);
                //}


            }
        });




        initializeVariables();
        int max = 35;
        int min = 20;
        sb1.setMax(max);
        sb1.setMin(min);

        textView.setText( sb1.getProgress() + "deg. C" );


        sb1.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            int progress = 0;

            @Override
            public void onProgressChanged(SeekBar seekBar, int progresValue, boolean fromUser) {
                progress = progresValue;
                //Toast.makeText(getApplicationContext(), "Changing seekbar's progress", Toast.LENGTH_SHORT).show();


            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
                //Toast.makeText(getApplicationContext(), "Started tracking seekbar", Toast.LENGTH_SHORT).show();

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                textView.setText(progress + "deg. C");
               // Toast.makeText(getApplicationContext(), "Stopped tracking seekbar", Toast.LENGTH_SHORT).show();
            }

        });
    }


    public void start() {
        sb2();
    }

    private void output(final String txt) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                output.setText(output.getText().toString() + "\n\n" + txt);

            }
        });
    }

    private void sb2(){
        String a = String.valueOf(sb1.getProgress());
        WS.send(a);

    }

    private void set2(String urlws) {

        request = new Request.Builder().url(urlws).build();
        EchoWebSocketListener listener = new EchoWebSocketListener();
        WS = client.newWebSocket(request, listener);
    }



    private void initializeVariables(){

        sb1 = (SeekBar) findViewById(R.id.seekBar);
        textView = (TextView) findViewById(R.id.textView1);

    }
}