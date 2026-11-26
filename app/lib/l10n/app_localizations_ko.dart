// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => '모델 로딩 중…';

  @override
  String get modelFileType => '모델';

  @override
  String get useModel => '모델 사용';

  @override
  String get imagesFileType => '이미지';

  @override
  String get detecting => '감지 중…';

  @override
  String detectingProgress(int current, int total) {
    return '$current/$total 감지 중…';
  }

  @override
  String get chooseModelFirst => '먼저 모델을 선택하세요';

  @override
  String get findingSimilar => '유사 항목 검색 중…';

  @override
  String similarSelected(int found, int added) {
    return '유사 영역 $found개 선택됨 (새로 추가 $added개)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$images개 이미지에서 유사 영역 $found개 선택됨 (새로 추가 $added개)';
  }

  @override
  String get saving => '저장 중…';

  @override
  String get exportHere => '여기로 내보내기';

  @override
  String exportStoppedAt(String name) {
    return '$name에서 내보내기 중단됨';
  }

  @override
  String exportedTo(String path) {
    return '$path(으)로 내보내기 완료';
  }

  @override
  String exportedToNoAudio(String path) {
    return '$path(으)로 내보내기 완료 (오디오 없음)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '이미지 $count개 내보내기 완료',
      one: '이미지 1개 내보내기 완료',
      zero: '이미지 0개 내보내기 완료',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name 확인 중…';
  }

  @override
  String get checkingAndExporting => '확인 및 내보내기 중…';

  @override
  String get cancel => '취소';

  @override
  String get exportAnyway => '그래도 내보내기';

  @override
  String get regionsTooltip => '영역';

  @override
  String get notCalibrated => '모델이 보정되지 않았습니다: 사전 선택에 고정 임계값이 사용됩니다.';

  @override
  String calibratedUnverified(String domain) {
    return '검증되지 않은 데이터($domain)로 보정됨: 재현율 보증이 아직 적용되지 않습니다.';
  }

  @override
  String calibratedFor(String domain) {
    return '$domain 이미지에 대해 보정됨. 다른 유형의 이미지는 보증 범위 밖입니다.';
  }

  @override
  String get cameraPhoto =>
      '이것은 카메라 사진입니다. 감지기는 스크린샷용으로 만들어졌으므로 여기의 박스는 신뢰할 수 없습니다.';

  @override
  String get modeDraw => '그리기';

  @override
  String get fillSolid => '단색';

  @override
  String get fillBlocks => '회색 모자이크';

  @override
  String get fillNoise => '노이즈';

  @override
  String get export => '내보내기';

  @override
  String pickOneModel(String formats) {
    return '$formats 모델을 정확히 하나 선택하세요';
  }

  @override
  String pickSidecar(String name) {
    return '$name.json도 선택하세요';
  }

  @override
  String get analysing => '분석 중';

  @override
  String get followingRegion => '영역 추적 중';

  @override
  String get exporting => '내보내기 중';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count프레임';
  }

  @override
  String redactingSpan(String start, String end) {
    return '$start – $end 구간 마스킹 중';
  }

  @override
  String exportCheckFailedAt(String time) {
    return '$time에 내보내기 확인 실패';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '거기에 개인 정보로 보이는 영역 $count개가 여전히 보입니다 ($classes).',
      one: '거기에 개인 정보로 보이는 영역 1개가 여전히 보입니다 ($classes).',
      zero: '거기에 개인 정보로 보이는 영역이 없습니다.',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => '프레임 표시';

  @override
  String get drawMissedRegion => '감지기가 놓친 영역 그리기';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '트랙 $total개 중 $on개 마스킹됨 · $keyframes개 키프레임';
  }

  @override
  String get keepAudio => '오디오 유지';

  @override
  String get keepAudioHint => '목소리와 알림음은 확인되지 않습니다';

  @override
  String get goToFirstAppearance => '첫 등장으로 이동';

  @override
  String get classPersonName => '이름';

  @override
  String get classAddress => '주소';

  @override
  String get classPhone => '전화번호';

  @override
  String get classEmail => '이메일';

  @override
  String get classIdNumber => '신분증 번호';

  @override
  String get classBankCard => '은행 카드';

  @override
  String get classPlate => '번호판';

  @override
  String get classAccountId => '계정';

  @override
  String get classAvatar => '아바타';

  @override
  String get classFace => '얼굴';

  @override
  String get classQr => 'QR 코드';

  @override
  String get classBarcode => '바코드';

  @override
  String get classManual => '수동';

  @override
  String savedModelFailed(String error) {
    return '저장된 모델을 불러올 수 없습니다. 모델을 다시 선택하세요. ($error)';
  }

  @override
  String get fillSurround => '배경색';

  @override
  String get fillTinted => '컬러 모자이크';

  @override
  String get settings => '설정';

  @override
  String get classFinance => '금액';

  @override
  String get delete => '삭제';

  @override
  String get undo => '실행 취소';

  @override
  String get redo => '다시 실행';

  @override
  String get similar => '유사';

  @override
  String get thisImage => '이 이미지';

  @override
  String allImagesCount(int count) {
    return '모든 $count개 이미지';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 영역이 여전히 읽을 수 있음',
      one: '1개 영역이 여전히 읽을 수 있음',
      zero: '0개 영역',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody => '마스킹 후에도 검사에서 출력물에 이 영역들이 여전히 발견되었습니다.';

  @override
  String get redactThemAndExport => '마스킹 후 내보내기';

  @override
  String get showThem => '표시';

  @override
  String get pickClass => '클래스 선택';

  @override
  String get filterScreenshots => '스크린샷';

  @override
  String get filterAll => '모두';

  @override
  String get filterVideos => '동영상';

  @override
  String get albums => '앨범';

  @override
  String get limitedAccess => 'MosaicIt은 일부 사진만 볼 수 있습니다';

  @override
  String get manage => '관리';

  @override
  String selectedImages(int count) {
    return '$count개 선택됨';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 이미지 마스킹',
      one: '1개 이미지 마스킹',
      zero: '0개 이미지 마스킹',
    );
    return '$_temp0';
  }

  @override
  String get badgeRedacted => '마스킹됨';

  @override
  String get photosDenied =>
      'MosaicIt은 여기에 사진을 표시하려면 사진 접근 권한이 필요합니다. 사진은 이 기기를 절대 나가지 않습니다.';

  @override
  String get openSettings => '설정 열기';

  @override
  String get openFiles => '파일 열기';

  @override
  String get noPhotos => '여기에는 사진이 없습니다';

  @override
  String get loading => '로딩 중…';

  @override
  String get appearance => '모양';

  @override
  String get theme => '테마';

  @override
  String get appIcon => '앱 아이콘';

  @override
  String get aspectRatioGrid => '원본 비율 격자';

  @override
  String get modelDownloadFailed => '모델을 다운로드할 수 없습니다';

  @override
  String get retry => '다시 시도';

  @override
  String get autoUpdateModel => '모델 자동 업데이트';

  @override
  String get threshold => '임계값';

  @override
  String get thresholdLow => '낮음';

  @override
  String get thresholdMedium => '중간';

  @override
  String get thresholdHigh => '높음';

  @override
  String get redaction => '마스킹';

  @override
  String get style => '스타일';

  @override
  String get selectedByDefault => '기본 선택';

  @override
  String get dataPrivacy => '데이터 및 개인정보';

  @override
  String get model => '모델';

  @override
  String get importModel => '다른 모델 가져오기';

  @override
  String get advanced => '고급';

  @override
  String get about => '정보';

  @override
  String get licenses => '오픈소스 라이선스';

  @override
  String get merge => '병합';

  @override
  String get split => '분할';

  @override
  String get mergeHint => '같은 값의 일부로 만들려면 다른 박스를 탭하세요';

  @override
  String get classOrganization => '단체명';

  @override
  String get classDeviceId => '기기 ID';

  @override
  String get classSecret => '비밀 정보';

  @override
  String get classPerson => '인물';

  @override
  String get classHealth => '건강';

  @override
  String get classPersonalInfo => '개인 정보';

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
  String get feedbackSubmit => 'Submit';

  @override
  String get feedbackDone => 'Done';

  @override
  String get feedbackSentTitle => 'Feedback sent';

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
}
