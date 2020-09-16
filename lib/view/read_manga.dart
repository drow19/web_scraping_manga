import 'package:flutter/material.dart';
import 'package:fluttermanga/helper/helper.dart';
import 'package:fluttermanga/model/read.dart';
import 'package:fluttermanga/widget/widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:swipedetector/swipedetector.dart';

class ReadManga extends StatefulWidget {
  final url;

  ReadManga(@required this.url);

  @override
  _ReadMangaState createState() => _ReadMangaState();
}

class _ReadMangaState extends State<ReadManga> {
  int page = 1;
  Helper helper = new Helper();
  ReadModel readModel = new ReadModel();

  bool _isloading = false;

  getData() async {
    _isloading = true;
    await helper.readManga(widget.url + "/" + page.toString()).then((value) {
      setState(() {
        _isloading = false;
        readModel = value;
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
      body: _isloading
          ? loadingView()
          : SwipeDetector(
              onSwipeLeft: () {
                setState(() {
                  page++;
                  getData();
                });
              },
              onSwipeRight: () {
                setState(() {
                  print(page);
                  if (page > 1) {
                    page--;
                    getData();
                  }
                });
              },
              swipeConfiguration: SwipeConfiguration(
                  verticalSwipeMinVelocity: 100.0,
                  verticalSwipeMinDisplacement: 50.0,
                  verticalSwipeMaxWidthThreshold: 100.0,
                  horizontalSwipeMaxHeightThreshold: 50.0,
                  horizontalSwipeMinDisplacement: 50.0,
                  horizontalSwipeMinVelocity: 200.0),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: readModel.images == null
                        ? _endOfPages()
                        : PhotoView(
                            imageProvider: NetworkImage(
                                readModel.images.replaceAll(" ", "")),
                          ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: page < 2 ? Text(
                      'Swipe to next pages',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ) : Container(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _endOfPages() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
                child: Text(
              'end of pages',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            )),
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(6)),
              child: Text("back to chapter list ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
            ),
          )
        ],
      ),
    );
  }
}
