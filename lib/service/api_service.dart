import 'dart:convert';
import 'package:flutter_api_calling/service/api_urls.dart';
import '../model/article_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<ArticleModel?> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse(ApiUrls.api));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return ArticleModel.fromJson(responseData);
      } else {
        Exception('Unknown Error Throw');
      }
    } catch (e) {
      Exception(e.toString());
    }
    return null;
  }
}
