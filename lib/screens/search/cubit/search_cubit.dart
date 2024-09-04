import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wallpapers/data/repository/wallpaper_repository.dart';
import 'package:wallpapers/models/wallpaper_model.dart';
import 'package:wallpapers/screens/search/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState>{
  WallPaperRepository wallPaperRepository;
  SearchCubit({required this.wallPaperRepository}):  super(SearchInitialState());

  void getSearchWallpaper({ required String query,String color = "", int page =1}) async{
    
    emit(SearchLoadingState());

    try{
      var mData = await wallPaperRepository.getSearchWallPapers(query,mColor: color ,mPage : page);
      WallpaperDataModel wallpaperDataModel = WallpaperDataModel.fromJson(mData);
      emit(SearchLoadedState(listPhotos: wallpaperDataModel.photos!,totalWallpapers: wallpaperDataModel.total_results!));
    }catch(e){
      emit(SearchErrorState(errorMsg: e.toString()));
    }
  }
}