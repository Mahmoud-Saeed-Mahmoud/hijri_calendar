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
```
### Error Handling
The library includes built-in date validation. It will throw ArgumentError for invalid dates:

```dart
try {
  HijriCalendarConfig.fromHijri(1500, 13, 1); // Invalid month
} catch (e) {
  print('Error: $e'); // Prints: Error: Hijri month must be between 1 and 12
}

try {
  HijriCalendarConfig.fromGregorian(DateTime(2077, 1, 1)); // Out of supported range
} catch (e) {
  print('Error: $e'); // Prints: Error: Gregorian year out of supported range (1937-2076)
}

```

## Contributions 🤝
Contributions are welcome! If you have suggestions for improvements or new features, feel free to open an issue or submit a pull request. Let's make this library even better together! 💪

## License 📜
This project is licensed under the MIT License. See the LICENSE file for more details.