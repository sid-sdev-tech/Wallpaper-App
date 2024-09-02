import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpapers/app_widgets/wallpaper_bg_widget.dart';
import 'package:wallpapers/screens/search/cubit/search_cubit.dart';
import 'package:wallpapers/screens/search/cubit/search_state.dart';
import 'package:wallpapers/utils/util_helper.dart';

class SearchedWallPaperPage extends StatefulWidget {
  String query;
  SearchedWallPaperPage({required this.query});

  @override
  State<SearchedWallPaperPage> createState() => _SearchedWallPaperPageState();
}

class _SearchedWallPaperPageState extends State<SearchedWallPaperPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SearchCubit>(context).getSearchWallpaper(query: widget.query);
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Text(widget.query,style: mTextStyle25(mFontWeight: FontWeight.w900),),
                  Text("${state.totalWallpapers} wallpapers available",style: mTextStyle14(),),
                  Expanded(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 11,
                          crossAxisSpacing: 11,
                          childAspectRatio: 3/4,
                        ),
                        itemCount: state.listPhotos.length,
                        itemBuilder: (_,index){
                          var eachPhoto = state.listPhotos[index];
                          return WallPaperBgWidget(imgUrl: eachPhoto.src!.portrait!);
                        }),
                  ))
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
