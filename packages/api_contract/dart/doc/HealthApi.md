# sisi_api.api.HealthApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthControllerCheck**](HealthApi.md#healthcontrollercheck) | **GET** /health | Estado de la API, la base de datos (con PostGIS) y Redis


# **healthControllerCheck**
> HealthResponseDto healthControllerCheck()

Estado de la API, la base de datos (con PostGIS) y Redis

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getHealthApi();

try {
    final response = api.healthControllerCheck();
    print(response);
} on DioException catch (e) {
    print('Exception when calling HealthApi->healthControllerCheck: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**HealthResponseDto**](HealthResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

