package com.example.menthee_flutter_project;

import android.annotation.SuppressLint;
import android.app.Presentation;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.VideoView;

import androidx.annotation.RequiresApi;


@SuppressLint("NewApi")
public class DifferentDisplay extends Presentation {

    private TextView text;
    private ImageView image;
    private VideoView video;

    public DifferentDisplay(Context outerContext, Display display) {
        super(outerContext, display);

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.display_layout);
        //此功能作用于主屏Activity返回桌面后，副屏View仍然显示
        //This function is used to display the secondary
        // screen View after the main screen activity returns to the desktop
        if (Build.VERSION.SDK_INT>=26){
            //8.0 以上安卓版本 新增的悬浮窗口类型 新增画布式   New hover window type for Android version above 8.0, new canvas type
            // 画中画等详细请查看android sdk    For details such as picture in picture, please check the android sdk
            getWindow().setType(WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY);
        }else {
            // 8.0 以下的安卓版本要实现上述功能使用以下api  Android versions below 8.0 use the following apis to achieve the above functions
            getWindow().setType(WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY);
        }
        text = findViewById(R.id.text);
        image = findViewById(R.id.image);
        video = findViewById(R.id.video);
    }


}
