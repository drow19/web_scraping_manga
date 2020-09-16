import 'package:flutter/material.dart';
import 'package:fluttermanga/helper/helper.dart';
import 'package:fluttermanga/model/detail_manga.dart';
import 'package:fluttermanga/view/read_manga.dart';
import 'package:fluttermanga/widget/widget.dart';

class ListChapter extends StatefulWidget {
  final url;

  ListChapter({@required this.url});

  @override
  _ListChapterState createState() => _ListChapterState();
}

class _ListChapterState extends State<ListChapter> {
  Helper _helper = new Helper();
  List<DetailManga> _list = new List<DetailManga>();

  bool loading = false;

  getData() async {
    loading = true;
    await _helper.getChapter(widget.url).then((value) {
      setState(() {
        loading = false;
        _list = value;
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
      ),
      body: loading
          ? loadingView()
          : Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                children: [
                  Text(
                    "List Chapter ",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _list.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return _listChapter(_list[index].chapter,
                              _list[index].date, _list[index].url);
                        }),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _listChapter(String chapter, String date, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReadManga(url)));
          },
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  chapter,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        )
      ],
    );
  }
}
