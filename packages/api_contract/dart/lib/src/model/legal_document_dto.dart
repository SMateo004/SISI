//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_document_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LegalDocumentDto {
  /// Returns a new [LegalDocumentDto] instance.
  LegalDocumentDto({

    required  this.type,

    required  this.version,

    required  this.title,

    required  this.contentMd,

    required  this.publishedAt,

    required  this.draft,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final LegalDocumentDtoTypeEnum type;



  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final num version;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



      /// Texto en Markdown
  @JsonKey(
    
    name: r'contentMd',
    required: true,
    includeIfNull: false,
  )


  final String contentMd;



  @JsonKey(
    
    name: r'publishedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime publishedAt;



      /// Sigue pendiente de revisión legal (borrador)
  @JsonKey(
    
    name: r'draft',
    required: true,
    includeIfNull: false,
  )


  final bool draft;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LegalDocumentDto &&
      other.type == type &&
      other.version == version &&
      other.title == title &&
      other.contentMd == contentMd &&
      other.publishedAt == publishedAt &&
      other.draft == draft;

    @override
    int get hashCode =>
        type.hashCode +
        version.hashCode +
        title.hashCode +
        contentMd.hashCode +
        publishedAt.hashCode +
        draft.hashCode;

  factory LegalDocumentDto.fromJson(Map<String, dynamic> json) => _$LegalDocumentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LegalDocumentDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum LegalDocumentDtoTypeEnum {
@JsonValue(r'terms')
terms(r'terms'),
@JsonValue(r'privacy')
privacy(r'privacy');

const LegalDocumentDtoTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


