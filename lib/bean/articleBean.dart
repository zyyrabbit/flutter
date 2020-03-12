class ArticleBean {
  var summaryInfo;
  var screenshot;
  var content;
  var title;
  var originalUrl;
  var id;
  var time;
 
  ArticleBean.fromMap(Map<String, dynamic> map){
    summaryInfo = map['summaryInfo'];
    screenshot = map['screenshot'];
    content = map['content'];
    title = map['title'];
    originalUrl = map['originalUrl'];
    time= map['time'];
  }

}