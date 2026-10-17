// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_qr_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SetQrDtoCWProxy {
  SetQrDto key(String key);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetQrDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetQrDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SetQrDto call({String key});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSetQrDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSetQrDto.copyWith.fieldName(...)`
class _$SetQrDtoCWProxyImpl implements _$SetQrDtoCWProxy {
  const _$SetQrDtoCWProxyImpl(this._value);

  final SetQrDto _value;

  @override
  SetQrDto key(String key) => this(key: key);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetQrDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetQrDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SetQrDto call({Object? key = const $CopyWithPlaceholder()}) {
    return SetQrDto(
      key: key == const $CopyWithPlaceholder()
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
    );
  }
}

extension $SetQrDtoCopyWith on SetQrDto {
  /// Returns a callable class that can be used as follows: `instanceOfSetQrDto.copyWith(...)` or like so:`instanceOfSetQrDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SetQrDtoCWProxy get copyWith => _$SetQrDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetQrDto _$SetQrDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SetQrDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['key']);
      final val = SetQrDto(key: $checkedConvert('key', (v) => v as String));
      return val;
    });

Map<String, dynamic> _$SetQrDtoToJson(SetQrDto instance) => <String, dynamic>{
  'key': instance.key,
};
