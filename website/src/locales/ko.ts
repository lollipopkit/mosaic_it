import type { Copy } from './types';

export const ko: Copy = {
  meta: {
    lang: 'ko',
    dir: 'ltr',
    title: 'MosaicIt — 온디바이스 개인정보 마스킹',
    description:
      '스크린샷과 사진 속 개인정보를 완전 오프라인으로 감지하고 가립니다. OCR 없이, 네트워크 요청 없이, 사진 보관함 읽기 권한 없이 작동합니다.',
  },
  nav: {
    screenshots: '스크린샷',
    features: '기능',
    privacy: '개인정보 보호',
    download: '다운로드',
    feedback: '피드백',
    github: 'GitHub',
    languageLabel: '언어',
    cta: '다운로드',
  },
  hero: {
    titlePrefix: '개인정보 자동 마스킹,',
    titleSuffix: '완전 오프라인으로.',
    subtitle:
      'MosaicIt은 이름, 전화번호, 주소, 금액, 신분증 번호, QR 코드, 얼굴을 기기 내에서 직접 감지합니다. OCR이나 네트워크 코드가 없으며 사진 보관함 읽기 권한도 요구하지 않습니다.',
    primaryAction: 'MosaicIt 다운로드',
    feedbackAction: '웹 피드백',
    githubAction: 'GitHub',
  },
  features: {
    title: '빠르고 검증 가능한 마스킹 워크플로.',
    cards: [
      {
        tag: 'unseen-det 0.6.0',
        title: 'ANE / GPU 저전력 고속 감지',
        description:
          '내장된 경량 FP16 가중치가 Apple Neural Engine(ANE / NPU, CoreML)과 Android 모바일 GPU(LiteRT)에서 실행되어 배터리 소모가 적고 밀리초 단위로 빠르게 동작합니다. OCR이나 사전·정규식 매칭 없이 18개 개인정보 유형과 YuNet 얼굴을 직접 감지합니다.',
      },
      {
        tag: '5가지 스타일',
        title: '복원 불가능한 픽셀 덮어쓰기',
        description:
          '단색, 배경색, 회색 모자이크, 컬러 모자이크, 노이즈 중에서 선택하세요. 모든 스타일은 가려진 영역 내부의 원본 픽셀을 읽지 않아 모자이크 해제나 블러 복원을 원천 차단합니다.',
      },
      {
        tag: '자체 점검',
        title: '내보내기 전 재검사',
        description:
          '저장하거나 공유하기 전에 마스킹된 결과물에 감지기를 다시 실행해 가려지지 않고 남은 영역을 찾아냅니다.',
      },
      {
        tag: '일괄 처리 및 적응형',
        title: '일괄 마스킹 및 로컬 학습',
        description:
          '여러 스크린샷을 한 번에 열어 전체 이미지에서 유사 영역을 찾고, 기기 내 선호도 학습을 통해 선택 습관에 맞게 임계값을 자동 조정합니다.',
      },
      {
        tag: '즉시 편집기 실행',
        title: '길게 눌러 비교, 복사 및 OS 공유',
        description:
          '실행 즉시 편집 화면으로 진입합니다. 눈 모양 배지를 길게 눌러 원본과 비교하고, 클립보드로 바로 복사하거나 공유, 연결 프로그램, 드래그 앤 드롭으로 파일을 불러오세요.',
      },
      {
        tag: 'Rust 코어 + CLI',
        title: '스크립트 가능한 unseen CLI',
        description:
          '공용 unseen-core 엔진이 Flutter 앱과 독립 실행형 CLI를 모두 구동해 일괄 마스킹과 BLAKE3 모델 검증을 지원합니다.',
      },
    ],
    classesTitle: '지원하는 19가지 유형',
  },
  privacy: {
    title: '네트워크 제로. 사진 보관함 읽기 권한 제로.',
    factors: [
      {
        tag: '오프라인 바이너리',
        title: '앱 내 네트워크 코드 완전 제거',
        description:
          '앱에 모델 가중치가 기본 내장되어 있으며 HTTP 클라이언트, 분석 SDK, 충돌 리포터, 네트워크 권한이 전혀 포함되지 않습니다. CI가 매 빌드마다 네트워크 의존성 제로를 검증합니다.',
      },
      {
        tag: '시스템 선택기 전용',
        title: '사진 보관함 읽기 권한 미요구',
        description:
          'iOS는 별도 프로세스의 PHPickerViewController와 쓰기 전용 .addOnly 저장만 사용합니다. Android는 시스템 Photo Picker를 사용하며 릴리스 매니페스트에서 전이 권한을 제거합니다.',
      },
    ],
    tableColArea: '경계',
    tableColDetail: '구현 방식',
    rows: [
      {
        area: '이미지 처리',
        detail:
          '감지, EXIF 방향 보정, 픽셀 덮어쓰기 모두 FFI를 통해 로컬 Rust(unseen-core)에서 실행됩니다.',
      },
      {
        area: '마스킹 비가역성',
        detail:
          '단색, 회색 모자이크, 노이즈는 원본 픽셀을 전혀 읽지 않습니다. 배경색과 컬러 모자이크는 박스 바깥 4 px 테두리만 샘플링합니다.',
      },
      {
        area: '선택적 감지 피드백',
        detail:
          '미탐지 또는 오탐지 사례를 제보하면 URL #fragment를 통해 시스템 브라우저에서 mosaic.lollipopkit.com/feedback이 열립니다. fragment는 HTTP GET 로그에 남지 않으며 history.replaceState로 즉시 제거됩니다.',
      },
      {
        area: '재현 가능한 오픈소스',
        detail:
          '앱, Rust 코어, 피드백 워커, 배포 모델 가중치 모두 BLAKE3 체크섬과 함께 AGPL-3.0 라이선스로 공개됩니다.',
      },
    ],
  },
  download: {
    title: '모바일과 데스크톱 네이티브 지원.',
    currentBadge: '현재 플랫폼',
    releasesAction: 'GitHub 릴리스',
    sourceAction: '소스에서 빌드',
    cliPrompt: '# Rust CLI(unseen) 빌드',
    appPrompt: '# 소스에서 Flutter 앱 실행',
    copy: '복사',
    copied: '복사됨',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · 릴리스 권한 제로' },
      linux: { name: 'Linux', meta: '데스크톱 앱(tar.gz) 및 unseen CLI' },
      windows: { name: 'Windows', meta: '데스크톱 앱(ZIP) 및 unseen CLI' },
    },
  },
  cta: {
    title: 'AGPL-3.0 오픈소스.',
    feedbackAction: '웹 피드백 열기',
    releasesAction: 'GitHub 릴리스',
    githubAction: '소스 보기',
  },
  more: {
    title: 'lollipopkit의 다른 앱.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          '서버 상태 모니터링, 터치 친화적 SSH 터미널, SFTP, Docker, systemd, S.M.A.R.T. 도구를 하나의 네이티브 워크스페이스에 담았습니다.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          '커널 확장 없이 Apple File Provider를 통해 macOS Finder에 SFTP, S3, WebDAV 등 원격 저장소를 마운트합니다.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          '로컬 우선 대화 기록, 도구 호출, 사용자 지정 엔드포인트를 지원하는 OpenAI 및 호환 LLM API용 네이티브 클라이언트입니다.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: '기능',
    privacy: '개인정보 보호',
    download: '다운로드',
    feedback: '피드백',
    releases: '릴리스',
    license: 'AGPL-3.0',
  },
};
