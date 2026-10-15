# sisi_api.model.IncomingRequestDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**requestId** | **String** |  | 
**outcome** | **String** | abierta = puede ofertar; elegido = lo eligieron (ver contacto con jobId) | 
**category** | **Object** |  | 
**description** | **String** |  | 
**distanceM** | **num** |  | 
**proposedPriceBs** | **String** |  | 
**referenceRange** | [**PriceRangeDto**](PriceRangeDto.md) |  | 
**maxCounterBs** | **String** | Tope de la contraoferta | 
**photos** | [**List&lt;IncomingPhotoDto&gt;**](IncomingPhotoDto.md) |  | 
**ring** | **num** | Anillo en el que le llegó | 
**respondBy** | [**DateTime**](DateTime.md) | Fin del plazo de su anillo (cuenta regresiva en la app) | 
**myOffer** | [**MyOfferDto**](MyOfferDto.md) |  | 
**jobId** | **String** |  | 
**notifiedAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


