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
  String get reviewButton => 'Εξέταση';

  @override
  String get openingLabels => 'Άνοιγμα ετικετών…';

  @override
  String noImagesIn(String name) {
    return 'Δεν υπάρχουν εικόνες στο $name';
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
  String get reviewPseudoLabels =>
      'Επιθεώρηση ψευδοετικετών (φάκελος με coco.json)';

  @override
  String get regionsTooltip => 'Περιοχές';

  @override
  String get notCalibrated =>
      'Το μοντέλο δεν έχει βαθμονομηθεί: η προεπιλογή χρησιμοποιεί σταθερό όριο.';

  @override
  String calibratedUnverified(String domain) {
    return 'Βαθμονομημένο σε μη επαληθευμένα δεδομένα ($domain): η εγγύηση ανακάλυψης δεν ισχύει ακόμα.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Βαθμονομημένο για εικόνες $domain. Άλλα είδη εικόνων βρίσκονται εκτός εγγύησης.';
  }

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
  String get verifyNext => 'Επαλήθευση & επόμενο';

  @override
  String get export => 'Εξαγωγή';

  @override
  String get pickOneModel => 'Επιλέξτε ακριβώς ένα μοντέλο .onnx';

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
  String noLabelsIn(String name) {
    return 'Δεν υπάρχει coco.json στο $name';
  }

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
  String get collectTitle => 'Συλλογή δεδομένων εκπαίδευσης';

  @override
  String get collectSubtitle =>
      'Αποθήκευση σε αυτή τη συσκευή κάθε εξαγόμενης εικόνας, των περιοχών που εντοπίστηκαν και των επιλογών σας για την εκπαίδευση μελλοντικών μοντέλων. Τίποτα δεν μεταφορτώνεται.';

  @override
  String collectStats(int count, String size) {
    return '$count εικόνες · $size';
  }

  @override
  String get collectDelete => 'Διαγραφή συλλεγμένων δεδομένων';

  @override
  String get collectDeleteConfirm =>
      'Διαγραφή όλων των συλλεγμένων εικόνων και επιλογών από αυτή τη συσκευή;';

  @override
  String get delete => 'Διαγραφή';

  @override
  String collectFailed(String error) {
    return 'Δεν ήταν δυνατή η αποθήκευση των δεδομένων εκπαίδευσης: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Αποθηκεύτηκαν ετικέτες για $count εικόνες';
  }

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
  String annotateOf(int index, int total) {
    return 'Σημείωση $index / $total';
  }

  @override
  String get suggestions => 'Προτάσεις';

  @override
  String get skip => 'Παράλειψη';

  @override
  String get nothingPrivate => 'Κανένα ιδιωτικό';

  @override
  String get next => 'Επόμενο';

  @override
  String get annotateHint =>
      'Πατήστε μια γραμμή κειμένου για να το πλαισιώσετε ή σύρετε για να σχεδιάσετε';

  @override
  String get annotationData => 'Δεδομένα σημειώσεων';

  @override
  String get statLabeled => 'Ετικεταρισμένες';

  @override
  String get statEmpty => 'Κανένα ιδιωτικό';

  @override
  String get statSkipped => 'Παρεληφμένες';

  @override
  String get boxesPerClass => 'Πλαίσια ανά κλάση';

  @override
  String get imagesHeader => 'Εικόνες';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count πλαίσια',
      many: 'Περισσότερα από 2 πλαίσια',
      few: 'Περισσότερα από 2 πλαίσια',
      two: '2 πλαίσια',
      one: '1 πλαίσιο',
      zero: '0 πλαίσια',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Εξαγωγή όλων';

  @override
  String get deleteAll => 'Διαγραφή όλων';

  @override
  String get annotateDeleteConfirm =>
      'Να διαγραφούν όλες οι σημειώσεις και οι εικόνες τους από αυτή τη συσκευή;';

  @override
  String get noAnnotations =>
      'Δεν υπάρχουν σημειώσεις ακόμα. Επιλέξτε εικόνες και πατήστε Σημείωση.';

  @override
  String get filterScreenshots => 'Στιγμιότυπα οθόνης';

  @override
  String get filterAll => 'Όλα';

  @override
  String get filterVideos => 'Βίντεο';

  @override
  String get albums => 'Συλλογές';

  @override
  String get limitedAccess =>
      'Το MosaicIt μπορεί να δει μόνο ορισμένες από τις φωτογραφίες σας';

  @override
  String get manage => 'Διαχείριση';

  @override
  String selectedImages(int count) {
    return '$count επιλεγμένες';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Κάλυψη $count εικόνων',
      many: 'Κάλυψη περισσότερων από 2 εικόνων',
      few: 'Κάλυψη περισσότερων από 2 εικόνων',
      two: 'Κάλυψη 2 εικόνων',
      one: 'Κάλυψη 1 εικόνας',
      zero: 'Κάλυψη 0 εικόνων',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Σημείωση';

  @override
  String get badgeRedacted => 'Καλυμμένη';

  @override
  String get badgeAnnotated => 'Σημειωμένη';

  @override
  String get photosDenied =>
      'Το MosaicIt χρειάζεται πρόσβαση στις φωτογραφίες σας για να τις εμφανίσει εδώ. Οι φωτογραφίες δεν αποχωρίζονται ποτέ αυτή τη συσκευή.';

  @override
  String get openSettings => 'Άνοιγμα Ρυθμίσεων';

  @override
  String get openFiles => 'Άνοιγμα αρχείων';

  @override
  String get noPhotos => 'Δεν υπάρχουν φωτογραφίες εδώ';

  @override
  String get loading => 'Φόρτωση…';

  @override
  String get appearance => 'Εμφάνιση';

  @override
  String get theme => 'Θέμα';

  @override
  String get appIcon => 'Εικονίδιο εφαρμογής';

  @override
  String get aspectRatioGrid => 'Πλέγμα με αναλογία διαστάσεων';

  @override
  String get modelDownloadFailed => 'Δεν ήταν δυνατή η λήψη του μοντέλου';

  @override
  String get retry => 'Επανάληψη';

  @override
  String get autoUpdateModel => 'Αυτόματη ενημέρωση μοντέλου';

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
  String get localOnly =>
      'Διατηρείται μόνο σε αυτή τη συσκευή, ποτέ στο iCloud ή σε αντιγράφα ασφαλείας.';

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
  String get saveAndDeleteOriginals => 'Save and delete originals';

  @override
  String get originalsToRecentlyDeleted => 'Originals go to Recently Deleted';

  @override
  String get originalsToTrash => 'Originals go to the trash';

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
  String originalsNotDeleted(String error) {
    return 'The originals were kept: $error';
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
  String get introTitle => 'Choose screenshots to redact';

  @override
  String get introBody =>
      'MosaicIt lists your screenshots here so you can pick the ones to redact. Detection runs on this device, and images never leave it.';

  @override
  String get allowPhotoAccess => 'Allow photo access';

  @override
  String get photosOffTitle => 'Photo access is off';

  @override
  String get openSource => 'Open source';

  @override
  String get downloadingDetector => 'Downloading the detector';

  @override
  String percent(int value) {
    return '$value%';
  }
}
