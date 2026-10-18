// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_moderation_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TestModerationDtoCWProxy {
  TestModerationDto text(String text);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TestModerationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TestModerationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TestModerationDto call({String text});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTestModerationDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTestModerationDto.copyWith.fieldName(...)`
class _$TestModerationDtoCWProxyImpl implements _$TestModerationDtoCWProxy {
  const _$TestModerationDtoCWProxyImpl(this._value);

  final TestModerationDto _value;

  @override
  TestModerationDto text(String text) => this(text: text);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TestModerationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TestModerationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TestModerationDto call({Object? text = const $CopyWithPlaceholder()}) {
    return TestModerationDto(
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
    );
  }
}

extension $TestModerationDtoCopyWith on TestModerationDto {
  /// Returns a callable class that can be used as follows: `instanceOfTestModerationDto.copyWith(...)` or like so:`instanceOfTestModerationDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TestModerationDtoCWProxy get copyWith =>
      _$TestModerationDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestModerationDto _$TestModerationDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TestModerationDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['text']);
      final val = TestModerationDto(
        text: $checkedConvert('text', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$TestModerationDtoToJson(TestModerationDto instance) =>
    <String, dynamic>{'text': instance.text};
