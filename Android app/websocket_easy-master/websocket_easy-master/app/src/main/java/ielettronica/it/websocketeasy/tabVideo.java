package ielettronica.it.websocketeasy;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.VideoView;

//import de.tavendo.autobahn.WebSocketConnection;

/**
 * Created by GNardelli on 03/12/2015.
 *
 */
public class tabVideo extends Fragment {

    //private WebSocketConnection mConnection;
    private Context mContext;

    EditText txtInput;
    TextView txtOutput;
    MyDBHandler dbHandler;


    public void onResume() {
        super.onResume();
    }

    //public void getArgument(WebSocketConnection mConnection, Context mContext) {
    //    this.mConnection=mConnection;
    //    this.mContext = mContext;
    //}



    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View view =inflater.inflate(R.layout.tabvideo,container,false);

        final VideoView vView  = (VideoView)view.findViewById(R.id.vView);
        //vView.setVideoPath("https://www.thenewboston.com/forum/project_files/006_testVideo.mp4");
        //vView.setVideoPath("http://www.sample-videos.com/video/mp4/480/big_buck_bunny_480p_50mb.mp4");


        String vidAddress = "https://archive.org/download/ksnn_compilation_master_the_internet/ksnn_compilation_master_the_internet_512kb.mp4";
        Uri vidUri = Uri.parse(vidAddress);
        vView.setVideoURI(vidUri);


        // Play control (play, pause,...)

        //MediaController mediaController = new MediaController(mContext);
        //mediaController.setAnchorView(vView);
        //vView.setMediaController(mediaController);

        //vView.start();


        return view;

    }







}
