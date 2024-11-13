# Hijri Calendar 📅🌙
[![Pub Package](https://img.shields.io/pub/v/hijri_calendar.svg)](https://pub.dev/packages/hijri_calendar)
[![Build Status](https://travis-ci.org/username/repo.svg?branch=main)](https://travis-ci.org/Shreemanarjun/repo)
[![Coverage Status](https://coveralls.io/repos/github/Shreemanarjun/repo/badge.svg?branch=main)](https://coveralls.io/github/Shreemanarjun/repo?branch=main)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)


Welcome to the **Hijri Calendar** library! This Dart library allows you to work with Hijri dates easily. Whether you want to create, validate, or convert Hijri dates, this library has you covered! 🎉

## Features ✨

- **Create Hijri Dates**: Create Hijri dates using different constructors:
  - `HijriCalendarConfig.now()` - Get current Hijri date
  - `HijriCalendarConfig.fromGregorian()` - Convert Gregorian to Hijri
  - `HijriCalendarConfig.fromHijri()` - Create from specific Hijri date

- **Date Conversion**: 
  - Convert Hijri dates to Gregorian using `hijriToGregorian(year, month, day)`
  - Convert Gregorian dates to Hijri using `fromGregorian()`

- **Calendar Configuration**:
  - Set language preference (e.g., 'ar' for Arabic)
  - Support for custom date adjustments through constructor or `setAdjustments()` method

- **Date Utilities**:
  - Get number of days in a specific Hijri month using `getDaysInMonth(year, month)`
  - Format Hijri dates with custom patterns using `formatDate(year, month, day, pattern)`

- **Validation**:
  - Built-in date validation for Hijri dates
  - Supported Gregorian date range validation (1937-2076)


## Understanding Adjustments 🔧

Adjustments in Hijri Calendar are used to fine-tune the dates according to local moon sighting or specific regional differences. Here's how they work:

1. **Adjustment Format**:
   - Adjustments are provided as a Map<int, int>
   - Key: Julian Day Number (JDN)
   - Value: Adjustment value (-1, 0, or 1)

2. **How to Calculate JDN**:
   ```dart
   // Example: To calculate JDN for May 17, 2023
   DateTime date = DateTime(2023, 5, 17);
   int jdn = (date.millisecondsSinceEpoch / 86400000).floor() + 2440588;
   
   ```

3. **Setting Adjustments**:
```dart
// Method 1: Through constructor
    var calendar = HijriCalendarConfig(adjustments: {
     16800: 1,  // Add one day when JDN is 16800
     16801: -1, // Subtract one day when JDN is 16801
    });

    // Method 2: Using setAdjustments method
    calendar.setAdjustments({
         16802: 1,
        16803: -1,
    });

```

4. **Setting Adjustments**:

- 1 : Adds one day to the calculated date
- -1 : Subtracts one day from the calculated date
- 0 : No adjustment needed

5. **Adjustments for Specific Month, Day, Year**: 
    To set adjustments for a specific month, day, and year, you first need to calculate the JDN for that specific date. Here's an example:

```dart
// Example: Adjusting for the 1st of Ramadan, 1444
int year = 1444;
int month = 9; // Ramadan
int day = 1;

// Calculate the JDN for the specific Hijri date
DateTime gregorianDate = HijriCalendarConfig.hijriToGregorian(year, month, day);
int jdn = (gregorianDate.millisecondsSinceEpoch / 86400000).floor() + 2440588;

// Set adjustment for that JDN
calendar.setAdjustments({
  jdn: 1, // Add one day for the 1st of Ramadan, 1444
});

```

6. **Use Cases**:
- Regional moon sighting differences
- Aligning with local Islamic calendar authorities
- Correcting calculated dates based on actual observations


## Installation 📦

To use the Hijri Calendar library, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  hijri_calendar: ^1.0.0

```

## Usage 🚀
Here's a quick example of how to use the Hijri Calendar library:
### Basic Usage
```dart

import 'package:hijri_calendar/hijri_calendar.dart';

void main() {
  // Create a HijriCalendarConfig instance for the current date
  var hijriCalendar = HijriCalendarConfig.now();
  print(hijriCalendar); // Prints the current Hijri date

  // Convert a specific Gregorian date to Hijri
  var specificDate = HijriCalendarConfig.fromGregorian(DateTime(2023, 5, 17));
  print(specificDate); // Prints the corresponding Hijri date

  // Create a Hijri date directly
  var hijriDate = HijriCalendarConfig.fromHijri(1444, 10, 27);
  print(hijriDate); // Prints the specified Hijri date

  // Convert Hijri to Gregorian
  DateTime gregorianDate = hijriDate.hijriToGregorian(1444, 10, 27);
  print(gregorianDate); // Prints the corresponding Gregorian date
}
```

### Advanced Usage

```dart
// Set language to Arabic
HijriCalendarConfig.language = 'ar';

// Create a calendar with custom adjustments
var customCalendar = HijriCalendarConfig(adjustments: {16800: 1, 16801: -1});

// Set adjustments after initialization
var calendar = HijriCalendarConfig.now();
calendar.setAdjustments({16802: 1, 16803: -1});

// Get days in a specific Hijri month
int daysInMonth = calendar.getDaysInMonth(1444, 10);
print('Days in Shawwal 1444: $daysInMonth');

// Format a specific date
String formattedDate = calendar.formatDate(1444, 10, 27, "dd/mm/yyyy");
print('Formatted date: $formattedDate');

// NEW: Compatibility APIs
// Bridge method to add a month
var nextMonth = HijriCalendarConfig.bridgeAddMonth(1444, 11);
print('Next month: ${nextMonth.fullDate()}');

// Create from DateTime
var fromDate = HijriCalendarConfig.bridgeFromDate(DateTime.now());
print('Current date: ${fromDate.fullDate()}');

// Format Hijri date with specific pattern
var hijriDate = HijriCalendarConfig.fromHijri(1444, 10, 27);
print('Formatted: ${hijriDate.toFormat("DDDD, MMMM dd, yyyy")}');

// Get month and day names
print('Month name: ${hijriDate.getLongMonthName()}');
print('Short month: ${hijriDate.getShortMonthName()}');
print('Day name: ${hijriDate.getDayName()}');

// Date comparison methods
var compareDate = HijriCalendarConfig.fromHijri(1444, 11, 1);
print('Is before: ${hijriDate.isBefore(1444, 11, 1)}');
print('Is after: ${hijriDate.isAfter(1444, 9, 1)}');
print('Same moment: ${hijriDate.isAtSameMomentAs(1444, 10, 27)}');

// Get calendar information
var months = hijriDate.getMonths();
print('All months: $months');

// Get days in a specific month
var monthDays = hijriDate.getMonthDays(1444, 10);
print('Days in month: $monthDays');

// Convert to List format
List<int?> dateList = hijriDate.toList();
print('Date as list: $dateList'); // [1444, 10, 27]

// Get length of year
int yearLength = hijriDate.lengthOfYear();
print('Days in year: $yearLength');

// Validate dates
print('Is valid date: ${hijriDate.isValid()}');

// Add new locale
HijriCalendarConfig.addLocale('fr', {
  'long': {1: 'Mouharram', 2: 'Safar', /* ... */},
  'short': {1: 'Mou', 2: 'Saf', /* ... */},
  'days': {1: 'Lundi', /* ... */},
  'short_days': {1: 'Lun', /* ... */}
});

```

## Contributions 🤝
Contributions are welcome! If you have suggestions for improvements or new features, feel free to open an issue or submit a pull request. Let's make this library even better together! 💪

## License 📜
This project is licensed under the MIT License. See the LICENSE file for more details.