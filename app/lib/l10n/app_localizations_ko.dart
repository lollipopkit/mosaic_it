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
  String get appearance => '모양';

  @override
  String get theme => '테마';

  @override
  String get appIcon => '앱 아이콘';

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
    return '$selected / $total 선택됨';
  }

  @override
  String get fillStyle => '채우기 스타일';

  @override
  String get colour => '색상';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '이미지 $images장',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '영역 $regions개',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => '공유';

  @override
  String get saveToPhotos => '사진에 저장';

  @override
  String get saveAs => '저장…';

  @override
  String get exportFormat => '형식';

  @override
  String get exportSize => '크기';

  @override
  String get sizeOriginal => '원본';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '이미지 $count장을 사진에 저장했습니다',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => '전체';

  @override
  String get selectNone => '없음';

  @override
  String get suggested => '추천';

  @override
  String scoreValue(String score) {
    return '점수 $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return '마스킹 후에도 검사에서 이미지 $index의 출력물에 이 영역들이 여전히 발견되었습니다.';
  }

  @override
  String get reasonNotSelected => '선택되지 않음';

  @override
  String get reasonBoxTooSmall => '영역이 너무 작음';

  @override
  String get reasonFillShowsThrough => '채우기가 비쳐 보임';

  @override
  String get openSource => '오픈소스';

  @override
  String get adaptivePreselectTitle => '기기 내 적응형 사전 선택';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 클래스 조정됨',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => '로컬 환경설정 초기화';

  @override
  String get adaptiveResetDone => '로컬 환경설정이 초기화되었습니다';

  @override
  String get feedbackTitle => '감지 문제 신고';

  @override
  String get feedbackShort => '피드백';

  @override
  String get feedbackMenu => '문제 신고';

  @override
  String get feedbackAction => '신고';

  @override
  String get feedbackAttachScreenshot => '스크린샷 첨부';

  @override
  String get feedbackModeMasked => '오류 영역만';

  @override
  String get feedbackModeFull => '전체 이미지';

  @override
  String get feedbackModeText => '이미지 없음';

  @override
  String get feedbackTagMissed => '미감지';

  @override
  String get feedbackTagFalsePositive => '오탐';

  @override
  String get feedbackTagBoxDrift => '영역 어긋남';

  @override
  String get feedbackTagWrongClass => '잘못된 클래스';

  @override
  String get feedbackTagOther => '기타';

  @override
  String get feedbackNoteHint => '메모 (선택)…';

  @override
  String feedbackCountMasked(int count) {
    return '마스킹됨 $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return '미감지 $count';
  }

  @override
  String feedbackCountFp(int count) {
    return '오탐 $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return '선택 해제 $count';
  }

  @override
  String get feedbackBoxMissed => '미감지';

  @override
  String get feedbackBoxMissedMasked => '미감지 · 마스킹됨';

  @override
  String get feedbackBoxFp => '오탐';

  @override
  String get feedbackBoxPreference => '표시 유지';

  @override
  String get introOfflineTitle => '네트워크 기능 없음';

  @override
  String get introOfflineBody =>
      'MosaicIt에는 네트워크 코드가 없으며 네트워크 권한도 요청하지 않습니다. 감지 모델이 앱에 내장되어 있어 이미지가 기기 밖으로 전송되지 않습니다.';

  @override
  String get introNoNetPermTitle => '네트워크 권한 없음';

  @override
  String get introBundledModelTitle => '내장 온디바이스 모델';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · 기기 내장';
  }

  @override
  String get resetBundledModel => '내장 모델로 복원';

  @override
  String get reviewIntro => '소개 다시 보기';

  @override
  String get feedbackOpenWeb => '브라우저에서 제출';

  @override
  String get introNoNetPermBodyIos => '네트워크 요청 없음 · 기기 내 처리';

  @override
  String get introNoNetPermBodyAndroid => 'INTERNET 권한 미선언';

  @override
  String get introNoNetPermBodyDesktop => '샌드박스에 네트워크 권한 없음';

  @override
  String get customModel => '사용자 지정 모델';

  @override
  String modelClassCount(int count) {
    return '$count개 클래스';
  }

  @override
  String get copyImage => '이미지 복사';

  @override
  String get copiedToClipboard => '클립보드에 복사됨';

  @override
  String get copyFailed => '이미지를 복사할 수 없음';

  @override
  String get peekOriginal => '길게 눌러 원본 비교';

  @override
  String get selectMedia => '사진 선택';

  @override
  String get saveFailed => '사진에 저장하지 못했습니다';

  @override
  String get retry => '다시 시도';

  @override
  String get iosWirelessPromptTitle => '무선 데이터 안내';

  @override
  String get iosWirelessPromptBody =>
      '시스템 사진 선택기를 열 때 iCloud 썸네일로 인해 iOS 무선 데이터 허용 창이 뜰 수 있습니다. MosaicIt은 네트워크를 사용하지 않으므로 ‘허용 안 함’을 선택하세요.';

  @override
  String get continueAction => '계속';
}
