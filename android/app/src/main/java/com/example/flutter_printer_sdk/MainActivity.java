package com.example.menthee_flutter_project;

import android.annotation.SuppressLint;
import android.app.Presentation;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.hardware.display.DisplayManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.view.Display;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.imin.image.ILcdManager;
import com.imin.library.IminSDKManager;
import com.imin.library.SystemPropManager;
import com.imin.printerlib.Callback;
import com.imin.printerlib.IminPrintUtils;
import com.imin.printerlib.print.PrintUtils;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.lang.ref.SoftReference;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
@SuppressLint("NewApi")
public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.imin.printersdk";
    private static MethodChannel.Result scanResult;

    private IminPrintUtils.PrintConnectType connectType = IminPrintUtils.PrintConnectType.USB;
    private Presentation presentation;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
            if(!Settings.canDrawOverlays(this)){
                Toast.makeText(this,"Menthee Technology",Toast.LENGTH_SHORT).show();
                startActivity(new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION));
            }
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("sdkInit")) {
                        String deviceModel = SystemPropManager.getModel();
                        if(deviceModel.contains("M2-203") ||deviceModel.contains("M2-202")|| deviceModel.contains("M2 Pro")
                                || deviceModel.contains("M2-Pro")){
                            connectType = IminPrintUtils.PrintConnectType.SPI;
                        }else {
                            connectType = IminPrintUtils.PrintConnectType.USB;
                        }
                        IminPrintUtils.getInstance(MainActivity.this).initPrinter(connectType);
                        result.success("init");
                    }else if(call.method.equals("getStatus")){
                        Log.d("1258XGH", " 呵呵哈哈哈 111 === 》connectType:"+connectType + "  PrintUtils.getPrintStatus==  " + PrintUtils.getPrintStatus());

                        if (connectType == IminPrintUtils.PrintConnectType.USB){
                            int status =
                                    IminPrintUtils.getInstance(MainActivity.this).getPrinterStatus(connectType);

                            result.success(String.format("%d",status));
                        }else {
                            Log.d("1258XGH", " 呵呵哈哈哈 22 === 》print SPI status:" + "  PrintUtils.getPrintStatus==  " + PrintUtils.getPrintStatus());

                            IminPrintUtils.getInstance(MainActivity.this).getPrinterStatus(IminPrintUtils.PrintConnectType.SPI, new Callback() {
                                @Override
                                public void callback(int status) {
                                    Log.d("1258XGH", " 呵呵哈哈哈 33 === 》print SPI status:" + status + "  PrintUtils.getPrintStatus==  " + PrintUtils.getPrintStatus());

                                    result.success(String.format("%d",status));
                                }

                            });
                        }

                    }else if(call.method.equals("printText")){
                        if(call.arguments() == null) return;
                        String text = ((List)call.arguments()).get(0).toString();
                        IminPrintUtils mIminPrintUtils =
                                IminPrintUtils.getInstance(MainActivity.this);
                        mIminPrintUtils.printText(text + "   \n");
                        result.success(text);
                    }else if(call.method.equals("getSn")){
                        String sn = "";
                        if (Build.VERSION.SDK_INT >= 30) {
                            sn = SystemPropManager.getSystemProperties("persist.sys.imin.sn");
                        } else {
                            sn = SystemPropManager.getSn();
                        }
                        result.success(sn);
                    }else if(call.method.equals("opencashBox")){
                        IminSDKManager.opencashBox();
                        result.success("opencashBox");
                    }else if (call.method.equals("printBitmap")){
                        byte[] image = call.argument("image");
                        Bitmap bitmap = null;
                        bitmap = byteToBitmap(image);
                        IminPrintUtils mIminPrintUtils =
                                IminPrintUtils.getInstance(MainActivity.this);
                        mIminPrintUtils.printSingleBitmap(bitmap);
                        mIminPrintUtils.printAndFeedPaper(30);
                        mIminPrintUtils.fullCut();
                        result.success("printBitmap");
                    }else if(call.method.equals("partialCut")){
                        IminPrintUtils.getInstance(MainActivity.this).partialCut();
                        result.success("partialCut");
                    }
                    else if(call.method.equals("setTextTypeface")){
                        if(call.arguments() == null) return;
                        int value = (int) ((List)call.arguments()).get(0);
                        //                    参数 value=0:设置字体默认 Typeface.DEFAULT ； value=1  等宽字体Typeface.MONOSPACE ； value=2 Typeface.DEFAULT_BOLD 加粗字体；
//                    value=3 Typeface.SANS_SERIF ； value=4 Typeface.SERIF
                        if (value == 0){
                            IminPrintUtils.getInstance(MainActivity.this).setTextTypeface(Typeface.DEFAULT);
                        }else if (value == 1){
                            IminPrintUtils.getInstance(MainActivity.this).setTextTypeface(Typeface.MONOSPACE);
                        }else if (value == 2){
                            IminPrintUtils.getInstance(MainActivity.this).setTextTypeface(Typeface.DEFAULT_BOLD);
                        }else if (value == 3){
                            IminPrintUtils.getInstance(MainActivity.this).setTextTypeface(Typeface.SANS_SERIF);
                        }else if (value == 4){
                            IminPrintUtils.getInstance(MainActivity.this).setTextTypeface(Typeface.SERIF);
                        }else {
                            IminPrintUtils.getInstance(MainActivity.this).setTextTypeface(Typeface.DEFAULT);
                        }
                        IminPrintUtils.getInstance(MainActivity.this).printText("iMin committed to use advanced technologies to help our business partners digitize their business.We are dedicated in becoming a leading provider of smart business equipment \" +\n" +
                                "                                            \"in ASEAN countries,assisting our partners to connect, create and utilize data effectively.\n");
                        result.success("setTextTypeface");
                    } else if (call.method.equals("setTextSize")) {
                        if(call.arguments() == null) return;
                        int value = (int) ((List)call.arguments()).get(0);
                        IminPrintUtils.getInstance(MainActivity.this).setTextSize(value);
                        result.success("setTextSize");
                    }

                    else if (call.method.equals("initLCD")) {
                        ILcdManager.getInstance(MainActivity.this).sendLCDCommand(1);
                        ILcdManager.getInstance(MainActivity.this).sendLCDCommand(4);
                        result.success("initLCD");
                    }
                    else if (call.method.equals("sendLCDString")) {
                        if(call.arguments() == null) return;
                        String text = ((List)call.arguments()).get(0).toString();
                        ILcdManager.getInstance(MainActivity.this).sendLCDString(text);
                        result.success("sendLCDString");
                    }
                    else if (call.method.equals("sendLCDBitmap")) {
                        if(call.arguments() == null) return;
                        byte[] image = call.argument("image");
                        Bitmap bitmap = null;
                        bitmap = byteToBitmap(image);
                        ILcdManager.getInstance(MainActivity.this).sendLCDBitmap(bitmap);
                        result.success("sendLCDBitmap");
                    }
                    else if (call.method.equals("sendLCDDoubleString")) {
                        if(call.arguments() == null) return;
                        String toptext = call.argument("topText");
                        String bottomText = call.argument("bottomText");
//                        try {
//                            Log.e("sdfdfdfsdfjskdj","      ===> "+ call.argument("topText")+" ....   ===>  " +
//                                    ""+ new String(call.argument("topText"),"gbk") +"  "+bottomText);
//                        } catch (UnsupportedEncodingException e) {
//                            e.printStackTrace();
//                        }
                        ILcdManager.getInstance(MainActivity.this).sendLCDDoubleString(toptext,bottomText);
                        result.success("sendLCDDoubleString");
                    }
                    else if (call.method.equals("sendLCDFillStringWithSize")) {
                        if(call.arguments() == null) return;
                        String text = call.argument("text");
                        int size = call.argument("size");
                        ILcdManager.getInstance(MainActivity.this).sendLCDFillStringWithSize(text, size);
                        result.success("sendLCDFillStringWithSize");
                    }
                    else if (call.method.equals("sendLCDMultiString")) {
                        Log.e("sdfdfdfsdfjskdj","    1111  ===> ");
                        if(call.arguments() == null) return;
                        List<String> strings = call.argument("text");
                        List<Integer> ints = call.argument("alignment");
                        int[] ints1 = new int[ints.size()];
                        for (int i=0;i<ints.size();i++){
                            ints1[i] = ints.get(i);
                        }
                        Log.e("sdfdfdfsdfjskdj","      ===> "+ strings.get(0)+" ////> "+Arrays.toString(ints1));
                        ILcdManager.getInstance(MainActivity.this).sendLCDMultiString(strings.toArray(new String[strings.size()]), ints1);
                        result.success("sendLCDMultiString");
                    }
                    else if (call.method.equals("StartDifferentDisplay")){
                       // if(call.arguments() == null) return;
                        android.util.Log.e(TAG,"StartDifferentDisplay==> " );
                        if(presentation != null){
                            presentation.cancel();
                        }
                        android.util.Log.e(TAG,"StartDifferentDisplay==> " );
                        showSecondByDisplayManager(MainActivity.this);
                    }
                    else if (call.method.equals("DisplayShowText")){
                        if(call.arguments() == null) return;
                        String text = ((List)call.arguments()).get(0).toString();
                        if(presentation != null){
                            TextView textView = presentation.findViewById(R.id.text);
                            textView.setText(text);
                        }
                    }
                    else if (call.method.equals("DisplayShowPic")){
                        if(call.arguments() == null) return;
                        byte[] image = call.argument("image");
                        Bitmap bitmap = null;
                        bitmap = byteToBitmap(image);
                        if(presentation != null){
                            ImageView imageView = presentation.findViewById(R.id.image);
                            imageView.setVisibility(View.VISIBLE);
                            imageView.setImageBitmap(bitmap);
                        }
                    }
                }
        );
    }

    private void showSecondByDisplayManager(Context context) {
        DisplayManager mDisplayManager = (DisplayManager) getSystemService(Context.DISPLAY_SERVICE);
        Display[] displays = mDisplayManager.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION);
        if (displays != null && getPresentationDisplays() != null) {
            presentation = new DifferentDisplay(context, getPresentationDisplays());
            presentation.show();
        }else {
            Toast.makeText(MainActivity.this,getString(R.string.no_second_screen),Toast.LENGTH_SHORT);
        }
        /*副屏的Window*/

    }
    private static final String TAG = "sdfdfdfsdfjskdj";
    public Display getPresentationDisplays() {
        DisplayManager mDisplayManager= (DisplayManager)getSystemService(Context.DISPLAY_SERVICE);
        Display[] displays =mDisplayManager.getDisplays();
        if (displays != null){
            for(int i=0;  i < displays.length; i++){
                android.util.Log.e(TAG,"屏幕==>" +displays[i] + " Flag:==> " + displays[i].getFlags());
                if((displays[i].getFlags() & Display.FLAG_SECURE)!=0
                        &&(displays[i].getFlags() & Display.FLAG_SUPPORTS_PROTECTED_BUFFERS)!=0
                        &&(displays[i].getFlags() & Display.FLAG_PRESENTATION) !=0){
                    android.util.Log.e(TAG,"第一个真实存在的副屏屏幕==> " + displays[i]);
                    return displays[i];
                }
            }
        }

        return null;
    }

    public static String urlEncodeURL(String str) {
        try {
            String result = URLEncoder.encode(str, "UTF-8");
            result = result.replaceAll("%3A", ":").replaceAll("%2F", "/").replaceAll("\\+", "%20");//+实际上是 空格 url encode而来
            return result;
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Bitmap byteToBitmap(byte[] imgByte) {
        InputStream input = null;
        Bitmap bitmap = null;
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inSampleSize = 1;
        input = new ByteArrayInputStream(imgByte);
        SoftReference softRef = new SoftReference(BitmapFactory.decodeStream(
                input, null, options));  //�����÷�ֹOOM
        bitmap = (Bitmap) softRef.get();
        if (imgByte != null) {
            imgByte = null;
        }

        try {
            if (input != null) {
                input.close();
            }
        } catch (IOException e) {
            // �쳣����
            e.printStackTrace();
        }
        return bitmap;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if(presentation != null){
            presentation.cancel();
        }
    }
}
