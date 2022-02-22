import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/calculator.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/scroll_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Speding Share',
      theme: ThemeData(
          fontFamily: 'Nunito',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: ColorConstants.backgroundBlack,
          scrollbarTheme: ScrollbarThemeData(
              isAlwaysShown: true,
              thickness: MaterialStateProperty.all(10),
              thumbColor: MaterialStateProperty.all(ColorConstants.defaultOrange),
              radius: const Radius.circular(10))),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Button Page'),
              onPressed: () {
                Get.to(() => const ButtonPage());
              },
            ),
            ElevatedButton(
              child: const Text('Input Field Page'),
              onPressed: () {
                Get.to(() => const InputFieldPage());
              },
            ),

            ElevatedButton(
              child: const Text('Scroll View Page'),
              onPressed: () {
                Get.to(() => ScrollViewPage());
              },
            ),

            ElevatedButton(
              child: const Text('Calculator Page'),
              onPressed: () {
                Get.to(() => CalculatorPage());
              },
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
