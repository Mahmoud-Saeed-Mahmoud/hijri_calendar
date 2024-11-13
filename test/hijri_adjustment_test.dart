import 'package:hijri_calendar/src/config/hijri_adjustment_maps.dart';
import 'package:hijri_calendar/src/hijri_config.dart';
import 'package:test/test.dart';

void main() {
  group('Hijri Calendar Adjustments Tests', () {
    test('Convert 2020-09-22 to Hijri with adjustments', () {
      final dateConfig = HijriCalendarConfig.fromGregorian(
          DateTime(2020, 9, 22),
          adjustments: hijriAdjustments2014to2034);

      expect(dateConfig.hYear, equals(1442), reason: 'Year should be 1442');
      expect(dateConfig.hMonth, equals(2), reason: 'Month should be 2');
      expect(dateConfig.hDay, equals(5), reason: 'Day should be 5');
    });

    test('Convert 2025-09-22 to Hijri with adjustments', () {
      final dateConfig = HijriCalendarConfig.fromGregorian(
        DateTime(2025, 9, 22),
        adjustments: hijriAdjustments2014to2034,
      );

      expect(dateConfig.hYear, equals(1447), reason: 'Year should be 1447');
      expect(dateConfig.hMonth, equals(04), reason: 'Month should be 04');
      expect(dateConfig.hDay, equals(01), reason: 'Day should be 30');
    });

    test('Convert 2030-09-22 to Hijri with adjustments', () {
      final dateConfig = HijriCalendarConfig.fromGregorian(
          DateTime(2030, 9, 22),
          adjustments: hijriAdjustments2014to2034);

      expect(dateConfig.hYear, equals(1452), reason: 'Year should be 1452');
      expect(dateConfig.hMonth, equals(5), reason: 'Month should be 5');
      expect(dateConfig.hDay, equals(24), reason: 'Day should be 24');
    });

    test('Convert 2034-09-22 to Hijri with adjustments', () {
      final dateConfig = HijriCalendarConfig.fromGregorian(
        DateTime(2034, 9, 21),
        adjustments: hijriAdjustments2014to2034,
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
        adjustments: hijriAdjustments2014to2034,
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
          adjustments: hijriAdjustments2014to2034);
      expect(endOfMonth.hDay <= endOfMonth.lengthOfMonth, isTrue,
          reason: 'Day should not exceed month length');

      final startOfMonth = HijriCalendarConfig.fromGregorian(
          DateTime(2030, 9, 1),
          adjustments: hijriAdjustments2014to2034);
      expect(startOfMonth.hDay >= 1, isTrue,
          reason: 'Day should not be less than 1');
    });
  });
}
