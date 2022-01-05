import 'package:animations/animations.dart';
import 'package:blog_app/constants/grid_shimmer.dart';
import 'package:blog_app/models/news.dart';
import 'package:flutter/material.dart';
import '../service/api_service.dart';
import 'detail_news.dart';

class MyNews extends StatefulWidget {
  const MyNews({Key? key}) : super(key: key);

  @override
  _MyNewsState createState() => _MyNewsState();
}

class _MyNewsState extends State<MyNews> {
  Service client = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/network.png"), fit: BoxFit.cover),
          ),
          child: FutureBuilder(
            future: client.getArticle(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
              //let's check if we got a response or not
              if (snapshot.hasData) {
                //Now let's make a list of articles
                List<Article>? news = snapshot.data;
                return GridView.builder(
                    //Now let's create our custom List tile
                    shrinkWrap: true,
                    itemCount: 20,
                    //Now let's create our custom List tile
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      childAspectRatio: 1 / 1.5,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 20),
                        child: OpenContainer(
                          transitionType: ContainerTransitionType.fade,
                          closedBuilder:
                              (BuildContext _, VoidCallback openContainer) {
                            return Container(
                              decoration: decoratedShadowBox(context),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    //  borderRadius: BorderRadius.circular(10),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(5, 5),
                                      )
                                    ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 150,
                                      child: Image.network(
                                        news![index].urlToImage.toString(),
                                        filterQuality: FilterQuality.low,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      news[index].title.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          openBuilder: (BuildContext _, VoidCallback __) {
                            return DetailScreen(
                                day: news![index].publishedAt!.day.toString(),
                                month:
                                    news[index].publishedAt!.month.toString(),
                                year: news[index].publishedAt!.year.toString(),
                                title: news[index].title!.toString(),
                                content: news[index].description.toString(),
                                url: news[index].urlToImage.toString());
                          },
                        ),
                      );
                    });
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
