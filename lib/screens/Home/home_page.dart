import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpapers/app_widgets/wallpaper_bg_widget.dart';
import 'package:wallpapers/data/remote/api_helper.dart';
import 'package:wallpapers/data/repository/wallpaper_repository.dart';
import 'package:wallpapers/screens/search/cubit/search_cubit.dart';
import 'package:wallpapers/screens/search/searched_wallpaper_page.dart';
import 'package:wallpapers/utils/util_helper.dart';

import '../../constants/app_constants.dart';
import 'cubit/home_cubit.dart';

class HomePage extends StatefulWidget {

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeCubit>(context).getTrendingWallpaper();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          //1
          SizedBox(
            height: 50,
          ),
          //2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              style: mTextStyle12(),
              decoration: InputDecoration(
                filled: true,
                suffixIcon: InkWell(
                  onTap: (){
                    if(searchController.text.isNotEmpty){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>BlocProvider(
                            create: (context)=>SearchCubit(
                                wallPaperRepository: WallPaperRepository(apiHelper: ApiHelper())),
                            child: SearchedWallPaperPage(
                              query: searchController.text,),
                          ),
                      ));
                    }
                  },
                    child: Icon(Icons.search_sharp,color: Colors.grey,)),
                fillColor: AppColors.secondaryLightColor,
                hintText: "Find Wallpaper..",
                hintStyle : mTextStyle12(mColor : Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  )
                ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      )
                  ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  )
                )
              ),
            ),
          ),

          SizedBox(
            height: 16,
          ),
          //3
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Best of Month',style: mTextStyle16(mFontWeight: FontWeight.bold),),
          ),
          SizedBox(
            height: 7,
          ),
          SizedBox(
            height: 200,
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (_,state){
                if(state is HomeLoadingState){
                  return Center(child: CircularProgressIndicator(),);
                } else if(state is HomeErrorState){
                  return Center(
                    child: Text('${state.errorMsg}'),
                  );
                }else if(state is HomeLoadedState){
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.listPhotos.length,
                      itemBuilder: (_,index){

                        var eachPhoto = state.listPhotos[index];

                        return Padding(
                          padding:  EdgeInsets.only(left: 11,right: index == state.listPhotos.length-1?11: 0),
                          child: WallPaperBgWidget(imgUrl: eachPhoto.src!.portrait!),
                        );
                      });
                }
                return Container();
              },
            ),
          ),

          //4
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Color Tone',style: mTextStyle16(mFontWeight: FontWeight.bold),),
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppConstant.mColors.length,
                itemBuilder: (_,index){
                  log(AppConstant.mColors[index]['code'].toString());
                  return Padding(
                    padding:  EdgeInsets.only(left:7,right: index == AppConstant.mColors.length-1?11: 0),
                    child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder:  (context)=> BlocProvider(
                                create: (context)=> SearchCubit(
                                    wallPaperRepository: WallPaperRepository(
                                        apiHelper: ApiHelper())),
                                child: SearchedWallPaperPage(
                                  query:  "nature",
                                color: "ffffff"
                                ///AppConstant.mColors[index]['code'].toString()
                                ),
///ffffff
                              )));
                        },
                        child: getColorToneWidget(AppConstant.mColors[index]['color']))
                  );
                }),
          ),
          //5
          SizedBox(
            height: 16,
          ),
          //3
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
            child: Text('Categories',style: mTextStyle16(mFontWeight: FontWeight.bold),),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 11,
                crossAxisSpacing: 11,
                childAspectRatio: 9/5,
              ),
                itemCount: AppConstant.mCategories.length,
                itemBuilder: (_,index){
                  return InkWell(
                    onTap: (){
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder:  (context)=> BlocProvider(
                              create: (context)=> SearchCubit(
                              wallPaperRepository: WallPaperRepository(
                              apiHelper: ApiHelper())),
                            child: SearchedWallPaperPage(
                              query: AppConstant.mCategories[index]['title'],),
                          )));
                    },
                    child: getCategoryWidget(
                        AppConstant.mCategories[index]['image'],
                        AppConstant.mCategories[index]['title']),
                  );
                }),
          ),
        ],
      ));
  }

  Widget getColorToneWidget(Color mColor){
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: mColor,
        borderRadius: BorderRadius.circular(11),
      ),
    );
  }

  Widget getCategoryWidget(String imgUrl ,String title){
    return Container(
      width: 200,
      height: 115,
      child: Center(
        child: Text(title, style: mTextStyle14(mColor: Colors.white),),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.fill
        )
      ),
    );
  }
}
