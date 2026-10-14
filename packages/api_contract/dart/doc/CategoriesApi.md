# sisi_api.api.CategoriesApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**categoriesControllerList**](CategoriesApi.md#categoriescontrollerlist) | **GET** /categories | Categorías activas


# **categoriesControllerList**
> List<CategoryDto> categoriesControllerList()

Categorías activas

Lista cerrada (R2.1). En la Fase 1 puede venir vacía: el seed llega en la Fase 2.

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

