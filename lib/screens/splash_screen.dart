import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate/main.dart';
import 'package:movie_mate/utils/constants.dart';

import '../provider/movie_provider.dart';
import '../provider/theme_provider.dart';
import '../utils/global_auth.dart';
import '../utils/theme_utils.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
@override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_){
    var provider = ref.read(movieProvider);
      provider.getAuth();
    var data = authBox!.get('auth');
    // authData = data;
    // if(data != null){
    //   Future.delayed(Duration(seconds: 3)).then((value){
        print("=============== $data");
    //   });
    // }
  });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = ref.watch(themeProvider);
    final themeData = CustomTheme.getTheme(isLightMode);
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Text(
          Constants.APP_NAME,
          style: themeData!.textTheme.titleMedium!.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
