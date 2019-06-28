import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool loading;

  ///true:show loading tip above child
  ///
  ///false:only show the loading tip
  final bool cover;

  LoadingContainer(
      {@required this.child, @required this.loading, this.cover = true});

  @override
  Widget build(BuildContext context) {
    return !cover
        ? loading ? _loadingWidget : child
        : loading ? Stack(
            children: <Widget>[child, _loadingWidget],
          ) : child;
  }

  Widget get _loadingWidget {
    return Center(
        child: CircularProgressIndicator(
      strokeWidth: 2,
    ));
  }
}
