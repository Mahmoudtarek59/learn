import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        itemScrollController.scrollTo(
            index: 0,
            duration: Duration(seconds: 2),
            curve: Curves.easeInOutCubic,);
        // itemScrollController.jumpTo(index: 0);
      },child: Icon(Icons.arrow_drop_up_outlined),),
      body: ScrollablePositionedList.builder(
        itemCount: 500,
        itemBuilder: (context, index) => Text('Item $index'),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
      ),
    );
  }
}
