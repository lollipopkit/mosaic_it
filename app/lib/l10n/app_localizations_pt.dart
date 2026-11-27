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
  String get regionsTooltip => 'Regiões';

  @override
  String get cameraPhoto =>
      'Esta é uma foto de câmera; o detector é feito para capturas de tela, então suas caixas aqui são pouco confiáveis.';

  @override
  String get modeDraw => 'Desenhar';

  @override
  String get fillSolid => 'Cor sólida';

  @override
  String get fillBlocks => 'Mosaico cinza';

  @override
  String get fillNoise => 'Ruído';

  @override
  String get export => 'Exportar';

  @override
  String pickOneModel(String formats) {
    return 'Escolha exatamente um modelo $formats';
  }

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
  String get delete => 'Excluir';

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
  String get appearance => 'Aparência';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Ícone do app';

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

  @override
  String get classPerson => 'Pessoa';

  @override
  String get classHealth => 'Saúde';

  @override
  String get classPersonalInfo => 'Dados pessoais';

  @override
  String selectedOf(int selected, int total) {
    return '$selected / $total selecionadas';
  }

  @override
  String get fillStyle => 'Estilo de preenchimento';

  @override
  String get colour => 'Cor';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images imagens',
      one: '1 imagem',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions regiões',
      one: '1 região',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Compartilhar';

  @override
  String get saveToPhotos => 'Salvar em Fotos';

  @override
  String get saveAs => 'Salvar…';

  @override
  String get exportFormat => 'Formato';

  @override
  String get exportSize => 'Tamanho';

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
      other: '$count imagens salvas em Fotos',
      one: '1 imagem salva em Fotos',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'Tudo';

  @override
  String get selectNone => 'Nada';

  @override
  String get suggested => 'sugerida';

  @override
  String scoreValue(String score) {
    return 'Pontuação $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'Após a ocultação, a verificação ainda encontrou estas áreas na saída da imagem $index.';
  }

  @override
  String get reasonNotSelected => 'não selecionada';

  @override
  String get reasonBoxTooSmall => 'caixa muito pequena';

  @override
  String get reasonFillShowsThrough => 'preenchimento deixa transparecer';

  @override
  String get openSource => 'Código aberto';

  @override
  String get adaptivePreselectTitle => 'Pré-seleção adaptativa local';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes ajustadas',
      one: '1 classe ajustada',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Redefinir preferências locais';

  @override
  String get adaptiveResetDone => 'Preferências locais redefinidas';

  @override
  String get feedbackTitle => 'Relatar problema de detecção';

  @override
  String get feedbackShort => 'Feedback';

  @override
  String get feedbackMenu => 'Relatar problema';

  @override
  String get feedbackAction => 'Relatar';

  @override
  String get feedbackAttachScreenshot => 'Anexar captura de tela';

  @override
  String get feedbackModeMasked => 'Somente erros';

  @override
  String get feedbackModeFull => 'Imagem completa';

  @override
  String get feedbackModeText => 'Sem imagem';

  @override
  String get feedbackTagMissed => 'Não detectado';

  @override
  String get feedbackTagFalsePositive => 'Falso positivo';

  @override
  String get feedbackTagBoxDrift => 'Caixa deslocada';

  @override
  String get feedbackTagWrongClass => 'Classe incorreta';

  @override
  String get feedbackTagOther => 'Outro';

  @override
  String get feedbackNoteHint => 'Observação opcional…';

  @override
  String feedbackCountMasked(int count) {
    return 'Ocultadas $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Não detectadas $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'Falso positivo $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Desmarcadas $count';
  }

  @override
  String get feedbackBoxMissed => 'Não detectado';

  @override
  String get feedbackBoxMissedMasked => 'Não detectado · ocultado';

  @override
  String get feedbackBoxFp => 'Falso positivo';

  @override
  String get feedbackBoxPreference => 'Manter visível';

  @override
  String get introOfflineTitle => 'Sem acesso à rede';

  @override
  String get introOfflineBody =>
      'O MosaicIt não possui código de rede nem solicita permissão de rede. O detector está integrado ao app e as imagens nunca saem do dispositivo.';

  @override
  String get introNoNetPermTitle => 'Sem permissões de rede';

  @override
  String get introBundledModelTitle => 'Modelo integrado no dispositivo';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · integrado';
  }

  @override
  String get resetBundledModel => 'Usar modelo integrado';

  @override
  String get reviewIntro => 'Ver introdução novamente';

  @override
  String get feedbackOpenWeb => 'Abrir formulário web';

  @override
  String get introNoNetPermBodyIos =>
      'Sem requisições de rede · apenas no dispositivo';

  @override
  String get introNoNetPermBodyAndroid => 'Sem permissão INTERNET declarada';

  @override
  String get introNoNetPermBodyDesktop => 'Sem acesso de rede no sandbox';

  @override
  String get customModel => 'Modelo personalizado';

  @override
  String modelClassCount(int count) {
    return '$count classes';
  }

  @override
  String get copyImage => 'Copiar imagem';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get copyFailed => 'Não foi possível copiar a imagem';

  @override
  String get peekOriginal => 'Segure para ver o original';

  @override
  String get selectMedia => 'Selecionar fotos';

  @override
  String get saveFailed => 'Não foi possível salvar em Fotos';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get iosWirelessPromptTitle => 'Aviso de dados sem fio';

  @override
  String get iosWirelessPromptBody =>
      'Ao abrir o seletor de fotos do sistema, o iOS pode exibir um aviso de dados para miniaturas do iCloud. O MosaicIt não usa rede — toque em “Não Permitir”.';

  @override
  String get continueAction => 'Continuar';
}
