import 'package:animations/animations.dart';
import 'package:blog_app/ui/detail_news.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shimmer/shimmer.dart';
import '../models/wordpress_model.dart';
import '../service/api_service.dart';

class WordpressScreen extends StatefulWidget {
  const WordpressScreen({Key? key}) : super(key: key);

  @override
  _WordpressScreenState createState() => _WordpressScreenState();
}

class _WordpressScreenState extends State<WordpressScreen> {
  Service client = Service();
  String formatHtmlString(String string) {
    return string
        .replaceAll("<p>", "")
        .replaceAll("</p>", "")
        .replaceAll("Dean&#8217;s", "") // Paragraphs
        .replaceAll("&#8217;s", "")
        .replaceAll("<p>", "")
        .replaceAll("[&hellip;]", "")
        .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
        .trim(); // Whitespace
  }

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
                    return OpenContainer(
                      transitionDuration: const Duration(milliseconds: 600),
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedBuilder:
                          (BuildContext _, VoidCallback openContainer) {
                        return listTileCard(
                            openContainer, news, index, formatHtmlString);
                      },
                      openBuilder: (BuildContext _, VoidCallback __) {
                        return DetailScreen(
                            day: news[index].date!.day.toString(),
                            month: news[index].date!.month.toString(),
                            year: news[index].date!.year.toString(),
                            title: news[index].title!.rendered.toString(),
                            content: news[index].content!.rendered.toString(),
                            url: news[index].betterFeaturedImage!.sourceUrl!);
                      },
                    );
                  });
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: ListView.builder(
                //Now let's create our custom List tile
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    shadowColor: Colors.grey.shade200,
                    child: ListTile(
                      leading: SizedBox(
                        width: 100,
                        height: 75,
                        child: Image.asset(
                          "images/news.png",
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      /*
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SwitchListTile(
          value: _slowAnimations,
          onChanged: (value) async {
            setState(() => _slowAnimations = value);
            // Wait until the Switch is done animating before actually slowing
            // down time.
            if (_slowAnimations) {
              await Future<void>.delayed(const Duration(milliseconds: 50));
            }
            timeDilation = _slowAnimations ? 2.0 : 1.0;
          },
          title: const Text('Slow animations'),
        ),
      ),
      */
    );
  }

  Card listTileCard(VoidCallback openContainer, List<WordPressModel> news,
      int index, String formatHtmlString(String string)) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.grey.shade200,
      child: ListTile(
        onTap: openContainer,
        leading: imageBox(news, index),
        title: titleText(formatHtmlString, news, index),
      ),
    );
  }

  SizedBox imageBox(List<WordPressModel> news, int index) {
    return SizedBox(
      width: 100,
      height: 75,
      child: Image.network(
        news[index].betterFeaturedImage!.sourceUrl!,
        filterQuality: FilterQuality.high,
        fit: BoxFit.cover,
      ),
    );
  }

  Text titleText(String formatHtmlString(String string),
      List<WordPressModel> news, int index) {
    return Text(
      formatHtmlString(news[index].title!.rendered.toString()),
      style: TextStyle(color: Colors.blueGrey.shade900, fontSize: 17),
    );
  }
}
