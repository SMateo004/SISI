//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_row_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReportRowDto {
  /// Returns a new [ReportRowDto] instance.
  ReportRowDto({

    required  this.id,

    required  this.targetType,

    required  this.reason,

    required  this.status,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'targetType',
    required: true,
    includeIfNull: false,
  )


  final String targetType;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReportRowDto &&
      other.id == id &&
      other.targetType == targetType &&
      other.reason == reason &&
      other.status == status &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        targetType.hashCode +
        reason.hashCode +
        status.hashCode +
        createdAt.hashCode;

  factory ReportRowDto.fromJson(Map<String, dynamic> json) => _$ReportRowDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportRowDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

