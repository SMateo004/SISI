# sisi_api.model.AvailabilityDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**available** | **bool** |  | 
**availableSince** | [**DateTime**](DateTime.md) |  | 
**locatedAt** | [**DateTime**](DateTime.md) | Última ubicación recibida por la API | 
**sendEverySec** | **num** | Cada cuántos segundos debe la app enviar la ubicación mientras está disponible (en primer plano) | 
**staleAfterSec** | **num** | Sin ubicación en este tiempo, deja de estar disponible | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


