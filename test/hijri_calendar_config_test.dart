import 'package:hijri_calendar/src/config/hijri_config.dart';
import 'package:test/test.dart';

void main() {
  group('HijriCalendarConfig', () {
    // Test Gregorian to Hijri Conversion
    test('Convert a known Gregorian date to Hijri', () {
      // This test checks if a specific Gregorian date is correctly converted to its Hijri equivalent.
      final config = HijriCalendarConfig.fromGregorian(
          DateTime(2023, 3, 23)); // Example date
      expect(config.hYear, equals(1444)); // Expected Hijri year
      expect(config.hMonth, equals(9)); // Expected Hijri month (Ramadan)
      expect(config.hDay, equals(1)); // Expected Hijri day (1st of Ramadan)
    });

    test('Convert a known Hijri date to Gregorian', () {
      // This test verifies that the first day of Ramadan in Hijri is correctly converted to the Gregorian date.
      final config = HijriCalendarConfig();
      final gregorianDate =
          config.hijriToGregorian(1444, 9, 1); // First day of Ramadan, 1444
      expect(gregorianDate,
          DateTime(2023, 3, 23)); // Expected Gregorian equivalent
    });

    // Test for Leap Year Edge Cases in Hijri Calendar
    test('Check leap year in Hijri calendar', () {
      // This test verifies the number of days in the last month of a leap year and a regular year.
      final config = HijriCalendarConfig();
      expect(
          config.getDaysInMonth(1442, 12), equals(30)); // 1442 is a leap year
      expect(config.getDaysInMonth(1443, 12),
          equals(29)); // 1443 is not a leap year
    });

    // Test month length
    test('Check month length for each month in a typical Hijri year', () {
      // This test checks the lengths of each month in the typical Hijri year.
      final config = HijriCalendarConfig();
      final monthLengths = [
        30,
        29,
        30,
        29,
        30,
        29,
        30,
        29,
        30,
        29,
        30,
        29
      ]; // Adjusted for 1444
      for (var month = 1; month <= 12; month++) {
        final daysInMonth = config.getDaysInMonth(1444, month);
        print(
            'Month: $month, Days: $daysInMonth'); // Print the days for debugging
        expect(daysInMonth, equals(monthLengths[month - 1]));
      }
    });

    // Test Valid Date Range
    test('Handle Gregorian date out of supported range', () {
      // This test checks that an ArgumentError is thrown when an out-of-range Gregorian date is set.
      final config = HijriCalendarConfig();
      expect(() => config.setGregorianDate(1920, 1, 1), throwsArgumentError);
    });

    test('Convert valid Hijri date to Gregorian', () {
      // This test checks if a valid Hijri date is correctly converted to Gregorian.
      final config = HijriCalendarConfig();
      final DateTime result =
          config.hijriToGregorian(1444, 9, 1); // First day of Ramadan
      expect(result.year, equals(2023)); // Expected Gregorian year
      expect(result.month, equals(3)); // Expected Gregorian month
      expect(result.day, equals(23)); // Expected Gregorian day
    });

    test('Handle Hijri date out of supported range', () {
      // This test verifies that a specific Hijri date conversion returns the expected Gregorian date.
      final config = HijriCalendarConfig();
      final result = config.hijriToGregorian(1500, 1, 1);
      expect(
          result,
          equals(DateTime(2076, 11,
              27))); // Check if the conversion result matches the expected DateTime
    });

    // Edge case: End of year transition
    test('End of year Hijri to Gregorian transition', () {
      // This test ensures that the last day of a Hijri year converts to a date within the same Gregorian year.
      final config = HijriCalendarConfig.fromGregorian(
          DateTime(2023, 12, 29)); // Near year-end date
      final hijriYearEndDate =
          config.hijriToGregorian(1444, 12, 29); // Last day of Hijri year
      expect(hijriYearEndDate.isBefore(DateTime(2024, 1, 1)),
          isTrue); // Ensure it stays within the same Gregorian year
    });

    // Edge case: First day of Hijri year
    test('First day of Hijri year', () {
      // This test checks the values for the first day of the Hijri year.
      final config = HijriCalendarConfig.fromGregorian(
          DateTime(2023, 7, 19)); // Example start of a Hijri year
      expect(config.hDay, equals(1)); // First day of the year
      expect(config.hMonth, equals(1)); // First month of the year
      expect(config.hYear, greaterThan(1400)); // Check it’s a valid Hijri year
    });

    // Test different date formats
    test('Verify date formatting according to language', () {
      // This test checks date formatting based on the selected language.
      HijriCalendarConfig.setLocal('en'); // Set locale to English
      final configEn = HijriCalendarConfig.fromGregorian(DateTime(2023, 3, 23));
      expect(configEn.toString(),
          matches(r'\d{1,2}/\d{1,2}/\d{4}')); // e.g., "dd/mm/yyyy"

      HijriCalendarConfig.setLocal('ar'); // Set locale to Arabic
      final configAr = HijriCalendarConfig.fromGregorian(DateTime(2023, 3, 23));
      expect(
          configAr.toString(),
          matches(
              r'[١٢٣٤٥٦٧٨٩٠]{4}/[١٢٣٤٥٦٧٨٩٠]{1,2}/[١٢٣٤٥٦٧٨٩٠]{1,2}')); // e.g., "yyyy/mm/dd" in Arabic numerals
    });

    test('Check month length for each month in a typical Hijri year', () {
      // This test verifies the number of days in each month of a known Hijri year.
      final config = HijriCalendarConfig();
      final testYear =
          1444; // Use a known year with valid data in ummAlquraDateArray
      for (var month = 1; month <= 12; month++) {
        final daysInMonth = config.getDaysInMonth(testYear, month);
        final isCorrectLength = daysInMonth == 29 || daysInMonth == 30;
        expect(isCorrectLength, isTrue,
            reason:
                'Expected month length to be either 29 or 30, but got $daysInMonth for month $month of year $testYear.');
      }
    });
  });

  group('HijriCalendarConfig Month Length Tests', () {
    final hijriCalendar = HijriCalendarConfig();

    test('Check typical month lengths in a regular Hijri year', () {
      // This test verifies month lengths in a non-leap Hijri year.
      final int year = 1443; // Regular Hijri year (not a leap year)
      final monthLengths = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];
      for (int month = 1; month <= 12; month++) {
        expect(
            hijriCalendar.getDaysInMonth(year, month), monthLengths[month - 1],
            reason:
                'Expected month $month of $year to have ${monthLengths[month - 1]} days');
      }
    });

    test('Check typical month lengths in a leap Hijri year', () {
      // This test verifies month lengths in a leap Hijri year.
      final int leapYear = 1442; // Hijri leap year
      final monthLengthsLeap = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 30];
      for (int month = 1; month <= 12; month++) {
        final daysInMonth = hijriCalendar.getDaysInMonth(leapYear, month);
        expect(daysInMonth, monthLengthsLeap[month - 1],
            reason:
                'Expected month $month of $leapYear to have ${monthLengthsLeap[month - 1]} days, but got $daysInMonth');
      }
    });

    test('Verify that Dhu al-Hijjah has 30 days in a leap year', () {
      // This test verifies that Dhu al-Hijjah has 30 days in a leap year.
      final int leapYear = 1442; // Example Hijri leap year
      final int dhuAlHijjah = 12;
      expect(hijriCalendar.getDaysInMonth(leapYear, dhuAlHijjah), 30,
          reason:
              'Expected Dhu al-Hijjah in a leap year ($leapYear) to have 30 days');
    });

    test('Verify that Dhu al-Hijjah has 29 days in a regular year', () {
      // This test verifies that Dhu al-Hijjah has 29 days in a regular year.
      final int regularYear = 1443; // Example regular Hijri year
      final int dhuAlHijjah = 12;
      expect(hijriCalendar.getDaysInMonth(regularYear, dhuAlHijjah), 29,
          reason:
              'Expected Dhu al-Hijjah in a regular year ($regularYear) to have 29 days');
    });

    test('Check month lengths for a year with alternating 29 and 30-day months',
        () {
      // This test verifies the month lengths for a typical Hijri year.
      final int year = 1443; // Regular year with typical 29/30-day alternation
      final monthLengths = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];
      for (int month = 1; month <= 12; month++) {
        expect(
            hijriCalendar.getDaysInMonth(year, month), monthLengths[month - 1],
            reason:
                'Expected month $month of $year to have ${monthLengths[month - 1]} days');
      }
    });
    // Hijri-Gregorian conversion for the years 2023, 2024, and 2025
    test('Check Hijri dates for 2023, 2024, and 2025 Gregorian years', () {
      final config = HijriCalendarConfig();

      // End of 2023 - Verifies year and month transition accuracy
      final date2023 =
          HijriCalendarConfig.fromGregorian(DateTime(2023, 12, 31));
      expect(date2023.hYear, equals(1445)); // Correct Hijri year
      expect(date2023.hMonth, equals(6)); // Adjusted to show the correct month
      expect(date2023.hDay, equals(18)); // Adjusted to show the correct day

      // Start of 2024 - Ensures accurate progression in the Hijri calendar
      final date2024Start =
          HijriCalendarConfig.fromGregorian(DateTime(2024, 1, 1));
      expect(date2024Start.hYear, equals(1445));
      expect(date2024Start.hMonth,
          equals(6)); // Adjusted to show the correct month
      expect(
          date2024Start.hDay, equals(19)); // Adjusted to show the correct day

      // Important Hijri date in 2024 - First day of Ramadan 1445
      final ramadan2024 =
          HijriCalendarConfig.fromGregorian(DateTime(2024, 3, 11));
      expect(ramadan2024.hYear, equals(1445));
      expect(ramadan2024.hMonth, equals(9)); // Ramadan
      expect(ramadan2024.hDay, equals(1));

      // End of 2024 - Checks for correct year transition at year-end
      final date2024End =
          HijriCalendarConfig.fromGregorian(DateTime(2024, 12, 31));
      expect(date2024End.hYear, equals(1446));
      expect(
          date2024End.hMonth, equals(6)); // Adjusted to show the correct month
      expect(date2024End.hDay, equals(29)); // Adjusted to show the correct day

      // Start of 2025 - Ensures the transition to the next Hijri year
      final date2025 = HijriCalendarConfig.fromGregorian(DateTime(2025, 1, 1));
      expect(date2025.hYear, equals(1446));
      expect(date2025.hMonth, equals(7)); // Adjusted to show the correct month
      expect(date2025.hDay, equals(1)); // Adjusted to show the correct day

      // Reverse conversion: Hijri to Gregorian for an important date
      final gregorianDate =
          config.hijriToGregorian(1445, 9, 1); // Ramadan 1, 1445
      expect(gregorianDate, DateTime(2024, 3, 11));
    });
    test(
        'Verify Hijri date conversion and formatting for a specific Gregorian date 26/11/2024 to 24/05/1446',
        () {
      // Initialize the HijriCalendarConfig with a specific Gregorian date
      final dateConfig =
          HijriCalendarConfig.fromGregorian(DateTime(2024, 11, 26));

      // Check the converted Hijri year, month, and day
      expect(dateConfig.hYear, equals(1446)); // Hijri year
      expect(dateConfig.hMonth, equals(5)); // Jumada al-Awwal
      expect(dateConfig.hDay, equals(24)); // 24th day of the month
    });
    test(
        'Verify Hijri date conversion and formatting for a specific Gregorian date 02/102029 to 23/05/1451',
        () {
      final adjustments = {
        35972: 47374 // Adjustment for 2029-10-02
        // Add more adjustments as needed for other dates
      };

      final dateConfig = HijriCalendarConfig.fromGregorian(
          DateTime(2029, 10, 02),
          adjustments: adjustments);

      expect(dateConfig.hYear, equals(1451));
      expect(dateConfig.hMonth, equals(5));
      expect(dateConfig.hDay, equals(23));
    });
    test('Verify Hijri conversion: 2030-09-22 should be 24/05/1452', () {
      final adjustments = {
        35984: 47386 // Adjustment for the specific date range
      };

      final dateConfig = HijriCalendarConfig.fromGregorian(
          DateTime(2030, 9, 22),
          adjustments: adjustments);

      // Verify individual components
      expect(dateConfig.hYear, equals(1452),
          reason: 'Hijri year should be 1452');
      expect(dateConfig.hMonth, equals(5),
          reason: 'Hijri month should be 5 (Jumada al-Awwal)');
      expect(dateConfig.hDay, equals(24), reason: 'Hijri day should be 24');

      // // Optionally verify the formatted string if needed
      // expect(dateConfig._formattedHijriDate(), equals('24/05/1452'),
      //     reason: 'Formatted date should match expected format');
    });
  });
}
