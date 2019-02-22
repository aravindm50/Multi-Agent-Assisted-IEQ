package ielettronica.it.websocketeasy;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.view.ViewGroup;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by GNARDELLI on 28/11/2015.
 * Rememeber to update also the number 3 in case you wabt to add a new TAB
 */
public class ma_pager_adapter extends FragmentPagerAdapter {

    private Context mContext;
    private Map<Integer, String> mFragmentTags;
    private FragmentManager mFragmentManager;

    public ma_pager_adapter(FragmentManager fm, Context mContext) {
        super(fm);
        mFragmentManager = fm;
        this.mContext = mContext;
        mFragmentTags = new HashMap<Integer, String>();
    }


    //private  WebSocketConnection mConnection = new WebSocketConnection();

    @Override
    public Fragment getItem(int i) {

        switch (i) {
            case 0:
                tabController t1 = new tabController();
                //t1.getArgument(mConnection,mContext);
                return t1;
            case 1:
                tabRemote tRemote = new tabRemote();
                //tRemote.getArgument(mConnection,mContext);
                return tRemote;
            case 2:
                tabLocal tLocal = new tabLocal();
                //tLocal.getArgument(mConnection,mContext);
                return tLocal;
            case 3:
                tabSqlite tSQLite = new tabSqlite();
                //tSQLite.getArgument(mConnection,mContext);
                return tSQLite;
            case 4:
                tabVideo tVideo = new tabVideo();
                //tVideo.getArgument(mConnection,mContext);
                return tVideo;

        }
        return null;
    }



    @Override
    public int getCount() {
        return 5;
    }//set the number of tabs

    @Override
    public CharSequence getPageTitle(int position) {
        //Locale l = Locale.getDefault();
        switch (position) {
            case 0:
                return "Controller";
            case 1:
                return "Playlist Remote";
            case 2:
                return "Playlist Local";
            case 3:
                return "SQLite local Playlist";
            case 4:
                return "Video Output";
        }
        return null;
    }



    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        Object obj =  super.instantiateItem(container, position);
        if (obj instanceof Fragment) {
            Fragment f = (Fragment) obj;
            String tag = f.getTag();
            mFragmentTags.put(position,tag);
        }

        return obj;
    }

    public Fragment getFragment(int position) {
        String tag = mFragmentTags.get(position);
        if (tag == null)
                return null;
        return mFragmentManager.findFragmentByTag(tag);
    }


}
