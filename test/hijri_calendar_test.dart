// import 'package:hijri_calendar/hijri_calendar.dart';
// import 'package:test/test.dart';

// void main() {
//   group('HijriCalendar', () {
//     test('Constructor initializes date correctly', () {
//       final hijriDate = HijriCalendar(hYear: 1445, hMonth: 10, hDay: 5);
//       expect(hijriDate.hYear, 1445);
//       expect(hijriDate.hMonth, 10);
//       expect(hijriDate.hDay, 5);
//     });

//     test('now() initializes with a reasonable current date', () {
//       final hijriDate = HijriCalendar.now();
//       expect(hijriDate.hYear, greaterThanOrEqualTo(1440));
//     });

//     test('getFormattedDate returns correct format', () {
//       final hijriDate = HijriCalendar(hYear: 1445, hMonth: 10, hDay: 5);
//       expect(hijriDate.getFormattedDate(), '5/10/1445');
//     });

//     test('isValidHijriDate returns true for valid date', () {
//       final hijriDate = HijriCalendar(hYear: 1445, hMonth: 10, hDay: 5);
//       expect(hijriDate.isValidHijriDate(), isTrue);
//     });

//     test('isValidHijriDate returns false for invalid month', () {
//       expect(() => HijriCalendar(hYear: 1445, hMonth: 13, hDay: 5),
//           throwsArgumentError);
//     });

//     test('isValidHijriDate returns false for invalid day', () {
//       expect(() => HijriCalendar(hYear: 1445, hMonth: 10, hDay: 32),
//           throwsArgumentError);
//     });
//   });
// }
