import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:prashna_app/screens/discover_screen/discover_screen.dart';
import 'constants.dart';
import 'screens/login_screen/login_screen.dart';
import 'screens/login_screen/password_reset_screen.dart';
import 'screens/register_screen/register_screen.dart';
import 'screens/splash_screen/splash_screen.dart';
import '../utilities/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => Auth())],
    child: App(),
  ));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Auth authProvider = Auth();

  @override
  void initState() {
    super.initState();
    getTheme();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: PRIMARY_DARK,
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);
  }

  void getTheme() async {
    Provider.of<Auth>(context, listen: false).darkTheme =
        await authProvider.localStorage.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData(isDarkTheme, BuildContext context) {
      return ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: isDarkTheme ? PRIMARY_DARK : PRIMARY_GREY,
        fontFamily: 'Roboto',
        backgroundColor: isDarkTheme ? SECONDARY_DARK : PRIMARY_LIGHT,
        scaffoldBackgroundColor: isDarkTheme ? SECONDARY_DARK : PRIMARY_LIGHT,
        disabledColor: Colors.grey,
        canvasColor: isDarkTheme ? PRIMARY_DARK : PRIMARY_GREY,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      );
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: themeData(true, context),
        theme: themeData(false, context),
        themeMode: Provider.of<Auth>(context, listen: true).darkTheme
            ? ThemeMode.dark
            : ThemeMode.light,
        home: SplashScreen(),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          PageTransition getPageTransition(
              Widget screen, PageTransitionType type,
              {Duration duration = const Duration(milliseconds: 500)}) {
            return PageTransition(
              child: screen,
              type: type,
              settings: settings,
              duration: duration,
              reverseDuration: duration,
            );
          }

          switch (settings.name) {
            case '/login':
              return getPageTransition(LoginScreen(), PageTransitionType.fade);
            case '/register':
              return getPageTransition(
                  RegisterScreen(), PageTransitionType.fade);
            case '/reset-password':
              return getPageTransition(
                  PasswordResetScreen(), PageTransitionType.fade);
            case '/dashboard':
              return getPageTransition(
                  const DiscoverScreen(), PageTransitionType.fade);
            default:
              return null;
          }
        });
  }
}
