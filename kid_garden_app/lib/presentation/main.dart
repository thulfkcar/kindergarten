
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/Childs.dart';
import 'package:kid_garden_app/presentation/ui/Home/HomeUI.dart';
import 'package:kid_garden_app/presentation/ui/Staff/StaffUI.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPage.dart';
import 'package:kid_garden_app/presentation/ui/profile/ProfileUI.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:kid_garden_app/them/DentalThem.dart';
import 'ui/childActions/ChildActions.dart';

const HomeScreenRoute = '/Home';
const ChildrenExplorerRoute = '/ChildrenExplorer';
const ChildActionsGroupsRoute = '/ChildActionsGroups';
const ChildActionsRoute = '/ChildActions';
const Login_Page = '/';
const StaffUI_Route='/Staff';

// void main() {
//   runApp(ProviderScope(child: MyApp()));
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp( ProviderScope(child: MyApp())
  );
}

class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return MaterialApp(

        locale: Locale("en"), // switch between en and ru to see effect
        localizationsDelegates: const [DemoLocalizationsDelegate()],
        supportedLocales: const [Locale('en', ''), Locale('ar', '')],
        onGenerateRoute: _routes(),
        title: StringResources.of(context)?.getText("text2") ?? "Error",
        theme: KidThem.lightTheme,
        darkTheme: KidThem.darkTheme,
      );
    });
  }

  RouteFactory _routes() {
    return (settings) {
      final Object? arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case HomeScreenRoute:
          screen = MyHomePage(title: "KinderGarten");
          break;
        case ChildActionsRoute:
          screen = ChildActions(childId: '');
          break;
        case Login_Page:
          screen = LoginPage();
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    Home(),
    ChildrenExplorer(),
     ProfileUI()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget get bottomNavigationBar {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(40),
        topLeft: Radius.circular(40),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Children',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ), //,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,

          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          // Here we take the value from the MyHomePage object that was created by
          // the app.build method, and use it to set our appbar title.
          title: Text(
            widget.title,
            style: TextStyle(color: KidThem.textTitleColor),
          ),
        ),
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: bottomNavigationBar);
  }
}
