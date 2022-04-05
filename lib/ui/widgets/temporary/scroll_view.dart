import 'package:flutter/material.dart';

// TODO Scroll view with indicator (steal from work?)
class ScrollViewPage extends StatelessWidget {
  ScrollViewPage({Key? key}) : super(key: key);

  final List dummyData = List.generate(10, (index) => '$index');
  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Page'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Scrollbar(
                controller: _firstController,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dummyData.length,
                  controller: _firstController,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200, childAspectRatio: 3 / 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
                  itemBuilder: (context, index) {
                    return GridTile(
                        child: Container(
                      color: Colors.amberAccent,
                      alignment: Alignment.center,
                      child: Text(
                        dummyData[index],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
