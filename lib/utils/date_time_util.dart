import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateTimeUtil {
  DateTime parseServerDateTime(String dateTime) {
    return DateTime.parse(dateTime);
  }

  String formateDate(DateTime? incomingDateTime) {
    if (incomingDateTime == null) {
      return "";
    }
    return DateFormat('dd MMMM yyyy').format(incomingDateTime);
  }

  String formateDateForServer(DateTime? incomingDateTime) {
    if (incomingDateTime == null) {
      return "";
    }
    return DateFormat('yyyy-MM-dd').format(incomingDateTime);
  }

  String forMateTime(int? incomingTime) {
    if (incomingTime == null) {
      return "";
    }
    DateTime _time = DateTime.fromMillisecondsSinceEpoch(incomingTime);
    return DateFormat('HH:mm').format(_time);
  }

  String getTimeAgo(int? incomingTime){
    if (incomingTime == null) {
      return "";
    }
    DateTime _time = DateTime.fromMillisecondsSinceEpoch(incomingTime);
    return timeago.format(_time);
  }

}
