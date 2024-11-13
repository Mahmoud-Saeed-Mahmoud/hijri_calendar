import 'package:hijri_calendar/src/hijri_config.dart';

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

 // verifyMuharram1446Dates();
}

void verifyMuharram1446Dates() {
  // 2024/8/4 is the END date of Muharram 1446
  DateTime muharramEndDate = DateTime(2024, 8, 4);

  // Calculate start date
  DateTime muharramStartDate = DateTime(2024, 7, 6); // Approximate start

  // Month length calculation
  int monthLength = muharramEndDate.difference(muharramStartDate).inDays + 1;

  print("Muharram 1446 Start Date: $muharramStartDate");
  print("Muharram 1446 End Date: $muharramEndDate");
  print("Month Length: $monthLength"); // Should be 29 days
}
