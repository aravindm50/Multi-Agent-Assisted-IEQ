package ielettronica.it.websocketeasy;

/**
 * Created by gnardelli on 11/22/15.
 */

import android.content.Context;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserFactory;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class SitesXmlPullParser {

    private String FileXml;
    private int res_id;
    final String KEY_SITE = "site";
    final String KEY_NAME = "name";
    final String KEY_LINK = "link";
    final String KEY_ABOUT = "about";
    final String KEY_IMAGE_URL = "image";

    public SitesXmlPullParser(String FileXmlReceived) {
        this.FileXml=FileXmlReceived;
    }

    public SitesXmlPullParser(int res_id) {
        this.res_id=res_id;
        this.FileXml = null;
    }

    public List<StackSite> getStackSitesFromFile(Context ctx) {

        // List of StackSites that we will return
        List<StackSite> stackSites;
        stackSites = new ArrayList<StackSite>();

        // temp holder for current StackSite while parsing
        StackSite curStackSite = null;
        // temp holder for current text value while parsing
        String curText = "";

        try {
            // Get our factory and PullParser
            XmlPullParserFactory factory = XmlPullParserFactory.newInstance();
            XmlPullParser xpp = factory.newPullParser();

            BufferedReader reader;

            if (FileXml == null) {
                InputStream is = ctx.getResources().openRawResource(res_id);
                InputStreamReader isr = new InputStreamReader(is);
                reader = new BufferedReader(isr, 8192);
            } else {
                // Open up InputStream and Reader of our file.
                FileInputStream fis;
                try {
                     fis = ctx.openFileInput(FileXml);
                } catch (Exception ex) {
                     fis = new FileInputStream(FileXml);
                }
                reader = new BufferedReader(new InputStreamReader(fis));
            }


            // point the parser to our file.
            xpp.setInput(reader);

            // get initial eventType
            int eventType = xpp.getEventType();

            // Loop through pull events until we reach END_DOCUMENT
            while (eventType != XmlPullParser.END_DOCUMENT) {
                // Get the current tag
                String tagname = xpp.getName();

                // React to different event types appropriately
                switch (eventType) {
                    case XmlPullParser.START_TAG:
                        if (tagname.equalsIgnoreCase(KEY_SITE)) {
                            // If we are starting a new <site> block we need
                            //a new StackSite object to represent it
                            curStackSite = new StackSite();
                        }
                        break;

                    case XmlPullParser.TEXT:
                        //grab the current text so we can use it in END_TAG event
                        curText = xpp.getText();
                        break;

                    case XmlPullParser.END_TAG:
                        if (tagname.equalsIgnoreCase(KEY_SITE)) {
                            // if </site> then we are done with current Site
                            // add it to the list.
                            stackSites.add(curStackSite);
                        } else if (tagname.equalsIgnoreCase(KEY_NAME)) {
                            // if </name> use setName() on curSite
                            curStackSite.setName(curText);
                        } else if (tagname.equalsIgnoreCase(KEY_LINK)) {
                            // if </link> use setLink() on curSite
                            curStackSite.setLink(curText);
                        } else if (tagname.equalsIgnoreCase(KEY_ABOUT)) {
                            // if </about> use setAbout() on curSite
                            curStackSite.setAbout(curText);
                        } else if (tagname.equalsIgnoreCase(KEY_IMAGE_URL)) {
                            // if </image> use setImgUrl() on curSite
                            curStackSite.setImgUrl(curText);
                        }
                        break;

                    default:
                        break;
                }
                //move on to next iteration
                eventType = xpp.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // return the populated list.
        return stackSites;
    }
}
