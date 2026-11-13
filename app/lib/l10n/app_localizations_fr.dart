// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Chargement du modèle…';

  @override
  String get modelFileType => 'Modèle';

  @override
  String get useModel => 'Utiliser le modèle';

  @override
  String get imagesFileType => 'Images';

  @override
  String get detecting => 'Détection…';

  @override
  String detectingProgress(int current, int total) {
    return 'Détection $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Choisissez d\'abord un modèle';

  @override
  String get findingSimilar => 'Recherche de similaires…';

  @override
  String similarSelected(int found, int added) {
    return '$found régions similaires sélectionnées ($added nouvelles)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found régions similaires sélectionnées ($added nouvelles) sur $images images';
  }

  @override
  String get reviewButton => 'Vérifier';

  @override
  String get openingLabels => 'Ouverture des étiquettes…';

  @override
  String noImagesIn(String name) {
    return 'Aucune image dans $name';
  }

  @override
  String get saving => 'Enregistrement…';

  @override
  String get exportHere => 'Exporter ici';

  @override
  String exportStoppedAt(String name) {
    return 'Export interrompu à $name';
  }

  @override
  String exportedTo(String path) {
    return 'Exporté vers $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Exporté vers $path (sans audio)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images exportées',
      one: '1 image exportée',
      zero: 'Aucune image exportée',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Vérification de $name…';
  }

  @override
  String get checkingAndExporting => 'Vérification et exportation…';

  @override
  String get cancel => 'Annuler';

  @override
  String get exportAnyway => 'Exporter quand même';

  @override
  String get reviewPseudoLabels =>
      'Examiner les pseudo-étiquettes (dossier avec coco.json)';

  @override
  String get regionsTooltip => 'Régions';

  @override
  String get notCalibrated =>
      'Le modèle n\'est pas calibré : la présélection utilise un seuil fixe.';

  @override
  String calibratedUnverified(String domain) {
    return 'Calibré sur des données non vérifiées ($domain) : la garantie de rappel ne s\'applique pas encore.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Calibré pour les images $domain. Les autres types d\'images sont hors garantie.';
  }

  @override
  String get cameraPhoto =>
      'Ceci est une photo d\'appareil photo ; le détecteur est conçu pour les captures d\'écran, ses cadres sont donc peu fiables ici.';

  @override
  String get modeDraw => 'Dessiner';

  @override
  String get fillSolid => 'Couleur unie';

  @override
  String get fillBlocks => 'Mosaïque grise';

  @override
  String get fillNoise => 'Bruit';

  @override
  String get verifyNext => 'Vérifier et suivant';

  @override
  String get export => 'Exporter';

  @override
  String get pickOneModel => 'Choisissez exactement un modèle .onnx';

  @override
  String pickSidecar(String name) {
    return 'Choisissez aussi $name.json';
  }

  @override
  String get analysing => 'Analyse';

  @override
  String get followingRegion => 'Suivi de la région';

  @override
  String get exporting => 'Exportation';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count images';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Masquage de $start à $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Échec de la vérification de l\'export à $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count régions à aspect privé sont toujours visibles là-bas ($classes).',
      one: '1 région à aspect privé est toujours visible là-bas ($classes).',
      zero: 'Aucune région à aspect privé n\'est visible là-bas ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Afficher l\'image';

  @override
  String get drawMissedRegion => 'Dessinez une région manquée par le détecteur';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on suivis sur $total masqués · $keyframes images clés';
  }

  @override
  String get keepAudio => 'Conserver l\'audio';

  @override
  String get keepAudioHint =>
      'Les voix et les sons de notification ne sont pas vérifiés';

  @override
  String get goToFirstAppearance => 'Aller à la première apparition';

  @override
  String get classPersonName => 'Nom';

  @override
  String get classAddress => 'Adresse';

  @override
  String get classPhone => 'Téléphone';

  @override
  String get classEmail => 'E-mail';

  @override
  String get classIdNumber => 'Numéro d\'identité';

  @override
  String get classBankCard => 'Carte bancaire';

  @override
  String get classPlate => 'Plaque';

  @override
  String get classAccountId => 'Compte';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Visage';

  @override
  String get classQr => 'Code QR';

  @override
  String get classBarcode => 'Code-barres';

  @override
  String get classManual => 'Manuel';

  @override
  String noLabelsIn(String name) {
    return 'Aucun coco.json dans $name';
  }

  @override
  String savedModelFailed(String error) {
    return 'Le modèle enregistré n\'a pas pu être chargé ; choisissez à nouveau un modèle. ($error)';
  }

  @override
  String get fillSurround => 'Couleur de fond';

  @override
  String get fillTinted => 'Mosaïque colorée';

  @override
  String get settings => 'Réglages';

  @override
  String get classFinance => 'Montant';

  @override
  String get collectTitle => 'Collecter des données d\'entraînement';

  @override
  String get collectSubtitle =>
      'Conserver sur cet appareil chaque image exportée, les zones détectées et vos choix pour entraîner de futurs modèles. Rien n\'est envoyé.';

  @override
  String collectStats(int count, String size) {
    return '$count images · $size';
  }

  @override
  String get collectDelete => 'Supprimer les données collectées';

  @override
  String get collectDeleteConfirm =>
      'Supprimer de cet appareil toutes les images et tous les choix collectés ?';

  @override
  String get delete => 'Supprimer';

  @override
  String collectFailed(String error) {
    return 'Impossible d\'enregistrer les données d\'entraînement : $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Annotations enregistrées pour $count images';
  }

  @override
  String get undo => 'Annuler';

  @override
  String get redo => 'Rétablir';

  @override
  String get similar => 'Similaires';

  @override
  String get thisImage => 'Cette image';

  @override
  String allImagesCount(int count) {
    return 'Les $count images';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zones peuvent encore être lisibles',
      one: '1 zone peut encore être lisible',
      zero: 'Aucune zone lisible',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Après le masquage, la vérification a encore détecté ces zones dans la sortie.';

  @override
  String get redactThemAndExport => 'Masquer et exporter';

  @override
  String get showThem => 'Afficher';

  @override
  String get pickClass => 'Choisir une classe';

  @override
  String annotateOf(int index, int total) {
    return 'Annoter $index / $total';
  }

  @override
  String get suggestions => 'Suggestions';

  @override
  String get skip => 'Passer';

  @override
  String get nothingPrivate => 'Rien de privé';

  @override
  String get next => 'Suivant';

  @override
  String get annotateHint =>
      'Touchez une ligne de texte pour la cadrer, ou glissez pour dessiner';

  @override
  String get annotationData => 'Données d\'annotation';

  @override
  String get statLabeled => 'Étiquetées';

  @override
  String get statEmpty => 'Rien de privé';

  @override
  String get statSkipped => 'Passées';

  @override
  String get boxesPerClass => 'Cadres par classe';

  @override
  String get imagesHeader => 'Images';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cadres',
      one: '1 cadre',
      zero: '0 cadre',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Tout exporter';

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get annotateDeleteConfirm =>
      'Supprimer toutes les annotations et leurs images de cet appareil ?';

  @override
  String get noAnnotations =>
      'Aucune annotation pour l\'instant. Sélectionnez des images et choisissez Annoter.';

  @override
  String get filterScreenshots => 'Captures d\'écran';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterVideos => 'Vidéos';

  @override
  String get albums => 'Albums';

  @override
  String get limitedAccess =>
      'MosaicIt ne peut voir que certaines de vos photos';

  @override
  String get manage => 'Gérer';

  @override
  String selectedImages(int count) {
    return '$count sélectionnée(s)';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Masquer $count images',
      one: 'Masquer 1 image',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Annoter';

  @override
  String get badgeRedacted => 'Masquée';

  @override
  String get badgeAnnotated => 'Annotée';

  @override
  String get photosDenied =>
      'MosaicIt a besoin d\'accéder à vos photos pour les afficher ici. Les photos ne quittent jamais cet appareil.';

  @override
  String get openSettings => 'Ouvrir les Réglages';

  @override
  String get openFiles => 'Ouvrir des fichiers';

  @override
  String get noPhotos => 'Aucune photo ici';

  @override
  String get loading => 'Chargement…';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get appIcon => 'Icône de l’app';

  @override
  String get aspectRatioGrid => 'Grille au format d’origine';

  @override
  String get modelDownloadFailed => 'Impossible de télécharger le modèle';

  @override
  String get retry => 'Réessayer';

  @override
  String get autoUpdateModel => 'Mettre à jour le modèle automatiquement';

  @override
  String get threshold => 'Seuil';

  @override
  String get thresholdLow => 'Bas';

  @override
  String get thresholdMedium => 'Moyen';

  @override
  String get thresholdHigh => 'Haut';

  @override
  String get redaction => 'Masquage';

  @override
  String get style => 'Style';

  @override
  String get selectedByDefault => 'Sélectionnés par défaut';

  @override
  String get dataPrivacy => 'Données et confidentialité';

  @override
  String get localOnly =>
      'Conservé uniquement sur cet appareil, jamais dans iCloud ou les sauvegardes.';

  @override
  String get model => 'Modèle';

  @override
  String get importModel => 'Importer un autre modèle';

  @override
  String get advanced => 'Avancé';

  @override
  String get about => 'À propos';

  @override
  String get licenses => 'Licences open source';

  @override
  String get merge => 'Fusionner';

  @override
  String get split => 'Séparer';

  @override
  String get mergeHint =>
      'Touchez un autre cadre pour l\'ajouter à la même valeur';

  @override
  String get classOrganization => 'Organisation';

  @override
  String get classDeviceId => 'Identifiant de l’appareil';

  @override
  String get classSecret => 'Secret';

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
