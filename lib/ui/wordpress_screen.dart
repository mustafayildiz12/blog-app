import 'package:animations/animations.dart';
import 'package:blog_app/constants/listtile_shimmer.dart';
import 'package:blog_app/constants/wordpress_widgets.dart';
import 'package:flutter/material.dart';
import '../models/wordpress_model.dart';
import '../service/api_service.dart';

class WordpressScreen extends StatefulWidget {
  const WordpressScreen({Key? key}) : super(key: key);

  @override
  _WordpressScreenState createState() => _WordpressScreenState();
}

class _WordpressScreenState extends State<WordpressScreen> {
  Service client = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: FutureBuilder(
          future: client.getNews(),
          builder: (BuildContext context,
              AsyncSnapshot<List<WordPressModel>> snapshot) {
            //let's check if we got a response or not
            if (snapshot.hasData) {
              //Now let's make a list of articles
              List<WordPressModel>? news = snapshot.data;
              return ListView.builder(
                  //Now let's create our custom List tile
                  itemCount: news!.length,
                  itemBuilder: (context, index) {
                    return openContainer(news, index);
                  });
            }
            return const ListShimmmer();
          },
        ),
      ),
    );
  }
}
