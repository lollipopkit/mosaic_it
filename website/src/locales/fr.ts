import type { Copy } from './types';

export const fr: Copy = {
  meta: {
    lang: 'fr',
    dir: 'ltr',
    title: 'MosaicIt — Masquage de confidentialité hors ligne',
    description:
      'Détectez et masquez vos informations privées dans les captures d’écran et photos entièrement hors ligne. Sans OCR, sans requête réseau et sans accès en lecture à votre photothèque.',
  },
  nav: {
    features: 'Fonctionnalités',
    privacy: 'Confidentialité',
    download: 'Télécharger',
    feedback: 'Retours',
    github: 'GitHub',
    languageLabel: 'Langue',
    cta: 'Télécharger',
  },
  hero: {
    titlePrefix: 'Masquez vos données privées,',
    titleSuffix: 'entièrement hors ligne.',
    subtitle:
      'MosaicIt détecte les noms, numéros de téléphone, adresses, montants, pièces d’identité, codes QR et visages directement sur l’appareil — sans OCR, sans code réseau et sans lire votre photothèque.',
    primaryAction: 'Télécharger MosaicIt',
    feedbackAction: 'Retour en ligne',
    githubAction: 'GitHub',
  },
  demo: {
    ariaLabel: 'Aperçu interactif du masquage avec MosaicIt',
    peekLabel: 'Maintenir pour voir l’original',
    resetLabel: 'Réinitialiser les masques',
    receiptTitle: 'Reçu de virement',
    recipientLabel: 'Bénéficiaire',
    recipientValue: 'Camille Laurent',
    phoneLabel: 'Téléphone',
    phoneValue: '+33 6 39 98 14 20',
    addressLabel: 'Adresse',
    addressValue: '42 rue des Érables, Apt 8B',
    amountLabel: 'Montant',
    amountValue: '2 480,00 €',
    cardLabel: 'Compte',
    cardValue: '6222 **** **** 4821',
    qrLabel: 'QR du reçu',
    styles: {
      solid: 'Couleur unie',
      surround: 'Couleur de fond',
      blocks: 'Mosaïque grise',
      tinted: 'Mosaïque colorée',
      noise: 'Bruit',
    },
    classes: {
      person_name: 'Nom',
      phone: 'Téléphone',
      address: 'Adresse',
      finance: 'Montant',
      bank_card: 'Carte bancaire',
      qr: 'Code QR',
    },
  },
  features: {
    title: 'Conçu pour un masquage rapide et vérifiable.',
    subtitle:
      'Ouvrez une image, vérifiez les zones détectées, ajustez si besoin et exportez en quelques secondes.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'Détection locale sans OCR',
        description:
          'Les poids FP16 ONNX / LiteRT intégrés détectent 18 classes de données personnelles dans les captures d’écran ainsi que les visages via YuNet — sans reconnaissance de texte ni téléchargement externe.',
      },
      {
        tag: '5 styles',
        title: 'Écrasement irréversible des pixels',
        description:
          'Choisissez Couleur unie, Couleur de fond, Mosaïque grise, Mosaïque colorée ou Bruit. Aucun ne lit les pixels à l’intérieur de la zone masquée, empêchant toute dépixellisation ou défloutage.',
      },
      {
        tag: 'Auto-vérification',
        title: 'Nouvelle analyse avant export',
        description:
          'Avant l’enregistrement ou le partage, MosaicIt peut relancer le détecteur sur l’image masquée pour signaler toute zone sensible encore visible.',
      },
      {
        tag: 'Lot & adaptatif',
        title: 'Traitement par lot et apprentissage local',
        description:
          'Ouvrez plusieurs captures d’écran d’un coup, recherchez des zones similaires sur tout le lot et laissez l’apprentissage local adapter les seuils à vos choix.',
      },
      {
        tag: 'Éditeur direct',
        title: 'Aperçu rapide, copie et partage système',
        description:
          'S’ouvre directement sur l’éditeur. Maintenez l’icône œil pour comparer avec l’original, copiez directement dans le presse-papiers ou importez via Partager, Ouvrir avec et glisser-déposer.',
      },
      {
        tag: 'Cœur Rust + CLI',
        title: 'CLI unseen scriptable',
        description:
          'Le moteur partagé unseen-core alimente l’application Flutter et une CLI autonome dédiée au masquage par lot et à la vérification BLAKE3 des modèles.',
      },
    ],
    classesTitle: '19 classes prises en charge',
    classesNote: '18 classes issues du modèle intégré unseen-det 0.5.0 plus la détection de visages par YuNet.',
  },
  privacy: {
    title: 'Zéro réseau. Zéro accès en lecture à vos photos.',
    subtitle:
      'Chaque engagement de confidentialité est garanti par la compilation et les permissions système, pas seulement par une politique écrite.',
    factors: [
      {
        tag: 'Binaire hors ligne',
        title: 'Aucun code réseau dans l’application',
        description:
          'L’application embarque les poids du modèle et ne contient ni client HTTP, ni SDK d’analyse, ni rapporteur de plantages, ni droit réseau. La CI vérifie l’absence totale de dépendances réseau à chaque build.',
      },
      {
        tag: 'Sélecteur système uniquement',
        title: 'Aucune permission de lecture de la photothèque',
        description:
          'iOS utilise PHPickerViewController hors processus et l’enregistrement en écriture seule .addOnly. Android s’appuie sur le Photo Picker système et supprime les permissions transitives des manifestes de production.',
      },
    ],
    tableColArea: 'Périmètre',
    tableColDetail: 'Implémentation',
    rows: [
      {
        area: 'Traitement d’image',
        detail:
          'La détection, l’orientation EXIF et l’écrasement des pixels s’exécutent localement en Rust (unseen-core) via FFI.',
      },
      {
        area: 'Irréversibilité du masquage',
        detail:
          'Couleur unie, Mosaïque grise et Bruit ignorent totalement les pixels source. Couleur de fond et Mosaïque colorée échantillonnent uniquement un anneau de 4 px à l’extérieur du cadre.',
      },
      {
        area: 'Retours de détection facultatifs',
        detail:
          'Signaler un oubli ou un faux positif ouvre mosaic.lollipopkit.com/feedback dans votre navigateur système via un #fragment d’URL qui n’apparaît jamais dans les journaux HTTP GET et est effacé via history.replaceState.',
      },
      {
        area: 'Open source reproductible',
        detail:
          'L’application, le cœur Rust, le worker de retours et les poids publiés sont distribués sous licence AGPL-3.0 avec sommes de contrôle BLAKE3.',
      },
    ],
  },
  download: {
    title: 'Natif sur mobile et ordinateur.',
    subtitle: 'Téléchargez les versions précompilées sur GitHub ou compilez directement depuis les sources.',
    currentBadge: 'Plateforme actuelle',
    releasesAction: 'Versions GitHub',
    sourceAction: 'Compiler depuis les sources',
    cliPrompt: '# Compiler la CLI Rust (unseen)',
    appPrompt: '# Lancer l’application Flutter depuis les sources',
    copy: 'Copier',
    copied: 'Copié',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Zéro permission en release' },
      linux: { name: 'Linux', meta: 'App bureau (tar.gz) & unseen CLI' },
      windows: { name: 'Windows', meta: 'App bureau (ZIP) & unseen CLI' },
    },
  },
  cta: {
    title: 'Open source sous AGPL-3.0.',
    subtitle:
      'Auditez le code, récupérez la dernière version ou signalez les détections manquées sur la page de retours.',
    feedbackAction: 'Ouvrir les retours web',
    releasesAction: 'Versions GitHub',
    githubAction: 'Voir le code source',
  },
  more: {
    title: 'Plus d’apps par lollipopkit.',
    subtitle: 'D’autres applications natives conçues avec la même exigence technique.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Suivi de serveurs, terminal SSH tactile, SFTP, Docker, systemd et outils S.M.A.R.T. réunis dans un espace natif.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Montez SFTP, S3, WebDAV et vos stockages distants dans le Finder macOS via Apple File Provider, sans extension noyau.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Client natif pour OpenAI et les API LLM compatibles, avec historique local, appels d’outils et points de terminaison personnalisés.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Fonctionnalités',
    privacy: 'Confidentialité',
    download: 'Télécharger',
    feedback: 'Retours',
    releases: 'Versions',
    license: 'AGPL-3.0',
  },
};
