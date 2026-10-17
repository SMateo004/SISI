//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_jobs_controller_resolve200_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminJobsControllerResolve200Response {
  /// Returns a new [AdminJobsControllerResolve200Response] instance.
  AdminJobsControllerResolve200Response({

     this.status,
  });

  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final String? status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminJobsControllerResolve200Response &&
      other.status == status;

    @override
    int get hashCode =>
        status.hashCode;

  factory AdminJobsControllerResolve200Response.fromJson(Map<String, dynamic> json) => _$AdminJobsControllerResolve200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdminJobsControllerResolve200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

