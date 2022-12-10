import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

import 'firebase_options.dart';
import 'models/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }

  FirebaseUIAuth.configureProviders([
    PhoneAuthProvider(),
    EmailAuthProvider()
    // ... other providers
  ]);
  String currentTheme = await LocalStorage.getTheme() ?? "light";
  runApp(MyApp(theme: currentTheme));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.theme}) : super(key: key);

  String get initialRoute {
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null || auth.currentUser!.isAnonymous) {
      return '/';
    }

    // if (!auth.currentUser!.emailVerified && auth.currentUser!.email != null) {
    //   return '/verify-email';
    // }

    return '/home';
  }

  final String theme;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    final mfaAction = AuthStateChangeAction<MFARequired>(
          (context, state) async {
        final nav = Navigator.of(context);

        await startMFAVerification(
          resolver: state.resolver,
          context: context,
        );

        nav.pushReplacementNamed('/home');
      },
    );
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
            initialRoute: initialRoute,
            routes: {
              '/': (context) {
                return SignInScreen(
                  actions: [
                    ForgotPasswordAction((context, email) {
                      Navigator.pushNamed(
                        context,
                        '/forgot-password',
                        arguments: {'email': email},
                      );
                    }),
                    VerifyPhoneAction((context, _) {
                      Navigator.pushNamed(context, '/phone');
                    }),
                    AuthStateChangeAction<SignedIn>((context, state) {
                      // if (!state.user!.emailVerified) {
                      //   Navigator.pushNamed(context, '/verify-email');
                      // } else {
                        Navigator.pushReplacementNamed(context, '/home');
                      //}
                    }),
                    AuthStateChangeAction<UserCreated>((context, state) {
                      if (!state.credential.user!.emailVerified) {
                        //Navigator.pushNamed(context, '/verify-email');
                      } else {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    }),
                    AuthStateChangeAction<CredentialLinked>((context, state) {
                      if (!state.user.emailVerified) {
                        //Navigator.pushNamed(context, '/verify-email');
                      } else {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    }),
                    mfaAction,
                    EmailLinkSignInAction((context) {
                      Navigator.pushReplacementNamed(context, '/email-link-sign-in');
                    }),
                  ],
                  styles: const {
                    EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
                  },
                  subtitleBuilder: (context, action) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        action == AuthAction.signIn
                            ? 'Welcome to Firebase UI! Please sign in to continue.'
                            : 'Welcome to Firebase UI! Please create an account to continue',
                      ),
                    );
                  },
                  footerBuilder: (context, action) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          action == AuthAction.signIn
                              ? 'By signing in, you agree to our terms and conditions.'
                              : 'By registering, you agree to our terms and conditions.',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                );
              },
              '/verify-email': (context) {
                return EmailVerificationScreen(
                  actions: [
                    EmailVerifiedAction(() {
                      Navigator.pushReplacementNamed(context, '/home');
                    }),
                    AuthCancelledAction((context) {
                      FirebaseUIAuth.signOut(context: context);
                      Navigator.pushReplacementNamed(context, '/');
                    }),
                  ],
                );
              },
              '/phone': (context) {
                return PhoneInputScreen(
                  actions: [
                    SMSCodeRequestedAction((context, action, flowKey, phone) {
                      Navigator.of(context).pushReplacementNamed(
                        '/sms',
                        arguments: {
                          'action': action,
                          'flowKey': flowKey,
                          'phone': phone,
                        },
                      );
                    }),
                  ],

                );
              },
              '/sms': (context) {
                final arguments = ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>?;

                return SMSCodeInputScreen(
                  actions: [
                    AuthStateChangeAction<SignedIn>((context, state) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    })
                  ],
                  flowKey: arguments?['flowKey'],
                  action: arguments?['action'],

                );
              },
              '/forgot-password': (context) {
                final arguments = ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>?;

                return ForgotPasswordScreen(
                  email: arguments?['email'],
                  headerMaxExtent: 200,

                );
              },
              '/email-link-sign-in': (context) {
                return EmailLinkSignInScreen(
                  actions: [
                    AuthStateChangeAction<SignedIn>((context, state) {
                      Navigator.pushReplacementNamed(context, '/');
                    }),
                  ],
                  headerMaxExtent: 200,
                );
              },
              '/profile': (context) {
                return ProfileScreen(
                  actions: [
                    SignedOutAction((context) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                    }),
                    mfaAction,
                  ],
                  showMFATile: false,
                );
              },
              '/home': (context) {
                return MySecureApp();
              },
            },
            themeMode: themeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
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
