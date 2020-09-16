import 'package:fluttermanga/model/detail_manga.dart';
import 'package:fluttermanga/model/latest_manga.dart';
import 'package:fluttermanga/model/list_manga_model.dart';
import 'package:fluttermanga/model/main_model.dart';
import 'package:fluttermanga/model/read.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart';

class Helper {
  Client _client;

  Helper() {
    this._client = Client();
  }

  Future<List<Manga>> getManga() async {
    List<Manga> _manga = [];

    String webUrl = "https://www..com/";

    final response = await get(webUrl);
    final document = parse(response.body);

    document.getElementsByClassName('hotmanga').forEach((e) {
      final images = e.getElementsByTagName('img')[0].attributes['src'];
      final title = e.getElementsByTagName('a')[0].text;
      final chapter = e.getElementsByTagName('p')[0].text;
      final url = e.getElementsByTagName('a')[0].attributes['href'];
      _manga.add(Manga(
          title: title,
          url: url,
          image: images,
          chapter: chapter));
    });

    return _manga;
  }

  Future<List<LatestManga>> latestManga() async {
    List<LatestManga> _latest = [];

    String webUrl = "https://www..com/";

    final response = await get(webUrl);
    final document = parse(response.body);
    String title;
    String url;
    String images;
    String chapter;
    
    document.getElementsByClassName('latestmanga')
    .forEach((element) {
      images = element.getElementsByTagName('img')[0].attributes['src'];
      url = element.getElementsByTagName('a')[0].attributes['href'];

      element.getElementsByClassName('well')
      .forEach((e) {
        title = e.getElementsByTagName('a')[0].text;
        chapter = e.getElementsByTagName('p')[0].text;
      });

      _latest.add(LatestManga(
        chapter: chapter,
        title: title,
        url: url,
        image: images
      ));
    });
    
    return _latest;
  }

  Future<List<DetailManga>> getChapter(String url) async {
    List<DetailManga> _manga = [];
    final response = await get(url);
    final document = parse(response.body);

    final mangaChapter = document.getElementsByClassName("chapters");

    for (Element e in mangaChapter) {
      final chapter = e.getElementsByTagName("li");
      for (Element m in chapter) {
        final aTag = m.getElementsByTagName('a')[0];
        final title = aTag.text;
        final date = m.getElementsByClassName("date-chapter-title-rtl")[0];
        final url = aTag.attributes['href'];
        final manga = DetailManga(chapter: title, url: url, date: date.text);
        _manga.add(manga);
      }
    }
    return _manga;
  }

  readManga(String url) async {
    final response = await get(url);
    final document = parse(response.body);
    String images;

    final link = document.getElementsByClassName('viewer-cnt');

    print("print : ${document.getElementsByTagName('select')[0].innerHtml}");

    for (Element e in link) {
      images = e
          .getElementsByClassName('img-responsive scan-page')[0]
          .attributes['src'];
    }

    return ReadModel(images: images);
  }

  ListManga(String page) async {
    List<ListMangaModel> _latest = new List<ListMangaModel>();

    String webUrl = "https://www...com/manga-list?page=$page";

    final response = await get(webUrl);
    final document = parse(response.body);

    String title;
    String images;
    String url;
    var rating;

    document.querySelectorAll('.col-sm-6').forEach((element) {
      title = element.getElementsByTagName('h5')[0].text;
      images = element.getElementsByTagName('img')[0].attributes['src'];
      url = element.getElementsByTagName('a')[0].attributes['href'];
      rating = element.getElementsByTagName('span')[0].text;

      _latest.add(ListMangaModel(
          image: images, title: title, url: url, rating: rating));
    });

    return _latest;
  }
}
