# sisi_api.model.PilotMetricsDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**cityId** | **String** |  | 
**cityName** | **String** |  | 
**startedAt** | **String** | Inicio del piloto (parámetro PILOT_STARTED_AT); sin él, las últimas 8 semanas | 
**from** | [**DateTime**](DateTime.md) |  | 
**to** | [**DateTime**](DateTime.md) |  | 
**funnel** | [**PilotFunnelDto**](PilotFunnelDto.md) |  | 
**avgFirstOfferSec** | **num** |  | 
**expirationRatePct** | **num** |  | 
**collectionRatePct** | **num** | Comisión cobrada sobre generada, en el rango | 
**weekly** | [**List&lt;PilotWeekDto&gt;**](PilotWeekDto.md) | Hasta 8 semanas, la última es la actual | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


