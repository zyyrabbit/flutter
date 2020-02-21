class ArticleEntity {
  var summaryInfo;
  var screenshot;
  var content;
  var title;
  var originalUrl;
 
  ArticleEntity.fromMap(Map<String, dynamic> map){
    summaryInfo = map['summaryInfo'];
    screenshot = map['screenshot'];
    content = map['content'];
    title = map['title'];
    originalUrl = map['originalUrl'];
  }
}