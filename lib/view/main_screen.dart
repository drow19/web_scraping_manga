import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttermanga/helper/helper.dart';
import 'package:fluttermanga/model/latest_manga.dart';
import 'package:fluttermanga/model/main_model.dart';
import 'package:fluttermanga/view/list_chapter.dart';
import 'package:fluttermanga/view/list_manga.dart';
import 'package:fluttermanga/widget/widget.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Helper _helper = new Helper();
  List<Manga> _list = new List<Manga>();
  List<LatestManga> _latest = new List<LatestManga>();

  bool _isloading = false;

  getData() async {
    _isloading = true;
    await _helper.getManga().then((value) {
      setState(() {
        _isloading = false;
        _list = value;
      });
    }).catchError((e) {
      print(e.toString());
    });

    await _helper.latestManga().then((value) {
      setState(() {
        _latest = value;
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff212121),
      appBar: AppBar(
        backgroundColor: Color(0xff424242),
        title: Text("Manga Reader"),
      ),
      body: _isloading
          ? loadingView()
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Updates manga",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white),
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                        itemCount: _list.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if (_list[index].title.contains("#")) {
                            return Container();
                          } else {
                            return _updateManga(
                                _list[index].image,
                                _list[index].url,
                                _list[index].title,
                                _list[index].chapter);
                          }
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    height: 8,
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Latest manga",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewAll()));
                        },
                        child: Text(
                          "View All",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 14, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Container(
                      child: GridView.builder(
                          itemCount: _latest.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 10),
                          itemBuilder: (context, index) {
                            return _latestManga(_latest[index].image,
                                _latest[index].title, _latest[index].url);
                          }),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _updateManga(String image, String url, String title, String chapter) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ListChapter(url: url)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  Widget _latestManga(String image, String title, String url) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListChapter(
                    url: url.replaceAll(new RegExp(r'[0-9]'), ""))));
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                color: Colors.black26, borderRadius: BorderRadius.circular(4)),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
