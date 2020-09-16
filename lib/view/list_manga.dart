import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttermanga/helper/helper.dart';
import 'package:fluttermanga/model/list_manga_model.dart';
import 'package:fluttermanga/view/list_chapter.dart';
import 'package:fluttermanga/widget/starDisplay.dart';
import 'package:fluttermanga/widget/widget.dart';

class ViewAll extends StatefulWidget {
  @override
  _ViewAllState createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  Helper _helper = new Helper();
  List<ListMangaModel> _list = new List<ListMangaModel>();

  ScrollController _scrollController = ScrollController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  int pages = 1;
  bool _isLoading = false;
  bool hasReachMax = false;
  bool _isloadingTopbar = false;

  getData() async {
    if (hasReachMax == false) {
      setState(() {
        _isLoading = true;
      });
    } else {
      _isloadingTopbar = true;
    }
    await _helper.ListManga(pages.toString()).then((value) {
      setState(() {
        if (hasReachMax == true) {
          setState(() {
            _isloadingTopbar = false;
            List<ListMangaModel> newList = value;
            _list = [..._list, ...newList];
          });
        } else {
          _isLoading = false;
          _list = value;
        }
      });
    });
  }

  scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        hasReachMax = true;
        pages++;
        print("print : $pages");
      });
      getData();
    }
  }

  @override
  void dispose() {
    _list = [];
    super.dispose();
  }

  @override
  void initState() {
    getData();
    super.initState();
    _scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff212121),
      appBar: AppBar(
        backgroundColor: Color(0xff424242),
        actions: [
          _isloadingTopbar
              ? Center(
                  child: Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )),
                )
              : Container(),
        ],
      ),
      body: _isLoading
          ? loadingView()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _list.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _listData(
                              _list[index].title,
                              _list[index].image,
                              _list[index].url,
                              _list[index].rating);
                        }),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _listData(String title, String images, String url, String rating) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ListChapter(url: url)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: images,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                StarDisplayWidget(
                  value: double.parse(rating),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
