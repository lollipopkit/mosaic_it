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
  String get reviewButton => 'Revisar';

  @override
  String get openingLabels => 'Abriendo etiquetas…';

  @override
  String noImagesIn(String name) {
    return 'No hay imágenes en $name';
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
  String get reviewPseudoLabels =>
      'Revisar etiquetas pseudo (carpeta con coco.json)';

  @override
  String get regionsTooltip => 'Regiones';

  @override
  String get notCalibrated =>
      'El modelo no está calibrado: la preselección usa un umbral fijo.';

  @override
  String calibratedUnverified(String domain) {
    return 'Calibrado con datos no verificados ($domain): la garantía de recuperación aún no se aplica.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Calibrado para imágenes de $domain. Otros tipos de imágenes están fuera de la garantía.';
  }

  @override
  String get cameraPhoto =>
      'Esta es una foto de cámara; el detector está diseñado para capturas de pantalla, por lo que sus recuadros aquí no son fiables.';

  @override
  String get modeDraw => 'Dibujar';

  @override
  String get fillLabel => 'Relleno';

  @override
  String get fillSolid => 'Color sólido';

  @override
  String get fillBlocks => 'Mosaico gris';

  @override
  String get fillNoise => 'Ruido';

  @override
  String get verifyNext => 'Verificar y siguiente';

  @override
  String get export => 'Exportar';

  @override
  String get pickOneModel => 'Elige exactamente un modelo .onnx';

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
  String noLabelsIn(String name) {
    return 'No hay coco.json en $name';
  }

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
  String get collectTitle => 'Recopilar datos de entrenamiento';

  @override
  String get collectSubtitle =>
      'Guardar en este dispositivo cada imagen exportada, las zonas detectadas y tus elecciones para entrenar modelos futuros. No se sube nada.';

  @override
  String collectStats(int count, String size) {
    return '$count imágenes · $size';
  }

  @override
  String get collectDelete => 'Eliminar datos recopilados';

  @override
  String get collectDeleteConfirm =>
      '¿Eliminar de este dispositivo todas las imágenes y elecciones recopiladas?';

  @override
  String get delete => 'Eliminar';

  @override
  String collectFailed(String error) {
    return 'No se pudieron guardar los datos de entrenamiento: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Etiquetas guardadas para $count imágenes';
  }

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
  String annotateOf(int index, int total) {
    return 'Anotar $index / $total';
  }

  @override
  String get suggestions => 'Sugerencias';

  @override
  String get skip => 'Omitir';

  @override
  String get nothingPrivate => 'Nada privado';

  @override
  String get next => 'Siguiente';

  @override
  String get annotateHint =>
      'Toca una línea de texto para enmarcarla o arrastra para dibujar';

  @override
  String get annotationData => 'Datos de anotación';

  @override
  String get statLabeled => 'Etiquetadas';

  @override
  String get statEmpty => 'Nada privado';

  @override
  String get statSkipped => 'Omitidas';

  @override
  String get boxesPerClass => 'Cajas por clase';

  @override
  String get imagesHeader => 'Imágenes';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cajas',
      one: '1 caja',
      zero: '0 cajas',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Exportar todo';

  @override
  String get deleteAll => 'Eliminar todo';

  @override
  String get annotateDeleteConfirm =>
      '¿Eliminar todas las anotaciones y sus imágenes de este dispositivo?';

  @override
  String get noAnnotations =>
      'Aún no hay anotaciones. Selecciona imágenes y elige Anotar.';

  @override
  String get filterScreenshots => 'Capturas de pantalla';

  @override
  String get filterAll => 'Todas';

  @override
  String get filterVideos => 'Vídeos';

  @override
  String get albums => 'Álbumes';

  @override
  String get limitedAccess => 'MosaicIt solo puede ver algunas de tus fotos';

  @override
  String get manage => 'Gestionar';

  @override
  String selectedImages(int count) {
    return '$count seleccionadas';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redactar $count imágenes',
      one: 'Redactar 1 imagen',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Anotar';

  @override
  String get badgeRedacted => 'Redactada';

  @override
  String get badgeAnnotated => 'Anotada';

  @override
  String get photosDenied =>
      'MosaicIt necesita acceso a tus fotos para mostrarlas aquí. Las fotos nunca salen de este dispositivo.';

  @override
  String get openSettings => 'Abrir Ajustes';

  @override
  String get openFiles => 'Abrir archivos';

  @override
  String get noPhotos => 'No hay fotos aquí';

  @override
  String get loading => 'Cargando…';

  @override
  String get appearance => 'Apariencia';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Icono de la app';

  @override
  String get aspectRatioGrid => 'Cuadrícula con proporción original';

  @override
  String get modelDownloadFailed => 'No se pudo descargar el modelo';

  @override
  String get retry => 'Reintentar';

  @override
  String get autoUpdateModel => 'Actualizar el modelo automáticamente';

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
  String get localOnly =>
      'Se guarda solo en este dispositivo, nunca en iCloud ni en copias de seguridad.';

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
}
