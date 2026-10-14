// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mode_denied_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ModeDeniedDtoCWProxy {
  ModeDeniedDto statusCode(num statusCode);

  ModeDeniedDto code(String code);

  ModeDeniedDto message(String message);

  ModeDeniedDto nextAction(ModeDeniedDtoNextActionEnum nextAction);

  ModeDeniedDto actionLabel(String actionLabel);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModeDeniedDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModeDeniedDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ModeDeniedDto call({
    num statusCode,
    String code,
    String message,
    ModeDeniedDtoNextActionEnum nextAction,
    String actionLabel,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfModeDeniedDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfModeDeniedDto.copyWith.fieldName(...)`
class _$ModeDeniedDtoCWProxyImpl implements _$ModeDeniedDtoCWProxy {
  const _$ModeDeniedDtoCWProxyImpl(this._value);

  final ModeDeniedDto _value;

  @override
  ModeDeniedDto statusCode(num statusCode) => this(statusCode: statusCode);

  @override
  ModeDeniedDto code(String code) => this(code: code);

  @override
  ModeDeniedDto message(String message) => this(message: message);

  @override
  ModeDeniedDto nextAction(ModeDeniedDtoNextActionEnum nextAction) =>
      this(nextAction: nextAction);

  @override
  ModeDeniedDto actionLabel(String actionLabel) =>
      this(actionLabel: actionLabel);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModeDeniedDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModeDeniedDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ModeDeniedDto call({
    Object? statusCode = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? nextAction = const $CopyWithPlaceholder(),
    Object? actionLabel = const $CopyWithPlaceholder(),
  }) {
    return ModeDeniedDto(
      statusCode: statusCode == const $CopyWithPlaceholder()
          ? _value.statusCode
          // ignore: cast_nullable_to_non_nullable
          : statusCode as num,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      nextAction: nextAction == const $CopyWithPlaceholder()
          ? _value.nextAction
          // ignore: cast_nullable_to_non_nullable
          : nextAction as ModeDeniedDtoNextActionEnum,
      actionLabel: actionLabel == const $CopyWithPlaceholder()
          ? _value.actionLabel
          // ignore: cast_nullable_to_non_nullable
          : actionLabel as String,
    );
  }
}

extension $ModeDeniedDtoCopyWith on ModeDeniedDto {
  /// Returns a callable class that can be used as follows: `instanceOfModeDeniedDto.copyWith(...)` or like so:`instanceOfModeDeniedDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ModeDeniedDtoCWProxy get copyWith => _$ModeDeniedDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModeDeniedDto _$ModeDeniedDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ModeDeniedDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'statusCode',
          'code',
          'message',
          'nextAction',
          'actionLabel',
        ],
      );
      final val = ModeDeniedDto(
        statusCode: $checkedConvert('statusCode', (v) => v as num),
        code: $checkedConvert('code', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
        nextAction: $checkedConvert(
          'nextAction',
          (v) => $enumDecode(_$ModeDeniedDtoNextActionEnumEnumMap, v),
        ),
        actionLabel: $checkedConvert('actionLabel', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ModeDeniedDtoToJson(ModeDeniedDto instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'code': instance.code,
      'message': instance.message,
      'nextAction': _$ModeDeniedDtoNextActionEnumEnumMap[instance.nextAction]!,
      'actionLabel': instance.actionLabel,
    };

const _$ModeDeniedDtoNextActionEnumEnumMap = {
  ModeDeniedDtoNextActionEnum.COMPLETE_VERIFICATION: 'COMPLETE_VERIFICATION',
  ModeDeniedDtoNextActionEnum.VIEW_REVIEW_STATUS: 'VIEW_REVIEW_STATUS',
  ModeDeniedDtoNextActionEnum.RESUBMIT_VERIFICATION: 'RESUBMIT_VERIFICATION',
  ModeDeniedDtoNextActionEnum.PAY_COMMISSION: 'PAY_COMMISSION',
  ModeDeniedDtoNextActionEnum.CONTACT_SUPPORT: 'CONTACT_SUPPORT',
};
