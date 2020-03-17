import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peanut/utils/application.dart';
import 'package:peanut/router.dart';
import 'package:peanut/bean/userInforBean.dart';
import 'package:peanut/event/UserGithubOAuthEvent.dart';
import 'package:peanut/pages/containerPage.dart';
import 'package:peanut/utils/storage.dart';
import 'package:event_bus/event_bus.dart';
import 'package:provider/provider.dart';
import 'package:peanut/model/globalModel.dart';
import 'package:peanut/db/sql.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState() {
    Application.event = EventBus();
  }

  /// 利用FocusNode和_focusScopeNode来控制焦点 可以通过FocusNode.of(context)来获取widget树中默认的_focusScopeNode
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusScopeNode _focusScopeNode = FocusScopeNode();

  GlobalKey<FormState> _signInFormKey = GlobalKey();
  TextEditingController _userNameEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  bool _isShowPassWord = false;
  String _username = '';
  String _password = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    registerListger();
  }

  void registerListger() {
    Application.event.on<UserGithubOAuthEvent>().listen((event) {
      print('token:${event.token}');
      if (event.isSuccess == true) {
        ///  oAuth 认证成功
        Application.api.getUserInfo(event.token).then((result) async{
          await Storage.setValue('hasLogin', 'true');
          await initGlobalModel(result, true);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ContainerPage()),
            (route) => route == null);

        }).catchError((onError) {
          print('获取身份信息 error:::$onError');
        });
      } else {
        Fluttertoast.showToast(
          msg: '验证失败',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }
    });
  }

  Future<void> initGlobalModel(UserInforBean result, bool hasLogin) async {
    GlobalModel globalModel = Provider.of<GlobalModel>(context, listen: false);
    List<Map<String, dynamic>> storeArticles = await getStoreWidgetList();
    globalModel.set(result, true, storeArticles);
  }

  Future<List<Map<String, dynamic>>> getStoreWidgetList() async {
    try {
      return await Sql.getByCondition(TableName.STORE);
    } on Exception catch(e) {
      return [];
    }
  }

// 创建登录界面的TextForm
  Widget buildSignInTextForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 190,
      //  * Flutter提供了一个Form widget，它可以对输入框进行分组，然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                child: TextFormField(
                  controller: _userNameEditingController,
                  ///关联焦点
                  focusNode: _emailFocusNode,
                  onEditingComplete: () {
                    if (_focusScopeNode == null) {
                      _focusScopeNode = FocusScope.of(context);
                    }
                    _focusScopeNode.requestFocus(_passwordFocusNode);
                  },

                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    hintText: '登录名',
                    border: InputBorder.none),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  //验证
                    validator: (value) {
                      if (value.isEmpty) {
                        return '登录名不可为空!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _username = value;
                      });
                    },
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: TextFormField(
                  controller: _passwordEditingController,
                  focusNode: _passwordFocusNode,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    hintText: '登录密码',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                      ),
                      onPressed: showPassWord,
                    ),
                  ),
                  ///输入密码，需要用*****显示
                  obscureText: !_isShowPassWord,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '密码不可为空!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignInButton() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color.fromARGB(255, 0, 127, 255)
        ),
        child: Text(
          '登录',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      onTap: () {
        // 利用key来获取widget的状态FormState,可以用过FormState对Form的子孙FromField进行统一的操作
        if (_signInFormKey.currentState.validate()) {
          doLogin();
        }
      },
    );
  }

  // 登陆操作
  doLogin() async {
    print('doLogin');
    _signInFormKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      /// 暂时不做密码校验
      UserInforBean userInfor = UserInforBean(
        username: _username,
        id: -1,
        avatarPic: 'https://hbimg.huabanimg.com/9bfa0fad3b1284d652d370fa0a8155e1222c62c0bf9d-YjG0Vt_fw658'
      );
      await initGlobalModel(userInfor, false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ContainerPage()),
        (route) => route == null);
    } catch(e) {
      print(e);
    }
   
    setState(() {
      _isLoading = false;
    });
  }

/// 点击控制密码是否显示
  void showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  Widget buildLoading() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/paimaiLogo.png',
                  ),
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 35.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/gitHub.png',
                            fit: BoxFit.contain,
                            width: 60.0,
                            height: 60.0,
                          ),
                        ],
                      ),
                      buildSignInTextForm(),
                      SizedBox(height: 15.0),
                      buildSignInButton(),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              'Github OAuth 认证',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 127, 255),
                                  decoration: TextDecoration.underline),
                            ),
                            onPressed: () {
                              Application.pageRouter.push(
                                context,
                                PageName.webViewPage,
                                {
                                  'title': 'Github',
                                  'url': Uri.encodeComponent('https://github.com/login/oauth/authorize?client_id=4974949c8779c6204086&scope=user,public_repo')
                                }
                              );
                            },
                          ),
                          FlatButton(
                            child: Text(
                              '游客登录',
                              style: TextStyle(color: Color.fromARGB(255, 0, 127, 255), decoration: TextDecoration.underline),
                            ),
                            onPressed: () async {
                              UserInforBean userInfor = UserInforBean(
                                username: '游客',
                                id: -1,
                                avatarPic: 'https://hbimg.huabanimg.com/9bfa0fad3b1284d652d370fa0a8155e1222c62c0bf9d-YjG0Vt_fw658'
                              );
                              await initGlobalModel(userInfor, false);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => ContainerPage()),
                                (route) => route == null);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
