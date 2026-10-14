# sisi_api.api.MapsApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**geocodingControllerReverse**](MapsApi.md#geocodingcontrollerreverse) | **GET** /geocoding/reverse | Dirección sugerida para unas coordenadas


# **geocodingControllerReverse**
> ReverseGeocodeDto geocodingControllerReverse(lat, lng)

Dirección sugerida para unas coordenadas

La geocodificación se hace en el backend: la llave de Maps nunca llega a la app.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getMapsApi();
final num lat = -17.7834; // num | 
final num lng = -63.1821; // num | 

try {
    final response = api.geocodingControllerReverse(lat, lng);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MapsApi->geocodingControllerReverse: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lat** | **num**|  | 
 **lng** | **num**|  | 

### Return type

[**ReverseGeocodeDto**](ReverseGeocodeDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

