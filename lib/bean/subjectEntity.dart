class SubjectEntity {
  
  Subject subject;
  var rank;
  var delta;

  SubjectEntity.fromMap(Map<String, dynamic> map){
    rank = map['rank'];
    delta = map['delta'];
    var subjectMap = map['subject'];
    subject = Subject.fromMap(subjectMap);
  }
}

class Subject {
  bool tag = false;
  Rating rating;
  var genres;
  var title;
  List<Cast> casts;
  var durations;
  var collectCount;
  var mainlandPubdate;
  var hasVideo;
  var originalTitle;
  var subtype;
  var directors;
  var pubdates;
  var year;
  Images images;
  var alt;
  var id;

  ///构造函数
  Subject.fromMap(Map<String, dynamic> map) {
    var rating = map['rating'];
    this.rating = Rating(rating['average'], rating['max']);
    genres = map['genres'];
    title = map['title'];
    var castMap = map['casts'];
    casts = _converCasts(castMap);
    collectCount = map['collect_count'];
    originalTitle = map['original_title'];
    subtype = map['subtype'];
    directors = map['directors'];
    year = map['year'];
    var img = map['images'];
    images = Images(img['small'], img['large'], img['medium']);
    alt = map['alt'];
    id = map['id'];
    durations = map['durations'];
    mainlandPubdate = map['mainland_pubdate'];
    hasVideo = map['has_video'];
    pubdates = map['pubdates'];
  }

  _converCasts(casts) {
    return casts.map<Cast>((item)=>Cast.fromMap(item)).toList();
  }

}

class Images {
  var small;
  var large;
  var medium;

  Images(this.small, this.large, this.medium);
}

class Rating {
  var average;
  var max;
  Rating(this.average, this.max);
}



class Cast {
  var id;
  var nameEn;
  var name;
  Avatar avatars;
  var alt;
  Cast(this.avatars, this.nameEn, this.name, this.alt, this.id);

  Cast.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nameEn = map['name_en'];
    name = map['name'];
    alt = map['alt'];
    var tmp = map['avatars'];
    if(tmp == null){
      avatars = null;
    }else{
      avatars = Avatar(tmp['small'], tmp['large'], tmp['medium']);
    }

  }
}

class Avatar {
  var medium;
  var large;
  var small;
  Avatar(this.small, this.large, this.medium);
}
