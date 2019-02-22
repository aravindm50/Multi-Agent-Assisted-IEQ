package ielettronica.it.websocketeasy;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

//import de.tavendo.autobahn.WebSocketConnection;

/**
 * Created by GNardelli on 03/12/2015.
 *
 */
public class tabSqlite extends Fragment implements View.OnTouchListener  {


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

        View view =inflater.inflate(R.layout.tabsqlite,container,false);

        Button btnAddDB = (Button) view.findViewById(R.id.btnAddDB);
        btnAddDB.setOnTouchListener(tabSqlite.this);

        Button btnDelDB = (Button) view.findViewById(R.id.btnDelDB);
        btnDelDB.setOnTouchListener(tabSqlite.this);


        txtInput = (EditText) view.findViewById(R.id.txtInput);
        txtOutput = (TextView) view.findViewById(R.id.txtOutput);
        //dbHandler = new MyDBHandler(mContext, null, null,1);
        //printDatabase();

        return view;

    }



    //public void printDatabase() {
    //    String dbString = dbHandler.databaseToString();
    //    txtOutput.setText(dbString);
    //    txtInput.setText("");
    //}


    @Override
    public boolean onTouch(View v, MotionEvent event) {
        if (v.getId() == R.id.btnAddDB) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    Products product = new Products(txtInput.getText().toString());
                    dbHandler.addProduct(product);
                    //printDatabase();
                    Toast.makeText(mContext, "value added to the database", Toast.LENGTH_SHORT).show();
                    break;
            }
            return true;
        } else if (v.getId() == R.id.btnDelDB) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    String inputText = txtInput.getText().toString();
                    dbHandler.deleteProduct(inputText);
                    //printDatabase();
                    //Toast.makeText(mContext, "delete a value from the database", Toast.LENGTH_SHORT).show();
                    break;
            }
            return true;
        }  else {
            return false;
        }
    }




}
