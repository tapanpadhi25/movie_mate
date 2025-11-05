import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_mate/screens/splash_screen.dart';
import 'package:movie_mate/utils/theme_utils.dart';
import 'package:path_provider/path_provider.dart';

Box? authBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  authBox = await Hive.openBox("auth");
  // Hive.registerAdapter(MovieProvider());
  await Hive.openBox('favoritesBox');
  await Hive.openBox('watchlistBox');
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLightMode = true;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.getTheme(isLightMode),
      home: const SplashScreen(),
    );
  }
}
