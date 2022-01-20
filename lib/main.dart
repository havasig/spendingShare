import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/translations.dart';

import 'auth/login.dart';
import 'auth/register.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/login',
    translations: MyTranslations(),
    locale: const Locale('en', 'EN'),
    getPages: [
      GetPage(name: '/login', page: () => Login()),
      GetPage(
        name: '/register',
        page: () => Register(),
      ),
      GetPage(
        name: '/home',
        page: () => Home(),
        binding: SampleBind(),
      ),
    ],
  ));
}



class Controller extends GetxController {
  int count = 0;
  void increment() {
    count++;
    // use update method to update all count variables
    update();
  }
}


class Home extends GetView<ControllerX> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('second Route'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
                  () {
                print("count1 rebuild");
                return Text('${controller.count1}');
              },
            ),
            Obx(
                  () {
                print("count2 rebuild");
                return Text('${controller.count2}');
              },
            ),
            Obx(() {
              print("sum rebuild");
              return Text('${controller.sum}');
            }),
            Obx(
                  () => Text('Name: ${controller.user.value.name}'),
            ),
            Obx(
                  () => Text('Age: ${controller.user.value.age}'),
            ),
            ElevatedButton(
              child: Text("Go to last page"),
              onPressed: () {
                Get.toNamed('/third', arguments: 'arguments of second');
              },
            ),
            ElevatedButton(
              child: Text("Back page and open snackbar"),
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'User 123',
                  'Successfully created',
                );
              },
            ),
            ElevatedButton(
              child: Text("Increment"),
              onPressed: () {
                controller.increment();
              },
            ),
            ElevatedButton(
              child: Text("Increment"),
              onPressed: () {
                controller.increment2();
              },
            ),
            ElevatedButton(
              child: Text("Update name"),
              onPressed: () {
                controller.updateUser();
              },
            ),
            ElevatedButton(
              child: Text("Dispose worker"),
              onPressed: () {
                controller.disposeWorker();
              },
            ),
          ],
        ),
      ),
    );
  }
}


class SampleBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerX>(() => ControllerX());
  }
}

class User {
  User({this.name = 'Name', this.age = 0});
  String name;
  int age;
}

class ControllerX extends GetxController {
  final count1 = 0.obs;
  final count2 = 0.obs;
  final list = [56].obs;
  final user = User().obs;

  updateUser() {
    user.update((value) {
      value!.name = 'Jose';
      value.age = 30;
    });
  }

  /// Once the controller has entered memory, onInit will be called.
  /// It is preferable to use onInit instead of class constructors or initState method.
  /// Use onInit to trigger initial events like API searches, listeners registration
  /// or Workers registration.
  /// Workers are event handlers, they do not modify the final result,
  /// but it allows you to listen to an event and trigger customized actions.
  /// Here is an outline of how you can use them:

  /// made this if you need cancel you worker
  late Worker _ever;

  @override
  onInit() {
    /// Called every time the variable $_ is changed
    _ever = ever(count1, (_) => print("$_ has been changed (ever)"));

    everAll([count1, count2], (_) => print("$_ has been changed (everAll)"));

    /// Called first time the variable $_ is changed
    once(count1, (_) => print("$_ was changed once (once)"));

    /// Anti DDos - Called every time the user stops typing for 1 second, for example.
    debounce(count1, (_) => print("debouce$_ (debounce)"),
        time: Duration(seconds: 1));

    /// Ignore all changes within 1 second.
    interval(count1, (_) => print("interval $_ (interval)"),
        time: Duration(seconds: 1));
  }

  int get sum => count1.value + count2.value;

  increment() => count1.value++;

  increment2() => count2.value++;

  disposeWorker() {
    _ever.dispose();
    // or _ever();
  }

  incrementList() => list.add(75);
}

class SizeTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Align(
      alignment: Alignment.center,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: curve!,
        ),
        child: child,
      ),
    );
  }
}