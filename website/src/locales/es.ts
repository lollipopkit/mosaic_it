import type { Copy } from './types';

export const es: Copy = {
  meta: {
    lang: 'es',
    dir: 'ltr',
    title: 'MosaicIt — Censura de privacidad en el dispositivo',
    description:
      'Detecta y oculta datos privados en capturas de pantalla y fotos completamente sin conexión. Sin OCR, sin solicitudes de red y sin permisos de lectura de tu fototeca.',
  },
  nav: {
    features: 'Funciones',
    privacy: 'Privacidad',
    download: 'Descargar',
    feedback: 'Comentarios',
    github: 'GitHub',
    languageLabel: 'Idioma',
    cta: 'Descargar',
  },
  hero: {
    titlePrefix: 'Oculta datos privados,',
    titleSuffix: 'totalmente sin conexión.',
    subtitle:
      'MosaicIt detecta nombres, teléfonos, direcciones, importes, documentos de identidad, códigos QR y rostros en tu dispositivo — sin OCR, sin código de red y sin leer tu galería de fotos.',
    primaryAction: 'Descargar MosaicIt',
    feedbackAction: 'Feedback web',
    githubAction: 'GitHub',
  },
  demo: {
    ariaLabel: 'Vista previa interactiva de ocultación con MosaicIt',
    peekLabel: 'Mantén pulsado para ver el original',
    resetLabel: 'Restablecer máscaras',
    receiptTitle: 'Comprobante de transferencia',
    recipientLabel: 'Destinatario',
    recipientValue: 'Carlos Mendoza',
    phoneLabel: 'Teléfono',
    phoneValue: '+34 600 00 89 20',
    addressLabel: 'Dirección',
    addressValue: 'Calle del Arce 42, 8.º B',
    amountLabel: 'Importe',
    amountValue: '2.480,00 €',
    cardLabel: 'Cuenta',
    cardValue: '6222 **** **** 4821',
    qrLabel: 'QR del recibo',
    styles: {
      solid: 'Color sólido',
      surround: 'Color de fondo',
      blocks: 'Mosaico gris',
      tinted: 'Mosaico de color',
      noise: 'Ruido',
    },
    classes: {
      person_name: 'Nombre',
      phone: 'Teléfono',
      address: 'Dirección',
      finance: 'Importe',
      bank_card: 'Tarjeta bancaria',
      qr: 'Código QR',
    },
  },
  features: {
    title: 'Pensado para ocultar datos de forma rápida y verificable.',
    subtitle:
      'Abre una imagen, revisa las regiones detectadas, ajusta lo que necesites y exporta en segundos.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'Detección local sin OCR',
        description:
          'Los pesos FP16 ONNX / LiteRT integrados detectan 18 clases de datos personales en capturas de interfaz junto con detección facial de YuNet — sin reconocimiento de texto ni descargas externas de modelos.',
      },
      {
        tag: '5 estilos',
        title: 'Sobrescritura irreversible de píxeles',
        description:
          'Elige entre Color sólido, Color de fondo, Mosaico gris, Mosaico de color o Ruido. Ninguno lee los píxeles dentro del recuadro oculto, evitando ataques de despixelado o desenfoque inverso.',
      },
      {
        tag: 'Autocomprobación',
        title: 'Reescaneo antes de exportar',
        description:
          'Antes de guardar o compartir, MosaicIt puede volver a ejecutar el detector sobre el resultado oculto para señalar cualquier región que haya quedado visible.',
      },
      {
        tag: 'Lotes y adaptación',
        title: 'Procesamiento por lotes y aprendizaje local',
        description:
          'Abre varias capturas a la vez, busca regiones similares en todo el lote y deja que el aprendizaje local adapte los umbrales a tus preferencias.',
      },
      {
        tag: 'Editor directo',
        title: 'Vista rápida, copia y compartir del sistema',
        description:
          'Abre directamente el editor. Mantén pulsado el icono del ojo para comparar con el original, copia directo al portapapeles o recibe archivos mediante Compartir, Abrir con y arrastrar y soltar.',
      },
      {
        tag: 'Núcleo Rust + CLI',
        title: 'CLI unseen automatizable',
        description:
          'El motor compartido unseen-core impulsa tanto la app de Flutter como una CLI independiente para ocultar lotes y verificar modelos con BLAKE3.',
      },
    ],
    classesTitle: '19 clases compatibles',
    classesNote: '18 clases del modelo integrado unseen-det 0.5.0 más detección facial con YuNet.',
  },
  privacy: {
    title: 'Cero red. Cero permisos de lectura de fotos.',
    subtitle:
      'Cada garantía de privacidad se impone en la compilación y los permisos del sistema, no solo en un texto legal.',
    factors: [
      {
        tag: 'Binario sin conexión',
        title: 'Sin código de red en la aplicación',
        description:
          'La app incluye los pesos del modelo integrados y no contiene cliente HTTP, SDK de analítica, informes de fallos ni permisos de red. La CI verifica cero dependencias de red en cada compilación.',
      },
      {
        tag: 'Solo selector del sistema',
        title: 'Sin permiso de lectura de la fototeca',
        description:
          'iOS usa el selector aislado PHPickerViewController y guardado de solo escritura con .addOnly. Android utiliza el Photo Picker del sistema y elimina permisos transitivos en los manifiestos de lanzamiento.',
      },
    ],
    tableColArea: 'Límite',
    tableColDetail: 'Implementación',
    rows: [
      {
        area: 'Procesamiento de imágenes',
        detail:
          'La detección, la orientación EXIF y la sobrescritura de píxeles se ejecutan localmente en Rust (unseen-core) mediante FFI.',
      },
      {
        area: 'Irreversibilidad del ocultado',
        detail:
          'Color sólido, Mosaico gris y Ruido ignoran por completo los píxeles originales. Color de fondo y Mosaico de color solo muestrean un anillo de 4 px fuera del recuadro.',
      },
      {
        area: 'Comentarios opcionales de detección',
        detail:
          'Reportar omisiones o falsos positivos abre mosaic.lollipopkit.com/feedback en tu navegador del sistema mediante un #fragment de URL que nunca llega a los registros HTTP GET y se elimina con history.replaceState.',
      },
      {
        area: 'Código abierto reproducible',
        detail:
          'La app, el núcleo en Rust, el worker de feedback y los pesos publicados se distribuyen bajo AGPL-3.0 con sumas de verificación BLAKE3.',
      },
    ],
  },
  download: {
    title: 'Nativa en móvil y escritorio.',
    subtitle: 'Las versiones precompiladas se publican en GitHub, o compila directamente desde el código fuente.',
    currentBadge: 'Plataforma actual',
    releasesAction: 'Lanzamientos en GitHub',
    sourceAction: 'Compilar desde fuente',
    cliPrompt: '# Compilar la CLI en Rust (unseen)',
    appPrompt: '# Ejecutar la app de Flutter desde el código fuente',
    copy: 'Copiar',
    copied: 'Copiado',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Cero permisos en lanzamiento' },
      linux: { name: 'Linux', meta: 'App de escritorio (tar.gz) y unseen CLI' },
      windows: { name: 'Windows', meta: 'App de escritorio (ZIP) y unseen CLI' },
    },
  },
  cta: {
    title: 'Código abierto bajo AGPL-3.0.',
    subtitle:
      'Audita el código, descarga la última versión o reporta detecciones fallidas en la página web de comentarios.',
    feedbackAction: 'Abrir feedback web',
    releasesAction: 'Lanzamientos en GitHub',
    githubAction: 'Ver código fuente',
  },
  more: {
    title: 'Más de lollipopkit.',
    subtitle: 'Otras aplicaciones nativas creadas con el mismo enfoque de ingeniería.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Monitorización de servidores, terminal SSH táctil, SFTP, Docker, systemd y herramientas S.M.A.R.T. en un solo entorno nativo.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Monta SFTP, S3, WebDAV y almacenamiento remoto en el Finder de macOS mediante Apple File Provider sin extensiones del kernel.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Cliente nativo para OpenAI y APIs de LLM compatibles con historial local, llamadas a herramientas y endpoints personalizados.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Funciones',
    privacy: 'Privacidad',
    download: 'Descargar',
    feedback: 'Comentarios',
    releases: 'Lanzamientos',
    license: 'AGPL-3.0',
  },
};
