// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_qr_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CurrentQrDtoCWProxy {
  CurrentQrDto qrUrl(String? qrUrl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CurrentQrDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CurrentQrDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CurrentQrDto call({String? qrUrl});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCurrentQrDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCurrentQrDto.copyWith.fieldName(...)`
class _$CurrentQrDtoCWProxyImpl implements _$CurrentQrDtoCWProxy {
  const _$CurrentQrDtoCWProxyImpl(this._value);

  final CurrentQrDto _value;

  @override
  CurrentQrDto qrUrl(String? qrUrl) => this(qrUrl: qrUrl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CurrentQrDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CurrentQrDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CurrentQrDto call({Object? qrUrl = const $CopyWithPlaceholder()}) {
    return CurrentQrDto(
      qrUrl: qrUrl == const $CopyWithPlaceholder()
          ? _value.qrUrl
          // ignore: cast_nullable_to_non_nullable
          : qrUrl as String?,
    );
  }
}

extension $CurrentQrDtoCopyWith on CurrentQrDto {
  /// Returns a callable class that can be used as follows: `instanceOfCurrentQrDto.copyWith(...)` or like so:`instanceOfCurrentQrDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CurrentQrDtoCWProxy get copyWith => _$CurrentQrDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentQrDto _$CurrentQrDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CurrentQrDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['qrUrl']);
      final val = CurrentQrDto(
        qrUrl: $checkedConvert('qrUrl', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CurrentQrDtoToJson(CurrentQrDto instance) =>
    <String, dynamic>{'qrUrl': instance.qrUrl};
