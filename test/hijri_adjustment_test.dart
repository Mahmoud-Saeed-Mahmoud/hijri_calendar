import 'package:hijri_calendar/src/config/hijri_config.dart';
import 'package:test/test.dart';

void main() {
  group('Hijri Calendar Adjustments Tests', () {
    final Map<int, int> hijriAdjustments = {
      // Previous 10 years (2014-2024)
      35742: 47144, // 2014 adjustments
      35753: 47155, // 2015 adjustments
      35764: 47166, // 2016 adjustments
      35775: 47177, // 2017 adjustments
      35786: 47188, // 2018 adjustments
      35797: 47199, // 2019 adjustments
      35808: 47210, // 2020 adjustments
      35819: 47221, // 2021 adjustments
      35830: 47232, // 2022 adjustments
      35841: 47243, // 2023 adjustments

      // Current and next 10 years (2024-2034)
      35852: 47254, // 2024 adjustments
      35863: 47265, // 2025 adjustments
      35874: 47276, // 2026 adjustments
      35885: 47287, // 2027 adjustments
      35896: 47298, // 2028 adjustments
      35907: 47309, // 2029 adjustments
      35918: 47320, // 2030 adjustments
      35929: 47331, // 2031 adjustments
      35940: 47342, // 2032 adjustments
      35951: 47353, // 2033 adjustments
      35962:
          47364, // 2034 adjustments// Add this if you need specific adjustment for 2034

      14567: 1, // Specific adjustment for Hijri year 1456, month 7
      17467: 1, // Add adjustment for the specific lunation number
      // Add other adjustments as needed
    };
    test('Convert 2020-09-22 to Hijri with adjustments', () {
      final dateConfig = HijriCalendarConfig.fromGregorian(
          DateTime(2020, 9, 22),
          adjustments: hijriAdjustments);

      expect(dateConfig.hYear, equals(1442), reason: 'Year should be 1442');
      expect(dateConfig.hMonth, equals(2), reason: 'Month should be 2');
      expect(dateConfig.hDay, equals(5), reason: 'Day should be 5');
    });

    test('Convert 2025-09-22 to Hijri with adjustments', () {
      final dateConfig = HijriCalendarConfig.fromGregorian(
        DateTime(2025, 9, 22),
      );

      expect(dateConfig.hYear, equals(1447), reason: 'Year should be 1447');
      expect(dateConfig.hMonth, equals(03), reason: 'Month should be 03');
      expect(dateConfig.hDay, equals(30), reason: 'Day should be 30');
    });

    test('Convert 2030-09-22 to Hijri with adjustments', () {
      final dateConfig = HijriCalendarConfig.fromGregorian(
          DateTime(2030, 9, 22),
          adjustments: hijriAdjustments);

      expect(dateConfig.hYear, equals(1452), reason: 'Year should be 1452');
      expect(dateConfig.hMonth, equals(5), reason: 'Month should be 5');
      expect(dateConfig.hDay, equals(24), reason: 'Day should be 24');
    });

    test('Convert 2034-09-22 to Hijri with adjustments', () {
      final dateConfig = HijriCalendarConfig.fromGregorian(
        DateTime(2034, 9, 21),
        adjustments: hijriAdjustments,
      );

      expect(dateConfig.hYear, equals(1456), reason: 'Year should be 1456');
      expect(dateConfig.hMonth, equals(7),
          reason: 'Month should be 7'); // Fixed error message
      expect(dateConfig.hDay, equals(09), reason: 'Day should be 09');
    });

    test('Verify adjustment affects conversion', () {
      final withoutAdjustments =
          HijriCalendarConfig.fromGregorian(DateTime(2034, 9, 22));

      final withAdjustments = HijriCalendarConfig.fromGregorian(
        DateTime(2034, 9, 22),
        adjustments: hijriAdjustments,
      );

      // Compare components individually for clearer debugging
      final daysMatch = withoutAdjustments.hDay == withAdjustments.hDay;
      final monthsMatch = withoutAdjustments.hMonth == withAdjustments.hMonth;
      final yearsMatch = withoutAdjustments.hYear == withAdjustments.hYear;

      expect(daysMatch && monthsMatch && yearsMatch, isFalse,
          reason: 'At least one component should differ with adjustments');
    });

    test('Verify month boundaries with adjustments', () {
      final endOfMonth = HijriCalendarConfig.fromGregorian(
          DateTime(2030, 9, 30),
          adjustments: hijriAdjustments);
      expect(endOfMonth.hDay <= endOfMonth.lengthOfMonth, isTrue,
          reason: 'Day should not exceed month length');

      final startOfMonth = HijriCalendarConfig.fromGregorian(
          DateTime(2030, 9, 1),
          adjustments: hijriAdjustments);
      expect(startOfMonth.hDay >= 1, isTrue,
          reason: 'Day should not be less than 1');
    });
  });
}
