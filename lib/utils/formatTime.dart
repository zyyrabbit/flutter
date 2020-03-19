 String formatTime (
  int value,
  { 
    String format = 'yyyy-MM-dd',
    String defaultValue = '--'
  }) {
  if (value == null) return defaultValue;
  DateTime time;
  try {
    time = DateTime.fromMillisecondsSinceEpoch(value);
  } catch(e) {
    return defaultValue;
  }
  Map<String, int> o = {
   'M+': time.month,
   'd+': time.day,
   'h+': time.hour,
   'm+': time.minute,
   's+': time.second,
   'q+': ((time.month + 3) / 3).floor(),
   'S': time.millisecond
  };
  
  if (RegExp(r'(y+)').hasMatch(format)) {
    int len = RegExp(r'(y+)').firstMatch(format).group(0).length;
    format = format.replaceFirst(RegExp(r'(y+)'), (time.year.toString()).substring(4 - len));
  }
  o.forEach((String key, int val) {
    if (RegExp('$key').hasMatch(format)) {
     int len = RegExp('$key').firstMatch(format).group(0).length;
     format = format.replaceFirst(
       RegExp('$key'),
       (len == 1) ? val : (('00$val').substring(val.toString().length))
      );
   }
  });
  return format;
}