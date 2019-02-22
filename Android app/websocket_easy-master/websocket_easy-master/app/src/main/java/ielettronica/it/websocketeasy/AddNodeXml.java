package ielettronica.it.websocketeasy;

/**
 * Created by gnardelli on 11/29/15.
 *
 */


import android.content.Context;
import android.os.Environment;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;


public class AddNodeXml {

    public static void addElement(Context ctx, String nameStr, String aboutStr, String linkStr, String imageStr) throws Exception {


        String filePath = Environment.getExternalStorageDirectory()+"/.Playlist/playlistlocal.xml";

        File file = new File(filePath);
        DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
        Document document = docBuilder.parse(file);
        Element root = document.getDocumentElement();



        //InputStream is = ctx.getResources().openRawResource(R.raw.playlistlocal);
        //DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        //DocumentBuilder builder = factory.newDocumentBuilder();
        //Document document = builder.parse(is);


        Element newElement = document.createElement("site");

        Element name = document.createElement("name");
        name.appendChild(document.createTextNode(nameStr));
        newElement.appendChild(name);

        Element about = document.createElement("about");
        about.appendChild(document.createTextNode(aboutStr));
        newElement.appendChild(about);

        Element link = document.createElement("link");
        link.appendChild(document.createTextNode(linkStr));
        newElement.appendChild(link);

        Element image = document.createElement("image");
        image.appendChild(document.createTextNode(imageStr));
        newElement.appendChild(image);


        root.appendChild(newElement);




        DOMSource source = new DOMSource(document);

        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer transformer = transformerFactory.newTransformer();


        StreamResult result = new StreamResult(file);
        transformer.transform(source, result);

        System.out.println(root);
    }


}



