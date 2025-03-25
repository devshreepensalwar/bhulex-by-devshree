// lib/language/investigation_strings.dart
class LocalizedStrings {
  // English Strings
  static const String pleaseSelectStateEn = 'Please select your state';
  static const String quickServicesEn = 'Quick Services';
  static const String oldRecordsEn = 'Old Records of Rights';
  static const String legalAdvisoryEn = 'Legal Advisory';
  static const String investigativeReportsEn = 'Investigative Reports';
  static const String eApplicationsEn = 'E-Applications';
  static const String instantEn = 'Instant';
  static const String within12HoursEn = 'within 12 hours';
  static const String within24HoursEn = 'within 24 hours';
  static const String pleaseEnterYourDetailsEn = 'Please Enter Your Details';
  static const String districtEn = 'District';
  static const String talukaEn = 'Taluka/Tahashil';
  static const String villageEn = 'Village/Mauza';
  static const String fieldSurveyNoEn = 'Field Survey No';
  static const String byNameEn = 'By Name';
  static const String byNameHintEn = '(In Case Survey No. Is Not known)';
  static const String nextEn = 'Next';
  static const String noteEn =
      'Note: After payment document can be downloaded from\norder section only once which you can share.';
  static const List<String> statesEn = ['Maharashtra', 'Madhya Pradesh'];
  static const List<String> labelsEn = [
    'Digitally Signed 7/12 Extract',
    'Digitally Signed 8A Extract',
    'Digitally Signed E-Mutation Extract',
    'Digitally Signed Property Card',
    'Index-II Search',
    'RERA Certificate',
    'Bhu Naksha Map',
    'CTS Map',
  ];

  // Marathi Strings
  static const String pleaseSelectStateMr = 'कृपया आपले राज्य निवडा';
  static const String quickServicesMr = 'त्वरित सेवा';
  static const String oldRecordsMr = 'जुने हक्कांचे रेकॉर्ड';
  static const String legalAdvisoryMr = 'कायदेशीर सल्ला';
  static const String investigativeReportsMr = 'तपास अहवाल';
  static const String eApplicationsMr = 'ई-अर्ज';
  static const String instantMr = 'तात्काळ';
  static const String within12HoursMr = '12 तासांच्या आत';
  static const String within24HoursMr = '24 तासांच्या आत';
  static const String pleaseEnterYourDetailsMr =
      'कृपया आपले तपशील प्रविष्ट करा';
  static const String districtMr = 'जिल्हा';
  static const String talukaMr = 'तालुका/तहसील';
  static const String villageMr = 'गाव/मौजा';
  static const String fieldSurveyNoMr = 'फील्ड सर्वे क्रमांक';
  static const String byNameMr = 'नावाने';
  static const String byNameHintMr = '(सर्वे क्रमांक माहित नसल्यास)';
  static const String nextMr = 'पुढे';
  static const String noteMr =
      'टीप: पेमेंट केल्यानंतर दस्तऐवज फक्त एकदाच ऑर्डर सेक्शनमधून डाउनलोड करता येईल, जे आपण शेअर करू शकता.';
  static const List<String> statesMr = ['महाराष्ट्र', 'मध्य प्रदेश'];
  static const List<String> labelsMr = [
    'डिजिटली साइन केलेला 7/12 उतारा',
    'डिजिटली साइन केलेला 8A उतारा',
    'डिजिटली साइन केलेला ई-म्यूटेशन उतारा',
    'डिजिटली साइन केलेले प्रॉपर्टी कार्ड',
    'इंडेक्स-II शोध',
    'RERA प्रमाणपत्र',
    'भू नक्शा नकाशा',
    'CTS नकाशा',
  ];

  // Method to get strings based on language toggle
  static String getString(String key, bool isToggled) {
    switch (key) {
      case 'pleaseSelectState':
        return isToggled ? pleaseSelectStateMr : pleaseSelectStateEn;
      case 'quickServices':
        return isToggled ? quickServicesMr : quickServicesEn;
      case 'oldRecords':
        return isToggled ? oldRecordsMr : oldRecordsEn;
      case 'legalAdvisory':
        return isToggled ? legalAdvisoryMr : legalAdvisoryEn;
      case 'investigativeReports':
        return isToggled ? investigativeReportsMr : investigativeReportsEn;
      case 'eApplications':
        return isToggled ? eApplicationsMr : eApplicationsEn;
      case 'instant':
        return isToggled ? instantMr : instantEn;
      case 'within12Hours':
        return isToggled ? within12HoursMr : within12HoursEn;
      case 'within24Hours':
        return isToggled ? within24HoursMr : within24HoursEn;
      case 'pleaseEnterYourDetails':
        return isToggled ? pleaseEnterYourDetailsMr : pleaseEnterYourDetailsEn;
      case 'district':
        return isToggled ? districtMr : districtEn;
      case 'taluka':
        return isToggled ? talukaMr : talukaEn;
      case 'village':
        return isToggled ? villageMr : villageEn;
      case 'fieldSurveyNo':
        return isToggled ? fieldSurveyNoMr : fieldSurveyNoEn;
      case 'byName':
        return isToggled ? byNameMr : byNameEn;
      case 'byNameHint':
        return isToggled ? byNameHintMr : byNameHintEn;
      case 'next':
        return isToggled ? nextMr : nextEn;
      case 'note':
        return isToggled ? noteMr : noteEn;
      default:
        return '';
    }
  }

  // Method to get state list based on language toggle
  static List<String> getStates(bool isToggled) {
    return isToggled ? statesMr : statesEn;
  }

  // Method to get label list based on language toggle
  static List<String> getLabels(bool isToggled) {
    return isToggled ? labelsMr : labelsEn;
  }
}

// property_card_strings.dart
class PropertyCardStrings {
  // English Strings
  static const String pleaseEnterYourDetailsEn = 'Please Enter Your Details';
  static const String districtEn = 'District';
  static const String villageEn = 'Village';
  static const String nextEn = 'Next';
  static const String noteEn =
      'Note: After payment document can be downloaded from order section only once which you can share.';
  static const String regionEn = 'Region';
  static const String officeEn = 'Office';
  static const String ctsNoEn = 'Enter CTS No.';

  // Marathi Strings
  static const String pleaseEnterYourDetailsMr =
      'कृपया आपले तपशील प्रविष्ट करा';
  static const String districtMr = 'जिल्हा';
  static const String villageMr = 'गाव';
  static const String nextMr = 'पुढे';
  static const String noteMr =
      'टीप: पेमेंट केल्यानंतर दस्तऐवज केवळ एकदाच ऑर्डर विभागातून डाउनलोड केला जाऊ शकतो, जो आपण शेअर करू शकता.';
  static const String regionMr = 'प्रदेश';
  static const String officeMr = 'कार्यालय';
  static const String ctsNoMr = 'सीटीएस क्रमांक प्रविष्ट करा';

  // Method to get string based on toggle state
  static String getString(String key, bool isToggled) {
    switch (key) {
      case 'pleaseEnterYourDetails':
        return isToggled ? pleaseEnterYourDetailsMr : pleaseEnterYourDetailsEn;
      case 'district':
        return isToggled ? districtMr : districtEn;
      case 'village':
        return isToggled ? villageMr : villageEn;
      case 'next':
        return isToggled ? nextMr : nextEn;
      case 'note':
        return isToggled ? noteMr : noteEn;
      case 'region':
        return isToggled ? regionMr : regionEn;
      case 'office':
        return isToggled ? officeMr : officeEn;
      case 'ctsNo':
        return isToggled ? ctsNoMr : ctsNoEn;
      default:
        return '';
    }
  }
}

// index_search_strings.dart
class IndexSearchStrings {
  static String getString(String key, bool isToggled) {
    final Map<String, Map<String, String>> strings = {
      'pleaseEnterYourDetails': {
        'en': 'Please Enter Your Details',
        'local': 'कृपया आपले तपशील प्रविष्ट करा', // Marathi example
      },
      'district': {'en': 'District', 'local': 'जिल्हा'},
      'selectSROOffice': {
        'en': 'Select SRO Office',
        'local': 'एसआरओ कार्यालय निवडा',
      },
      'ctsNo': {
        'en': 'Enter CTS No./FS No./Plot No.',
        'local': 'सीटीएस क्रमांक/एफएस क्रमांक/प्लॉट क्रमांक प्रविष्ट करा',
      },
      'byName': {'en': 'By Name', 'local': 'नावाने'},
      'byNameHint': {
        'en': '(In Case Survey No. Is Not Known)',
        'local': '(जर सर्व्हे क्रमांक माहित नसेल तर)',
      },
      'next': {'en': 'Next', 'local': 'पुढे'},
      'note': {
        'en':
            'Note: After payment document can be downloaded from\norder section only once which you can share.',
        'local':
            'टीप: पेमेंट केल्यानंतर दस्तऐवज\nऑर्डर विभागातून फक्त एकदा डाउनलोड करता येईल, जे आपण शेअर करू शकता.',
      },
    };

    final language = isToggled ? 'local' : 'en';
    return strings[key]?[language] ??
        key; // Fallback to key if string not found
  }
}

// lib/language/rera_certificate_strings.dart
class ReraCertificateStrings {
  static String getString(String key, bool isToggled) {
    final Map<String, Map<String, String>> strings = {
      'pleaseEnterYourDetails': {
        'en': 'Please Enter Your Details',
        'local': 'कृपया आपले तपशील प्रविष्ट करा', // Marathi example
      },
      'projectName': {'en': 'Project Name', 'local': 'प्रकल्पाचे नाव'},
      'builderName': {
        'en': 'Builder/Promoter Name',
        'local': 'बांधकाम व्यावसायिक/प्रवर्तकाचे नाव',
      },
      'next': {'en': 'Next', 'local': 'पुढे'},
      'note': {
        'en':
            'Note: After payment document can be downloaded from\norder section only once which you can share.',
        'local':
            'टीप: पेमेंट केल्यानंतर दस्तऐवज\nऑर्डर विभागातून फक्त एकदा डाउनलोड करता येईल, जे आपण शेअर करू शकता.',
      },
    };

    final language = isToggled ? 'local' : 'en';
    return strings[key]?[language] ??
        key; // Fallback to key if string not found
  }
}

class MortgageReportsStrings {
  static String getString(String key, bool isToggled) {
    final Map<String, Map<String, String>> strings = {
      'pleaseEnterYourDetails': {
        'en': 'Please Enter Your Details',
        'local': 'कृपया आपले तपशील प्रविष्ट करा', // Marathi example
      },
      'district': {'en': 'District', 'local': 'जिल्हा'},
      'taluka': {'en': 'Taluka/Tahashil', 'local': 'तालुका/तहसील'},
      'village': {'en': 'Village/Mauza', 'local': 'गाव/मौजा'},
      'ctsNo': {
        'en': 'Enter CTS No./FS No./Plot No.',
        'local': 'सीटीएस क्रमांक/एफएस क्रमांक/प्लॉट क्रमांक प्रविष्ट करा',
      },
      'next': {'en': 'Next', 'local': 'पुढे'},
      'note': {
        'en':
            'Note: After payment document can be downloaded from\norder section only once which you can share.',
        'local':
            'टीप: पेमेंट केल्यानंतर दस्तऐवज\nऑर्डर विभागातून फक्त एकदा डाउनलोड करता येईल, जे आपण शेअर करू शकता.',
      },
    };

    final language = isToggled ? 'local' : 'en';
    return strings[key]?[language] ??
        key; // Fallback to key if string not found
  }
}

class RegisteredDocumentStrings {
  static String getString(String key, bool isToggled) {
    final Map<String, Map<String, String>> strings = {
      'pleaseEnterYourDetails': {
        'en': 'Please Enter Your Details',
        'local': 'कृपया आपले तपशील प्रविष्ट करा', // Marathi example
      },
      'district': {'en': 'District', 'local': 'जिल्हा'},
      'taluka': {'en': 'Taluka/Tahashil', 'local': 'तालुका/तहसील'},
      'village': {'en': 'Village/Mauza', 'local': 'गाव/मौजा'},
      'ctsNo': {
        'en': 'Enter CTS No./FS No./Plot No.',
        'local': 'सीटीएस क्रमांक/एफएस क्रमांक/प्लॉट क्रमांक प्रविष्ट करा',
      },
      'byName': {'en': 'By Name', 'local': 'नावाने'},
      'byNameHint': {
        'en': '(In Case Survey No. Is Not Known)',
        'local': '(जर सर्व्हे क्रमांक माहित नसेल तर)',
      },
      'typeOfDocument': {
        'en': 'Type Of Document',
        'local': 'दस्तऐवजाचा प्रकार',
      },
      'next': {'en': 'Next', 'local': 'पुढे'},
      'note': {
        'en':
            'Note: After payment document can be downloaded from\norder section only once which you can share.',
        'local':
            'टीप: पेमेंट केल्यानंतर दस्तऐवज\nऑर्डर विभागातून फक्त एकदा डाउनलोड करता येईल, जे आपण शेअर करू शकता.',
      },
    };

    final language = isToggled ? 'local' : 'en';
    return strings[key]?[language] ??
        key; // Fallback to key if string not found
  }
}

class InvestigationStrings {
  static String getString(String key, bool isToggled) {
    final Map<String, Map<String, String>> strings = {
      'pleaseEnterYourDetails': {
        'en': 'Please Enter Your Details',
        'local': 'कृपया आपले तपशील प्रविष्ट करा', // Marathi example
      },
      'district': {'en': 'District', 'local': 'जिल्हा'},
      'taluka': {'en': 'Taluka/Tahashil', 'local': 'तालुका/तहसील'},
      'village': {'en': 'Village/Mauza', 'local': 'गाव/मौजा'},
      'ctsNo': {
        'en': 'Select CTS No./FS No./Plot No.',
        'local': 'सीटीएस क्रमांक/एफएस क्रमांक/प्लॉट क्रमांक निवडा',
      },
      'byName': {'en': 'By Name', 'local': 'नावाने'},
      'byNameHint': {
        'en': '(In Case Survey No. Is Not Known)',
        'local': '(जर सर्व्हे क्रमांक माहित नसेल तर)',
      },
      'next': {'en': 'Next', 'local': 'पुढे'},
      'description': {
        'en':
            'Our document drafting service is a professional offering provided by our in-house, highly qualified advocates. We prepare a variety of legal documents, including Sale Deeds, Wills, Gift Deeds, Mortgage Deeds, Leave and Licence Agreements, Lease Deeds, Partition Deeds, and other required documents, all of which can be registered at any SRO office.',
        'local':
            'आमची दस्तऐवज मसुदा सेवा ही आमच्या इन-हाउस, उच्च पात्र वकिलांद्वारे प्रदान केलेली व्यावसायिक सेवा आहे. आम्ही विक्री करार, मृत्युपत्र, भेटपत्र, गहाणखत, परवाना आणि करार सोडणे, भाडेपट्टा करार, विभाजन करार आणि इतर आवश्यक दस्तऐवज तयार करतो, जे सर्व कोणत्याही SRO कार्यालयात नोंदणीकृत केले जाऊ शकतात.',
      },
    };

    final language = isToggled ? 'local' : 'en';
    return strings[key]?[language] ??
        key; // Fallback to key if string not found
  }
}

// lib/language/legaldrafts_strings.dart
class LegaldraftsStrings {
  static String getString(String key, bool isToggled) {
    final Map<String, Map<String, String>> strings = {
      'pleaseEnterYourDetails': {
        'en': 'Please Enter Your Details',
        'local': 'कृपया आपले तपशील प्रविष्ट करा', // Marathi example
      },
      'district': {'en': 'District', 'local': 'जिल्हा'},
      'taluka': {'en': 'Taluka/Tahashil', 'local': 'तालुका/तहसील'},
      'village': {'en': 'Village/Mauza', 'local': 'गाव/मौजा'},
      'ctsNo': {
        'en': 'Select CTS No./FS No./Plot No.',
        'local': 'सीटीएस क्रमांक/एफएस क्रमांक/प्लॉट क्रमांक निवडा',
      },
      'partyNames': {'en': 'Party Names', 'local': 'पक्षकारांची नावे'},
      'shortBrief': {
        'en': 'Short brief of required draft',
        'local': 'आवश्यक मसुद्याचे संक्षिप्त वर्णन',
      },
      'next': {'en': 'Next', 'local': 'पुढे'},
      'description': {
        'en':
            'Our document drafting service is a professional offering provided by our in-house, highly qualified advocates. We prepare a variety of legal documents, including Sale Deeds, Wills, Gift Deeds, Mortgage Deeds, Leave and Licence Agreements, Lease Deeds, Partition Deeds, and other required documents, all of which can be registered at any SRO office.',
        'local':
            'आमची दस्तऐवज मसुदा सेवा ही आमच्या इन-हाउस, उच्च पात्र वकिलांद्वारे प्रदान केलेली व्यावसायिक सेवा आहे. आम्ही विक्री करार, मृत्युपत्र, भेटपत्र, गहाणखत, परवाना आणि करार सोडणे, भाडेपट्टा करार, विभाजन करार आणि इतर आवश्यक दस्तऐवज तयार करतो, जे सर्व कोणत्याही SRO कार्यालयात नोंदणीकृत केले जाऊ शकतात.',
      },
    };

    final language = isToggled ? 'local' : 'en';
    return strings[key]?[language] ??
        key; // Fallback to key if string not found
  }
}

// lib/language/courtcases_strings.dart
class CourtcasesStrings {
  static String getString(String key, bool isToggled) {
    final Map<String, Map<String, String>> strings = {
      'pleaseEnterYourDetails': {
        'en': 'Please Enter Your Details',
        'local': 'कृपया आपले तपशील प्रविष्ट करा', // Marathi example
      },
      'district': {'en': 'District', 'local': 'जिल्हा'},
      'selectCourt': {'en': 'Select Court', 'local': 'न्यायालय निवडा'},
      'partyNames': {'en': 'Party Names', 'local': 'पक्षकारांची नावे'},
      'caseNo': {'en': 'Case No.', 'local': 'प्रकरण क्रमांक'},
      'dateFormatHint': {'en': 'dd-mm-yyyy', 'local': 'दिनांक-महिना-वर्ष'},
      'next': {'en': 'Next', 'local': 'पुढे'},
      'description': {
        'en':
            'Our document drafting service is a professional offering provided by our in-house, highly qualified advocates. We prepare a variety of legal documents, including Sale Deeds, Wills, Gift Deeds, Mortgage Deeds, Leave and Licence Agreements, Lease Deeds, Partition Deeds, and other required documents, all of which can be registered at any SRO office.',
        'local':
            'आमची दस्तऐवज मसुदा सेवा ही आमच्या इन-हाउस, उच्च पात्र वकिलांद्वारे प्रदान केलेली व्यावसायिक सेवा आहे. आम्ही विक्री करार, मृत्युपत्र, भेटपत्र, गहाणखत, परवाना आणि करार सोडणे, भाडेपट्टा करार, विभाजन करार आणि इतर आवश्यक दस्तऐवज तयार करतो, जे सर्व कोणत्याही SRO कार्यालयात नोंदणीकृत केले जाऊ शकतात.',
      },
    };

    final language = isToggled ? 'local' : 'en';
    return strings[key]?[language] ??
        key; // Fallback to key if string not found
  }
}

// lib/language/adhikar_abhilekh_strings.dart
class AdhikarAbhilekhStrings {
  static String getString(String key, bool isToggled) {
    final Map<String, Map<String, String>> strings = {
      'pleaseEnterYourDetails': {
        'en': 'Please Enter Your Details',
        'local': 'कृपया आपले तपशील प्रविष्ट करा', // Marathi example
      },
      'district': {'en': 'District', 'local': 'जिल्हा'},
      'taluka': {'en': 'Taluka/Tahashil', 'local': 'तालुका/तहसील'},
      'village': {'en': 'Village/Mauza', 'local': 'गाव/मौजा'},
      'fieldSurveyNo': {
        'en': 'Field Survey No',
        'local': 'शेत सर्वेक्षण क्रमांक',
      },
      'byName': {'en': 'By Name', 'local': 'नावाने'},
      'inCaseSurveyNotKnown': {
        'en': '(In Case Survey No. Is Not known)',
        'local': '(सर्वेक्षण क्रमांक माहित नसल्यास)',
      },
      'next': {'en': 'Next', 'local': 'पुढे'},
      'note': {
        'en':
            'Note : After payment document can be downloaded from\norder section only once which you can share.',
        'local':
            'टीप: पेमेंट केल्यानंतर दस्तऐवज ऑर्डर विभागातून\nफक्त एकदाच डाउनलोड केला जाऊ शकतो जो आपण शेअर करू शकता.',
      },
    };

    final language = isToggled ? 'local' : 'en';
    return strings[key]?[language] ??
        key; // Fallback to key if string not found
  }
}

class LocalizationStringsinstant {
  static String getString(String key, bool isToggled) {
    final Map<String, Map<String, String>> strings = {
      // Bottom Navigation Strings
      'home': {'en': 'Home', 'local': 'होम'},
      'customerCare': {'en': 'Customer Care', 'local': 'ग्राहक सेवा'},
      'myOrder': {'en': 'My Order', 'local': 'माझी ऑर्डर'},
      'myProfile': {'en': 'My Profile', 'local': 'माझे प्रोफाइल'},
      'packages': {'en': 'Packages', 'local': 'पॅकेजेस'},

      // Delivery Time Strings
      'instant': {'en': 'Instant', 'local': 'तत्काल'},
      'within12Hours': {'en': 'Within 12 Hours', 'local': '12 तासांच्या आत'},
      'within24Hours': {'en': 'Within 24 Hours', 'local': '24 तासांच्या आत'},
    };

    final language = isToggled ? 'local' : 'en';
    return strings[key]?[language] ?? key; // Fallback to key if not found
  }
}
