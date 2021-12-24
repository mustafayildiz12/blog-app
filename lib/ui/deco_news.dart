import 'package:animations/animations.dart';
import 'package:blog_app/ui/wordpress_screen.dart';
import 'package:flutter/material.dart';
import '../models/wordpress_model.dart';
import '../service/api_service.dart';
import 'detail_news.dart';

class DecoNewsScreen extends StatefulWidget {
  const DecoNewsScreen({Key? key}) : super(key: key);

  @override
  _DecoNewsScreenState createState() => _DecoNewsScreenState();
}

class _DecoNewsScreenState extends State<DecoNewsScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Service client = Service();

  bool isSelected = false;

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
      child: SafeArea(
        child: Scaffold(
            key: _key,
            drawer: Theme(
                data: Theme.of(context)
                    .copyWith(canvasColor: const Color(0xFF1B1D29)),
                child: drawerMenu()),
            appBar: bottomAppBar(),
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
              child: TabBarView(
                children: [
                  homeTab(),
                  const WordpressScreen(),
                  const Center(child: Text("Tab 3")),
                  const Center(child: Text("Tab 4")),
                  const Center(child: Text("Tab 5")),
                  const Center(child: Text("Tab 6")),
                  const Center(child: Text("Tab 7")),
                ],
              ),
            )),
      ),
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
              childAspectRatio: 1 / 1.5,
            ),
            itemCount: news!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 8.0),
                child: OpenContainer(
                  transitionType: ContainerTransitionType.fade,
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return Container(
                      decoration: BoxDecoration(color: Colors.white,
                          // borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(5, 5),
                            )
                          ]),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                            child: Image.network(
                              news[index].betterFeaturedImage!.sourceUrl!,
                              filterQuality: FilterQuality.low,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              formatHtmlString(
                                  news[index].title!.rendered.toString()),
                              style: TextStyle(
                                  color: Colors.blueGrey.shade900,
                                  fontSize: 15),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
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
                          )
                        ],
                      ),
                    );
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
              image: DecorationImage(
                  image: AssetImage('images/news.png'), fit: BoxFit.cover),
            ),
            child: null,
          ),
          const SizedBox(
            height: 12,
          ),
          ListTile(
            onTap: () {
              setState(() {
                isSelected = true;
              });
            },
            leading: const Icon(
              Icons.menu_book,
              color: Color(0xFF7E7D95),
            ),
            title:
                const Text('Home', style: TextStyle(color: Color(0xFF7E7D95))),
          ),
          const ListTile(
            leading: Icon(Icons.book, color: Color(0xFF7E7D95)),
            title:
                Text('Categories', style: TextStyle(color: Color(0xFF7E7D95))),
          ),
          const ListTile(
            leading: Icon(Icons.swap_vert, color: Color(0xFF7E7D95)),
            title: Text(
              'Bookmarks',
              style: TextStyle(color: Color(0xFF7E7D95)),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.flag_outlined, color: Color(0xFF7E7D95)),
            title:
                Text('About App', style: TextStyle(color: Color(0xFF7E7D95))),
          ),
          const ListTile(
            leading: Icon(Icons.settings, color: Color(0xFF7E7D95)),
            title: Text('Settings', style: TextStyle(color: Color(0xFF7E7D95))),
          ),
        ],
      ),
    );
  }
}
