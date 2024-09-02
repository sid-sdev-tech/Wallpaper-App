import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as httpClient;

import 'app_exception.dart';

class ApiHelper{
  Future<dynamic> getAPI({required String url}) async{
    var uri = Uri.parse(url);
    try{
      var res = await httpClient.get(uri, headers: {
        "Authorization":"3gQaU5o4D1QiCI0bgbshTiJxS1XDjzNsQ3oayUEqWdm4ywqCjLSc2uYN"
      });
      // log(res.body);
      return returnJsonResponse(res);
    }on SocketException catch(e){
      throw (FetchDataException(errorMsg: 'No Internet'));
    }
  }
/*  Future<dynamic> postAPI(
  {required String url,Map<String,dynamic>? bodyParams}) async{
    var uri = Uri.parse(url);
    var res = await httpClient.post(uri,body: bodyParams??{});

    if(res.statusCode == 200){
      var mData = jsonDecode(res.body);
      return mData;
    }else{
      return null;
    }
  }*/
 dynamic returnJsonResponse(httpClient.Response response)
 {
   switch(response.statusCode){
     case 200:{
       var mData = jsonDecode(response.body);
       return mData;
     }
     case 400:
       throw BadRequestException(errorMsg : response.body.toString());
     case 401:
     case 403 :
       throw FetchDataException(
         errorMsg:"Error occurred while Communication with StatusCode : ${response.statusCode}"
       );
   }
 }

}