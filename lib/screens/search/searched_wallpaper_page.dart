import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpapers/app_widgets/wallpaper_bg_widget.dart';
import 'package:wallpapers/screens/search/cubit/search_cubit.dart';
import 'package:wallpapers/screens/search/cubit/search_state.dart';
import 'package:wallpapers/utils/util_helper.dart';

class SearchedWallPaperPage extends StatefulWidget {
  String query;
  String color;
  SearchedWallPaperPage({super.key, required this.query, this.color = ""});

  @override
  State<SearchedWallPaperPage> createState() => _SearchedWallPaperPageState();
}

class _SearchedWallPaperPageState extends State<SearchedWallPaperPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SearchCubit>(context).getSearchWallpaper(query: widget.query,color: widget.color);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: BlocBuilder<SearchCubit, SearchState>(
        builder:(_,state){
          if(state is SearchLoadingState){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(state is SearchErrorState){
            return Center(
              child: Text(state.errorMsg),
            );
          } else if(state is SearchLoadedState){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: ListView(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(widget.query,style: mTextStyle34(mFontWeight: FontWeight.w900),),
                  Text("${state.totalWallpapers} wallpapers available",style: mTextStyle14(),),
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
                        itemCount: state.listPhotos.length,
                        itemBuilder: (_,index){
                          var eachPhoto = state.listPhotos[index];
                          return Padding(
                            padding:  EdgeInsets.only(bottom: index == state.listPhotos.length-1 ?  11.0 : 0),
                            child: WallPaperBgWidget(imgUrl: eachPhoto.src!.portrait!),
                          );
                        }),
                  )
                ],
              ),
            );
          }

            return Container();
        }
      )
    );
  }
}
