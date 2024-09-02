import '../../../models/wallpaper_model.dart';
import 'search_cubit.dart';

abstract class SearchState{}

class SearchInitialState extends SearchState{}
class SearchLoadingState extends SearchState{}

class SearchLoadedState extends SearchState{
  List<PhotoModel> listPhotos;
  num totalWallpapers;
  SearchLoadedState({ required this.listPhotos,required this.totalWallpapers});
}
class SearchErrorState extends SearchState{
  String   errorMsg;
  SearchErrorState({required this.errorMsg});
}