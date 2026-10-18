// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_category_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationCategoryDtoCWProxy {
  VerificationCategoryDto id(String id);

  VerificationCategoryDto name(String name);

  VerificationCategoryDto extraRequirements(List<String> extraRequirements);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationCategoryDto call({
    String id,
    String name,
    List<String> extraRequirements,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationCategoryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationCategoryDto.copyWith.fieldName(...)`
class _$VerificationCategoryDtoCWProxyImpl
    implements _$VerificationCategoryDtoCWProxy {
  const _$VerificationCategoryDtoCWProxyImpl(this._value);

  final VerificationCategoryDto _value;

  @override
  VerificationCategoryDto id(String id) => this(id: id);

  @override
  VerificationCategoryDto name(String name) => this(name: name);

  @override
  VerificationCategoryDto extraRequirements(List<String> extraRequirements) =>
      this(extraRequirements: extraRequirements);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationCategoryDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? extraRequirements = const $CopyWithPlaceholder(),
  }) {
    return VerificationCategoryDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      extraRequirements: extraRequirements == const $CopyWithPlaceholder()
          ? _value.extraRequirements
          // ignore: cast_nullable_to_non_nullable
          : extraRequirements as List<String>,
    );
  }
}

extension $VerificationCategoryDtoCopyWith on VerificationCategoryDto {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationCategoryDto.copyWith(...)` or like so:`instanceOfVerificationCategoryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationCategoryDtoCWProxy get copyWith =>
      _$VerificationCategoryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationCategoryDto _$VerificationCategoryDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerificationCategoryDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'name', 'extraRequirements']);
  final val = VerificationCategoryDto(
    id: $checkedConvert('id', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    extraRequirements: $checkedConvert(
      'extraRequirements',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$VerificationCategoryDtoToJson(
  VerificationCategoryDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'extraRequirements': instance.extraRequirements,
};
