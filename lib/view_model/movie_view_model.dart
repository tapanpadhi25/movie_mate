import 'package:flutter/cupertino.dart';
import 'package:movie_mate/main.dart';
import 'package:movie_mate/repository/movie_repo.dart';

class MovieViewModel extends ChangeNotifier{
  final MovieRepository repo;
  MovieViewModel({required this.repo});

  String authError = "";
  bool isAuthLoading = false;
  Future<void> getAuth()async{
    try{
      print("====+++++++++++++++++++++");
      isAuthLoading = true;
      authError = "";
      notifyListeners();
      var data = await repo.fetchAuthToken();
      print('=======Auth :- -=== $data');
      authBox!.put("auth",data['auth']);
      notifyListeners();
    }catch(e){
      authError = e.toString();
      notifyListeners();
    }finally{
      isAuthLoading = false;
      notifyListeners();
    }
  }
}