import 'date_functions.dart';
import 'hijri_month_week_names.dart';

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
    bool isLeapYear = _isLeapYear(year);
    List<int> monthLengths = [
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
      isLeapYear ? 30 : 29
    ];
    return monthLengths[month - 1];
  }

  bool _isLeapYear(int year) {
    int mod30 = year % 30;
    return mod30 == 2 ||
        mod30 == 5 ||
        mod30 == 7 ||
        mod30 == 10 ||
        mod30 == 13 ||
        mod30 == 16 ||
        mod30 == 18 ||
        mod30 == 21 ||
        mod30 == 24 ||
        mod30 == 26 ||
        mod30 == 29;
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

  String formatDate(int year, int month, int day, String format) {
    return format
        .replaceAll("dd", _localizedValue(day.toString(), "day"))
        .replaceAll("mm", _localizedValue(month.toString(), "month"))
        .replaceAll("yyyy", _localizedValue(year.toString(), "year"));
  }

  String _localizedValue(String value, String type) {
    return language == "ar"
        ? DateFunctions.convertEnglishToHijriNumber(int.parse(value))
        : value;
  }

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
}
