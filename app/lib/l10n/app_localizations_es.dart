// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Cargando modelo…';

  @override
  String get modelFileType => 'Modelo';

  @override
  String get useModel => 'Usar modelo';

  @override
  String get imagesFileType => 'Imágenes';

  @override
  String get detecting => 'Detectando…';

  @override
  String detectingProgress(int current, int total) {
    return 'Detectando $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Elige un modelo primero';

  @override
  String get findingSimilar => 'Buscando similares…';

  @override
  String similarSelected(int found, int added) {
    return '$found regiones similares seleccionadas ($added nuevas)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found regiones similares seleccionadas ($added nuevas) en $images imágenes';
  }

  @override
  String get saving => 'Guardando…';

  @override
  String get exportHere => 'Exportar aquí';

  @override
  String exportStoppedAt(String name) {
    return 'Exportación detenida en $name';
  }

  @override
  String exportedTo(String path) {
    return 'Exportado a $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Exportado a $path (sin audio)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imágenes exportadas',
      one: '1 imagen exportada',
      zero: '0 imágenes exportadas',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Comprobando $name…';
  }

  @override
  String get checkingAndExporting => 'Comprobando y exportando…';

  @override
  String get cancel => 'Cancelar';

  @override
  String get exportAnyway => 'Exportar de todos modos';

  @override
  String get regionsTooltip => 'Regiones';

  @override
  String get cameraPhoto =>
      'Esta es una foto de cámara; el detector está diseñado para capturas de pantalla, por lo que sus recuadros aquí no son fiables.';

  @override
  String get modeDraw => 'Dibujar';

  @override
  String get fillSolid => 'Color sólido';

  @override
  String get fillBlocks => 'Mosaico gris';

  @override
  String get fillNoise => 'Ruido';

  @override
  String get export => 'Exportar';

  @override
  String pickOneModel(String formats) {
    return 'Elige exactamente un modelo $formats';
  }

  @override
  String pickSidecar(String name) {
    return 'Elige también $name.json';
  }

  @override
  String get analysing => 'Analizando';

  @override
  String get followingRegion => 'Siguiendo la región';

  @override
  String get exporting => 'Exportando';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count fotogramas';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Censurando $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Error en la comprobación de exportación en $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count regiones que parecen privadas siguen siendo visibles allí ($classes).',
      one: '1 región que parece privada sigue siendo visible allí ($classes).',
      zero: 'No hay regiones privadas visibles allí.',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Mostrar fotograma';

  @override
  String get drawMissedRegion =>
      'Dibuja una región que el detector pasó por alto';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on de $total seguimientos censurados · $keyframes fotogramas clave';
  }

  @override
  String get keepAudio => 'Mantener audio';

  @override
  String get keepAudioHint =>
      'Las voces y los sonidos de notificación no se comprueban';

  @override
  String get goToFirstAppearance => 'Ir a la primera aparición';

  @override
  String get classPersonName => 'Nombre';

  @override
  String get classAddress => 'Dirección';

  @override
  String get classPhone => 'Teléfono';

  @override
  String get classEmail => 'Correo electrónico';

  @override
  String get classIdNumber => 'Número de identificación';

  @override
  String get classBankCard => 'Tarjeta bancaria';

  @override
  String get classPlate => 'Matrícula';

  @override
  String get classAccountId => 'Cuenta';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Cara';

  @override
  String get classQr => 'Código QR';

  @override
  String get classBarcode => 'Código de barras';

  @override
  String get classManual => 'Manual';

  @override
  String savedModelFailed(String error) {
    return 'No se pudo cargar el modelo guardado; elige un modelo de nuevo. ($error)';
  }

  @override
  String get fillSurround => 'Color de fondo';

  @override
  String get fillTinted => 'Mosaico de color';

  @override
  String get settings => 'Ajustes';

  @override
  String get classFinance => 'Importe';

  @override
  String get delete => 'Eliminar';

  @override
  String get undo => 'Deshacer';

  @override
  String get redo => 'Rehacer';

  @override
  String get similar => 'Similares';

  @override
  String get thisImage => 'Esta imagen';

  @override
  String allImagesCount(int count) {
    return 'Las $count imágenes';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count áreas pueden seguir siendo legibles',
      one: '1 área puede seguir siendo legible',
      zero: 'No hay áreas legibles',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Tras la redacción, la comprobación aún encontró estas áreas en la salida.';

  @override
  String get redactThemAndExport => 'Redactarlas y exportar';

  @override
  String get showThem => 'Mostrarlas';

  @override
  String get pickClass => 'Elegir una clase';

  @override
  String get appearance => 'Apariencia';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Icono de la app';

  @override
  String get threshold => 'Umbral';

  @override
  String get thresholdLow => 'Bajo';

  @override
  String get thresholdMedium => 'Medio';

  @override
  String get thresholdHigh => 'Alto';

  @override
  String get redaction => 'Redacción';

  @override
  String get style => 'Estilo';

  @override
  String get selectedByDefault => 'Seleccionado por defecto';

  @override
  String get dataPrivacy => 'Datos y privacidad';

  @override
  String get model => 'Modelo';

  @override
  String get importModel => 'Importar otro modelo';

  @override
  String get advanced => 'Avanzado';

  @override
  String get about => 'Acerca de';

  @override
  String get licenses => 'Licencias de código abierto';

  @override
  String get merge => 'Combinar';

  @override
  String get split => 'Dividir';

  @override
  String get mergeHint => 'Toca otra caja para que forme parte del mismo valor';

  @override
  String get classOrganization => 'Organización';

  @override
  String get classDeviceId => 'ID del dispositivo';

  @override
  String get classSecret => 'Credencial';

  @override
  String get classPerson => 'Persona';

  @override
  String get classHealth => 'Salud';

  @override
  String get classPersonalInfo => 'Datos personales';

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
  String get introOfflineTitle => 'Sin acceso a la red';

  @override
  String get introOfflineBody =>
      'MosaicIt no contiene código de red ni solicita permisos de red. El detector viene integrado y las imágenes y vídeos nunca salen del dispositivo.';

  @override
  String get introNoNetPermTitle => 'Sin permisos de red';

  @override
  String get introBundledModelTitle => 'Modelo integrado en el dispositivo';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · integrado';
  }

  @override
  String get resetBundledModel => 'Usar modelo integrado';

  @override
  String get reviewIntro => 'Ver introducción de nuevo';

  @override
  String get feedbackOpenWeb => 'Abrir formulario web';

  @override
  String get introNoNetPermBodyIos =>
      'Sin solicitudes de red · solo en el dispositivo';

  @override
  String get introNoNetPermBodyAndroid => 'Sin permiso INTERNET declarado';

  @override
  String get introNoNetPermBodyDesktop =>
      'Sin acceso de red en el entorno aislado';

  @override
  String get customModel => 'Modelo personalizado';

  @override
  String modelClassCount(int count) {
    return '$count clases';
  }

  @override
  String get copyImage => 'Copiar imagen';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get copyFailed => 'No se pudo copiar la imagen';

  @override
  String get peekOriginal => 'Mantén pulsado para ver el original';

  @override
  String get selectMedia => 'Seleccionar fotos';

  @override
  String get saveFailed => 'No se pudo guardar en Fotos';

  @override
  String get retry => 'Reintentar';

  @override
  String get iosWirelessPromptTitle => 'Aviso de datos inalámbricos';

  @override
  String get iosWirelessPromptBody =>
      'Al abrir el selector de fotos del sistema, iOS puede mostrar un aviso de datos por las miniaturas de iCloud. MosaicIt no usa red: pulsa «No permitir».';

  @override
  String get continueAction => 'Continuar';
}
