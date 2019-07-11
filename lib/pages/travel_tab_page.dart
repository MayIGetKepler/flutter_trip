import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_trip/dao/travel_dao.dart';
import 'package:flutter_trip/model/travel_model.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/webview.dart';

const PAGE_SIZE = 10;

class TravelTabPage extends StatefulWidget {
  final String code;
  final String url;
  final Map params;

  TravelTabPage({Key key, this.code, this.url, this.params}) : super(key: key);

  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _pageIndex = 1;
  List<TravelItem> _items = [];

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<void> _handleRefresh() async {
//    _isLoading = true;
    _pageIndex = 1;
    final model = await TravelDao.fetch(
            widget.url, widget.params, widget.code, _pageIndex, PAGE_SIZE)
        .catchError((e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    });

    if (model != null) {
      _items.insertAll(0, _modelFilter(model.resultList));
      setState(() {
        _isLoading = false;
      });
    }

    return null;
  }

  _loadMore() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    TravelDao.fetch(
            widget.url, widget.params, widget.code, _pageIndex + 1, PAGE_SIZE)
        .then((model) {
      if (model != null) {
        _items.addAll(_modelFilter(model.resultList));
        _pageIndex++;
        _isLoadingMore = false;
        setState(() {});
      }
    }).catchError((e) {
      _isLoadingMore = false;
      setState(() {});
      print(e.toString());
    });
  }

  List<TravelItem> _modelFilter(List<TravelItem> models) {
    if (models != null && models.isNotEmpty) {
      models.removeWhere((e) => e == null);
      return models;
    } else {
      return [];
    }
  }

  bool _handleScroll(Notification notification) {
    if (notification is ScrollUpdateNotification && notification.depth == 0) {
      if (notification.metrics.pixels >=
          notification.metrics.maxScrollExtent - 30) {
        _loadMore();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
        child: RefreshIndicator(
            child: NotificationListener(
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  itemCount:
                      _items.isNotEmpty ? _items.length + 1 : _items.length,
                  itemBuilder: (context, index) => index == _items.length
                      ? Container(
                          height: 30,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(
                                strokeWidth: 1,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text('加载中'),
                              )
                            ],
                          ),
                        )
                      : _TravelItem(model: _items[index]),
                  staggeredTileBuilder: (index) => StaggeredTile.fit(
                      (_items.isNotEmpty && index == _items.length) ? 2 : 1)),
              onNotification: _handleScroll,
            ),
            onRefresh: _handleRefresh),
        loading: _isLoading);
  }

  @override
  bool get wantKeepAlive => true;
}

class _TravelItem extends StatelessWidget {
  final TravelItem model;

  _TravelItem({this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NavigatorUtil.push(
          context,
          WebView(
            url: model.article.urls[0].h5Url,
            title: '详情',
          )),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _image(context),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text(model.article.articleTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
            ),
            _info(context)
          ],
        ),
      ),
    );
  }

  Widget _image(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        FadeInImage.assetNetwork(
            placeholder: 'images/place_holder.jpg',
            image: model?.article?.images[0]?.dynamicUrl),
        Positioned(
            left: 5,
            bottom: 5,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 3),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  LimitedBox(
                    child: Text(
                      model?.article?.poiName ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    maxWidth: screenWidth * 2 / 5,
                  )
                ],
              ),
            ))
      ],
    );
  }

  Widget _info(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage:
                    NetworkImage(model.article.author.coverImage.dynamicUrl),
                radius: 12,
              ),
              SizedBox(
                width: 3,
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(
                  model.article.author?.nickName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                size: 12,
                color: Colors.grey,
              ),
              SizedBox(
                width: 3,
              ),
              Text(model.article.likeCount.toString(),
                  style: TextStyle(fontSize: 10))
            ],
          )
        ],
      ),
    );
  }
}
