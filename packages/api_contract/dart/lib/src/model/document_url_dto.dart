//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_url_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentUrlDto {
  /// Returns a new [DocumentUrlDto] instance.
  DocumentUrlDto({

    required  this.url,

    required  this.expiresAt,
  });

      /// Enlace temporal (5 min)
  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: false,
  )


  final String url;



  @JsonKey(
    
    name: r'expiresAt',
    required: true,
    includeIfNull: false,
  )


  final String expiresAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DocumentUrlDto &&
      other.url == url &&
      other.expiresAt == expiresAt;

    @override
    int get hashCode =>
        url.hashCode +
        expiresAt.hashCode;

  factory DocumentUrlDto.fromJson(Map<String, dynamic> json) => _$DocumentUrlDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentUrlDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

