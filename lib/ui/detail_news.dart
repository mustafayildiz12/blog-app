import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen(
      {Key? key,
      required this.title,
      required this.content,
      required this.url,
      required this.day,
      required this.month,
      required this.year})
      : super(key: key);

  String? url;
  String? title;
  String? content;
  String? day;
  String? month;
  String? year;

  @override
  Widget build(BuildContext context) {
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

    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              centerTitle: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.35,
              pinned: false,
              stretch: false,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.fadeTitle],
                background: Image.network(url!, fit: BoxFit.cover),
              ),
            ),
          ];
        },
        body: Scaffold(
          backgroundColor: Colors.white70,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ]),
                child: Column(
                  children: [
                    Text(
                      formatHtmlString(title!),
                      style: TextStyle(
                          color: Colors.blueGrey.shade900,
                          fontSize: 21,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
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
                        Text(day! + " " + month! + " " + year!),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(formatHtmlString(content!),
                        style: TextStyle(
                            color: Colors.blueGrey.shade900,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
