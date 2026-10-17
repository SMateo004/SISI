// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_jobs_controller_resolve200_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminJobsControllerResolve200ResponseCWProxy {
  AdminJobsControllerResolve200Response status(String? status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobsControllerResolve200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobsControllerResolve200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobsControllerResolve200Response call({String? status});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminJobsControllerResolve200Response.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminJobsControllerResolve200Response.copyWith.fieldName(...)`
class _$AdminJobsControllerResolve200ResponseCWProxyImpl
    implements _$AdminJobsControllerResolve200ResponseCWProxy {
  const _$AdminJobsControllerResolve200ResponseCWProxyImpl(this._value);

  final AdminJobsControllerResolve200Response _value;

  @override
  AdminJobsControllerResolve200Response status(String? status) =>
      this(status: status);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobsControllerResolve200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobsControllerResolve200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobsControllerResolve200Response call({
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return AdminJobsControllerResolve200Response(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String?,
    );
  }
}

extension $AdminJobsControllerResolve200ResponseCopyWith
    on AdminJobsControllerResolve200Response {
  /// Returns a callable class that can be used as follows: `instanceOfAdminJobsControllerResolve200Response.copyWith(...)` or like so:`instanceOfAdminJobsControllerResolve200Response.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminJobsControllerResolve200ResponseCWProxy get copyWith =>
      _$AdminJobsControllerResolve200ResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminJobsControllerResolve200Response
_$AdminJobsControllerResolve200ResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminJobsControllerResolve200Response', json, (
      $checkedConvert,
    ) {
      final val = AdminJobsControllerResolve200Response(
        status: $checkedConvert('status', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AdminJobsControllerResolve200ResponseToJson(
  AdminJobsControllerResolve200Response instance,
) => <String, dynamic>{'status': ?instance.status};
