//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cancellation_count_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CancellationCountDto {
  /// Returns a new [CancellationCountDto] instance.
  CancellationCountDto({

    required  this.reason,

    required  this.count,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



  @JsonKey(
    
    name: r'count',
    required: true,
    includeIfNull: false,
  )


  final num count;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CancellationCountDto &&
      other.reason == reason &&
      other.count == count;

    @override
    int get hashCode =>
        reason.hashCode +
        count.hashCode;

  factory CancellationCountDto.fromJson(Map<String, dynamic> json) => _$CancellationCountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CancellationCountDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

