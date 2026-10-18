# sisi_api.model.AdminJobOfferDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**worker** | [**AdminJobPartyDto**](AdminJobPartyDto.md) |  | 
**status** | **String** |  | 
**chosen** | **bool** | La que eligió el empleador | 
**history** | [**List&lt;AdminOfferEventDto&gt;**](AdminOfferEventDto.md) | Historial (ADR-0042) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


