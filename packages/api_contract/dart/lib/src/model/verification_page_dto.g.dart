// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationPageDtoCWProxy {
  VerificationPageDto items(List<VerificationRowDto> items);

  VerificationPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationPageDto call({
    List<VerificationRowDto> items,
    String? nextCursor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationPageDto.copyWith.fieldName(...)`
class _$VerificationPageDtoCWProxyImpl implements _$VerificationPageDtoCWProxy {
  const _$VerificationPageDtoCWProxyImpl(this._value);

  final VerificationPageDto _value;

  @override
  VerificationPageDto items(List<VerificationRowDto> items) =>
      this(items: items);

  @override
  VerificationPageDto nextCursor(String? nextCursor) =>
      this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return VerificationPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<VerificationRowDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $VerificationPageDtoCopyWith on VerificationPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationPageDto.copyWith(...)` or like so:`instanceOfVerificationPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationPageDtoCWProxy get copyWith =>
      _$VerificationPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationPageDto _$VerificationPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VerificationPageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = VerificationPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map(
                (e) => VerificationRowDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$VerificationPageDtoToJson(
  VerificationPageDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'nextCursor': instance.nextCursor,
};
