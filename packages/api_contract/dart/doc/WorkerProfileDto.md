# sisi_api.model.WorkerProfileDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **String** |  | 
**rejectionReason** | **String** |  | [optional] 
**birthDate** | **String** |  | [optional] 
**transport** | **String** |  | [optional] 
**maxRadiusKm** | **num** |  | [optional] 
**categoryIds** | **List&lt;String&gt;** |  | 
**documents** | [**List&lt;WorkerDocumentStatusDto&gt;**](WorkerDocumentStatusDto.md) | Estado de cada documento. Nunca incluye la imagen (R9.5). | 
**submittedAt** | **String** |  | [optional] 
**editable** | **bool** | Puede editar documentos y enviar la solicitud | 
**missingDocuments** | **List&lt;String&gt;** | Documentos que faltan subir | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


