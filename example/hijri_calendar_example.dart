import 'package:hijri_calendar/src/config/hijri_config.dart';

void main() {
  final datetimes = [
    DateTime(2014, 06, 04),
    DateTime(2019, 06, 04),
    DateTime(2024, 06, 04),
    DateTime(2024, 10, 05),
    DateTime(2029, 06, 04),
    DateTime(2034, 06, 04),
  ];
  for (var datetime in datetimes) {
    final hijridate = HijriCalendarConfig.fromGregorian(datetime);
    print(hijridate);
  }
}
