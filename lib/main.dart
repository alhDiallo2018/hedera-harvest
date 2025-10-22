import 'package:agridash/core/app_export.dart';
import 'package:agridash/core/hedera_service.dart';
import 'package:agridash/presentation/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await AuthService().initialize();
  await HederaService().initialize();
  await AuthService().initializeDemoData();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NavigationService _navigationService = NavigationService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroSense',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: AppConstants.textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            borderSide: BorderSide(color: AppConstants.primaryColor),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      navigatorKey: _navigationService.navigatorKey,
      initialRoute: AppRoutes.getInitialRoute(),
      onGenerateRoute: (settings) {
        final routes = AppRoutes.routes(context);
        final builder = routes[settings.name];
        
        if (builder != null) {
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        }
        
        // Fallback to splash screen
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}