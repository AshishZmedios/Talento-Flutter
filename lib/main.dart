import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:talento_flutter/core/theme/theme_notifier.dart';
import 'package:talento_flutter/core/utils/connectivity_utils.dart';
import 'package:talento_flutter/data/services/api_client.dart';
import 'package:talento_flutter/domain/repositories/job_repository.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';
import 'package:talento_flutter/presentation/screens/auth/repository/auth_repository.dart';

void main() async {
  // Essential for smooth startup
  WidgetsFlutterBinding.ensureInitialized();
  // Dependency injection using GetX
  Get.put(ApiClient());
  Get.put(JobRepository(Get.find<ApiClient>()));
  Get.put(AuthRepository(Get.find<ApiClient>()));

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ConnectivityUtils _connectivityUtils = ConnectivityUtils();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectivityUtils.init(context);
    });
  }

  @override
  void dispose() {
    _connectivityUtils.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeNotifier.currentTheme,
          initialRoute: AppRoutes.splash,
          getPages: AppRoutes.routes,
        );
      },
    );
  }
}
