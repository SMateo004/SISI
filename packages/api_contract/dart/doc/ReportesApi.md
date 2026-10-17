# sisi_api.api.ReportesApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reportsControllerCreate**](ReportesApi.md#reportscontrollercreate) | **POST** /reports | Reportar una solicitud, un perfil, un mensaje o un trabajo
[**reportsControllerMine**](ReportesApi.md#reportscontrollermine) | **GET** /reports/mine | Mis reportes y su estado


# **reportsControllerCreate**
> ReportDto reportsControllerCreate(createReportDto)

Reportar una solicitud, un perfil, un mensaje o un trabajo

Solo algo con lo que tuviste relación. Un reporte por objetivo. Un mensaje reportado deja de mostrarse para quien lo reportó.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getReportesApi();
final CreateReportDto createReportDto = ; // CreateReportDto | 

try {
    final response = api.reportsControllerCreate(createReportDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportesApi->reportsControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createReportDto** | [**CreateReportDto**](CreateReportDto.md)|  | 

### Return type

[**ReportDto**](ReportDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportsControllerMine**
> List<ReportDto> reportsControllerMine()

Mis reportes y su estado

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getReportesApi();

try {
    final response = api.reportsControllerMine();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportesApi->reportsControllerMine: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;ReportDto&gt;**](ReportDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

