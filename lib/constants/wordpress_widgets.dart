import 'package:animations/animations.dart';
import 'package:blog_app/constants/string_constant.dart';
import 'package:blog_app/models/wordpress_model.dart';
import 'package:blog_app/ui/detail_news.dart';
import 'package:flutter/material.dart';

OpenContainer<Object?> openContainer(List<WordPressModel> news, int index) {
  return OpenContainer(
    transitionDuration: const Duration(milliseconds: 600),
    transitionType: ContainerTransitionType.fadeThrough,
    closedBuilder: (BuildContext _, VoidCallback openContainer) {
      return listTileCard(openContainer, news, index, formatHtmlString);
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
}

Card listTileCard(VoidCallback openContainer, List<WordPressModel> news,
    int index, String Function(String string) formatHtmlString) {
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

Text titleText(String Function(String string) formatHtmlString,
    List<WordPressModel> news, int index) {
  return Text(
    formatHtmlString(news[index].title!.rendered.toString()),
    style: TextStyle(color: Colors.blueGrey.shade900, fontSize: 17),
  );
}
