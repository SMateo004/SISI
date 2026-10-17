// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportDtoCWProxy {
  ReportDto id(String id);

  ReportDto targetType(ReportDtoTargetTypeEnum targetType);

  ReportDto targetId(String targetId);

  ReportDto reason(ReportDtoReasonEnum reason);

  ReportDto status(ReportDtoStatusEnum status);

  ReportDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportDto call({
    String id,
    ReportDtoTargetTypeEnum targetType,
    String targetId,
    ReportDtoReasonEnum reason,
    ReportDtoStatusEnum status,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReportDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReportDto.copyWith.fieldName(...)`
class _$ReportDtoCWProxyImpl implements _$ReportDtoCWProxy {
  const _$ReportDtoCWProxyImpl(this._value);

  final ReportDto _value;

  @override
  ReportDto id(String id) => this(id: id);

  @override
  ReportDto targetType(ReportDtoTargetTypeEnum targetType) =>
      this(targetType: targetType);

  @override
  ReportDto targetId(String targetId) => this(targetId: targetId);

  @override
  ReportDto reason(ReportDtoReasonEnum reason) => this(reason: reason);

  @override
  ReportDto status(ReportDtoStatusEnum status) => this(status: status);

  @override
  ReportDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? targetType = const $CopyWithPlaceholder(),
    Object? targetId = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return ReportDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      targetType: targetType == const $CopyWithPlaceholder()
          ? _value.targetType
          // ignore: cast_nullable_to_non_nullable
          : targetType as ReportDtoTargetTypeEnum,
      targetId: targetId == const $CopyWithPlaceholder()
          ? _value.targetId
          // ignore: cast_nullable_to_non_nullable
          : targetId as String,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as ReportDtoReasonEnum,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ReportDtoStatusEnum,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $ReportDtoCopyWith on ReportDto {
  /// Returns a callable class that can be used as follows: `instanceOfReportDto.copyWith(...)` or like so:`instanceOfReportDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportDtoCWProxy get copyWith => _$ReportDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDto _$ReportDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReportDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'targetType',
          'targetId',
          'reason',
          'status',
          'createdAt',
        ],
      );
      final val = ReportDto(
        id: $checkedConvert('id', (v) => v as String),
        targetType: $checkedConvert(
          'targetType',
          (v) => $enumDecode(_$ReportDtoTargetTypeEnumEnumMap, v),
        ),
        targetId: $checkedConvert('targetId', (v) => v as String),
        reason: $checkedConvert(
          'reason',
          (v) => $enumDecode(_$ReportDtoReasonEnumEnumMap, v),
        ),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$ReportDtoStatusEnumEnumMap, v),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReportDtoToJson(ReportDto instance) => <String, dynamic>{
  'id': instance.id,
  'targetType': _$ReportDtoTargetTypeEnumEnumMap[instance.targetType]!,
  'targetId': instance.targetId,
  'reason': _$ReportDtoReasonEnumEnumMap[instance.reason]!,
  'status': _$ReportDtoStatusEnumEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$ReportDtoTargetTypeEnumEnumMap = {
  ReportDtoTargetTypeEnum.request: 'request',
  ReportDtoTargetTypeEnum.user: 'user',
  ReportDtoTargetTypeEnum.chatMessage: 'chat_message',
  ReportDtoTargetTypeEnum.job: 'job',
};

const _$ReportDtoReasonEnumEnumMap = {
  ReportDtoReasonEnum.serviciosSexuales: 'servicios_sexuales',
  ReportDtoReasonEnum.drogas: 'drogas',
  ReportDtoReasonEnum.armas: 'armas',
  ReportDtoReasonEnum.ilegal: 'ilegal',
  ReportDtoReasonEnum.inmoral: 'inmoral',
  ReportDtoReasonEnum.ventaProductos: 'venta_productos',
  ReportDtoReasonEnum.acoso: 'acoso',
  ReportDtoReasonEnum.fraude: 'fraude',
  ReportDtoReasonEnum.noSePresento: 'no_se_presento',
  ReportDtoReasonEnum.suplantacion: 'suplantacion',
  ReportDtoReasonEnum.otro: 'otro',
};

const _$ReportDtoStatusEnumEnumMap = {
  ReportDtoStatusEnum.pendiente: 'pendiente',
  ReportDtoStatusEnum.valido: 'valido',
  ReportDtoStatusEnum.descartado: 'descartado',
};
