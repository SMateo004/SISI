// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_job_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CancelJobDtoCWProxy {
  CancelJobDto reason(CancelJobDtoReasonEnum reason);

  CancelJobDto note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancelJobDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancelJobDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CancelJobDto call({CancelJobDtoReasonEnum reason, String? note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCancelJobDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCancelJobDto.copyWith.fieldName(...)`
class _$CancelJobDtoCWProxyImpl implements _$CancelJobDtoCWProxy {
  const _$CancelJobDtoCWProxyImpl(this._value);

  final CancelJobDto _value;

  @override
  CancelJobDto reason(CancelJobDtoReasonEnum reason) => this(reason: reason);

  @override
  CancelJobDto note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancelJobDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancelJobDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CancelJobDto call({
    Object? reason = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return CancelJobDto(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as CancelJobDtoReasonEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $CancelJobDtoCopyWith on CancelJobDto {
  /// Returns a callable class that can be used as follows: `instanceOfCancelJobDto.copyWith(...)` or like so:`instanceOfCancelJobDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CancelJobDtoCWProxy get copyWith => _$CancelJobDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelJobDto _$CancelJobDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CancelJobDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = CancelJobDto(
        reason: $checkedConvert(
          'reason',
          (v) => $enumDecode(_$CancelJobDtoReasonEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CancelJobDtoToJson(CancelJobDto instance) =>
    <String, dynamic>{
      'reason': _$CancelJobDtoReasonEnumEnumMap[instance.reason]!,
      'note': ?instance.note,
    };

const _$CancelJobDtoReasonEnumEnumMap = {
  CancelJobDtoReasonEnum.cambioDePlanes: 'cambio_de_planes',
  CancelJobDtoReasonEnum.noLlegaONoResponde: 'no_llega_o_no_responde',
  CancelJobDtoReasonEnum.desacuerdoDePrecio: 'desacuerdo_de_precio',
  CancelJobDtoReasonEnum.emergencia: 'emergencia',
  CancelJobDtoReasonEnum.otro: 'otro',
};
