import 'package:blog_app/ui/wordpress_screen.dart';
import 'package:flutter/material.dart';
import '../models/wordpress_model.dart';
import '../service/api_service.dart';

class DecoNewsScreen extends StatefulWidget {
  const DecoNewsScreen({Key? key}) : super(key: key);

  @override
  _DecoNewsScreenState createState() => _DecoNewsScreenState();
}

class _DecoNewsScreenState extends State<DecoNewsScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
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
    return DefaultTabController(
      length: 7,
      child: Scaffold(
          key: _key,
          drawer: drawerMenu(),
          appBar: bottomAppBar(),
          body: TabBarView(
            children: [
              homeTab(),
              const WordpressScreen(),
              const Center(child: Text("Tab 3")),
              const Center(child: Text("Tab 4")),
              const Center(child: Text("Tab 5")),
              const Center(child: Text("Tab 6")),
              const Center(child: Text("Tab 7")),
            ],
          )),
    );
  }

  FutureBuilder<List<WordPressModel>> homeTab() {
    return FutureBuilder(
      future: client.getNews(),
      builder:
          (BuildContext context, AsyncSnapshot<List<WordPressModel>> snapshot) {
        //let's check if we got a response or not
        if (snapshot.hasData) {
          //Now let's make a list of articles
          List<WordPressModel>? news = snapshot.data;
          return GridView.builder(
            //Now let's create our custom List tile
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 1 / 1.6,
            ),
            itemCount: news!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        )
                      ]),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Image.network(
                          news[index].betterFeaturedImage!.sourceUrl!,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          formatHtmlString(
                              news[index].title!.rendered.toString()),
                          style: TextStyle(
                              color: Colors.blueGrey.shade900, fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.watch_later,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(news[index].date!.day.toString() +
                                  " " +
                                  news[index].date!.month.toString() +
                                  " " +
                                  news[index].date!.year.toString()),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  AppBar bottomAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: Colors.blueGrey,
        ),
        onPressed: () {
          _key.currentState!.openDrawer();
        },
      ),
      title: const Text(
        "DECO NEWS",
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      bottom: tabbars(),
    );
  }

  TabBar tabbars() {
    return TabBar(
      indicatorColor: Colors.black,
      labelColor: Colors.grey.shade800,
      unselectedLabelColor: Colors.grey.shade400,
      isScrollable: true,
      tabs: const [
        Tab(
          text: "Home",
        ),
        Tab(
          text: "Technology",
        ),
        Tab(
          text: "Sport",
        ),
        Tab(
          text: "Travel",
        ),
        Tab(
          text: "NBA",
        ),
        Tab(
          text: "Politics",
        ),
        Tab(
          text: "World",
        ),
      ],
    );
  }

  Drawer drawerMenu() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
