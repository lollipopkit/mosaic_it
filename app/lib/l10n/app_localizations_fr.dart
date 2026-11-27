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
  String get regionsTooltip => 'Régions';

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
  String get export => 'Exporter';

  @override
  String pickOneModel(String formats) {
    return 'Choisissez exactement un modèle $formats';
  }

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
  String get delete => 'Supprimer';

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
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get appIcon => 'Icône de l’app';

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
  String get classPerson => 'Personne';

  @override
  String get classHealth => 'Santé';

  @override
  String get classPersonalInfo => 'Infos personnelles';

  @override
  String selectedOf(int selected, int total) {
    return '$selected / $total sélectionnées';
  }

  @override
  String get fillStyle => 'Style de remplissage';

  @override
  String get colour => 'Couleur';

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
      other: '$regions régions',
      one: '1 région',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Partager';

  @override
  String get saveToPhotos => 'Enregistrer dans Photos';

  @override
  String get saveAs => 'Enregistrer…';

  @override
  String get exportFormat => 'Format';

  @override
  String get exportSize => 'Taille';

  @override
  String get sizeOriginal => 'Originale';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images enregistrées dans Photos',
      one: '1 image enregistrée dans Photos',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'Tout';

  @override
  String get selectNone => 'Aucune';

  @override
  String get suggested => 'suggérée';

  @override
  String scoreValue(String score) {
    return 'Score $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'Après le masquage, la vérification a encore détecté ces zones dans la sortie de l’image $index.';
  }

  @override
  String get reasonNotSelected => 'non sélectionnée';

  @override
  String get reasonBoxTooSmall => 'cadre trop petit';

  @override
  String get reasonFillShowsThrough =>
      'le remplissage laisse apparaître le contenu';

  @override
  String get openSource => 'Code source ouvert';

  @override
  String get adaptivePreselectTitle => 'Présélection adaptative locale';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes ajustées',
      one: '1 classe ajustée',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Réinitialiser les préférences locales';

  @override
  String get adaptiveResetDone => 'Préférences locales réinitialisées';

  @override
  String get feedbackTitle => 'Signaler un problème de détection';

  @override
  String get feedbackShort => 'Commentaires';

  @override
  String get feedbackMenu => 'Signaler un problème';

  @override
  String get feedbackAction => 'Signaler';

  @override
  String get feedbackAttachScreenshot => 'Joindre une capture';

  @override
  String get feedbackModeMasked => 'Erreurs uniquement';

  @override
  String get feedbackModeFull => 'Image complète';

  @override
  String get feedbackModeText => 'Sans image';

  @override
  String get feedbackTagMissed => 'Manqué';

  @override
  String get feedbackTagFalsePositive => 'Faux positif';

  @override
  String get feedbackTagBoxDrift => 'Cadre décalé';

  @override
  String get feedbackTagWrongClass => 'Mauvaise classe';

  @override
  String get feedbackTagOther => 'Autre';

  @override
  String get feedbackNoteHint => 'Remarque facultative…';

  @override
  String feedbackCountMasked(int count) {
    return 'Masquées $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Manquées $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'Faux positifs $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Décochées $count';
  }

  @override
  String get feedbackBoxMissed => 'Manqué';

  @override
  String get feedbackBoxMissedMasked => 'Manqué · masqué';

  @override
  String get feedbackBoxFp => 'Faux positif';

  @override
  String get feedbackBoxPreference => 'Garder visible';

  @override
  String get introOfflineTitle => 'Aucun accès réseau';

  @override
  String get introOfflineBody =>
      'MosaicIt ne contient aucun code réseau et ne demande aucune autorisation réseau. Le modèle est intégré à l’application et vos images restent sur l’appareil.';

  @override
  String get introNoNetPermTitle => 'Zéro autorisation réseau';

  @override
  String get introBundledModelTitle => 'Modèle intégré sur l’appareil';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · intégré';
  }

  @override
  String get resetBundledModel => 'Utiliser le modèle intégré';

  @override
  String get reviewIntro => 'Revoir la présentation';

  @override
  String get feedbackOpenWeb => 'Ouvrir dans le navigateur';

  @override
  String get introNoNetPermBodyIos => 'Aucune requête réseau · 100 % local';

  @override
  String get introNoNetPermBodyAndroid => 'Aucune permission INTERNET déclarée';

  @override
  String get introNoNetPermBodyDesktop =>
      'Aucun droit réseau dans le bac à sable';

  @override
  String get customModel => 'Modèle personnalisé';

  @override
  String modelClassCount(int count) {
    return '$count classes';
  }

  @override
  String get copyImage => 'Copier l’image';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get copyFailed => 'Impossible de copier l’image';

  @override
  String get peekOriginal => 'Maintenir pour voir l’original';

  @override
  String get selectMedia => 'Choisir des photos';

  @override
  String get saveFailed => 'Impossible d’enregistrer dans Photos';

  @override
  String get retry => 'Réessayer';

  @override
  String get iosWirelessPromptTitle => 'Invite de données sans fil';

  @override
  String get iosWirelessPromptBody =>
      'L’ouverture du sélecteur de photos système peut déclencher une alerte iOS pour les vignettes iCloud. MosaicIt n’utilise pas le réseau — touchez « Ne pas autoriser ».';

  @override
  String get continueAction => 'Continuer';
}
