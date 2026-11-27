import type { Copy } from './types';

export const pt: Copy = {
  meta: {
    lang: 'pt',
    dir: 'ltr',
    title: 'MosaicIt — Ocultação de privacidade no dispositivo',
    description:
      'Detecte e oculte informações privadas em capturas de tela e fotos totalmente offline. Sem OCR, sem requisições de rede e sem permissão de leitura da biblioteca de fotos.',
  },
  nav: {
    features: 'Recursos',
    privacy: 'Privacidade',
    download: 'Baixar',
    feedback: 'Feedback',
    github: 'GitHub',
    languageLabel: 'Idioma',
    cta: 'Baixar',
  },
  hero: {
    titlePrefix: 'Oculte dados privados,',
    titleSuffix: 'totalmente offline.',
    subtitle:
      'O MosaicIt detecta nomes, telefones, endereços, valores financeiros, documentos, códigos QR e rostos no próprio dispositivo — sem OCR, sem código de rede e sem ler sua galeria de fotos.',
    primaryAction: 'Baixar MosaicIt',
    feedbackAction: 'Feedback web',
    githubAction: 'GitHub',
  },
  demo: {
    ariaLabel: 'Prévia interativa de ocultação do MosaicIt',
    peekLabel: 'Segure para ver o original',
    resetLabel: 'Redefinir máscaras',
    receiptTitle: 'Comprovante de transferência',
    recipientLabel: 'Destinatário',
    recipientValue: 'Lucas Ferreira',
    phoneLabel: 'Telefone',
    phoneValue: '+55 11 90000-8920',
    addressLabel: 'Endereço',
    addressValue: 'Rua das Palmeiras, 42, Apto 8B',
    amountLabel: 'Valor',
    amountValue: 'R$ 2.480,00',
    cardLabel: 'Conta',
    cardValue: '6222 **** **** 4821',
    qrLabel: 'QR do recibo',
    styles: {
      solid: 'Cor sólida',
      surround: 'Cor de fundo',
      blocks: 'Mosaico cinza',
      tinted: 'Mosaico colorido',
      noise: 'Ruído',
    },
    classes: {
      person_name: 'Nome',
      phone: 'Telefone',
      address: 'Endereço',
      finance: 'Valor',
      bank_card: 'Cartão bancário',
      qr: 'Código QR',
    },
  },
  features: {
    title: 'Feito para ocultação rápida e verificável.',
    subtitle:
      'Abra uma imagem, revise as regiões detectadas, ajuste se necessário e exporte em segundos.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'Detecção local sem OCR',
        description:
          'Pesos FP16 ONNX / LiteRT integrados detectam 18 classes de dados pessoais em capturas de tela, além de detecção facial via YuNet — sem reconhecimento de texto nem downloads externos de modelos.',
      },
      {
        tag: '5 estilos',
        title: 'Sobrescrita irreversível de pixels',
        description:
          'Escolha Cor sólida, Cor de fundo, Mosaico cinza, Mosaico colorido ou Ruído. Nenhum lê os pixels dentro da área ocultada, impedindo recuperação por despixelização ou remoção de desfoque.',
      },
      {
        tag: 'Autoverificação',
        title: 'Nova verificação antes de exportar',
        description:
          'Antes de salvar ou compartilhar, o MosaicIt pode executar o detector novamente na saída ocultada para apontar qualquer região ainda exposta.',
      },
      {
        tag: 'Lote e adaptativo',
        title: 'Ocultação em lote e aprendizado local',
        description:
          'Abra várias capturas de tela de uma vez, encontre regiões semelhantes em todo o lote e deixe o aprendizado local ajustar os limiares às suas escolhas.',
      },
      {
        tag: 'Editor direto',
        title: 'Comparação rápida, cópia e compartilhamento',
        description:
          'Abre direto no editor. Segure o ícone de olho para comparar com o original, copie direto para a área de transferência ou receba arquivos via Compartilhar, Abrir com e arrastar e soltar.',
      },
      {
        tag: 'Núcleo Rust + CLI',
        title: 'CLI unseen programável',
        description:
          'O motor compartilhado unseen-core equipa tanto o app Flutter quanto uma CLI independente para ocultação em lote e verificação BLAKE3 de modelos.',
      },
    ],
    classesTitle: '19 classes suportadas',
    classesNote: '18 classes do modelo integrado unseen-det 0.5.0 mais detecção de rostos via YuNet.',
  },
  privacy: {
    title: 'Zero rede. Zero leitura da galeria de fotos.',
    subtitle:
      'Cada garantia de privacidade é aplicada na compilação e nas permissões do sistema, não apenas em texto de política.',
    factors: [
      {
        tag: 'Binário offline',
        title: 'Nenhum código de rede no aplicativo',
        description:
          'O app já vem com os pesos do modelo embarcados e não contém cliente HTTP, SDK de telemetria, relatório de falhas nem permissões de rede. A CI verifica zero dependências de rede a cada compilação.',
      },
      {
        tag: 'Apenas seletor do sistema',
        title: 'Sem permissão de leitura da biblioteca de fotos',
        description:
          'O iOS usa o PHPickerViewController fora do processo e salvamento somente gravação com .addOnly. O Android usa o Photo Picker do sistema e remove permissões transitivas dos manifestos de release.',
      },
    ],
    tableColArea: 'Fronteira',
    tableColDetail: 'Implementação',
    rows: [
      {
        area: 'Processamento de imagens',
        detail:
          'Detecção, orientação EXIF e sobrescrita de pixels rodam localmente em Rust (unseen-core) via FFI.',
      },
      {
        area: 'Irreversibilidade da ocultação',
        detail:
          'Cor sólida, Mosaico cinza e Ruído ignoram totalmente os pixels originais. Cor de fundo e Mosaico colorido amostram apenas um anel de 4 px fora da caixa.',
      },
      {
        area: 'Feedback opcional de detecção',
        detail:
          'Enviar casos não detectados ou falsos positivos abre mosaic.lollipopkit.com/feedback no navegador do sistema via #fragment de URL que nunca entra em logs HTTP GET e é removido com history.replaceState.',
      },
      {
        area: 'Código aberto reproduzível',
        detail:
          'App, núcleo em Rust, worker de feedback e pesos de modelos publicados estão sob AGPL-3.0 com somas de verificação BLAKE3.',
      },
    ],
  },
  download: {
    title: 'Nativo em dispositivos móveis e desktops.',
    subtitle: 'Versões pré-compiladas são publicadas no GitHub, ou compile diretamente do código-fonte.',
    currentBadge: 'Plataforma atual',
    releasesAction: 'Lançamentos no GitHub',
    sourceAction: 'Compilar do código-fonte',
    cliPrompt: '# Compilar a CLI em Rust (unseen)',
    appPrompt: '# Executar o app Flutter a partir do código-fonte',
    copy: 'Copiar',
    copied: 'Copiado',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Zero permissões em release' },
      linux: { name: 'Linux', meta: 'App desktop (tar.gz) e unseen CLI' },
      windows: { name: 'Windows', meta: 'App desktop (ZIP) e unseen CLI' },
    },
  },
  cta: {
    title: 'Código aberto sob AGPL-3.0.',
    subtitle:
      'Audite o código, baixe a versão mais recente ou reporte detecções perdidas na página de feedback web.',
    feedbackAction: 'Abrir feedback web',
    releasesAction: 'Lançamentos no GitHub',
    githubAction: 'Ver código-fonte',
  },
  more: {
    title: 'Mais de lollipopkit.',
    subtitle: 'Outros apps nativos criados com o mesmo rigor de engenharia.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Monitoramento de servidores, terminal SSH otimizado para toque, SFTP, Docker, systemd e ferramentas S.M.A.R.T. em um único espaço nativo.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Monte SFTP, S3, WebDAV e armazenamento remoto no Finder do macOS via Apple File Provider, sem extensões de kernel.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Cliente nativo para OpenAI e APIs de LLM compatíveis, com histórico local, chamada de ferramentas e endpoints personalizados.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Recursos',
    privacy: 'Privacidade',
    download: 'Baixar',
    feedback: 'Feedback',
    releases: 'Lançamentos',
    license: 'AGPL-3.0',
  },
};
