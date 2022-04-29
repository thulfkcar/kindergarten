import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/ui/Staff/StaffUI.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/kindergartenScreen.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationScreen/parent/NavigationScreenParent.dart';
import 'package:kid_garden_app/presentation/ui/navigationScreen/NavigationScreenStaff.dart';
import 'package:kid_garden_app/presentation/ui/navigationScreen/NavigationsScreen.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:kid_garden_app/presentation/utile/RestartApp.dart';
import 'package:kid_garden_app/them/DentalThem.dart';
import '../di/Modules.dart';
import '../firebase_options.dart';
import 'ui/childActions/ChildActions.dart';
import 'package:firebase_core/firebase_core.dart';

const HomeScreenRoute = '/Home';
const ChildrenExplorerRoute = '/ChildrenExplorer';
const ChildActionsGroupsRoute = '/ChildActionsGroups';
const ChildActionsRoute = '/ChildActions';
const Login_Page = '/';
const StaffUI_Route = '/Staff';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  void main() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    runApp(MyApp());
  }

  runApp(ProviderScope(
    child: RestartWidget(child: MyApp()),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late LoginPageViewModel viewModel;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(LoginPageViewModelProvider);
    return MaterialApp(
      locale: Locale("en"),
      // switch between en and ru to see effect
      localizationsDelegates: const [DemoLocalizationsDelegate()],
      supportedLocales: const [Locale('en', ''), Locale('ar', '')],
      onGenerateRoute: _routes(),
      // title: StringResources.of(context)?.getText("text2") ?? "Error",
      theme: KidThem.lightTheme,
      darkTheme: KidThem.darkTheme,
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final Object? arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case HomeScreenRoute:
          screen = NavigationScreen(title: "KinderGarten");
          break;
        case ChildActionsRoute:
          screen = ChildActions();
          break;
        case Login_Page:
          viewModel.currentUser == null
              ? screen = KindergartenScreen()
              : (viewModel.currentUser!.role == Role.admin ||
              viewModel.currentUser!.role == Role.superAdmin)
              ? screen = NavigationScreen(title: "kinderGarten")
              : (viewModel.currentUser!.role == Role.Staff)
              ? screen = NavigationScreenStaff(
              title: viewModel.currentUser!.name.toString())
              : screen = NavigationScreenParent(
              title: viewModel.currentUser!.name.toString());
          viewModel.currentUser != null ? FirebaseMessaging.instance
              .subscribeToTopic("user.${viewModel.currentUser?.id}"):null;
          break;
        case StaffUI_Route:
          screen = StaffUI();
          break;
        default:
          return null;
      }

      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
