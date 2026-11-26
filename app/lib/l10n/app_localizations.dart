import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('hy'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ka'),
    Locale('ko'),
    Locale('ms'),
    Locale('nb'),
    Locale('ne'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'PT'),
    Locale('ro'),
    Locale('ru'),
    Locale('sv'),
    Locale('ta'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MosaicIt'**
  String get appTitle;

  /// No description provided for @loadingModel.
  ///
  /// In en, this message translates to:
  /// **'Loading model…'**
  String get loadingModel;

  /// File picker group label for model files
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get modelFileType;

  /// No description provided for @useModel.
  ///
  /// In en, this message translates to:
  /// **'Use model'**
  String get useModel;

  /// File picker group label for images
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get imagesFileType;

  /// No description provided for @detecting.
  ///
  /// In en, this message translates to:
  /// **'Detecting…'**
  String get detecting;

  /// No description provided for @detectingProgress.
  ///
  /// In en, this message translates to:
  /// **'Detecting {current}/{total}…'**
  String detectingProgress(int current, int total);

  /// No description provided for @chooseModelFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a model first'**
  String get chooseModelFirst;

  /// No description provided for @findingSimilar.
  ///
  /// In en, this message translates to:
  /// **'Finding similar…'**
  String get findingSimilar;

  /// No description provided for @similarSelected.
  ///
  /// In en, this message translates to:
  /// **'{found} similar regions selected ({added} new)'**
  String similarSelected(int found, int added);

  /// No description provided for @similarSelectedAcross.
  ///
  /// In en, this message translates to:
  /// **'{found} similar regions selected ({added} new) across {images} images'**
  String similarSelectedAcross(int found, int added, int images);

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @exportHere.
  ///
  /// In en, this message translates to:
  /// **'Export here'**
  String get exportHere;

  /// No description provided for @exportStoppedAt.
  ///
  /// In en, this message translates to:
  /// **'Export stopped at {name}'**
  String exportStoppedAt(String name);

  /// No description provided for @exportedTo.
  ///
  /// In en, this message translates to:
  /// **'Exported to {path}'**
  String exportedTo(String path);

  /// No description provided for @exportedToNoAudio.
  ///
  /// In en, this message translates to:
  /// **'Exported to {path} (no audio)'**
  String exportedToNoAudio(String path);

  /// No description provided for @exportedImages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Exported 1 image} other{Exported {count} images}}'**
  String exportedImages(int count);

  /// No description provided for @checkingImage.
  ///
  /// In en, this message translates to:
  /// **'Checking {name}…'**
  String checkingImage(String name);

  /// No description provided for @checkingAndExporting.
  ///
  /// In en, this message translates to:
  /// **'Checking and exporting…'**
  String get checkingAndExporting;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @exportAnyway.
  ///
  /// In en, this message translates to:
  /// **'Export anyway'**
  String get exportAnyway;

  /// No description provided for @regionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get regionsTooltip;

  /// No description provided for @notCalibrated.
  ///
  /// In en, this message translates to:
  /// **'Model is not calibrated: pre-selection uses a fixed threshold.'**
  String get notCalibrated;

  /// No description provided for @calibratedUnverified.
  ///
  /// In en, this message translates to:
  /// **'Calibrated on unverified data ({domain}): the recall guarantee does not apply yet.'**
  String calibratedUnverified(String domain);

  /// No description provided for @calibratedFor.
  ///
  /// In en, this message translates to:
  /// **'Calibrated for {domain} images. Other kinds of images are outside the guarantee.'**
  String calibratedFor(String domain);

  /// No description provided for @cameraPhoto.
  ///
  /// In en, this message translates to:
  /// **'This is a camera photo; the detector is made for screenshots, so its boxes here are unreliable.'**
  String get cameraPhoto;

  /// No description provided for @modeDraw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get modeDraw;

  /// No description provided for @fillSolid.
  ///
  /// In en, this message translates to:
  /// **'Solid colour'**
  String get fillSolid;

  /// No description provided for @fillBlocks.
  ///
  /// In en, this message translates to:
  /// **'Grey mosaic'**
  String get fillBlocks;

  /// No description provided for @fillNoise.
  ///
  /// In en, this message translates to:
  /// **'Noise'**
  String get fillNoise;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @pickOneModel.
  ///
  /// In en, this message translates to:
  /// **'Pick exactly one {formats} model'**
  String pickOneModel(String formats);

  /// No description provided for @pickSidecar.
  ///
  /// In en, this message translates to:
  /// **'Also pick {name}.json'**
  String pickSidecar(String name);

  /// No description provided for @analysing.
  ///
  /// In en, this message translates to:
  /// **'Analysing'**
  String get analysing;

  /// No description provided for @followingRegion.
  ///
  /// In en, this message translates to:
  /// **'Following the region'**
  String get followingRegion;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting'**
  String get exporting;

  /// No description provided for @busyFrames.
  ///
  /// In en, this message translates to:
  /// **'{label}… {count} frames'**
  String busyFrames(String label, int count);

  /// No description provided for @redactingSpan.
  ///
  /// In en, this message translates to:
  /// **'Redacting it {start} – {end}'**
  String redactingSpan(String start, String end);

  /// No description provided for @exportCheckFailedAt.
  ///
  /// In en, this message translates to:
  /// **'Export check failed at {time}'**
  String exportCheckFailedAt(String time);

  /// No description provided for @videoRegionsVisible.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 private-looking region is still visible there ({classes}).} other{{count} private-looking regions are still visible there ({classes}).}}'**
  String videoRegionsVisible(int count, String classes);

  /// No description provided for @showFrame.
  ///
  /// In en, this message translates to:
  /// **'Show frame'**
  String get showFrame;

  /// No description provided for @drawMissedRegion.
  ///
  /// In en, this message translates to:
  /// **'Draw a region the detector missed'**
  String get drawMissedRegion;

  /// No description provided for @tracksSummary.
  ///
  /// In en, this message translates to:
  /// **'{on} of {total} tracks redacted · {keyframes} keyframes'**
  String tracksSummary(int on, int total, int keyframes);

  /// No description provided for @keepAudio.
  ///
  /// In en, this message translates to:
  /// **'Keep audio'**
  String get keepAudio;

  /// No description provided for @keepAudioHint.
  ///
  /// In en, this message translates to:
  /// **'Voices and notification sounds are not checked'**
  String get keepAudioHint;

  /// No description provided for @goToFirstAppearance.
  ///
  /// In en, this message translates to:
  /// **'Go to first appearance'**
  String get goToFirstAppearance;

  /// Label of the person_name region class
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get classPersonName;

  /// Label of the address region class
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get classAddress;

  /// Label of the phone region class
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get classPhone;

  /// Label of the email region class
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get classEmail;

  /// Label of the id_number region class
  ///
  /// In en, this message translates to:
  /// **'ID number'**
  String get classIdNumber;

  /// Label of the bank_card region class
  ///
  /// In en, this message translates to:
  /// **'Bank card'**
  String get classBankCard;

  /// Label of the plate region class
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get classPlate;

  /// Label of the account_id region class
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get classAccountId;

  /// Label of the avatar region class
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get classAvatar;

  /// Label of the face region class (faces in photos, from the built-in face detector)
  ///
  /// In en, this message translates to:
  /// **'Face'**
  String get classFace;

  /// Label of the qr region class
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get classQr;

  /// Label of the barcode region class
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get classBarcode;

  /// Label of the manual region class
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get classManual;

  /// No description provided for @savedModelFailed.
  ///
  /// In en, this message translates to:
  /// **'The saved model could not be loaded; choose a model again. ({error})'**
  String savedModelFailed(String error);

  /// No description provided for @fillSurround.
  ///
  /// In en, this message translates to:
  /// **'Background colour'**
  String get fillSurround;

  /// No description provided for @fillTinted.
  ///
  /// In en, this message translates to:
  /// **'Colour mosaic'**
  String get fillTinted;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label of the finance region class: money amounts tied to the person (balance, transfer, income, payment, bill)
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get classFinance;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Toolbar button: undo the last change to the boxes.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Toolbar button: redo the change just undone.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// Short button: find areas that look like the chosen box, in this image and the others opened with it.
  ///
  /// In en, this message translates to:
  /// **'Similar'**
  String get similar;

  /// Segment in the regions panel: show only the image on screen.
  ///
  /// In en, this message translates to:
  /// **'This image'**
  String get thisImage;

  /// Segment in the regions panel: show every opened image.
  ///
  /// In en, this message translates to:
  /// **'All {count} images'**
  String allImagesCount(int count);

  /// Title of a sheet after export: the safety check still found this many areas that can be read in the redacted output.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 area may still be readable} other{{count} areas may still be readable}}'**
  String exportCheckTitle(int count);

  /// Explains the sheet: after hiding the chosen areas, the automatic check looked at the output and found these areas again.
  ///
  /// In en, this message translates to:
  /// **'After redaction, the check still found these areas in the output.'**
  String get exportCheckBody;

  /// Main button: hide those areas too, then export.
  ///
  /// In en, this message translates to:
  /// **'Redact them and export'**
  String get redactThemAndExport;

  /// Button: close the sheet and show those areas in the image so the user can decide.
  ///
  /// In en, this message translates to:
  /// **'Show them'**
  String get showThem;

  /// Title of a list: choose what kind of private information this box holds.
  ///
  /// In en, this message translates to:
  /// **'Choose a class'**
  String get pickClass;

  /// Gallery filter chip: the Screenshots album.
  ///
  /// In en, this message translates to:
  /// **'Screenshots'**
  String get filterScreenshots;

  /// Gallery filter chip: all photos.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Gallery filter chip: videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get filterVideos;

  /// Gallery filter chip that opens a list of albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// Banner: the user allowed access to only some photos (iOS limited photo access).
  ///
  /// In en, this message translates to:
  /// **'MosaicIt can see only some of your photos'**
  String get limitedAccess;

  /// Button on that banner: choose which photos the app may see.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// Title bar while selecting photos in the gallery: how many are selected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedImages(int count);

  /// Main button after selecting photos: hide private information in them (redact).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Redact 1 image} other{Redact {count} images}}'**
  String redactImages(int count);

  /// Small tag on a gallery thumbnail: this photo was already redacted and exported.
  ///
  /// In en, this message translates to:
  /// **'Redacted'**
  String get badgeRedacted;

  /// Shown when the app has no photo access: why it needs it, and that photos never leave the phone.
  ///
  /// In en, this message translates to:
  /// **'MosaicIt needs access to your photos to show them here. Photos never leave this device.'**
  String get photosDenied;

  /// Button: open the system Settings app to grant photo access.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Menu item on desktop: open image files from disk.
  ///
  /// In en, this message translates to:
  /// **'Open files'**
  String get openFiles;

  /// Empty gallery: no photos in this album.
  ///
  /// In en, this message translates to:
  /// **'No photos here'**
  String get noPhotos;

  /// Progress text while photos load.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// Settings section header: look of the app.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Settings row and page title: app theme (colours, light/dark).
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Settings row: choose the app's home screen icon.
  ///
  /// In en, this message translates to:
  /// **'App icon'**
  String get appIcon;

  /// Gallery menu, checkable: show each photo whole in its grid cell instead of cropped to a square.
  ///
  /// In en, this message translates to:
  /// **'Aspect ratio grid'**
  String get aspectRatioGrid;

  /// Gallery notice: the detector model, downloaded on first launch, could not be fetched (offline or server error).
  ///
  /// In en, this message translates to:
  /// **'The model could not be downloaded'**
  String get modelDownloadFailed;

  /// Button: try the failed download again.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Settings switch: download newer detector models when they are published.
  ///
  /// In en, this message translates to:
  /// **'Update the model automatically'**
  String get autoUpdateModel;

  /// Settings row: how confident the detector must be to pre-select a region (a lower threshold pre-selects more regions).
  ///
  /// In en, this message translates to:
  /// **'Threshold'**
  String get threshold;

  /// Threshold preset: low (pre-selects more regions).
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get thresholdLow;

  /// Threshold preset: medium (the model's own thresholds).
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get thresholdMedium;

  /// Threshold preset: high (pre-selects fewer regions).
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get thresholdHigh;

  /// Settings section header: how private areas are hidden.
  ///
  /// In en, this message translates to:
  /// **'Redaction'**
  String get redaction;

  /// Settings row: the redaction style (solid colour, mosaic, ...).
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// Settings row under Redaction: which region classes are pre-selected for redaction after detection; the others are shown as unselected suggestions.
  ///
  /// In en, this message translates to:
  /// **'Selected by default'**
  String get selectedByDefault;

  /// Settings section header: data and privacy.
  ///
  /// In en, this message translates to:
  /// **'Data and privacy'**
  String get dataPrivacy;

  /// Settings section header: the detection model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// Settings row: import a different detection model file.
  ///
  /// In en, this message translates to:
  /// **'Import another model'**
  String get importModel;

  /// Subtitle marking the row as an advanced option.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// Settings section header: about the app.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Settings row: open-source licences of the libraries used.
  ///
  /// In en, this message translates to:
  /// **'Open-source licences'**
  String get licenses;

  /// Box menu item: join this box with another box as one value printed over several lines (e.g. an address broken over two lines).
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get merge;

  /// Box menu item: undo a merge; each line becomes a value of its own again.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get split;

  /// Banner while merging: tap another box to make it part of the same value as the selected one.
  ///
  /// In en, this message translates to:
  /// **'Tap another box to make it part of the same value'**
  String get mergeHint;

  /// Class of private information: the name of a group chat, shop, company or other organization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get classOrganization;

  /// Class of private information: a device or network identifier (IP or MAC address, IMEI, serial number, advertising ID).
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get classDeviceId;

  /// Class of private information: a credential shown in clear text (password, API key or token, private key, recovery phrase, one-time code).
  ///
  /// In en, this message translates to:
  /// **'Secret'**
  String get classSecret;

  /// Class of private information: a picture of a real person or part of one (body, selfie, video call).
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get classPerson;

  /// Class of private information: health data (sleep, heart rate, weight, diagnosis, medication).
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get classHealth;

  /// Class of private information: other details tied to a person (gender, age, birthday, relatives, job, dates of personal events).
  ///
  /// In en, this message translates to:
  /// **'Personal info'**
  String get classPersonalInfo;

  /// Editor top bar: selected regions of the shown image
  ///
  /// In en, this message translates to:
  /// **'{selected} / {total} selected'**
  String selectedOf(int selected, int total);

  /// No description provided for @fillStyle.
  ///
  /// In en, this message translates to:
  /// **'Fill style'**
  String get fillStyle;

  /// No description provided for @colour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get colour;

  /// No description provided for @exportSummary.
  ///
  /// In en, this message translates to:
  /// **'{images, plural, =1{1 image} other{{images} images}} · {regions, plural, =1{1 region} other{{regions} regions}}'**
  String exportSummary(num images, num regions);

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @saveToPhotos.
  ///
  /// In en, this message translates to:
  /// **'Save to Photos'**
  String get saveToPhotos;

  /// No description provided for @saveAs.
  ///
  /// In en, this message translates to:
  /// **'Save…'**
  String get saveAs;

  /// No description provided for @saveAndDeleteOriginals.
  ///
  /// In en, this message translates to:
  /// **'Save and delete originals'**
  String get saveAndDeleteOriginals;

  /// iOS
  ///
  /// In en, this message translates to:
  /// **'Originals go to Recently Deleted'**
  String get originalsToRecentlyDeleted;

  /// Android
  ///
  /// In en, this message translates to:
  /// **'Originals go to the trash'**
  String get originalsToTrash;

  /// No description provided for @exportFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get exportFormat;

  /// No description provided for @exportSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get exportSize;

  /// No description provided for @sizeOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get sizeOriginal;

  /// Longest side of an exported image
  ///
  /// In en, this message translates to:
  /// **'{px} px'**
  String sizePixels(int px);

  /// No description provided for @savedToPhotos.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Saved 1 image to Photos} other{Saved {count} images to Photos}}'**
  String savedToPhotos(num count);

  /// No description provided for @originalsNotDeleted.
  ///
  /// In en, this message translates to:
  /// **'The originals were kept: {error}'**
  String originalsNotDeleted(String error);

  /// Select every region
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get selectAll;

  /// Select no region
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get selectNone;

  /// A region the model found but did not select
  ///
  /// In en, this message translates to:
  /// **'suggested'**
  String get suggested;

  /// No description provided for @scoreValue.
  ///
  /// In en, this message translates to:
  /// **'Score {score}'**
  String scoreValue(String score);

  /// No description provided for @exportCheckBodyOf.
  ///
  /// In en, this message translates to:
  /// **'After redaction, the check still found these areas in the output of image {index}.'**
  String exportCheckBodyOf(int index);

  /// No description provided for @reasonNotSelected.
  ///
  /// In en, this message translates to:
  /// **'not selected'**
  String get reasonNotSelected;

  /// No description provided for @reasonBoxTooSmall.
  ///
  /// In en, this message translates to:
  /// **'box too small'**
  String get reasonBoxTooSmall;

  /// No description provided for @reasonFillShowsThrough.
  ///
  /// In en, this message translates to:
  /// **'fill shows through'**
  String get reasonFillShowsThrough;

  /// No description provided for @introTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose screenshots to redact'**
  String get introTitle;

  /// No description provided for @introBody.
  ///
  /// In en, this message translates to:
  /// **'MosaicIt lists your screenshots here so you can pick the ones to redact. Detection runs on this device, and images never leave it.'**
  String get introBody;

  /// No description provided for @allowPhotoAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow photo access'**
  String get allowPhotoAccess;

  /// No description provided for @photosOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo access is off'**
  String get photosOffTitle;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open source'**
  String get openSource;

  /// No description provided for @downloadingDetector.
  ///
  /// In en, this message translates to:
  /// **'Downloading the detector'**
  String get downloadingDetector;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percent(int value);

  /// Settings toggle: adjust per-class pre-selection thresholds locally on this device from user edits.
  ///
  /// In en, this message translates to:
  /// **'Local adaptive pre-selection'**
  String get adaptivePreselectTitle;

  /// No description provided for @adaptiveLearnedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 class adjusted} other{{count} classes adjusted}}'**
  String adaptiveLearnedCount(int count);

  /// No description provided for @adaptiveReset.
  ///
  /// In en, this message translates to:
  /// **'Reset local preferences'**
  String get adaptiveReset;

  /// No description provided for @adaptiveResetDone.
  ///
  /// In en, this message translates to:
  /// **'Local preferences reset'**
  String get adaptiveResetDone;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Report detection issue'**
  String get feedbackTitle;

  /// No description provided for @feedbackShort.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackShort;

  /// No description provided for @feedbackMenu.
  ///
  /// In en, this message translates to:
  /// **'Report issue'**
  String get feedbackMenu;

  /// No description provided for @feedbackAction.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get feedbackAction;

  /// No description provided for @feedbackSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get feedbackSubmit;

  /// No description provided for @feedbackDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get feedbackDone;

  /// No description provided for @feedbackSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback sent'**
  String get feedbackSentTitle;

  /// No description provided for @feedbackAttachScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Attach screenshot'**
  String get feedbackAttachScreenshot;

  /// No description provided for @feedbackModeMasked.
  ///
  /// In en, this message translates to:
  /// **'Errors only'**
  String get feedbackModeMasked;

  /// No description provided for @feedbackModeFull.
  ///
  /// In en, this message translates to:
  /// **'Full image'**
  String get feedbackModeFull;

  /// No description provided for @feedbackModeText.
  ///
  /// In en, this message translates to:
  /// **'No image'**
  String get feedbackModeText;

  /// No description provided for @feedbackTagMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get feedbackTagMissed;

  /// No description provided for @feedbackTagFalsePositive.
  ///
  /// In en, this message translates to:
  /// **'False positive'**
  String get feedbackTagFalsePositive;

  /// No description provided for @feedbackTagBoxDrift.
  ///
  /// In en, this message translates to:
  /// **'Box drift'**
  String get feedbackTagBoxDrift;

  /// No description provided for @feedbackTagWrongClass.
  ///
  /// In en, this message translates to:
  /// **'Wrong class'**
  String get feedbackTagWrongClass;

  /// No description provided for @feedbackTagOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get feedbackTagOther;

  /// No description provided for @feedbackNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Optional note…'**
  String get feedbackNoteHint;

  /// No description provided for @feedbackCountMasked.
  ///
  /// In en, this message translates to:
  /// **'Masked {count}'**
  String feedbackCountMasked(int count);

  /// No description provided for @feedbackCountMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed {count}'**
  String feedbackCountMissed(int count);

  /// No description provided for @feedbackCountFp.
  ///
  /// In en, this message translates to:
  /// **'False positive {count}'**
  String feedbackCountFp(int count);

  /// No description provided for @feedbackCountPreference.
  ///
  /// In en, this message translates to:
  /// **'Unchecked {count}'**
  String feedbackCountPreference(int count);

  /// No description provided for @feedbackBoxMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get feedbackBoxMissed;

  /// No description provided for @feedbackBoxMissedMasked.
  ///
  /// In en, this message translates to:
  /// **'Missed · masked'**
  String get feedbackBoxMissedMasked;

  /// No description provided for @feedbackBoxFp.
  ///
  /// In en, this message translates to:
  /// **'False positive'**
  String get feedbackBoxFp;

  /// No description provided for @feedbackBoxPreference.
  ///
  /// In en, this message translates to:
  /// **'Keep visible'**
  String get feedbackBoxPreference;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fa',
    'fi',
    'fr',
    'he',
    'hi',
    'hr',
    'hu',
    'hy',
    'id',
    'it',
    'ja',
    'ka',
    'ko',
    'ms',
    'nb',
    'ne',
    'nl',
    'pl',
    'pt',
    'ro',
    'ru',
    'sv',
    'ta',
    'th',
    'tr',
    'uk',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'PT':
            return AppLocalizationsPtPt();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'hy':
      return AppLocalizationsHy();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ka':
      return AppLocalizationsKa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'nb':
      return AppLocalizationsNb();
    case 'ne':
      return AppLocalizationsNe();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'ta':
      return AppLocalizationsTa();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
