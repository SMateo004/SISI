# sisi_api.model.DashboardDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**range** | **String** |  | 
**cityId** | **String** |  | 
**cityName** | **String** |  | 
**from** | [**DateTime**](DateTime.md) |  | 
**to** | [**DateTime**](DateTime.md) |  | 
**requestsCreated** | **num** | Publicadas en el rango (sin borradores) | 
**assignmentRatePct** | **num** |  | 
**expirationRatePct** | **num** |  | 
**avgFirstOfferSec** | **num** | Desde la publicación, en segundos | 
**jobsCompleted** | **num** |  | 
**cancellationsByReason** | [**List&lt;CancellationCountDto&gt;**](CancellationCountDto.md) |  | 
**commissionGeneratedBs** | **String** |  | 
**commissionCollectedBs** | **String** |  | 
**overdueDebtBs** | **String** | Saldo de los periodos vencidos (ahora) | 
**overdueWorkers** | **num** |  | 
**workersAvailableNow** | **num** | Disponibles con ubicación reciente | 
**queues** | [**CountersDto**](CountersDto.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


