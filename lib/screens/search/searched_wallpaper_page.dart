import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpapers/app_widgets/wallpaper_bg_widget.dart';
import 'package:wallpapers/screens/search/cubit/search_cubit.dart';
import 'package:wallpapers/screens/search/cubit/search_state.dart';
import 'package:wallpapers/utils/util_helper.dart';

import '../../models/wallpaper_model.dart';
import '../detail_wallpaper_page.dart';

class SearchedWallPaperPage extends StatefulWidget {
  String query;
  String color;
  SearchedWallPaperPage({super.key, required this.query, this.color = ""});

  @override
  State<SearchedWallPaperPage> createState() => _SearchedWallPaperPageState();
}

class _SearchedWallPaperPageState extends State<SearchedWallPaperPage> {
  ScrollController? scrollController;
  num  totalWallPaperCount = 0;
  int totalNoPages =1;
  int pageCount = 1;
  List<PhotoModel> allWallpapers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    scrollController!.addListener(() {
      if(scrollController!.position.pixels == scrollController!.position.maxScrollExtent){
        print("End of List");
        totalNoPages = totalWallPaperCount~/15+1;
        if(totalNoPages>pageCount){
          pageCount++;
          BlocProvider.of<SearchCubit>(context).getSearchWallpaper(query: widget.query,color: widget.color,page: pageCount);
        }else{
          print('You\'ve reached the end of this category wallpapers!');
        }
      }
    });
    BlocProvider.of<SearchCubit>(context).getSearchWallpaper(query: widget.query,color: widget.color);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: BlocListener<SearchCubit, SearchState>(
        listener:(_,state){
          if(state is SearchLoadingState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pageCount != 1  ? "Next Page Loading.." : 'Loading..')));
          }else if(state is SearchErrorState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMsg)));
          } else if(state is SearchLoadedState){
            totalWallPaperCount = state.totalWallpapers!;
            allWallpapers.addAll(state.listPhotos);
            setState(() {

            });
          }
        },
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: ListView(
        controller: scrollController,
        children: [
          SizedBox(
            height: 40,
          ),
          Text(widget.query,style: mTextStyle34(mFontWeight: FontWeight.w900),),
          Text("${totalWallPaperCount} wallpapers available",style: mTextStyle14(),),
          SizedBox(
            height: 15,
          ),
          Container(
            child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 11,
                  crossAxisSpacing: 11,
                  childAspectRatio: 3/4,
                ),
                itemCount: allWallpapers.length,
                itemBuilder: (_,index){
                  var eachPhoto = allWallpapers[index];
                  return Padding(
                    padding:  EdgeInsets.only(bottom: index == allWallpapers.length-1 ?  11.0 : 0),
                    child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailWallpaperPage(imgModel: eachPhoto.src!,),));
                        },
                        child: WallPaperBgWidget(imgUrl: eachPhoto.src!.portrait!)),
                  );
                }),
          )
        ],
      ),
    ),
      )
    );
  }
}
