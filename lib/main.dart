import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:recipe_app/providers/category_provider.dart';
import 'package:recipe_app/providers/search_provider.dart';
import 'package:recipe_app/providers/theme_provider.dart';
import 'package:recipe_app/view/explore.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/view/theme.dart';
import 'package:secure_application/secure_application.dart';
import 'package:secure_application/secure_application_controller.dart';
import 'package:secure_application/secure_application_provider.dart';

import 'models/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String currentTheme = await LocalStorage.getTheme() ?? "light";
  runApp( MyApp(theme: currentTheme));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.theme}) : super(key: key);

  final String theme;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryProvider>(
            create: (context) => CategoryProvider()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(theme)),
        ChangeNotifierProvider<SearchProvider>(
            create: (context) => SearchProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            themeMode: themeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            home: MySecureApp(),
          );
        },
      ),
    );
  }
}

class MySecureApp extends StatefulWidget {
  const MySecureApp({Key? key}) : super(key: key);

  @override
  _MySecureAppState createState() => _MySecureAppState();
}

class _MySecureAppState extends State<MySecureApp> {
  // Local Auth Logic for both screens
  void localAuthentication(SecureApplicationController? secureNotifier,
      BuildContext? context) async {
    LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = false;

    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      debugPrint('Error caught with biometrics: $e');
    }
    debugPrint('Biometric is available: $canCheckBiometrics');

    List<BiometricType>? availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error caught while enumerating biometrics: $e');
    }
    debugPrint('The following biometrics are available');
    if (availableBiometrics!.isNotEmpty) {
      for (var ab in availableBiometrics) {
        debugPrint('\ttech: $ab');
      }
    } else {
      debugPrint('No biometrics are available');
    }

    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          biometricOnly: true,
          localizedReason: 'Touch your finger on the sensor to login',
          androidAuthStrings:
          const AndroidAuthMessages(signInTitle: 'Login to HomePage'));
    } catch (e) {
      debugPrint('Error caught while using biometric auth: $e');
    }

    if (secureNotifier != null) {
      authenticated
          ? secureNotifier.authSuccess(unlock: true)
          : debugPrint('fail');
    } else if (context != null) {
      authenticated
          ? SecureApplicationProvider.of(context)?.secure()
          : debugPrint('fail');
    }
  }

  // Locked Screen Widget
  Widget lockedScreen(Function()? function) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 40),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Unlock Secure App',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                'Unlock your screen by pressing the fingerprint icon on the bottom of the screen and then using your fingerprint sensor.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              IconButton(
                onPressed: function,
                icon: const Icon(Icons.fingerprint),
                iconSize: 50,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SecureApplication(
      nativeRemoveDelay: 100,
      autoUnlockNative: true,
      child: SecureGate(
        lockedBuilder: (context, secureNotifier) => Center(
          child: lockedScreen(() => localAuthentication(secureNotifier, null)),
        ),
        child: Builder(
          builder: (context) {
            return ValueListenableBuilder<SecureApplicationState>(
                valueListenable: SecureApplicationProvider.of(context)
                as ValueListenable<SecureApplicationState>,
                builder: (context, state, _) => state.secured
                    ? const Explore()
                    : lockedScreen(() => localAuthentication(null, context)));
          },
        ),
      ),
    );
  }
}

