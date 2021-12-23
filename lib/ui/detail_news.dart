import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen(
      {Key? key, required this.title, required this.content, required this.url})
      : super(key: key);

  String? url;
  String? title;
  String? content;

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

    return Scaffold(
      backgroundColor: const Color(0xFFccac00),
      appBar: AppBar(
        title: const Text("HABERİN DETAYLARI"),
        centerTitle: true,
        backgroundColor: const Color(0xFF998100),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Text(
              formatHtmlString(title!),
              style: TextStyle(
                  color: Colors.blueGrey.shade900,
                  fontSize: 23,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 12,
            ),
            Image.network(url!),
            Container(
              padding: const EdgeInsets.all(8),
              // margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFe5c100),
              ),
              child: Text(formatHtmlString(content!),
                  style: TextStyle(
                      color: Colors.blueGrey.shade900,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
            )
          ],
        ),
      ),
    );
  }
}
