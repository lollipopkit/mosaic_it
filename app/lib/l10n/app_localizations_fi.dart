// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Ladataan mallia…';

  @override
  String get modelFileType => 'Malli';

  @override
  String get useModel => 'Käytä mallia';

  @override
  String get imagesFileType => 'Kuvat';

  @override
  String get detecting => 'Tunnistetaan…';

  @override
  String detectingProgress(int current, int total) {
    return 'Tunnistetaan $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Valitse ensin malli';

  @override
  String get findingSimilar => 'Etsitään vastaavia…';

  @override
  String similarSelected(int found, int added) {
    return '$found vastaavaa aluetta valittu ($added uutta)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found vastaavaa aluetta valittu ($added uutta) $images kuvasta';
  }

  @override
  String get reviewButton => 'Tarkista';

  @override
  String get openingLabels => 'Avataan merkintöjä…';

  @override
  String noImagesIn(String name) {
    return 'Ei kuvia kohdassa $name';
  }

  @override
  String get saving => 'Tallennetaan…';

  @override
  String get exportHere => 'Vie tähän';

  @override
  String exportStoppedAt(String name) {
    return 'Vienti keskeytettiin kohdassa $name';
  }

  @override
  String exportedTo(String path) {
    return 'Vienti suoritettu kohteeseen $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Vienti suoritettu kohteeseen $path (ei ääntä)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Viedy $count kuvaa',
      many: 'Viedy $count kuvaa',
      few: 'Viedy $count kuvaa',
      two: 'Viedy 2 kuvaa',
      one: 'Viedy 1 kuva',
      zero: 'Viedy 0 kuvaa',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Tarkistetaan $name…';
  }

  @override
  String get checkingAndExporting => 'Tarkistetaan ja vietiin…';

  @override
  String get cancel => 'Peruuta';

  @override
  String get exportAnyway => 'Vie silti';

  @override
  String get reviewPseudoLabels =>
      'Tarkista vääriä merkkejä (kansio, jossa on coco.json)';

  @override
  String get regionsTooltip => 'Alueet';

  @override
  String get notCalibrated =>
      'Mallia ei ole kalibroitu: esivalinta käyttää kiinteää kynnysarvoa.';

  @override
  String calibratedUnverified(String domain) {
    return 'Kalibroitu vahvistamattomalla tiedolla ($domain): takuu ei vielä päde.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Kalibroitu $domain-kuville. Muiden tyyppisten kuvien osalta takuu ei päde.';
  }

  @override
  String get cameraPhoto =>
      'Tämä on kamerakuva; tunnistin on suunniteltu ruutukaappauksiin, joten sen laatikot täällä ovat epäluotettavia.';

  @override
  String get modeDraw => 'Piirrä';

  @override
  String get fillSolid => 'Yksivärinen';

  @override
  String get fillBlocks => 'Harmaa mosaiikki';

  @override
  String get fillNoise => 'Melu';

  @override
  String get verifyNext => 'Vahvista ja seuraava';

  @override
  String get export => 'Vie';

  @override
  String get pickOneModel => 'Valitse täsmälleen yksi .onnx-malli';

  @override
  String pickSidecar(String name) {
    return 'Valitse myös $name.json';
  }

  @override
  String get analysing => 'Analysointi';

  @override
  String get followingRegion => 'Seurataan aluetta';

  @override
  String get exporting => 'Vienti';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count kehystä';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Peitetään se $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Vientitarkistus epäonnistui kellonajassa $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count yksityisyyttä koskevaa aluetta on näkyvissä siellä ($classes).',
      many:
          '$count yksityisyyttä koskevaa aluetta on näkyvissä siellä ($classes).',
      few:
          '$count yksityisyyttä koskevaa aluetta on näkyvissä siellä ($classes).',
      two: '2 yksityisyyttä koskevaa aluetta on näkyvissä siellä ($classes).',
      one: '1 yksityisyyttä koskeva alue on näkyvissä siellä ($classes).',
      zero: '0 yksityisyyttä koskevaa aluetta on näkyvissä siellä ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Näytä kehys';

  @override
  String get drawMissedRegion => 'Piirrä alue, jonka tunnistin ohitti';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on/$total seurantaa peitetty · $keyframes avainkehyttä';
  }

  @override
  String get keepAudio => 'Säilytä ääni';

  @override
  String get keepAudioHint => 'Ääniä ja ilmoitussävyjä ei tarkisteta';

  @override
  String get goToFirstAppearance => 'Siirry ensimmäiseen esiintymiseen';

  @override
  String get classPersonName => 'Nimi';

  @override
  String get classAddress => 'Osoite';

  @override
  String get classPhone => 'Puhelin';

  @override
  String get classEmail => 'Sähköposti';

  @override
  String get classIdNumber => 'Henkilötunnus';

  @override
  String get classBankCard => 'Pankkikortti';

  @override
  String get classPlate => 'Rekisterikilpi';

  @override
  String get classAccountId => 'Tili';

  @override
  String get classAvatar => 'Profiilikuva';

  @override
  String get classFace => 'Kasvot';

  @override
  String get classQr => 'QR-koode';

  @override
  String get classBarcode => 'Viivakoodi';

  @override
  String get classManual => 'Manuaalinen';

  @override
  String noLabelsIn(String name) {
    return 'Ei coco.json-tiedostoa kohdassa $name';
  }

  @override
  String savedModelFailed(String error) {
    return 'Tallennettua mallia ei voitu ladata; valitse malli uudelleen. ($error)';
  }

  @override
  String get fillSurround => 'Taustaväri';

  @override
  String get fillTinted => 'Värimosaiikki';

  @override
  String get settings => 'Asetukset';

  @override
  String get classFinance => 'Summa';

  @override
  String get collectTitle => 'Kerää opetusdataa';

  @override
  String get collectSubtitle =>
      'Tallenna jokainen viety kuva, tunnistetut alueet ja valintasi tälle laitteelle tulevien mallien opettamiseen. Mitään ei ladata palvelimelle.';

  @override
  String collectStats(int count, String size) {
    return '$count kuvaa · $size';
  }

  @override
  String get collectDelete => 'Poista kerätyt tiedot';

  @override
  String get collectDeleteConfirm =>
      'Poistetaanko kaikki kerätyt kuvat ja valinnat tältä laitteelta?';

  @override
  String get delete => 'Poista';

  @override
  String collectFailed(String error) {
    return 'Opetusdataa ei voitu tallentaa: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Merkinnät tallennettu $count kuvalle';
  }

  @override
  String get undo => 'Kumoa';

  @override
  String get redo => 'Tee uudelleen';

  @override
  String get similar => 'Samankaltaiset';

  @override
  String get thisImage => 'Tämä kuva';

  @override
  String allImagesCount(int count) {
    return 'Kaikki $count kuvaa';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aluetta voivat olla luettavissa',
      many: '$count aluetta voivat olla luettavissa',
      few: '$count aluetta voivat olla luettavissa',
      two: '2 aluetta voivat olla luettavissa',
      one: '1 alue voi olla luettavissa',
      zero: '0 aluetta voi olla luettavissa',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Piilottamisen jälkeen tarkistus löysi nämä alueet tulosteesta.';

  @override
  String get redactThemAndExport => 'Piilota ne ja vie';

  @override
  String get showThem => 'Näytä ne';

  @override
  String get pickClass => 'Valitse luokka';

  @override
  String annotateOf(int index, int total) {
    return 'Merkitse $index / $total';
  }

  @override
  String get suggestions => 'Ehdotukset';

  @override
  String get skip => 'Ohita';

  @override
  String get nothingPrivate => 'Ei yksityistä';

  @override
  String get next => 'Seuraava';

  @override
  String get annotateHint =>
      'Kosketa tekstiriviä rajataksesi sen tai vedä piirtääksesi rajan';

  @override
  String get annotationData => 'Merkitsemistiedot';

  @override
  String get statLabeled => 'Merkitty';

  @override
  String get statEmpty => 'Ei yksityistä';

  @override
  String get statSkipped => 'Ohitettu';

  @override
  String get boxesPerClass => 'Rajat luokan mukaan';

  @override
  String get imagesHeader => 'Kuvat';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rajaa',
      many: '$count rajaa',
      few: '$count rajaa',
      two: '2 rajaa',
      one: '1 raja',
      zero: '0 rajaa',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Vie kaikki';

  @override
  String get deleteAll => 'Poista kaikki';

  @override
  String get annotateDeleteConfirm =>
      'Haluatko poistaa kaikki merkinnät ja niiden kuvat tältä laitteelta?';

  @override
  String get noAnnotations =>
      'Ei vielä merkintöjä. Valitse kuvia ja valitse Merkitse.';

  @override
  String get filterScreenshots => 'Kuvakaappaukset';

  @override
  String get filterAll => 'Kaikki';

  @override
  String get filterVideos => 'Videot';

  @override
  String get albums => 'Albumit';

  @override
  String get limitedAccess => 'MosaicIt näkee vain osan valokuvistasi';

  @override
  String get manage => 'Hallinnoi';

  @override
  String selectedImages(int count) {
    return '$count valittu';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Piilota $count kuvaa',
      many: 'Piilota $count kuvaa',
      few: 'Piilota $count kuvaa',
      two: 'Piilota 2 kuvaa',
      one: 'Piilota 1 kuva',
      zero: 'Piilota 0 kuvaa',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Merkitse';

  @override
  String get badgeRedacted => 'Piilotettu';

  @override
  String get badgeAnnotated => 'Merkitty';

  @override
  String get photosDenied =>
      'MosaicIt tarvitsee pääsyn valokuviisi näyttääkseen ne täällä. Valokuvat eivät koskaan poistu tältä laitteelta.';

  @override
  String get openSettings => 'Avaa asetukset';

  @override
  String get openFiles => 'Avaa tiedostoja';

  @override
  String get noPhotos => 'Ei valokuvia täällä';

  @override
  String get loading => 'Ladataan…';

  @override
  String get appearance => 'Ulkoasu';

  @override
  String get theme => 'Teema';

  @override
  String get appIcon => 'Appin kuvake';

  @override
  String get aspectRatioGrid => 'Kuvasuhderuudukko';

  @override
  String get modelDownloadFailed => 'Mallia ei voitu ladata';

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get autoUpdateModel => 'Päivitä malli automaattisesti';

  @override
  String get threshold => 'Kynnys';

  @override
  String get thresholdLow => 'Matala';

  @override
  String get thresholdMedium => 'Keski';

  @override
  String get thresholdHigh => 'Korkea';

  @override
  String get redaction => 'Piilottaminen';

  @override
  String get style => 'Tyyli';

  @override
  String get selectedByDefault => 'Oletuksena valittu';

  @override
  String get dataPrivacy => 'Tiedot ja yksityisyys';

  @override
  String get localOnly =>
      'Säilytetään vain tällä laitteella, ei koskaan iCloudissa tai varmuuskopioissa.';

  @override
  String get model => 'Malli';

  @override
  String get importModel => 'Tuo toinen malli';

  @override
  String get advanced => 'Lisäasetukset';

  @override
  String get about => 'Tietoja';

  @override
  String get licenses => 'Avoimen lähdekoodin lisenssit';

  @override
  String get merge => 'Yhdistä';

  @override
  String get split => 'Erota';

  @override
  String get mergeHint =>
      'Kosketa toista rajaa tehdäksesi siitä osa samaa arvoa';

  @override
  String get classOrganization => 'Organisaatio';

  @override
  String get classDeviceId => 'Laitetunnus';

  @override
  String get classSecret => 'Salaisuus';

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
