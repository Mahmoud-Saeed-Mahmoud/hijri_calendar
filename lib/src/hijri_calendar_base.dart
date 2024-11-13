// library hijri_calendar;

// class HijriCalendar {
//   final int hDay;
//   final int hMonth;
//   final int hYear;

//   HijriCalendar({
//     required this.hYear,
//     required this.hMonth,
//     required this.hDay,
//   }) {
//     if (!isValidHijriDate()) {
//       throw ArgumentError("Invalid Hijri date: $hYear-$hMonth-$hDay");
//     }
//   }

//   /// Initializes with today's date in the Hijri calendar.
//   factory HijriCalendar.now() {
//     final DateTime now = DateTime.now();
//     // Placeholder conversion; use a real Gregorian-to-Hijri conversion
//     return HijriCalendar(hYear: now.year, hMonth: now.month, hDay: now.day);
//   }

//   /// Returns the Hijri date formatted as `day/month/year`.
//   String getFormattedDate() => '$hDay/$hMonth/$hYear';

//   /// Checks if the Hijri date is valid (simplified).
//   bool isValidHijriDate() =>
//       (hMonth >= 1 && hMonth <= 12) && (hDay >= 1 && hDay <= 30);

//   /// Converts the Hijri date to a Gregorian date (stub function).
//   /// Replace this with actual conversion logic if available.
//   DateTime toGregorian() {
//     return DateTime(hYear, hMonth, hDay); // Placeholder
//   }
// }
