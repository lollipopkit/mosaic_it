import '../l10n/app_localizations.dart';

/// Localized label of a region class; unknown classes (label sets can carry
/// their own) show as they are.
String classLabel(AppLocalizations l, String c) => switch (c) {
  'person_name' => l.classPersonName,
  'address' => l.classAddress,
  'phone' => l.classPhone,
  'email' => l.classEmail,
  'id_number' => l.classIdNumber,
  'bank_card' => l.classBankCard,
  'plate' => l.classPlate,
  'account_id' => l.classAccountId,
  'avatar' => l.classAvatar,
  'face' => l.classFace,
  'qr' => l.classQr,
  'barcode' => l.classBarcode,
  'finance' => l.classFinance,
  'organization' => l.classOrganization,
  'device_id' => l.classDeviceId,
  'secret' => l.classSecret,
  'manual' => l.classManual,
  _ => c,
};
