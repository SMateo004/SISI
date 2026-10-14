# sisi_api.model.RequestDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**status** | **String** |  | 
**statusMessage** | **String** | Mensaje para el empleador según el estado (neutral si está retenida) | [optional] 
**category** | [**RequestCategoryDto**](RequestCategoryDto.md) |  | 
**cityId** | **String** |  | 
**description** | **String** |  | 
**latitude** | **num** |  | 
**longitude** | **num** |  | 
**address** | **String** |  | 
**proposedPriceBs** | **String** |  | 
**photos** | [**List&lt;RequestPhotoDto&gt;**](RequestPhotoDto.md) |  | 
**createdAt** | **String** |  | 
**publishedAt** | **String** |  | [optional] 
**cancelledAt** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


