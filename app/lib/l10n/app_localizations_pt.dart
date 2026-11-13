// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Carregando modelo…';

  @override
  String get modelFileType => 'Modelo';

  @override
  String get useModel => 'Usar modelo';

  @override
  String get imagesFileType => 'Imagens';

  @override
  String get detecting => 'Detectando…';

  @override
  String detectingProgress(int current, int total) {
    return 'Detectando $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Escolha um modelo primeiro';

  @override
  String get findingSimilar => 'Encontrando semelhantes…';

  @override
  String similarSelected(int found, int added) {
    return '$found regiões semelhantes selecionadas ($added novas)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found regiões semelhantes selecionadas ($added novas) em $images imagens';
  }

  @override
  String get reviewButton => 'Revisar';

  @override
  String get openingLabels => 'Abrindo rótulos…';

  @override
  String noImagesIn(String name) {
    return 'Nenhuma imagem em $name';
  }

  @override
  String get saving => 'Salvando…';

  @override
  String get exportHere => 'Exportar aqui';

  @override
  String exportStoppedAt(String name) {
    return 'Exportação interrompida em $name';
  }

  @override
  String exportedTo(String path) {
    return 'Exportado para $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Exportado para $path (sem áudio)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imagens exportadas',
      one: '1 imagem exportada',
      zero: 'Nenhuma imagem exportada',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Verificando $name…';
  }

  @override
  String get checkingAndExporting => 'Verificando e exportando…';

  @override
  String get cancel => 'Cancelar';

  @override
  String get exportAnyway => 'Exportar mesmo assim';

  @override
  String get reviewPseudoLabels =>
      'Revisar rótulos pseudo (pasta com coco.json)';

  @override
  String get regionsTooltip => 'Regiões';

  @override
  String get notCalibrated =>
      'O modelo não está calibrado: a pré-seleção usa um limiar fixo.';

  @override
  String calibratedUnverified(String domain) {
    return 'Calibrado com dados não verificados ($domain): a garantia de recall ainda não se aplica.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Calibrado para imagens de $domain. Outros tipos de imagens estão fora da garantia.';
  }

  @override
  String get cameraPhoto =>
      'Esta é uma foto de câmera; o detector é feito para capturas de tela, então suas caixas aqui são pouco confiáveis.';

  @override
  String get modeDraw => 'Desenhar';

  @override
  String get fillLabel => 'Preencher';

  @override
  String get fillSolid => 'Cor sólida';

  @override
  String get fillBlocks => 'Mosaico cinza';

  @override
  String get fillNoise => 'Ruído';

  @override
  String get verifyNext => 'Verificar e próximo';

  @override
  String get export => 'Exportar';

  @override
  String get pickOneModel => 'Escolha exatamente um modelo .onnx';

  @override
  String pickSidecar(String name) {
    return 'Escolha também $name.json';
  }

  @override
  String get analysing => 'Analisando';

  @override
  String get followingRegion => 'Seguindo a região';

  @override
  String get exporting => 'Exportando';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count quadros';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Redigindo de $start a $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Falha na verificação de exportação em $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count regiões com aparência privada ainda estão visíveis lá ($classes).',
      one: '1 região com aparência privada ainda está visível lá ($classes).',
      zero: 'Nenhuma região com aparência privada está visível lá ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Mostrar quadro';

  @override
  String get drawMissedRegion => 'Desenhe uma região que o detector perdeu';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on de $total trilhas redigidas · $keyframes quadros-chave';
  }

  @override
  String get keepAudio => 'Manter áudio';

  @override
  String get keepAudioHint => 'Vozes e sons de notificação não são verificados';

  @override
  String get goToFirstAppearance => 'Ir para a primeira aparição';

  @override
  String get classPersonName => 'Nome';

  @override
  String get classAddress => 'Endereço';

  @override
  String get classPhone => 'Telefone';

  @override
  String get classEmail => 'E-mail';

  @override
  String get classIdNumber => 'Número de documento';

  @override
  String get classBankCard => 'Cartão bancário';

  @override
  String get classPlate => 'Placa';

  @override
  String get classAccountId => 'Conta';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Rosto';

  @override
  String get classQr => 'Código QR';

  @override
  String get classBarcode => 'Código de barras';

  @override
  String get classManual => 'Manual';

  @override
  String noLabelsIn(String name) {
    return 'Nenhum coco.json em $name';
  }

  @override
  String savedModelFailed(String error) {
    return 'O modelo salvo não pôde ser carregado; escolha um modelo novamente. ($error)';
  }

  @override
  String get fillSurround => 'Cor de fundo';

  @override
  String get fillTinted => 'Mosaico colorido';

  @override
  String get settings => 'Ajustes';

  @override
  String get classFinance => 'Valor';

  @override
  String get collectTitle => 'Coletar dados de treinamento';

  @override
  String get collectSubtitle =>
      'Guardar neste dispositivo cada imagem exportada, as áreas detectadas e suas escolhas para treinar modelos futuros. Nada é enviado.';

  @override
  String collectStats(int count, String size) {
    return '$count imagens · $size';
  }

  @override
  String get collectDelete => 'Excluir dados coletados';

  @override
  String get collectDeleteConfirm =>
      'Excluir deste dispositivo todas as imagens e escolhas coletadas?';

  @override
  String get delete => 'Excluir';

  @override
  String collectFailed(String error) {
    return 'Não foi possível salvar os dados de treinamento: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Rótulos salvos para $count imagens';
  }

  @override
  String get undo => 'Desfazer';

  @override
  String get redo => 'Refazer';

  @override
  String get similar => 'Semelhante';

  @override
  String get thisImage => 'Esta imagem';

  @override
  String allImagesCount(int count) {
    return 'Todas as $count imagens';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count áreas podem ainda estar legíveis',
      one: '1 área pode ainda estar legível',
      zero: 'Nenhuma área legível',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Após a ocultação, a verificação ainda encontrou estas áreas na saída.';

  @override
  String get redactThemAndExport => 'Ocultar e exportar';

  @override
  String get showThem => 'Mostrar';

  @override
  String get pickClass => 'Escolher uma classe';

  @override
  String annotateOf(int index, int total) {
    return 'Anotar $index / $total';
  }

  @override
  String get suggestions => 'Sugestões';

  @override
  String get skip => 'Pular';

  @override
  String get nothingPrivate => 'Nada privado';

  @override
  String get next => 'Próximo';

  @override
  String get annotateHint =>
      'Toque em uma linha de texto para encaixotá-la ou arraste para desenhar';

  @override
  String get annotationData => 'Dados de anotação';

  @override
  String get statLabeled => 'Rótulos';

  @override
  String get statEmpty => 'Nada privado';

  @override
  String get statSkipped => 'Puladas';

  @override
  String get boxesPerClass => 'Caixas por classe';

  @override
  String get imagesHeader => 'Imagens';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caixas',
      one: '1 caixa',
      zero: '0 caixas',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Exportar tudo';

  @override
  String get deleteAll => 'Excluir tudo';

  @override
  String get annotateDeleteConfirm =>
      'Excluir todas as anotações e suas imagens deste dispositivo?';

  @override
  String get noAnnotations =>
      'Nenhuma anotação ainda. Selecione imagens e escolha Anotar.';

  @override
  String get filterScreenshots => 'Capturas de tela';

  @override
  String get filterAll => 'Todas';

  @override
  String get filterVideos => 'Vídeos';

  @override
  String get albums => 'Álbuns';

  @override
  String get limitedAccess =>
      'O MosaicIt pode ver apenas algumas das suas fotos';

  @override
  String get manage => 'Gerenciar';

  @override
  String selectedImages(int count) {
    return '$count selecionada(s)';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ocultar $count imagens',
      one: 'Ocultar 1 imagem',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Anotar';

  @override
  String get badgeRedacted => 'Ocultado';

  @override
  String get badgeAnnotated => 'Anotado';

  @override
  String get photosDenied =>
      'O MosaicIt precisa de acesso às suas fotos para exibi-las aqui. As fotos nunca saem deste dispositivo.';

  @override
  String get openSettings => 'Abrir Ajustes';

  @override
  String get openFiles => 'Abrir arquivos';

  @override
  String get noPhotos => 'Nenhuma foto aqui';

  @override
  String get loading => 'Carregando…';

  @override
  String get appearance => 'Aparência';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Ícone do app';

  @override
  String get aspectRatioGrid => 'Grade com proporção original';

  @override
  String get modelDownloadFailed => 'Não foi possível baixar o modelo';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get autoUpdateModel => 'Atualizar o modelo automaticamente';

  @override
  String get threshold => 'Limiar';

  @override
  String get thresholdLow => 'Baixo';

  @override
  String get thresholdMedium => 'Médio';

  @override
  String get thresholdHigh => 'Alto';

  @override
  String get redaction => 'Ocultação';

  @override
  String get style => 'Estilo';

  @override
  String get selectedByDefault => 'Selecionado por padrão';

  @override
  String get dataPrivacy => 'Dados e privacidade';

  @override
  String get localOnly =>
      'Mantido apenas neste dispositivo, nunca no iCloud ou em backups.';

  @override
  String get model => 'Modelo';

  @override
  String get importModel => 'Importar outro modelo';

  @override
  String get advanced => 'Avançado';

  @override
  String get about => 'Sobre';

  @override
  String get licenses => 'Licenças de código aberto';

  @override
  String get merge => 'Mesclar';

  @override
  String get split => 'Dividir';

  @override
  String get mergeHint =>
      'Toque em outra caixa para torná-la parte do mesmo valor';

  @override
  String get classOrganization => 'Organização';

  @override
  String get classDeviceId => 'ID do dispositivo';

  @override
  String get classSecret => 'Credencial';
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class AppLocalizationsPtPt extends AppLocalizationsPt {
  AppLocalizationsPtPt() : super('pt_PT');

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'A carregar o modelo…';

  @override
  String get modelFileType => 'Modelo';

  @override
  String get useModel => 'Usar modelo';

  @override
  String get imagesFileType => 'Imagens';

  @override
  String get detecting => 'A detetar…';

  @override
  String detectingProgress(int current, int total) {
    return 'A detetar $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Escolha primeiro um modelo';

  @override
  String get findingSimilar => 'A procurar semelhantes…';

  @override
  String similarSelected(int found, int added) {
    return '$found regiões semelhantes selecionadas ($added novas)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found regiões semelhantes selecionadas ($added novas) em $images imagens';
  }

  @override
  String get reviewButton => 'Rever';

  @override
  String get openingLabels => 'A abrir etiquetas…';

  @override
  String noImagesIn(String name) {
    return 'Sem imagens em $name';
  }

  @override
  String get saving => 'A guardar…';

  @override
  String get exportHere => 'Exportar aqui';

  @override
  String exportStoppedAt(String name) {
    return 'Exportação interrompida em $name';
  }

  @override
  String exportedTo(String path) {
    return 'Exportado para $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Exportado para $path (sem áudio)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imagens exportadas',
      one: '1 imagem exportada',
      zero: '0 imagens exportadas',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'A verificar $name…';
  }

  @override
  String get checkingAndExporting => 'A verificar e a exportar…';

  @override
  String get cancel => 'Cancelar';

  @override
  String get exportAnyway => 'Exportar mesmo assim';

  @override
  String get reviewPseudoLabels =>
      'Rever pseudoetiquetas (pasta com coco.json)';

  @override
  String get regionsTooltip => 'Regiões';

  @override
  String get notCalibrated =>
      'O modelo não está calibrado: a pré-seleção usa um limiar fixo.';

  @override
  String calibratedUnverified(String domain) {
    return 'Calibrado com dados não verificados ($domain): a garantia de recall ainda não se aplica.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Calibrado para imagens de $domain. Outros tipos de imagens estão fora da garantia.';
  }

  @override
  String get cameraPhoto =>
      'Esta é uma fotografia de câmara; o detetor foi feito para capturas de ecrã, pelo que as suas caixas aqui são pouco fiáveis.';

  @override
  String get modeDraw => 'Desenhar';

  @override
  String get fillLabel => 'Preenchimento';

  @override
  String get fillSolid => 'Cor sólida';

  @override
  String get fillBlocks => 'Mosaico cinzento';

  @override
  String get fillNoise => 'Ruído';

  @override
  String get verifyNext => 'Verificar e avançar';

  @override
  String get export => 'Exportar';

  @override
  String get pickOneModel => 'Escolha exatamente um modelo .onnx';

  @override
  String pickSidecar(String name) {
    return 'Escolha também $name.json';
  }

  @override
  String get analysing => 'A analisar';

  @override
  String get followingRegion => 'A seguir a região';

  @override
  String get exporting => 'A exportar';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count fotogramas';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'A redigir $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Falha na verificação de exportação às $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count regiões com aspeto privado ainda são visíveis ali ($classes).',
      one: '1 região com aspeto privado ainda é visível ali ($classes).',
      zero: '0 regiões com aspeto privado visíveis ali ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Mostrar fotograma';

  @override
  String get drawMissedRegion => 'Desenhe uma região que o detetor perdeu';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on de $total trajetórias redigidas · $keyframes fotogramas-chave';
  }

  @override
  String get keepAudio => 'Manter áudio';

  @override
  String get keepAudioHint => 'Vozes e sons de notificação não são verificados';

  @override
  String get goToFirstAppearance => 'Ir para a primeira aparição';

  @override
  String get classPersonName => 'Nome';

  @override
  String get classAddress => 'Endereço';

  @override
  String get classPhone => 'Telefone';

  @override
  String get classEmail => 'Email';

  @override
  String get classIdNumber => 'N.º de identificação';

  @override
  String get classBankCard => 'Cartão bancário';

  @override
  String get classPlate => 'Matrícula';

  @override
  String get classAccountId => 'Conta';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Rosto';

  @override
  String get classQr => 'Código QR';

  @override
  String get classBarcode => 'Código de barras';

  @override
  String get classManual => 'Manual';

  @override
  String noLabelsIn(String name) {
    return 'Sem coco.json em $name';
  }

  @override
  String savedModelFailed(String error) {
    return 'Não foi possível carregar o modelo guardado; escolha um modelo novamente. ($error)';
  }

  @override
  String get fillSurround => 'Cor de fundo';

  @override
  String get fillTinted => 'Mosaico colorido';

  @override
  String get settings => 'Definições';

  @override
  String get classFinance => 'Valor';

  @override
  String get collectTitle => 'Recolher dados de treino';

  @override
  String get collectSubtitle =>
      'Guardar neste dispositivo cada imagem exportada, as áreas detetadas e as suas escolhas para treinar modelos futuros. Nada é enviado.';

  @override
  String collectStats(int count, String size) {
    return '$count imagens · $size';
  }

  @override
  String get collectDelete => 'Eliminar dados recolhidos';

  @override
  String get collectDeleteConfirm =>
      'Eliminar deste dispositivo todas as imagens e escolhas recolhidas?';

  @override
  String get delete => 'Eliminar';

  @override
  String collectFailed(String error) {
    return 'Não foi possível guardar os dados de treino: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Etiquetas guardadas para $count imagens';
  }

  @override
  String get undo => 'Desfazer';

  @override
  String get redo => 'Refazer';

  @override
  String get similar => 'Semelhantes';

  @override
  String get thisImage => 'Esta imagem';

  @override
  String allImagesCount(int count) {
    return 'Todas as $count imagens';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count áreas podem ainda ser legíveis',
      many: 'muitas áreas podem ainda ser legíveis',
      few: 'poucas áreas podem ainda ser legíveis',
      two: '2 áreas podem ainda ser legíveis',
      one: '1 área pode ainda ser legível',
      zero: '0 áreas podem ainda ser legíveis',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Após a ocultação, a verificação ainda encontrou estas áreas na saída.';

  @override
  String get redactThemAndExport => 'Ocultar e exportar';

  @override
  String get showThem => 'Mostrar';

  @override
  String get pickClass => 'Escolher uma classe';

  @override
  String annotateOf(int index, int total) {
    return 'Anotar $index / $total';
  }

  @override
  String get suggestions => 'Sugestões';

  @override
  String get skip => 'Ignorar';

  @override
  String get nothingPrivate => 'Nada privado';

  @override
  String get next => 'Seguinte';

  @override
  String get annotateHint =>
      'Toque numa linha de texto para a encaixotar ou arraste para desenhar';

  @override
  String get annotationData => 'Dados de anotação';

  @override
  String get statLabeled => 'Etiquetadas';

  @override
  String get statEmpty => 'Nada privado';

  @override
  String get statSkipped => 'Ignoradas';

  @override
  String get boxesPerClass => 'Caixas por classe';

  @override
  String get imagesHeader => 'Imagens';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caixas',
      many: 'muitas caixas',
      few: 'poucas caixas',
      two: '2 caixas',
      one: '1 caixa',
      zero: '0 caixas',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Exportar tudo';

  @override
  String get deleteAll => 'Eliminar tudo';

  @override
  String get annotateDeleteConfirm =>
      'Eliminar todas as anotações e as respetivas imagens deste dispositivo?';

  @override
  String get noAnnotations =>
      'Ainda não há anotações. Selecione imagens e escolha Anotar.';

  @override
  String get filterScreenshots => 'Capturas de ecrã';

  @override
  String get filterAll => 'Todas';

  @override
  String get filterVideos => 'Vídeos';

  @override
  String get albums => 'Álbuns';

  @override
  String get limitedAccess => 'O MosaicIt só pode ver algumas das suas fotos';

  @override
  String get manage => 'Gerir';

  @override
  String selectedImages(int count) {
    return '$count selecionadas';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redigir $count imagens',
      many: 'Redigir muitas imagens',
      few: 'Redigir poucas imagens',
      two: 'Redigir 2 imagens',
      one: 'Redigir 1 imagem',
      zero: 'Redigir 0 imagens',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Anotar';

  @override
  String get badgeRedacted => 'Ocultada';

  @override
  String get badgeAnnotated => 'Anotada';

  @override
  String get photosDenied =>
      'O MosaicIt precisa de acesso às suas fotos para as mostrar aqui. As fotos nunca saem deste dispositivo.';

  @override
  String get openSettings => 'Abrir Definições';

  @override
  String get openFiles => 'Abrir ficheiros';

  @override
  String get noPhotos => 'Não há fotos aqui';

  @override
  String get loading => 'A carregar…';

  @override
  String get appearance => 'Aparência';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Ícone da app';

  @override
  String get aspectRatioGrid => 'Grelha com proporção original';

  @override
  String get modelDownloadFailed => 'Não foi possível descarregar o modelo';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get autoUpdateModel => 'Atualizar o modelo automaticamente';

  @override
  String get threshold => 'Limiar';

  @override
  String get thresholdLow => 'Baixo';

  @override
  String get thresholdMedium => 'Médio';

  @override
  String get thresholdHigh => 'Alto';

  @override
  String get redaction => 'Ocultação';

  @override
  String get style => 'Estilo';

  @override
  String get selectedByDefault => 'Selecionado por predefinição';

  @override
  String get dataPrivacy => 'Dados e privacidade';

  @override
  String get localOnly =>
      'Mantido apenas neste dispositivo, nunca no iCloud ou nas cópias de segurança.';

  @override
  String get model => 'Modelo';

  @override
  String get importModel => 'Importar outro modelo';

  @override
  String get advanced => 'Avançado';

  @override
  String get about => 'Acerca de';

  @override
  String get licenses => 'Licenças de código aberto';

  @override
  String get merge => 'Juntar';

  @override
  String get split => 'Separar';

  @override
  String get mergeHint =>
      'Toque noutra caixa para a tornar parte do mesmo valor';

  @override
  String get classOrganization => 'Organização';

  @override
  String get classDeviceId => 'ID do dispositivo';

  @override
  String get classSecret => 'Credencial';
}
