import 'package:flutter/material.dart';
import 'package:peanut/pages/home/homePage.dart';
import 'package:peanut/pages/account/accountPage.dart';

///这个页面是作为整个APP的最外层的容器，以Tab为基础控制每个item的显示与隐藏
class ContainerPage extends StatefulWidget {
  ContainerPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ContainerPageState();
  }
}

class _Item {
  String name, activeIcon, normalIcon;

  _Item(this.name, this.activeIcon, this.normalIcon);
}

class _ContainerPageState extends State<ContainerPage> {
  List<Widget> pages;

  final defaultItemColor = Color.fromARGB(255, 125, 125, 125);

  final itemNames = [
    _Item('首页', 'assets/images/ic_tab_home_active.png', 'assets/images/ic_tab_home_normal.png'),
    _Item('个人中心', 'assets/images/ic_tab_profile_active.png', 'assets/images/ic_tab_profile_normal.png')
  ];

  List<BottomNavigationBarItem> itemList;

  @override
  void initState() {
    super.initState();
    print('initState _ContainerPageState');
    if (pages == null) {
      pages = [
        HomePage(),
        AccountPage(),
      ];
    }
    if (itemList == null) {
      itemList = itemNames
        .map((item) => BottomNavigationBarItem(
          icon: Image.asset(
            item.normalIcon,
            width: 30.0,
            height: 30.0,
          ),
          title: Text(
            item.name,
            style: TextStyle(fontSize: 10.0),
          ),
          activeIcon: Image.asset(item.activeIcon, width: 30.0, height: 30.0))
        ).toList();
    }
  }

  int _selectIndex = 0;

//Stack（层叠布局）+ Offstage 组合, 解决状态被重置的问题
  Widget _getPagesWidget(int index) {
    return Offstage(
      offstage: _selectIndex != index,
      child: TickerMode(
        enabled: _selectIndex == index,
        child: pages[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build _ContainerPageState');
    return Scaffold(
      body: new Stack(
        children: [
          _getPagesWidget(0),
          _getPagesWidget(1),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      bottomNavigationBar: BottomNavigationBar(
        items: itemList,
        onTap: (int index) {
          ///这里根据点击的index来显示，非index的page均隐藏
          setState(() {
            _selectIndex = index;
          });
        },
        //图标大小
        iconSize: 24,
        //当前选中的索引
        currentIndex: _selectIndex,
        //选中后，底部BottomNavigationBar内容的颜色(选中时，默认为主题色)（仅当type: BottomNavigationBarType.fixed,时生效）
        fixedColor: Color.fromARGB(255, 0, 127, 255),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
