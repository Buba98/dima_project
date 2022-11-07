import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/home/search/search_result_widget.dart';
import 'package:dima_project/input/button.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .size
            .shortestSide <
        550) {
      child = SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            Button(onPressed: () {}, text: 'Filter'),
            SizedBox(
              height: 15,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                SearchResultWidget(
                    name: 'name1',
                    price: 1,
                    distance: 1,
                    startingTime: DateTime.now(),
                    duration: Duration(hours: 1)),
                SearchResultWidget(
                    name: 'name2',
                    price: '2',
                    distance: 2,
                    startingTime: DateTime.now(),
                    duration: Duration(hours: 2)),
              ],
            ),
          ],
        ),
      );
    } else {
      child = SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Row(
          children: [
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      Text('Filter'),
                      SizedBox(width: 10,),
                      Icon(Icons.filter_list_sharp),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Button(onPressed: () {}, text: 'example')
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.65,
              child: ListView(
                shrinkWrap: true,
                children: [
                  SearchResultWidget(
                      name: 'name1',
                      price: 1,
                      distance: 1,
                      startingTime: DateTime.now(),
                      duration: Duration(hours: 1)),
                  SearchResultWidget(
                      name: 'name2',
                      price: '2',
                      distance: 2,
                      startingTime: DateTime.now(),
                      duration: Duration(hours: 2)),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: const KAppBar(
        text: 'Search',
      ),
      body: Center(
        child: child,
      ),
    );
  }
}
