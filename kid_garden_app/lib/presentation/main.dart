import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/User.dart';
import 'package:kid_garden_app/presentation/ui/Child/Childs.dart';
import 'package:kid_garden_app/presentation/ui/Home/HomeUI.dart';
import 'package:kid_garden_app/presentation/ui/Staff/StaffUI.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPage.dart';
import 'package:kid_garden_app/providers/Providers.dart';
import 'package:kid_garden_app/them/DentalThem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/Application.dart';
import 'ui/childActions/ChildActions.dart';

const HomeScreenRoute = '/';
const ChildrenExplorerRoute = '/ChildrenExplorer';
const ChildActionsGroupsRoute = '/ChildActionsGroups';
const ChildActionsRoute = '/ChildActions';
const Login_Page = '/';

// void main() {
//   runApp(ProviderScope(child: MyApp()));
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 // ProviderScope(child: RestartWidget(child: MaterialApp(home: await getUser() == null ? await const LoginPage() : await MyApp())));
  runApp( ProviderScope(child: RestartWidget(child: MaterialApp(home: await getUser() == null ? await const LoginPage() : await MyApp())))
  );
}

class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return MaterialApp(
        onGenerateRoute: _routes(),
        title: 'Flutter Demo',
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
    StaffUI(),
    ChildrenExplorer(),
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
            icon: Icon(Icons.business),
            label: 'Staff',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
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
