package ielettronica.it.websocketeasy;


import android.graphics.Color;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Environment;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.PagerTabStrip;
import android.support.v4.view.ViewPager;
import android.view.Menu;
import android.view.MenuItem;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;


public class MainActivity extends FragmentActivity {


    ViewPager pager;
    PagerTabStrip tab_strp;
    public static MediaPlayer mPlayer;

    public static int channelValueMax;
    public static int channelValue;
    public static int volumeValue;




    //private ArrayList<String> data = new ArrayList<String>();
    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }



    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }






    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        setContentView(R.layout.main_tab);
        ma_pager_adapter mapager=new ma_pager_adapter(getSupportFragmentManager(),this);
        pager=(ViewPager)findViewById(R.id.pager);

        pager.setAdapter(mapager);
        tab_strp=(PagerTabStrip)findViewById(R.id.tab_strip);
        tab_strp.setTextColor(Color.WHITE);





       // pager.setOffscreenPageLimit(0);

        File folder = new File(Environment.getExternalStorageDirectory() + "/.Playlist");

        channelValueMax = 6;
        channelValue = 1;
        volumeValue = 90;

        pager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                Fragment fragment = ((FragmentPagerAdapter) pager.getAdapter()).getItem(position);
                //Fragment fragment = ((FragmentStatePagerAdapter) pager.getAdapter()).getItem(position);
                if (position == 2 && fragment != null) {
                    fragment.onResume();
                }

            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });



        String filePath = Environment.getExternalStorageDirectory()+"/.Playlist/playlistlocal.xml";
        File filePlaylist = new File(filePath);

        if (!folder.exists()) {
            folder.mkdir();
        }

        if (!filePlaylist.exists()) {
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


    }




    @Override
    public void onStart() {
        super.onStart();

    }





    /*
	 * AsyncTask that will download the xml file for us and store it locally.
	 * After the download is done we'll parse the local file.
	 */



}