import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/router.dart' as router;
import 'package:refresco/ui/views/buy_view.dart';
import 'package:refresco/utils/routing_constants.dart';

import 'core/dataModels/cart.dart';
import 'core/services/cart_service.dart';
import 'ui/theme.dart';

// TODO: use auto_resize_text

void main() {
  Logger.level = Level.debug;
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>(
            create: (context) => locator<AuthService>().user,
            initialData: User()),
        StreamProvider<Cart>(
          create: (context) => locator<CartService>().cart,
          initialData: Cart.empty(),
        )
      ],
      child: MaterialApp(
        navigatorKey: Get.key,
        title: 'Refresco',
        onGenerateRoute: router.generateRoute,
        initialRoute: Router.BuyViewRoute,
        theme: ThemeData(
          primarySwatch: AppColors.primary,
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          accentColor: AppColors.accent,
          buttonTheme: AppThemes.buttonTheme,
          accentTextTheme: AppThemes.accentTextTheme,
          inputDecorationTheme: AppThemes.inputDecorationTheme,
          cardTheme: AppThemes.cardTheme,
        ),
        home: BuyView(),
      ),
    );
  }
}
