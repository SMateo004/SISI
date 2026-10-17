// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_report_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateReportDtoCWProxy {
  CreateReportDto targetType(CreateReportDtoTargetTypeEnum targetType);

  CreateReportDto targetId(String targetId);

  CreateReportDto reason(CreateReportDtoReasonEnum reason);

  CreateReportDto note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateReportDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateReportDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateReportDto call({
    CreateReportDtoTargetTypeEnum targetType,
    String targetId,
    CreateReportDtoReasonEnum reason,
    String? note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateReportDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateReportDto.copyWith.fieldName(...)`
class _$CreateReportDtoCWProxyImpl implements _$CreateReportDtoCWProxy {
  const _$CreateReportDtoCWProxyImpl(this._value);

  final CreateReportDto _value;

  @override
  CreateReportDto targetType(CreateReportDtoTargetTypeEnum targetType) =>
      this(targetType: targetType);

  @override
  CreateReportDto targetId(String targetId) => this(targetId: targetId);

  @override
  CreateReportDto reason(CreateReportDtoReasonEnum reason) =>
      this(reason: reason);

  @override
  CreateReportDto note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateReportDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateReportDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateReportDto call({
    Object? targetType = const $CopyWithPlaceholder(),
    Object? targetId = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return CreateReportDto(
      targetType: targetType == const $CopyWithPlaceholder()
          ? _value.targetType
          // ignore: cast_nullable_to_non_nullable
          : targetType as CreateReportDtoTargetTypeEnum,
      targetId: targetId == const $CopyWithPlaceholder()
          ? _value.targetId
          // ignore: cast_nullable_to_non_nullable
          : targetId as String,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as CreateReportDtoReasonEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $CreateReportDtoCopyWith on CreateReportDto {
  /// Returns a callable class that can be used as follows: `instanceOfCreateReportDto.copyWith(...)` or like so:`instanceOfCreateReportDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateReportDtoCWProxy get copyWith => _$CreateReportDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReportDto _$CreateReportDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateReportDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['targetType', 'targetId', 'reason'],
      );
      final val = CreateReportDto(
        targetType: $checkedConvert(
          'targetType',
          (v) => $enumDecode(_$CreateReportDtoTargetTypeEnumEnumMap, v),
        ),
        targetId: $checkedConvert('targetId', (v) => v as String),
        reason: $checkedConvert(
          'reason',
          (v) => $enumDecode(_$CreateReportDtoReasonEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CreateReportDtoToJson(
  CreateReportDto instance,
) => <String, dynamic>{
  'targetType': _$CreateReportDtoTargetTypeEnumEnumMap[instance.targetType]!,
  'targetId': instance.targetId,
  'reason': _$CreateReportDtoReasonEnumEnumMap[instance.reason]!,
  'note': ?instance.note,
};

const _$CreateReportDtoTargetTypeEnumEnumMap = {
  CreateReportDtoTargetTypeEnum.request: 'request',
  CreateReportDtoTargetTypeEnum.user: 'user',
  CreateReportDtoTargetTypeEnum.chatMessage: 'chat_message',
  CreateReportDtoTargetTypeEnum.job: 'job',
};

const _$CreateReportDtoReasonEnumEnumMap = {
  CreateReportDtoReasonEnum.serviciosSexuales: 'servicios_sexuales',
  CreateReportDtoReasonEnum.drogas: 'drogas',
  CreateReportDtoReasonEnum.armas: 'armas',
  CreateReportDtoReasonEnum.ilegal: 'ilegal',
  CreateReportDtoReasonEnum.inmoral: 'inmoral',
  CreateReportDtoReasonEnum.ventaProductos: 'venta_productos',
  CreateReportDtoReasonEnum.acoso: 'acoso',
  CreateReportDtoReasonEnum.fraude: 'fraude',
  CreateReportDtoReasonEnum.noSePresento: 'no_se_presento',
  CreateReportDtoReasonEnum.suplantacion: 'suplantacion',
  CreateReportDtoReasonEnum.otro: 'otro',
};
