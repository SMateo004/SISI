//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_photo_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RequestPhotoDto {
  /// Returns a new [RequestPhotoDto] instance.
  RequestPhotoDto({

    required  this.id,

    required  this.position,

    required  this.url,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'position',
    required: true,
    includeIfNull: false,
  )


  final num position;



      /// URL temporal (1 h)
  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: false,
  )


  final String url;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RequestPhotoDto &&
      other.id == id &&
      other.position == position &&
      other.url == url;

    @override
    int get hashCode =>
        id.hashCode +
        position.hashCode +
        url.hashCode;

  factory RequestPhotoDto.fromJson(Map<String, dynamic> json) => _$RequestPhotoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RequestPhotoDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

