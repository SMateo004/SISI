//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mark_read_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MarkReadDto {
  /// Returns a new [MarkReadDto] instance.
  MarkReadDto({

    required  this.upToId,
  });

      /// Último mensaje leído (incluido)
  @JsonKey(
    
    name: r'upToId',
    required: true,
    includeIfNull: false,
  )


  final String upToId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MarkReadDto &&
      other.upToId == upToId;

    @override
    int get hashCode =>
        upToId.hashCode;

  factory MarkReadDto.fromJson(Map<String, dynamic> json) => _$MarkReadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MarkReadDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

