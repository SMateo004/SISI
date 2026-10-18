# sisi_api.model.UserProfileDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**phone** | **String** |  | 
**name** | **String** |  | 
**role** | **String** |  | 
**activeMode** | **String** |  | 
**cityName** | **String** |  | 
**workerStatus** | **String** | Estado del perfil de trabajador | 
**flagged** | **bool** | Empleador marcado para revisión (3 reportes válidos) | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**employerRating** | [**RatingDto**](RatingDto.md) | Como empleador | 
**cancellationsCount** | **num** |  | 
**flaggedAt** | [**DateTime**](DateTime.md) |  | 
**worker** | [**WorkerSummaryDto**](WorkerSummaryDto.md) |  | 
**reportCounts** | [**ReportCountsDto**](ReportCountsDto.md) | Reportes recibidos | 
**reports** | [**List&lt;ReportRowDto&gt;**](ReportRowDto.md) | Últimos 10 recibidos | 
**jobsCount** | **num** | Trabajos como trabajador o empleador | 
**jobs** | [**List&lt;JobRowDto&gt;**](JobRowDto.md) | Últimos 10 | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


