//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_qr_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SetQrDto {
  /// Returns a new [SetQrDto] instance.
  SetQrDto({

    required  this.key,
  });

      /// Clave devuelta por qr/upload-url, después del PUT
  @JsonKey(
    
    name: r'key',
    required: true,
    includeIfNull: false,
  )


  final String key;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SetQrDto &&
      other.key == key;

    @override
    int get hashCode =>
        key.hashCode;

  factory SetQrDto.fromJson(Map<String, dynamic> json) => _$SetQrDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SetQrDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

