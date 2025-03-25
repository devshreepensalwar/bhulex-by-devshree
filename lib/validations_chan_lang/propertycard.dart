class ValidationMessagespropertycard {
  // English Validation Messages (existing ones remain unchanged)
  static const String pleaseSelectRegionEn = 'Please select a Region';
  static const String pleaseEnterOfficeEn = 'Please enter Office';
  static const String pleaseEnterCTSNoEn = 'Please enter CTS No.';

  // Marathi Validation Messages (existing ones remain unchanged)
  static const String pleaseSelectRegionMr = 'कृपया प्रदेश निवडा';
  static const String pleaseEnterOfficeMr = 'कृपया कार्यालय प्रविष्ट करा';
  static const String pleaseEnterCTSNoMr = 'कृपया CTS क्रमांक प्रविष्ट करा';

  // Updated getMessage method (add new cases)
  static String getMessage(String key, bool isToggled) {
    switch (key) {
      // Existing cases...
      case 'pleaseSelectRegion':
        return isToggled ? pleaseSelectRegionMr : pleaseSelectRegionEn;
      case 'pleaseEnterOffice':
        return isToggled ? pleaseEnterOfficeMr : pleaseEnterOfficeEn;
      case 'pleaseEnterCTSNo':
        return isToggled ? pleaseEnterCTSNoMr : pleaseEnterCTSNoEn;
      // Other existing cases...
      default:
        return '';
    }
  }
}
