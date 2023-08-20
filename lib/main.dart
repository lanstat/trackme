import 'package:flutter/material.dart';
import 'package:trackme/core/constants.dart';
import 'package:trackme/core/theme.dart';
import 'package:trackme/providers/background.dart';
import 'package:trackme/providers/database.dart';
import 'package:trackme/providers/notification.dart';
import 'package:trackme/screens/home.dart';
import 'package:trackme/screens/profile.dart';
import 'package:trackme/screens/timer.dart';
import 'package:trackme/widgets/main_navbar.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (!DatabaseProvider.instance.isInitialized) {
      await DatabaseProvider.instance.initialize();
    }
    switch(taskName) {
      case pomodoroStart:
        await BackgroundService.instance.pomodoroStartHandler(true);
        break;
      case notificationShow:
        await BackgroundService.instance.showNotification(inputData ?? {});
        break;
    }
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.instance.initialize();
  await NotificationProvider.instance.requestPermissions();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: blueColor),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedPage = 0;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const TimerScreen(),
      emptyWidget,
      Text('!!!'),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedPage,
          children: _pages,
        ),
      ),
      bottomNavigationBar: MainNavbar(
        onTap: (index) {
          if (index == 2) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return const AddMenu();
              }
            );
            return;
          }
          setState(() {
            _selectedPage = index;
          });
        },
        selectedIndex: _selectedPage,
      )
    );
  }
}
