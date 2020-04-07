class ArticleBean {
  var summaryInfo;
  var screenshot;
  var content;
  var title;
  var originalUrl;
  var id;
  var createdAt;
  var user;
  var author;
 
  ArticleBean.fromMap(Map<String, dynamic> map){
    summaryInfo = map['summaryInfo'];
    screenshot = map['screenshot'];
    content = map['content'];
    title = map['title'];
    originalUrl = map['originalUrl'];
    createdAt= map['createdAt'];
    user=map['user'];
    author=map['author'];
  }

}