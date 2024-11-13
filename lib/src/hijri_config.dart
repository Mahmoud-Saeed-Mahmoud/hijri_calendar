import 'package:hijri_calendar/src/config/digits_converter.dart';

import 'config/hijri_month_week_names.dart';

class HijriCalendarConfig {
  // Configuration variables
  static String language = 'en';
  late int lengthOfMonth;
  int hDay = 1;
  late int hMonth;
  late int hYear;
  int? wkDay;
  Map<int, int>? adjustments; // User-configurable adjustments
  bool isHijri = false;

  // Add new variables needed for HijriCalendar compatibility
  static final Map<String, Map<String, Map<int, String>>> _local = {
    'en': {
      'long': monthNames,
      'short': monthShortNames,
      'days': wdNames,
      'short_days': shortWdNames
    },
    'ar': {
      'long': arMonthNames,
      'short': arMonthShortNames,
      'days': arWkNames,
      'short_days': arShortWdNames
    },
    'tr': {
      'long': trMonthNames,
      'short': trMonthShortNames,
      'days': trWkNames,
      'short_days': trShortWdNames
    },
  };
  // Modified constructors to accept adjustments
  HijriCalendarConfig({this.adjustments});

  HijriCalendarConfig.setLocal(String locale, {this.adjustments}) {
    language = locale;
  }

  HijriCalendarConfig.fromGregorian(DateTime date, {this.adjustments}) {
    setGregorianDate(date.year, date.month, date.day);
    isHijri = false;
  }

  HijriCalendarConfig.fromHijri(int year, int month, int day,
      {this.adjustments}) {
    setHijriDate(year, month, day);
    isHijri = true;
  }

  HijriCalendarConfig.now({this.adjustments}) {
    setGregorianDate(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    isHijri = false;
  }

  // Method to set adjustments after initialization
  void setAdjustments(Map<int, int> newAdjustments) {
    adjustments = newAdjustments;
  }

  // Set Date as Gregorian and Convert
  String setGregorianDate(int year, int month, int day) {
    _validateGregorianDate(year, month, day);
    isHijri = false;
    return _gregorianToHijri(year, month, day);
  }

  // Set Date as Hijri
  void setHijriDate(int year, int month, int day) {
    _validateHijriDate(year, month, day);
    isHijri = true;
    hYear = year;
    hMonth = month;
    hDay = day;
  }

  // Hijri to Gregorian Conversion
  DateTime hijriToGregorian(int year, int month, int day) {
    _validateHijriDate(year, month, day);
    int mcjdn =
        day + _ummalquraDataIndex(_getNewMoonIndex(year, month) - 1)! - 1;
    int cjdn = mcjdn + 2400000;
    return _julianToGregorian(cjdn);
  }

  // Gregorian Date Validation
  void _validateGregorianDate(int year, int month, int day) {
    if (year < 1937 || year > 2076) {
      throw ArgumentError("Gregorian year out of supported range (1937-2076)");
    }
    if (month < 1 || month > 12) {
      throw ArgumentError("Gregorian month must be between 1 and 12");
    }
    // Use DateTime to validate the day in the Gregorian calendar
    if (day < 1 || day > DateTime(year, month + 1, 0).day) {
      throw ArgumentError(
          "Day $day is not valid for month $month in year $year");
    }
  }

  // Hijri Date Validation
  void _validateHijriDate(int year, int month, int day) {
    if (year < 1 || year > 1500) {
      throw ArgumentError("Hijri year out of supported range (1-1500)");
    }
    if (month < 1 || month > 12) {
      throw ArgumentError("Hijri month must be between 1 and 12");
    }
    if (day < 1 || day > getDaysInMonth(year, month)) {
      throw ArgumentError(
          "Day $day is not valid for month $month in year $year");
    }
  }

  // Gregorian to Julian Conversion
  DateTime _julianToGregorian(int julianDate) {
    int z = (julianDate + 0.5).floor();
    int a = ((z - 1867216.25) / 36524.25).floor();
    a = z + 1 + a - (a / 4).floor();
    int b = a + 1524;
    int c = ((b - 122.1) / 365.25).floor();
    int d = (365.25 * c).floor();
    int e = ((b - d) / 30.6001).floor();
    int day = b - d - (e * 30.6001).floor();
    int month = e - (e > 13.5 ? 13 : 1);
    int year = c - (month > 2.5 ? 4716 : 4715);
    return DateTime(year, month, day);
  }

// Gregorian to Hijri Conversion Helper
  String _gregorianToHijri(int year, int month, int day) {
    int cjdn = _calculateChronologicalJulianDayNumber(year, month, day);
    int mcjdn = cjdn - 2400000;
    int iln = _findLunationIndex(mcjdn);

    hYear = ((iln - 1) / 12).floor() + 1;
    hMonth = iln - 12 * (hYear - 1);

    // Get the index for Umm al-Qura calculation
    int index = _getNewMoonIndex(hYear, hMonth) - 1;

    // Modify the adjustment logic
    int adjustment = 0;
    if (adjustments != null && adjustments!.containsKey(iln)) {
      adjustment = adjustments![iln]!; // Use the actual adjustment value
    }

    // Calculate hDay with adjustment
    hDay = mcjdn - _ummalquraDataIndex(index)! + 1 + adjustment;

    // Handle month boundary cases
    if (hDay > getDaysInMonth(hYear, hMonth)) {
      hDay = 1;
      hMonth++;
      if (hMonth > 12) {
        hMonth = 1;
        hYear++;
      }
    } else if (hDay < 1) {
      hMonth--;
      if (hMonth < 1) {
        hMonth = 12;
        hYear--;
      }
      hDay = getDaysInMonth(hYear, hMonth);
    }

    // Calculate weekday
    wkDay = _calculateWeekday(cjdn);
    lengthOfMonth = getDaysInMonth(hYear, hMonth);

    // Debug output
    print(
        'Converted Gregorian Date: $year-$month-$day to Hijri Date: $hYear-$hMonth-$hDay');
    print(
        'Indices - CJDN: $cjdn, MCJDN: $mcjdn, ILN: $iln, Index: $index, Adjustment: $adjustment');

    return _formattedHijriDate();
  }

  // Helpers for Hijri Calendar Calculations
  int _calculateChronologicalJulianDayNumber(int year, int month, int day) {
    if (month < 3) {
      year -= 1;
      month += 12;
    }
    int a = (year / 100).floor();
    int jgc = a - (a / 4).floor() - 2;
    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day -
        jgc -
        1524;
  }

  int _findLunationIndex(int mcjdn) {
    for (int i = 0; i < ummAlquraDateArray.length; i++) {
      if (_ummalquraDataIndex(i)! > mcjdn) return i + 16260;
    }
    throw ArgumentError("Date out of supported range");
  }

  int _calculateWeekday(int cjdn) {
    int wd = ((cjdn + 1) % 7).toInt();
    return wd == 0 ? 7 : wd;
  }

  int getDaysInMonth(int year, int month) {
    // Standard month lengths
    List<int> monthLengths = [
      29, // Muḥarram (1st month)
      30, // Safar (2nd month)
      29, // Rabīʿ al-Awwal (3rd month)
      30, // Rabīʿ al-Thānī (4th month)
      29, // Jumādá al-Ūlá (5th month)
      30, // Jumādá al-Ākhirah (6th month)
      29, // Rajab (7th month)
      29, // Sha'bān (8th month)
      30, // Ramaḍān (9th month)
      29, // Shawwāl (10th month)
      29, // Dhū al-Qa'dah (11th month)
      30 // Dhū al-Ḥijjah (12th month)
    ];

    // If it's not the 12th month, return standard length
    if (month != 12) {
      return monthLengths[month - 1];
    }

    // Special handling for 12th month (Dhu al-Hijjah)
    // 11 years in a 30-year cycle have 30 days
    // These years correspond to specific positions in the 30-year cycle
    List<int> thirtyDayYears = [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29];

    // Check if the current year is in the list of 30-day years
    int mod30 = year % 30;
    return thirtyDayYears.contains(mod30) ? 30 : 29;
  }

  int _getNewMoonIndex(int year, int month) {
    return ((year - 1) * 12 + month) - 16260;
  }

// Also modify the _ummalquraDataIndex method
  int? _ummalquraDataIndex(int index) {
    if (index < 0 || index >= ummAlquraDateArray.length) {
      throw ArgumentError("Date out of supported range");
    }

    // Modified adjustment logic
    int lunationNumber = index + 16260;
    if (adjustments != null && adjustments!.containsKey(lunationNumber)) {
      return ummAlquraDateArray[index] + adjustments![lunationNumber]!;
    }
    return ummAlquraDateArray[index];
  }

  // Formatting and Output with Calendar Type
  String _formattedHijriDate() {
    String format = language == "ar" ? "yyyy/mm/dd" : "dd/mm/yyyy";
    return formatDate(hYear, hMonth, hDay, format);
  }

  String formatDate(year, month, day, format) {
    String newFormat = format;

    String dayString;
    String monthString;
    String yearString;

    if (language == 'ar') {
      dayString = DigitsConverter.convertWesternNumberToEastern(day);
      monthString = DigitsConverter.convertWesternNumberToEastern(month);
      yearString = DigitsConverter.convertWesternNumberToEastern(year);
    } else {
      dayString = day.toString();
      monthString = month.toString();
      yearString = year.toString();
    }

    if (newFormat.contains("dd")) {
      newFormat = newFormat.replaceFirst("dd", dayString);
    } else {
      if (newFormat.contains("d")) {
        newFormat = newFormat.replaceFirst("d", day.toString());
      }
    }

    //=========== Day Name =============//
    // Friday
    if (newFormat.contains("DDDD")) {
      newFormat = newFormat.replaceFirst(
          "DDDD", "${_local[language]!['days']![wkDay ?? weekDay()]}");

      // Fri
    } else if (newFormat.contains("DD")) {
      newFormat = newFormat.replaceFirst(
          "DD", "${_local[language]!['short_days']![wkDay ?? weekDay()]}");
    }

    //============== Month ========================//
    // 1
    if (newFormat.contains("mm")) {
      newFormat = newFormat.replaceFirst("mm", monthString);
    } else {
      newFormat = newFormat.replaceFirst("m", monthString);
    }

    // Muharram
    if (newFormat.contains("MMMM")) {
      newFormat =
          newFormat.replaceFirst("MMMM", _local[language]!['long']![month]!);
    } else {
      if (newFormat.contains("MM")) {
        newFormat =
            newFormat.replaceFirst("MM", _local[language]!['short']![month]!);
      }
    }

    //================= Year ========================//
    if (newFormat.contains("yyyy")) {
      newFormat = newFormat.replaceFirst("yyyy", yearString);
    } else {
      newFormat = newFormat.replaceFirst("yy", yearString.substring(2, 4));
    }
    return newFormat;
  }

  // String _localizedValue(String value, String type) {
  //   return language == "ar"
  //       ? DateFunctions.convertEnglishToHijriNumber(int.parse(value))
  //       : value;
  // }

  @override
  String toString() {
    if (isHijri) {
      return "Hijri Date: ${_formattedHijriDate()}"; // Existing for Hijri date
    } else {
      // Format Gregorian date based on the selected language
      String format = language == "ar" ? "yyyy/mm/dd" : "dd/mm/yyyy";
      return "Gregorian Date: ${formatDate(DateTime.now().year, DateTime.now().month, DateTime.now().day, format)}";
    }
  }

  ///Compatibility functions
  // Bridge constructor equivalent to HijriCalendar.addMonth
  static HijriCalendarConfig bridgeAddMonth(int year, int month) {
    var config = HijriCalendarConfig();
    config.hYear = month % 12 == 0 ? year - 1 : year;
    config.hMonth = month % 12 == 0 ? 12 : month % 12;
    config.hDay = 1;
    config.isHijri = true;
    return config;
  }

  // Bridge method for HijriCalendar.fromDate
  static HijriCalendarConfig bridgeFromDate(DateTime date) {
    return HijriCalendarConfig.fromGregorian(date);
  }

  // Bridge methods to match HijriCalendar API
  String hDate(int year, int month, int day) {
    setHijriDate(year, month, day);
    return formatDate(year, month, day, "dd/mm/yyyy");
  }

  String toFormat(String format) {
    return formatDate(hYear, hMonth, hDay, format);
  }

  bool isBefore(int year, int month, int day) {
    DateTime current = hijriToGregorian(hYear, hMonth, hDay);
    DateTime other = hijriToGregorian(year, month, day);
    return current.isBefore(other);
  }

  bool isAfter(int year, int month, int day) {
    DateTime current = hijriToGregorian(hYear, hMonth, hDay);
    DateTime other = hijriToGregorian(year, month, day);
    return current.isAfter(other);
  }

  bool isAtSameMomentAs(int year, int month, int day) {
    DateTime current = hijriToGregorian(hYear, hMonth, hDay);
    DateTime other = hijriToGregorian(year, month, day);
    return current.isAtSameMomentAs(other);
  }

  String getLongMonthName() {
    return _local[language]!['long']![hMonth]!;
  }

  String getShortMonthName() {
    return _local[language]!['short']![hMonth]!;
  }

  String getDayName() {
    return _local[language]!['days']![wkDay ?? weekDay()]!;
  }

  Map<int, String> getMonths() {
    return _local[language]!['long']!;
  }

  Map<int, String> getMonthDays(int month, int year) {
    Map<int, String> calendar = {};
    int d = hijriToGregorian(year, month, 1).weekday;
    int daysInMonth = getDaysInMonth(year, month);

    for (int i = 1; i <= daysInMonth; i++) {
      calendar[i] = _local[language]!['days']![d]!;
      d = d < 7 ? d + 1 : 1;
    }

    return calendar;
  }

  List<int?> toList() => [hYear, hMonth, hDay];

  String fullDate() {
    return formatDate(hYear, hMonth, hDay, "DDDD, MMMM dd, yyyy");
  }

  int weekDay() {
    return hijriToGregorian(hYear, hMonth, hDay).weekday;
  }

  static void addLocale(String locale, Map<String, Map<int, String>> names) {
    _local[locale] = names;
  }

  int lengthOfYear({int? year}) {
    int yearToCheck = year ?? hYear;
    int total = 0;
    for (int m = 1; m <= 12; m++) {
      total += getDaysInMonth(yearToCheck, m);
    }
    return total;
  }

  bool isValid() {
    return validateHijri(hYear, hMonth, hDay) &&
        hDay <= getDaysInMonth(hYear, hMonth);
  }

  bool validateHijri(int year, int month, int day) {
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 30) return false;
    return true;
  }
}
