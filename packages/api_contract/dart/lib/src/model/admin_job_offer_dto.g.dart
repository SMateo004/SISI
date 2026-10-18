// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_job_offer_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminJobOfferDtoCWProxy {
  AdminJobOfferDto id(String id);

  AdminJobOfferDto worker(AdminJobPartyDto worker);

  AdminJobOfferDto status(String status);

  AdminJobOfferDto chosen(bool chosen);

  AdminJobOfferDto history(List<AdminOfferEventDto> history);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobOfferDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobOfferDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobOfferDto call({
    String id,
    AdminJobPartyDto worker,
    String status,
    bool chosen,
    List<AdminOfferEventDto> history,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminJobOfferDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminJobOfferDto.copyWith.fieldName(...)`
class _$AdminJobOfferDtoCWProxyImpl implements _$AdminJobOfferDtoCWProxy {
  const _$AdminJobOfferDtoCWProxyImpl(this._value);

  final AdminJobOfferDto _value;

  @override
  AdminJobOfferDto id(String id) => this(id: id);

  @override
  AdminJobOfferDto worker(AdminJobPartyDto worker) => this(worker: worker);

  @override
  AdminJobOfferDto status(String status) => this(status: status);

  @override
  AdminJobOfferDto chosen(bool chosen) => this(chosen: chosen);

  @override
  AdminJobOfferDto history(List<AdminOfferEventDto> history) =>
      this(history: history);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobOfferDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobOfferDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobOfferDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? worker = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? chosen = const $CopyWithPlaceholder(),
    Object? history = const $CopyWithPlaceholder(),
  }) {
    return AdminJobOfferDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      worker: worker == const $CopyWithPlaceholder()
          ? _value.worker
          // ignore: cast_nullable_to_non_nullable
          : worker as AdminJobPartyDto,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      chosen: chosen == const $CopyWithPlaceholder()
          ? _value.chosen
          // ignore: cast_nullable_to_non_nullable
          : chosen as bool,
      history: history == const $CopyWithPlaceholder()
          ? _value.history
          // ignore: cast_nullable_to_non_nullable
          : history as List<AdminOfferEventDto>,
    );
  }
}

extension $AdminJobOfferDtoCopyWith on AdminJobOfferDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminJobOfferDto.copyWith(...)` or like so:`instanceOfAdminJobOfferDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminJobOfferDtoCWProxy get copyWith => _$AdminJobOfferDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminJobOfferDto _$AdminJobOfferDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminJobOfferDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'worker', 'status', 'chosen', 'history'],
      );
      final val = AdminJobOfferDto(
        id: $checkedConvert('id', (v) => v as String),
        worker: $checkedConvert(
          'worker',
          (v) => AdminJobPartyDto.fromJson(v as Map<String, dynamic>),
        ),
        status: $checkedConvert('status', (v) => v as String),
        chosen: $checkedConvert('chosen', (v) => v as bool),
        history: $checkedConvert(
          'history',
          (v) => (v as List<dynamic>)
              .map(
                (e) => AdminOfferEventDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminJobOfferDtoToJson(AdminJobOfferDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'worker': instance.worker.toJson(),
      'status': instance.status,
      'chosen': instance.chosen,
      'history': instance.history.map((e) => e.toJson()).toList(),
    };
