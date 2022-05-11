class ParseTime {
  static String toHourMinute(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;

    return "${hour < 10 ? "0$hour" : hour} : ${minute < 10 ? "0$minute" : minute}";
  }

  static String toDateDetail(DateTime dateTime) {
    final day = dateTime.day;
    final month = dateTime.month;

    return "${toDayOfWeek(dateTime.weekday)},"
        " ${day < 10 ? "0$day" : day} tháng ${month < 10 ? "0$month" : month} năm ${dateTime.year}";
  }

  static String toDayOfWeek(int weekday) {
    switch (weekday) {
      case 0:
        return 'Chủ nhật';
      case 1:
        return 'Thứ 2';
      case 2:
        return 'Thứ 3';
      case 3:
        return 'Thứ 4';
      case 4:
        return 'Thứ 5';
      case 5:
        return 'Thứ 6';
      case 6:
        return 'Thứ 7';
      case 7:
        return 'Chủ nhật';
      default:
        throw Exception('>>> ${weekday} not yet defined');
    }
  }
}
