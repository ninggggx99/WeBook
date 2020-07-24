package com.example.webookapp;
import android.os.Bundle;
// import io.flutter.app.FlutterActivity;
// import io.flutter.plugins.GeneratedPluginRegistrant;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
public class MainActivity extends FlutterActivity {

    @Override 
    protected void onCreate (Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        // GeneratedPluginRegistrant.registerWith(this);
    }
    
    @Override
    public void configureFlutterEngine(@NonNull final FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);      
    }
}
