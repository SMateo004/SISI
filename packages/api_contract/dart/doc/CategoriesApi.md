# sisi_api.api.CategoriesApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**categoriesControllerList**](CategoriesApi.md#categoriescontrollerlist) | **GET** /categories | Categorías activas en mi ciudad


# **categoriesControllerList**
> List<CategoryDto> categoriesControllerList()

Categorías activas en mi ciudad

Lista cerrada (R2.1) con el rango de referencia efectivo de la ciudad (R2.2, R10.1).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getCategoriesApi();

try {
    final response = api.categoriesControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling CategoriesApi->categoriesControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;CategoryDto&gt;**](CategoryDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

