# sisi_api.model.JobDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**requestId** | **String** |  | 
**status** | **String** |  | 
**myRole** | **String** | Mi rol en este trabajo | 
**category** | [**JobCategoryDto**](JobCategoryDto.md) |  | 
**description** | **String** |  | 
**counterpart** | [**JobCounterpartDto**](JobCounterpartDto.md) |  | 
**finalPriceBs** | **String** |  | 
**commissionBs** | **String** | Comisión (R6.3, R8.3). Solo para el trabajador y con el trabajo terminado. | 
**netBs** | **String** | Lo que recibe el trabajador: precio final − comisión. Solo para el trabajador. | 
**timeline** | [**JobTimelineDto**](JobTimelineDto.md) |  | 
**autoConfirmed** | **bool** | Se confirmó solo, pasado el plazo sin respuesta del empleador | 
**autoConfirmAt** | [**DateTime**](DateTime.md) | Cuándo se confirmará solo, si el empleador no responde | 
**cancellation** | [**JobCancellationDto**](JobCancellationDto.md) |  | 
**reviews** | [**JobReviewsDto**](JobReviewsDto.md) | Calificaciones (ciegas hasta publicarse) | 
**allowedActions** | **List&lt;String&gt;** | Lo que puedo hacer ahora (para mostrar los botones) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


