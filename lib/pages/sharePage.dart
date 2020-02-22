import 'package:flutter/material.dart';

class ActorFilterEntry {
  const ActorFilterEntry(this.name, this.initials);
  final String name;
  final int initials;
}

/// 分享文章
class SharePage extends StatefulWidget {
  SharePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final _formKey = GlobalKey<FormState>();
  final List<ActorFilterEntry> _cast = <ActorFilterEntry>[
    const ActorFilterEntry('前端', 0),
    const ActorFilterEntry('后端', 1),
    const ActorFilterEntry('Nodejs', 2),
    const ActorFilterEntry('Flutter', 3),
  ];
  List<String> _filters = <String>[];
  Map<String, String> _formData = {
    'link': '',
    'title': '',
    'content': ''
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文章详情页'),
        actions: <Widget>[
        MaterialButton(
          textColor: Colors.black,
          child: Text('发布'),
          onPressed: () {
            _neverSatisfied();
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
            }
          },
        )]
      ),
      backgroundColor: Color(0xffffffff),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _createFields()
          ),
        ),
      )
    );
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('通知'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('你的水平不够，继续修炼吧!奋斗，年青人'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('关闭'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
}

  _createFields() {
    return <Widget>[
      TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.laptop, 
            color: Color.fromARGB(60, 60, 60, 60) /// 一定要设置，否者输入时候图标会消失
          ),
          hintText: '文章链接',
          contentPadding: EdgeInsets.all(10.0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1)
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(60, 60, 60, 60), width: 1)
          ),
        ),
        onSaved: (val) {
          _formData['link'] = val;
        },
      ),
      TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.title, color: Color.fromARGB(60, 60, 60, 60) ),
          hintText: '标题',
          contentPadding: EdgeInsets.all(10.0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1)
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(60, 60, 60, 60), width: 1)
          ),
        ),
        onSaved: (val) {
          _formData['title'] = val;
        },
      ),
      TextFormField(
        maxLines: 4,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.tune, color: Color.fromARGB(60, 60, 60, 60) ),
          hintText: '此刻你的想法...',
          contentPadding: EdgeInsets.all(10.0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1)
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(60, 60, 60, 60), width: 1)
          ),
        ),
        onSaved: (val) {
          _formData['content'] = val;
        },
      ),
      TextFormField(
        enabled: false,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.toc, color: Color.fromARGB(60, 60, 60, 60) ),
          hintText: '选择分类',
          border: InputBorder.none
        )
      ),
      labelsWidgets()
    ];
  }

  labelsWidgets() {
    return new Container(
        padding: const EdgeInsets.only(right: 15.0, left: 15.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              spacing: 6.0, // gap between adjacent chips
              runSpacing: 0, // gap between lines
              children: actorWidgets.toList()
            )
        ]
      )
    );
  }

  Iterable<Widget> get actorWidgets sync* {
    for (ActorFilterEntry actor in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          label: Text(actor.name),
          selected: _filters.contains(actor.name),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(actor.name);
              } else {
                _filters.removeWhere((String name) {
                  return name == actor.name;
                });
              }
            });
          },
        ),
      );
    }
  }
}
