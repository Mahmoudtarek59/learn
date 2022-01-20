import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class ScrollPositionScreen extends StatelessWidget {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        itemScrollController.scrollTo(
            index: 100,
            duration: Duration(seconds: 2),
            curve: Curves.easeInOutCubic);
        // itemScrollController.jumpTo(index: 150);
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
