// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_read_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MarkReadResultDtoCWProxy {
  MarkReadResultDto updated(num updated);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MarkReadResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MarkReadResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MarkReadResultDto call({num updated});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMarkReadResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMarkReadResultDto.copyWith.fieldName(...)`
class _$MarkReadResultDtoCWProxyImpl implements _$MarkReadResultDtoCWProxy {
  const _$MarkReadResultDtoCWProxyImpl(this._value);

  final MarkReadResultDto _value;

  @override
  MarkReadResultDto updated(num updated) => this(updated: updated);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MarkReadResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MarkReadResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MarkReadResultDto call({Object? updated = const $CopyWithPlaceholder()}) {
    return MarkReadResultDto(
      updated: updated == const $CopyWithPlaceholder()
          ? _value.updated
          // ignore: cast_nullable_to_non_nullable
          : updated as num,
    );
  }
}

extension $MarkReadResultDtoCopyWith on MarkReadResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfMarkReadResultDto.copyWith(...)` or like so:`instanceOfMarkReadResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MarkReadResultDtoCWProxy get copyWith =>
      _$MarkReadResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkReadResultDto _$MarkReadResultDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MarkReadResultDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['updated']);
      final val = MarkReadResultDto(
        updated: $checkedConvert('updated', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$MarkReadResultDtoToJson(MarkReadResultDto instance) =>
    <String, dynamic>{'updated': instance.updated};
