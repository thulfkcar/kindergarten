import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/Child/Childs.dart';
import 'package:kid_garden_app/presentation/ui/Home/HomeUI.dart';
import 'package:kid_garden_app/presentation/ui/Staff/StaffUI.dart';
import 'package:kid_garden_app/presentation/ui/general_components/ActionDialog.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/kindergartenScreen.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationScreen/NavigationScreenParent.dart';
import 'package:kid_garden_app/presentation/ui/navigationScreen/NavigationsScreen.dart';
import 'package:kid_garden_app/presentation/ui/parentsScreen/parentsScreen.dart';
import 'package:kid_garden_app/presentation/ui/profile/ProfileUI.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
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
late LoginPageViewModel viewModel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
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
      title: StringResources.of(context)?.getText("text2") ?? "Error",
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
                      ? screen = Container()
                      : screen = NavigationScreenParent(title: viewModel.currentUser!.name.toString());
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
