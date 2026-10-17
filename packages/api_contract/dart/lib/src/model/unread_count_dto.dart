//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'unread_count_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UnreadCountDto {
  /// Returns a new [UnreadCountDto] instance.
  UnreadCountDto({

    required  this.count,
  });

      /// Avisos sin leer (para el contador del ícono)
  @JsonKey(
    
    name: r'count',
    required: true,
    includeIfNull: false,
  )


  final num count;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UnreadCountDto &&
      other.count == count;

    @override
    int get hashCode =>
        count.hashCode;

  factory UnreadCountDto.fromJson(Map<String, dynamic> json) => _$UnreadCountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UnreadCountDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

