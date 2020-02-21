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
  Map<String, String> formData = {
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
            children: createFilelds()
          ),
        ),
      )
    );
  }

  createFilelds() {
    return <Widget>[
      TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.laptop),
          hintText: '文章链接',
          contentPadding: EdgeInsets.all(10.0),
        ),
        onSaved: (val) {
          formData['link'] = val;
        },
      ),
      TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.title),
          hintText: '标题',
          contentPadding: EdgeInsets.all(10.0),
        ),
        onSaved: (val) {
          formData['title'] = val;
        },
      ),
      TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.tune),
          hintText: '此刻你的想法...',
          contentPadding: EdgeInsets.all(10.0),
        ),
        onSaved: (val) {
          formData['content'] = val;
        },
      ),
      labelsWidgets()
    ];
  }

  labelsWidgets() {
    return new Container(
        padding: const EdgeInsets.all(15.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: const Icon(Icons.toc),
              ),
              Text('选择分类', style: const TextStyle(fontSize: 16.0)),
              ]
            ),
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
