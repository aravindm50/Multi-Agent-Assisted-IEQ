package ielettronica.it.websocketeasy;

import android.content.Context;
import android.graphics.Bitmap;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.assist.ImageLoadingListener;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.List;

//import de.tavendo.autobahn.WebSocketConnection;

/**
 * Created by GNardelli on 03/12/2015.
 *
 */
public class tabRemote extends Fragment implements View.OnTouchListener {



    private SitesXmlPullParser smplLocal;

    //private WebSocketConnection mConnection;
    private Context mContext;

    private  List<StackSite> itemsSS;
    private ListView sitesMusic;

    private MyListAdapter adapterBtn2;

    @Override
    public void onResume() {
        super.onResume();
    }

    //public void getArgument(WebSocketConnection mConnection, Context mContext) {
    //    this.mConnection=mConnection;
    //    this.mContext = mContext;
    //}

    // private boolean isNetworkAvailable() {
    //   ConnectivityManager connectivityManager
    //            = (ConnectivityManager) mContext.getSystemService(Context.CONNECTIVITY_SERVICE);
    //    NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
    //    return activeNetworkInfo != null && activeNetworkInfo.isConnected();
    //}


    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view =inflater.inflate(R.layout.tabremote,container,false);

        Button btnRelease = (Button) view.findViewById(R.id.btnRelease);
        btnRelease.setOnTouchListener(tabRemote.this);


        smplLocal = new SitesXmlPullParser("PlayList.xml");
        sitesMusic = (ListView) view.findViewById(R.id.sitesMusic);


        //if (isNetworkAvailable()) {
        //    Log.i("StackSites", "starting download Task");
        //    SitesDownloadTask2 download2 = new SitesDownloadTask2();
        //    download2.execute();
        //} else {
        //    SitesXmlPullParser smplLocal = new SitesXmlPullParser("PlayList.xml");
        //    itemsSS = smplLocal.getStackSitesFromFile(mContext);
        //    adapterBtn2 = new MyListAdapter(mContext,  itemsSS);
        //    sitesMusic.setAdapter(adapterBtn2);
        //}



        return view;

    }



    @Override
    public boolean onTouch(View v, MotionEvent event) {
            if (v.getId() == R.id.btnRelease) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        try {
                            MainActivity.mPlayer.release();
                        } catch (Exception ex) {
                            System.out.print(ex);
                        }
                        //mConnection.sendTextMessage("radiooff");
                        break;
                }
                return true;
            }   else {
                return false;
            }
    }



    private class SitesDownloadTask2 extends AsyncTask<Void, Void, Void> {


        @Override
        protected Void doInBackground(Void... arg0) {
            //Download the file
            try {
                Downloader.DownloadFromUrl("https://dl.dropboxusercontent.com/u/51109679/android/playlist.xml", mContext.openFileOutput("PlayList.xml", Context.MODE_PRIVATE));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }

            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            //setup our Adapter and set it to the ListView.
            SitesAdapter mAdapter2 = new SitesAdapter(mContext, -1, smplLocal.getStackSitesFromFile(mContext));
            sitesMusic.setAdapter(mAdapter2);
            //Log.i("StackSites", "adapter size = " + mAdapter2.getCount());
            itemsSS = smplLocal.getStackSitesFromFile(mContext);
            adapterBtn2 = new MyListAdapter(mContext, itemsSS);
            sitesMusic.setAdapter(adapterBtn2);
        }

    }

    private class MyListAdapter extends BaseAdapter {
        private List<StackSite> mItems;
        private LayoutInflater mInflater;
        StackSite stk;
        ImageLoader imageLoader;
        DisplayImageOptions options;
        Context cloc;
        PlaylistValues plv;

        public MyListAdapter (Context c, List<StackSite> items) {
            mItems = items;
            this.cloc = c;
            //Cache a reference to avoid looking it up on every getView() call
            mInflater = LayoutInflater.from(c);

            //Setup the ImageLoader, we'll use this to display our images
            ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(c).build();
            imageLoader = ImageLoader.getInstance();
            imageLoader.init(config);

            //Setup options for ImageLoader so it will handle caching for us.
            options = new DisplayImageOptions.Builder()
                    .cacheInMemory()
                    .cacheOnDisc()
                    .build();
        }

        @Override
        public int getCount () {
            return mItems.size();
        }

        @Override
        public long getItemId (int position) {
            return position;
        }

        @Override
        public Object getItem (int position) {
            return mItems.get(position);
        }

        @Override
        public View getView (final int position, View convertView, ViewGroup parent) {
            //If there's no recycled view, inflate one and tag each of the views
            //you'll want to modify later
            //Log.d("Inside", "GetView");

            plv = null;
            if (convertView == null) {
                convertView = mInflater.inflate (R.layout.row_site_remote, parent, false);
                plv = new PlaylistValues();
                plv.nameTxt = (TextView) convertView.findViewById(R.id.nameTxt);
                plv.aboutTxt = (TextView) convertView.findViewById(R.id.aboutTxt);
                plv.iconImg = (ImageView) convertView.findViewById(R.id.iconImg);
                plv.btnPlayLocal = (Button) convertView.findViewById(R.id.btnPlayLocal);
                plv.btnPlayRemote = (Button) convertView.findViewById(R.id.btnPlayRemote);
                plv.indicator = (ProgressBar)convertView.findViewById(R.id.progress);
                plv.btnAddLocal = (Button) convertView.findViewById(R.id.btnAddLocal);

                //This assumes layout/row_left.xml includes a TextView with an id of "textview"
                convertView.setTag (plv);
            } else {
                plv = (PlaylistValues) convertView.getTag();
            }

            //Initially we want the progress indicator visible, and the image invisible
            plv.indicator.setVisibility(View.VISIBLE);
            plv.iconImg.setVisibility(View.INVISIBLE);

            //Retrieve the tagged view, get the item for that position, and
            //update the text

            ImageLoadingListener listener = new ImageLoadingListener(){


                @Override
                public void onLoadingStarted(String arg0, View arg1) {
                    // TODO Auto-generated method stub
                    plv.indicator.setVisibility(View.INVISIBLE);
                    plv.iconImg.setVisibility(View.VISIBLE);

                }

                @Override
                public void onLoadingCancelled(String arg0, View arg1) {
                    // TODO Auto-generated method stub

                }

                @Override
                public void onLoadingComplete(String arg0, View arg1, Bitmap arg2) {
                    //plv.indicator.setVisibility(View.INVISIBLE);
                    //plv.iconImg.setVisibility(View.VISIBLE);
                }

                @Override
                public void onLoadingFailed(String arg0, View arg1, FailReason arg2) {
                    // TODO Auto-generated method stub

                }

            };

            stk = mItems.get(position);
            plv.nameTxt.setText(stk.getName());
            plv.aboutTxt.setText(stk.getAbout());
            imageLoader.displayImage(stk.getImgUrl(), plv.iconImg, options, listener);



            plv.btnPlayLocal.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    StackSite stkloc = mItems.get(position);
                    Uri myUri = Uri.parse(stkloc.getLink());
                    try {
                        MainActivity.mPlayer.release();

                    } catch (Exception ex) {
                        System.out.print(ex);
                    }
                    MainActivity.mPlayer = MediaPlayer.create(cloc, myUri);

                    MainActivity.mPlayer.start();
                    Toast.makeText(cloc, "Play Locally: " + stkloc.getName(),
                            Toast.LENGTH_SHORT).show();
                }
            });

            plv.btnPlayRemote.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    StackSite stkloc = mItems.get(position);
                    String url = stkloc.getLink();
                    //String nameStation = stkloc.getName();
                    //Toast.makeText(mContext, nameStation + " is sent", Toast.LENGTH_SHORT).show();
                    //mConnection.sendTextMessage("radioon");
                    //mConnection.sendTextMessage("{radio:" + url + "}");


                    Toast.makeText(cloc, "Play Remotely: " + stkloc.getName(),
                            Toast.LENGTH_SHORT).show();
                }
            });

            plv.btnAddLocal.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    StackSite stkloc = mItems.get(position);
                    String url = stkloc.getLink();
                    String nameStation = stkloc.getName();
                    String aboutStation = stkloc.getAbout();
                    String imageStation = stkloc.getImgUrl();
                    Toast.makeText(mContext, nameStation + " is added in Local Playlist", Toast.LENGTH_SHORT).show();

                    try {

                        String filePath = Environment.getExternalStorageDirectory()+"/.Playlist/playlistlocal.xml";

                        //SitesXmlPullParser smplLocal = new SitesXmlPullParser(R.raw.playlistlocal);
                        SitesXmlPullParser smplLocal = new SitesXmlPullParser(filePath);
                        List<StackSite> lst = smplLocal.getStackSitesFromFile(mContext);

                        if (lst.size() == 0) {
                            InputStream in = getResources().openRawResource(R.raw.playlistlocal);
                            try {
                                FileOutputStream out = new FileOutputStream(filePath);
                                byte[] buff = new byte[1024];
                                int read = 0;

                                try {
                                    while ((read = in.read(buff)) > 0) {
                                        out.write(buff, 0, read);
                                    }
                                } finally {
                                    in.close();
                                    out.close();
                                }
                            } catch (Exception ex) {
                                System.out.print("Some error to copy the playlist locally");
                            }
                        }


                        SitesXmlPullParser sxpp = new SitesXmlPullParser(filePath);
                        List<StackSite> ListStackSite= sxpp.getStackSitesFromFile(mContext);
                        String nameStationFile;
                        Boolean alreadyLocated;
                        alreadyLocated = Boolean.FALSE;
                        for (StackSite sts : ListStackSite ) {
                            nameStationFile = sts.getName();
                            if (nameStationFile.equals(nameStation)) {
                                alreadyLocated = Boolean.TRUE;
                            }
                        }

                        if (!alreadyLocated) {
                            AddNodeXml.addElement(mContext, nameStation, aboutStation, url, imageStation);

                        }



                    } catch (Exception ex) {
                        System.out.print(ex);
                    }


                }
            });


            return convertView;
        }
    }

    private class PlaylistValues {
        ImageView iconImg;
        TextView nameTxt;
        TextView aboutTxt;
        Button btnPlayLocal;
        Button btnPlayRemote;
        Button btnAddLocal;
        ProgressBar indicator;

        //Initially we want the progress indicator visible, and the image invisible

    }
}
