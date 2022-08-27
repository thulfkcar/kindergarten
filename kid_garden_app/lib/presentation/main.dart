import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/general_components/Error.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/kindergartenScreen.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/admin/AdminScreen.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/parent/ParentScreen.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/staff/StaffScreen.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:kid_garden_app/presentation/utile/RestartApp.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import 'package:kid_garden_app/them/DentalThem.dart';
import '../di/Modules.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

const HomeScreenRoute = '/Home';
const ChildrenExplorerRoute = '/ChildrenExplorer';
const ChildActionsGroupsRoute = '/ChildActionsGroups';
const ChildActionsRoute = '/ChildActions';
const Login_Page = '/';
const StaffUI_Route = '/Staff';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = Directory.current.path;
  await Hive
    ..init(path)
    ..registerAdapter(UserModelAdapter());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String? token = await messaging.getToken(
    vapidKey: "BGpdLRs......",
  );
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await messaging.subscribeToTopic("all");

  print('User granted permission: ${settings.authorizationStatus}');

//Foreground messages#
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
//background message
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }


}

class MyApp extends ConsumerStatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // late LoginPageViewModel viewModel;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // viewModel = ref.watch(LoginPageViewModelProvider);
// ref.watch(userProvider);
    return MaterialApp(
      // locale: const Locale('ar', ''),
      localizationsDelegates: const [
        ThugLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('ar', '')],
      // onGenerateRoute: _routes(),
      home: home(),
      title: AppLocalizations.of(context)?.getText("app_name") ??
          "Phoenix kindergarten",
      theme: KidThem.lightTheme,
      // darkTheme: KidThem.darkTheme,
    );
  }

  Widget home() {
    late Widget screen;

    ref.watch(hiveProvider).when(data: (value) {
      var user = value.getUser();
      user == null
          ? screen = KindergartenScreen()
          : (user.role == Role.admin || user.role == Role.superAdmin)
              ? screen =
                  AdminScreen(title: getTranslated("app_name", context))
              : (user.role == Role.Staff)
                  ? screen = StaffScreen(title: user.name.toString())
                  : screen = ParentScreen(title: user.name.toString());
      user != null
          ? FirebaseMessaging.instance.subscribeToTopic("user.${user.id}")
          : null;
    }, error: (Object error, StackTrace? stackTrace) {
      MyErrorWidget(msg: error.toString());
    }, loading: () {
      screen = CircularProgressIndicator();
    });

    return screen;
  }
}
