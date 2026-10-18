//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_row_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JobRowDto {
  /// Returns a new [JobRowDto] instance.
  JobRowDto({

    required  this.id,

    required  this.as_,

    required  this.status,

    required  this.categoryName,

    required  this.finalPriceBs,

    required  this.assignedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'as',
    required: true,
    includeIfNull: false,
  )


  final JobRowDtoAs_Enum as_;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'categoryName',
    required: true,
    includeIfNull: false,
  )


  final String categoryName;



  @JsonKey(
    
    name: r'finalPriceBs',
    required: true,
    includeIfNull: false,
  )


  final String finalPriceBs;



  @JsonKey(
    
    name: r'assignedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime assignedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JobRowDto &&
      other.id == id &&
      other.as_ == as_ &&
      other.status == status &&
      other.categoryName == categoryName &&
      other.finalPriceBs == finalPriceBs &&
      other.assignedAt == assignedAt;

    @override
    int get hashCode =>
        id.hashCode +
        as_.hashCode +
        status.hashCode +
        categoryName.hashCode +
        finalPriceBs.hashCode +
        assignedAt.hashCode;

  factory JobRowDto.fromJson(Map<String, dynamic> json) => _$JobRowDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobRowDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum JobRowDtoAs_Enum {
@JsonValue(r'worker')
worker(r'worker'),
@JsonValue(r'employer')
employer(r'employer');

const JobRowDtoAs_Enum(this.value);

final String value;

@override
String toString() => value;
}


