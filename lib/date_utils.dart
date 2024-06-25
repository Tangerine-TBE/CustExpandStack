import 'package:intl/intl.dart';

class DateUtils {
  static DateFormat formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss');
  static DateFormat formattedDateSimple = DateFormat('yyyy-MM-dd');

  static String convertDateFormatString(DateTime dateTime,DateFormat dateFormat) {
    return dateFormat.format(dateTime);
  }

}
