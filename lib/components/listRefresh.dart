import 'dart:async';
import 'package:flutter/material.dart';

class ListRefresh extends StatefulWidget {
  final renderItem;
  final requestApi;

  const ListRefresh([this.requestApi, this.renderItem]) : super();

  @override
  State<StatefulWidget> createState() => ListRefreshState();
}

class ListRefreshState extends State<ListRefresh> {
  bool isLoading = false; // 是否正在请求数据中
  bool _hasMore = true; // 是否还有更多数据可加载
  int _pageIndex = 0; // 页面的索引
  int _pageTotal = 0; // 页面总数
  List items = List();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getMoreData();
    _scrollController.addListener(() {
      /// 如果下拉的当前位置到scroll的最下面
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

// list探底，执行的具体事件
 Future _getMoreData() async {
    if (!isLoading && _hasMore) {
      // 如果上一次异步请求数据完成 同时有数据可以加载
      if (mounted) {
        setState(() => isLoading = true);
      }
      // 还有数据可以拉新
      List newEntries = await mokeHttpRequest();
      _hasMore = (_pageIndex <= _pageTotal);
      if (mounted) {
        setState(() {
          items.addAll(newEntries);
          isLoading = false;
        });
      }
    } else if (!isLoading && !_hasMore) {
      // 这样判断,减少以后的绘制
      _pageIndex = 0;
    }
  }

/// 伪装吐出新数据
  Future<List> mokeHttpRequest() async {
    if (widget.requestApi is Function) {
      final listObj = await widget.requestApi({'pageIndex': _pageIndex});
      _pageIndex = listObj['pageIndex'];
      _pageTotal = listObj['total'];
      return listObj['list'];
    } else {
      return Future.delayed(Duration(seconds: 2), () {
        return [];
      });
    }
  }

/// 下拉加载的事件，清空之前list内容，取前X个
/// 其实就是列表重置
  Future<Null> _handleRefresh() async {
    List newEntries = await mokeHttpRequest();
    if (mounted) {
      setState(() {
        items.clear();
        items.addAll(newEntries);
        isLoading = false;
        _hasMore = true;
        return null;
      });
    }
  }

/// 加载中的提示
  Widget _buildLoadText() {
    Widget child = Text('');
    if (items.isEmpty) {
      child = Column(
        children: <Widget>[
        Image.asset('assets/icon/icon.png', width: 60, height: 60, color: Color.fromARGB(255, 160, 160, 160)),
        Text('暂无数据', style: TextStyle(color: Color.fromARGB(255, 160, 160, 160)))
      ]);
    } else if (_scrollController.position.pixels <
          _scrollController.position.maxScrollExtent) {
      child = Text('数据没有更多了！！！');
    }
    return Container(
        child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: child
        ),
    ));
  }

/// 上提加载loading的widget,如果数据到达极限，显示没有更多
  Widget _buildProgressIndicator() {
    if (_hasMore) {
      return Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Opacity(
                opacity: isLoading ? 1.0 : 0.0,
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue)),
              ),
              SizedBox(height: 20.0),
              Text( '稍等片刻更精彩...',style: TextStyle(fontSize: 14.0))
            ],
        )
       ),
      );
    } else {
      return _buildLoadText();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: ListView.builder(
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return _buildProgressIndicator();
          } else {
            if (widget.renderItem is Function) {
              return widget.renderItem(index, items[index]);
            }
          }
          return null;
        },
        controller: _scrollController,
      ),
      onRefresh: _handleRefresh,
    );
  }
}
