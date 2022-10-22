import 'package:flutter/material.dart';
import 'dart:async';
import 'package:quick_actions/quick_actions.dart';
import 'package:flutter/services.dart';
import 'package:wolfflashlight/wolfflashlight.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';
  bool _hasFlashlight = false;
  String shortcut = 'no action set';
  Timer? timer;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool hasFlashlight;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await Wolfflashlight.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      hasFlashlight = await Wolfflashlight.hasFlashlight;
    } on PlatformException {
      hasFlashlight = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _hasFlashlight = hasFlashlight;
      if (_hasFlashlight) {
        Wolfflashlight.lightOn();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: IconButton(
              iconSize: 170,
              color: Color(0xFF1C1C1C),
              icon: FaIcon(
                FontAwesomeIcons.powerOff,
                color: _hasFlashlight
                    ? Color.fromARGB(255, 255, 208, 113)
                    : Color(0xFF503705),
                size: 120,
              ),
              onPressed: () {
                if (_hasFlashlight) {
                  Wolfflashlight.lightOff();
                } else {
                  Wolfflashlight.lightOn();
                }
                setState(() {
                  _hasFlashlight = !_hasFlashlight;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

/*   Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
              child: Column(
            children: <Widget>[
              Text(
                  'Running on: $_platformVersion\n flashlight is $_hasFlashlight'),
              ElevatedButton(
                child: Text('Turn on'),
                onPressed: () {
                  if (_hasFlashlight) {
                    Wolfflashlight.lightOff();
                  } else {
                    Wolfflashlight.lightOn();
                  }
                  setState(() {
                    _hasFlashlight = !_hasFlashlight;
                  });
                },
              ),
                 ElevatedButton(
                child: Text('Turn off'),
                onPressed: () => Wolfflashlight.lightOff(),
              ),
              ElevatedButton(
                  child: Text('Turn WolfOn'),
                  onPressed: () => {
                        // Wolfflashlight.lightWolfOn()
                        timer = Timer.periodic(Duration(milliseconds: 300),
                            (timer) {
                          Wolfflashlight.lightFlash();
                        }),
                      }),
              ElevatedButton(
                child: Text('Turn Wolfoff'),
                onPressed: () => timer?.cancel(),
              ), 
            ],
          ))),
    );
  }
}*/