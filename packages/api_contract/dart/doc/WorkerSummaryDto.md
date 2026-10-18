# sisi_api.model.WorkerSummaryDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **String** |  | 
**statusChangedAt** | [**DateTime**](DateTime.md) |  | 
**rating** | [**RatingDto**](RatingDto.md) |  | 
**rejectionReason** | **String** |  | 
**moderationResolution** | **String** |  | 
**categories** | **List&lt;String&gt;** |  | 
**transport** | **String** |  | 
**maxRadiusKm** | **num** |  | 
**balanceBs** | **String** | Saldo del ledger (positivo = debe) | 
**periods** | [**List&lt;PeriodRowDto&gt;**](PeriodRowDto.md) | Últimos 8 | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


