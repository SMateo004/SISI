// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$QrResultDtoCWProxy {
  QrResultDto qrUrl(String qrUrl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QrResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QrResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  QrResultDto call({String qrUrl});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfQrResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfQrResultDto.copyWith.fieldName(...)`
class _$QrResultDtoCWProxyImpl implements _$QrResultDtoCWProxy {
  const _$QrResultDtoCWProxyImpl(this._value);

  final QrResultDto _value;

  @override
  QrResultDto qrUrl(String qrUrl) => this(qrUrl: qrUrl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QrResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QrResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  QrResultDto call({Object? qrUrl = const $CopyWithPlaceholder()}) {
    return QrResultDto(
      qrUrl: qrUrl == const $CopyWithPlaceholder()
          ? _value.qrUrl
          // ignore: cast_nullable_to_non_nullable
          : qrUrl as String,
    );
  }
}

extension $QrResultDtoCopyWith on QrResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfQrResultDto.copyWith(...)` or like so:`instanceOfQrResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$QrResultDtoCWProxy get copyWith => _$QrResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrResultDto _$QrResultDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('QrResultDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['qrUrl']);
      final val = QrResultDto(
        qrUrl: $checkedConvert('qrUrl', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$QrResultDtoToJson(QrResultDto instance) =>
    <String, dynamic>{'qrUrl': instance.qrUrl};
