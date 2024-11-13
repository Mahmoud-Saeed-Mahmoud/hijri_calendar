import 'package:hijri_calendar/src/config/hijri_adjustment_maps.dart';
import 'package:hijri_calendar/src/hijri_config.dart';
import 'package:test/test.dart';

void main() {
  group('Hijri Calendar Month Length Tests', () {
    test('Verify Hijri conversion: 2024-08-04 should be 29/01/1446', () {
      final config = HijriCalendarConfig(
        adjustments: hijriAdjustments2014to2034,
      );
      final date = config.hijriToGregorian(
        1446,
        01,
        29,
      );

      expect(date, DateTime(2024, 08, 04));
      final hijri = HijriCalendarConfig.fromGregorian(DateTime(2024, 08, 04));

      expect(hijri.hDay, 29);
      expect(hijri.hMonth, 01);
      expect(hijri.hYear, 1446);
    });
    test('Test specific months in 1446 AH', () {
      final config =
          HijriCalendarConfig(adjustments: hijriAdjustments2014to2034);
      // Muharram 1446 should be 29 days
      expect(config.getDaysInMonth(1446, 1), equals(29),
          reason: 'Muharram 1446 should be 29 days');
      // Safar 1446 should be 30 days
      expect(config.getDaysInMonth(1446, 2), equals(30),
          reason: 'Safar 1446 should be 30 days');

      expect(config.getDaysInMonth(1446, 3), equals(29),
          reason: ' Rabi al-awwal 1446 should be 29 days');
    });

    test('Test full year month lengths pattern', () {
      final config = HijriCalendarConfig(
        adjustments: hijriAdjustments2014to2034,
      );
      final List<int> expectedMonthLengths = [
        29, // Muharram
        30, // Safar
        30, // Rabi' al-awwal
        30, // Rabi' al-thani
        29, // Jumada al-ula
        30, // Jumada al-akhirah
        30, // Rajab
        29, // Sha'ban
        29, // Ramadan
        30, // Shawwal
        29, // Dhu al-Qi'dah
        29, // Dhu al-Hijjah (29 in non-leap years)
      ];

      for (int month = 1; month <= 12; month++) {
        print(
            'Month $month of 1446 should be ${expectedMonthLengths[month - 1]} days but getindays ${config.getDaysInMonth(
          1446,
          month,
        )}');
      }
    });
  });
}
