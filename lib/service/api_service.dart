import 'package:blog_app/models/wordpress_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Service {
  final String _wrodpressUrl =
      "http://deneme.kitabya.com/index.php/wp-json/wp/v2";

  Future<List<WordPressModel>> getNews() async {
    Response res = await http.get(Uri.parse(_wrodpressUrl + "/posts"),headers: {"Accept":"application/json"});

    //first of all let's check that we got a 200 statu code: this mean that the request was a succes
    if (res.statusCode == 200) {
      return wordPressModelFromJson(res.body);
    } else {
      throw ("Can't get the Articles");
    }
  }
}
