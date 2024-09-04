import  'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpapers/utils/util_helper.dart';
import '../models/wallpaper_model.dart';

class DetailWallpaperPage extends StatelessWidget {
  SrcModel imgModel;
  DetailWallpaperPage({required this.imgModel});
   //DetailWallpaperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
              height: double.infinity,
              child: Image.network(imgModel.portrait!,fit: BoxFit.fill,)),
          Positioned(
            bottom: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getActionBtn(onTap: (){}, title: 'Info', icons: Icons.info_outline),
                    SizedBox(
                      width: 25,
                    ),
                    getActionBtn(onTap: (){
                      saveWallpaper(context);
                    }, title: 'Save', icons: Icons.download),
                    SizedBox(
                      width: 25,
                    ),
                    getActionBtn(onTap: (){
                      applyWallpaper(context);
                    }, title: 'Apply', icons: Icons.format_paint,bgColor: Colors.blueAccent)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget getActionBtn({required VoidCallback onTap, required String title,required IconData icons,Color? bgColor}){
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: bgColor != null ? Colors.blueAccent : Colors.white.withOpacity(0.4),
          ),
          child: Center(child: Icon(icons,color: Colors.white,size: 30,),),
        ),
        SizedBox(
          height: 2,
        ),
        Text(title,style: mTextStyle12(mColor: Colors.white),)
      ],
    );
  }

  void saveWallpaper(BuildContext context){
    GallerySaver.saveImage(imgModel.portrait!).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Wallpaper saved into gallery"))));
  }

  void applyWallpaper(BuildContext context){
    Wallpaper.imageDownloadProgress(imgModel.portrait!).listen((event) {
      print(event);
    },onDone: (){
      Wallpaper.bothScreen(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        options: RequestSizeOptions.RESIZE_FIT
      ).then((value) {
        print(value);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Wallpaper set on Home Screen and Lock Screen !!")));
      });
    },onError: (e){
      GallerySaver.saveImage(imgModel.portrait!).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download ERROR: $e, Error while setting  the wallpaper"))));
    });
  }
}
