// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Φόρτωση μοντέλου…';

  @override
  String get modelFileType => 'Μοντέλο';

  @override
  String get useModel => 'Χρήση μοντέλου';

  @override
  String get imagesFileType => 'Εικόνες';

  @override
  String get detecting => 'Ανίχνευση…';

  @override
  String detectingProgress(int current, int total) {
    return 'Ανίχνευση $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Επιλέξτε πρώτα ένα μοντέλο';

  @override
  String get findingSimilar => 'Αναζήτηση παρόμοιων…';

  @override
  String similarSelected(int found, int added) {
    return 'Επιλέχθηκαν $found παρόμοιες περιοχές ($added νέες)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'Επιλέχθηκαν $found παρόμοιες περιοχές ($added νέες) σε $images εικόνες';
  }

  @override
  String get saving => 'Αποθήκευση…';

  @override
  String get exportHere => 'Εξαγωγή εδώ';

  @override
  String exportStoppedAt(String name) {
    return 'Η εξαγωγή διακόπηκε στο $name';
  }

  @override
  String exportedTo(String path) {
    return 'Εξήχθη στο $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Εξήχθη στο $path (χωρίς ήχο)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Εξήχθησαν $count εικόνες',
      many: 'Εξήχθησαν $count εικόνες',
      few: 'Εξήχθησαν $count εικόνες',
      two: 'Εξήχθησαν 2 εικόνες',
      one: 'Εξήχθη 1 εικόνα',
      zero: 'Εξήχθησαν 0 εικόνες',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Έλεγχος $name…';
  }

  @override
  String get checkingAndExporting => 'Έλεγχος και εξαγωγή…';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get exportAnyway => 'Εξαγωγή ούτως ή άλλως';

  @override
  String get regionsTooltip => 'Περιοχές';

  @override
  String get cameraPhoto =>
      'Αυτή είναι φωτογραφία από κάμερα· ο ανιχνευτής είναι σχεδιασμένος για στιγμιότυπα οθόνης, οπότε τα πλαίσια εδώ είναι αναξιόπιστα.';

  @override
  String get modeDraw => 'Σχεδίαση';

  @override
  String get fillSolid => 'Συμπαγές χρώμα';

  @override
  String get fillBlocks => 'Γκρι μωσαϊκό';

  @override
  String get fillNoise => 'Θόρυβος';

  @override
  String get export => 'Εξαγωγή';

  @override
  String pickOneModel(String formats) {
    return 'Επιλέξτε ακριβώς ένα μοντέλο $formats';
  }

  @override
  String pickSidecar(String name) {
    return 'Επιλέξτε επίσης $name.json';
  }

  @override
  String get analysing => 'Ανάλυση';

  @override
  String get followingRegion => 'Παρακολούθηση της περιοχής';

  @override
  String get exporting => 'Εξαγωγή';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count καρέ';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Κρύψιμο $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Αποτυχία ελέγχου εξαγωγής στις $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ιδιωτικές περιοχές είναι ακόμα ορατές εκεί ($classes).',
      many: '$count ιδιωτικές περιοχές είναι ακόμα ορατές εκεί ($classes).',
      few: '$count ιδιωτικές περιοχές είναι ακόμα ορατές εκεί ($classes).',
      two: '2 ιδιωτικές περιοχές είναι ακόμα ορατές εκεί ($classes).',
      one: '1 ιδιωτική περιοχή είναι ακόμα ορατή εκεί ($classes).',
      zero: 'Καμία ιδιωτική περιοχή δεν είναι ορατή εκεί ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Εμφάνιση καρέ';

  @override
  String get drawMissedRegion =>
      'Σχεδιάστε μια περιοχή που παραλείφθηκε από τον ανιχνευτή';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on από $total παρακολουθήσεις κρυφτές · $keyframes βασικά καρέ';
  }

  @override
  String get keepAudio => 'Διατήρηση ήχου';

  @override
  String get keepAudioHint =>
      'Οι φωνές και οι ήχοι ειδοποιήσεων δεν ελέγχονται';

  @override
  String get goToFirstAppearance => 'Μετάβαση στην πρώτη εμφάνιση';

  @override
  String get classPersonName => 'Όνομα';

  @override
  String get classAddress => 'Διεύθυνση';

  @override
  String get classPhone => 'Τηλέφωνο';

  @override
  String get classEmail => 'Email';

  @override
  String get classIdNumber => 'Αριθμός ταυτότητας';

  @override
  String get classBankCard => 'Τραπεζική κάρτα';

  @override
  String get classPlate => 'Πίνακας';

  @override
  String get classAccountId => 'Λογαριασμός';

  @override
  String get classAvatar => 'Άβαταρ';

  @override
  String get classFace => 'Πρόσωπο';

  @override
  String get classQr => 'Κώδικας QR';

  @override
  String get classBarcode => 'Κωδικός γραμμής';

  @override
  String get classManual => 'Χειροκίνητο';

  @override
  String savedModelFailed(String error) {
    return 'Δεν ήταν δυνατή η φόρτωση του αποθηκευμένου μοντέλου. Επιλέξτε ξανά ένα μοντέλο. ($error)';
  }

  @override
  String get fillSurround => 'Χρώμα φόντου';

  @override
  String get fillTinted => 'Έγχρωμο μωσαϊκό';

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get classFinance => 'Ποσό';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get undo => 'Αναίρεση';

  @override
  String get redo => 'Επανάληψη';

  @override
  String get similar => 'Ομοιόμορφα';

  @override
  String get thisImage => 'Αυτή η εικόνα';

  @override
  String allImagesCount(int count) {
    return 'Όλες οι $count εικόνες';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count πεδία μπορεί να είναι ακόμα αναγνώσιμα',
      many: 'Περισσότερα από 2 πεδία μπορεί να είναι ακόμα αναγνώσιμα',
      few: 'Περισσότερα από 2 πεδία μπορεί να είναι ακόμα αναγνώσιμα',
      two: '2 πεδία μπορεί να είναι ακόμα αναγνώσιμα',
      one: '1 πεδίο μπορεί να είναι ακόμα αναγνώσιμο',
      zero: 'Κανένα πεδίο δεν φαίνεται να είναι αναγνώσιμο',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Μετά την κάλυψη, ο έλεγχος εντόπισε ξανά αυτά τα πεδία στην έξοδο.';

  @override
  String get redactThemAndExport => 'Κάλυψέ τα και εξαγωγή';

  @override
  String get showThem => 'Εμφάνισέ τα';

  @override
  String get pickClass => 'Επιλογή κλάσης';

  @override
  String get appearance => 'Εμφάνιση';

  @override
  String get theme => 'Θέμα';

  @override
  String get appIcon => 'Εικονίδιο εφαρμογής';

  @override
  String get threshold => 'Κατώφλι';

  @override
  String get thresholdLow => 'Χαμηλό';

  @override
  String get thresholdMedium => 'Μεσαίο';

  @override
  String get thresholdHigh => 'Υψηλό';

  @override
  String get redaction => 'Κάλυψη';

  @override
  String get style => 'Στυλ';

  @override
  String get selectedByDefault => 'Επιλεγμένα από προεπιλογή';

  @override
  String get dataPrivacy => 'Δεδομένα και απορρήτων';

  @override
  String get model => 'Μοντέλο';

  @override
  String get importModel => 'Εισαγωγή άλλου μοντέλου';

  @override
  String get advanced => 'Προχωρημένο';

  @override
  String get about => 'Σχετικά';

  @override
  String get licenses => 'Άδειες ανοιχτού κώδικα';

  @override
  String get merge => 'Συγχώνευση';

  @override
  String get split => 'Διαχωρισμός';

  @override
  String get mergeHint =>
      'Πατήστε ένα άλλο πλαίσιο για να γίνει μέρος της ίδιας τιμής';

  @override
  String get classOrganization => 'Οργανισμός';

  @override
  String get classDeviceId => 'Αναγνωριστικό συσκευής';

  @override
  String get classSecret => 'Μυστικό';

  @override
  String get classPerson => 'Πρόσωπο';

  @override
  String get classHealth => 'Υγεία';

  @override
  String get classPersonalInfo => 'Προσωπικά στοιχεία';

  @override
  String selectedOf(int selected, int total) {
    return '$selected / $total selected';
  }

  @override
  String get fillStyle => 'Fill style';

  @override
  String get colour => 'Colour';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images images',
      one: '1 image',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions regions',
      one: '1 region',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Share';

  @override
  String get saveToPhotos => 'Save to Photos';

  @override
  String get saveAs => 'Save…';

  @override
  String get exportFormat => 'Format';

  @override
  String get exportSize => 'Size';

  @override
  String get sizeOriginal => 'Original';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saved $count images to Photos',
      one: 'Saved 1 image to Photos',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'All';

  @override
  String get selectNone => 'None';

  @override
  String get suggested => 'suggested';

  @override
  String scoreValue(String score) {
    return 'Score $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'After redaction, the check still found these areas in the output of image $index.';
  }

  @override
  String get reasonNotSelected => 'not selected';

  @override
  String get reasonBoxTooSmall => 'box too small';

  @override
  String get reasonFillShowsThrough => 'fill shows through';

  @override
  String get openSource => 'Open source';

  @override
  String get adaptivePreselectTitle => 'Local adaptive pre-selection';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes adjusted',
      one: '1 class adjusted',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Reset local preferences';

  @override
  String get adaptiveResetDone => 'Local preferences reset';

  @override
  String get feedbackTitle => 'Report detection issue';

  @override
  String get feedbackShort => 'Feedback';

  @override
  String get feedbackMenu => 'Report issue';

  @override
  String get feedbackAction => 'Report';

  @override
  String get feedbackAttachScreenshot => 'Attach screenshot';

  @override
  String get feedbackModeMasked => 'Errors only';

  @override
  String get feedbackModeFull => 'Full image';

  @override
  String get feedbackModeText => 'No image';

  @override
  String get feedbackTagMissed => 'Missed';

  @override
  String get feedbackTagFalsePositive => 'False positive';

  @override
  String get feedbackTagBoxDrift => 'Box drift';

  @override
  String get feedbackTagWrongClass => 'Wrong class';

  @override
  String get feedbackTagOther => 'Other';

  @override
  String get feedbackNoteHint => 'Optional note…';

  @override
  String feedbackCountMasked(int count) {
    return 'Masked $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Missed $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'False positive $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Unchecked $count';
  }

  @override
  String get feedbackBoxMissed => 'Missed';

  @override
  String get feedbackBoxMissedMasked => 'Missed · masked';

  @override
  String get feedbackBoxFp => 'False positive';

  @override
  String get feedbackBoxPreference => 'Keep visible';

  @override
  String get introOfflineTitle => 'No network access';

  @override
  String get introOfflineBody =>
      'MosaicIt contains no networking code and requests no network permission. The detector is bundled inside the app, and images and videos never leave your device.';

  @override
  String get introNoNetPermTitle => 'Zero network permissions';

  @override
  String get introBundledModelTitle => 'Bundled on-device model';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · on-device';
  }

  @override
  String get resetBundledModel => 'Use bundled model';

  @override
  String get reviewIntro => 'Show intro again';

  @override
  String get feedbackOpenWeb => 'Open web form';

  @override
  String get introNoNetPermBodyIos => 'No network requests · on-device only';

  @override
  String get introNoNetPermBodyAndroid => 'No INTERNET permission declared';

  @override
  String get introNoNetPermBodyDesktop => 'No network entitlement in sandbox';

  @override
  String get customModel => 'Custom model';

  @override
  String modelClassCount(int count) {
    return '$count classes';
  }

  @override
  String get copyImage => 'Copy image';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get copyFailed => 'Could not copy image';

  @override
  String get peekOriginal => 'Hold to compare original';

  @override
  String get selectMedia => 'Select photos or video';

  @override
  String get saveFailed => 'Could not save to Photos';

  @override
  String get retry => 'Retry';

  @override
  String get iosWirelessPromptTitle => 'Wireless data prompt';

  @override
  String get iosWirelessPromptBody =>
      'Opening the system photo picker may trigger an iOS wireless data prompt for iCloud thumbnails. MosaicIt does not use the network — tap “Don’t Allow”.';

  @override
  String get continueAction => 'Continue';
}
