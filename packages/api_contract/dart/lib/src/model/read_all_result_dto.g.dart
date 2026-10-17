// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_all_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReadAllResultDtoCWProxy {
  ReadAllResultDto updated(num updated);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReadAllResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReadAllResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReadAllResultDto call({num updated});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReadAllResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReadAllResultDto.copyWith.fieldName(...)`
class _$ReadAllResultDtoCWProxyImpl implements _$ReadAllResultDtoCWProxy {
  const _$ReadAllResultDtoCWProxyImpl(this._value);

  final ReadAllResultDto _value;

  @override
  ReadAllResultDto updated(num updated) => this(updated: updated);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReadAllResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReadAllResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReadAllResultDto call({Object? updated = const $CopyWithPlaceholder()}) {
    return ReadAllResultDto(
      updated: updated == const $CopyWithPlaceholder()
          ? _value.updated
          // ignore: cast_nullable_to_non_nullable
          : updated as num,
    );
  }
}

extension $ReadAllResultDtoCopyWith on ReadAllResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfReadAllResultDto.copyWith(...)` or like so:`instanceOfReadAllResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReadAllResultDtoCWProxy get copyWith => _$ReadAllResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadAllResultDto _$ReadAllResultDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReadAllResultDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['updated']);
      final val = ReadAllResultDto(
        updated: $checkedConvert('updated', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$ReadAllResultDtoToJson(ReadAllResultDto instance) =>
    <String, dynamic>{'updated': instance.updated};
