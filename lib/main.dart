import 'package:deliverylo/Https%20Requests/server_configs.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Config.appFlavor = Flavor.DEV;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String renderInitialRoute() => resolvePostSplashRoute();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Delivery Lo',
      getPages: AppPages.pages,
      initialRoute: Routes.SPLASHSCREEN,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaleFactor: mq.textScaleFactor.clamp(0.8, 0.9),
          ),
          child: child!,
        );
      },
      theme: ThemeData(
        fontFamily: 'PlusJakartaSans',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}

