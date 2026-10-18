# sisi_api.api.PilotApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**pilotControllerInterest**](PilotApi.md#pilotcontrollerinterest) | **POST** /pilot/interest | \&quot;Pronto en tu zona\&quot;: dejar el interés (ADR-0052)


# **pilotControllerInterest**
> pilotControllerInterest(pilotInterestDto)

\"Pronto en tu zona\": dejar el interés (ADR-0052)

Para quien todavía no puede crear su cuenta en el piloto. Mide la demanda.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getPilotApi();
final PilotInterestDto pilotInterestDto = ; // PilotInterestDto | 

try {
    api.pilotControllerInterest(pilotInterestDto);
} on DioException catch (e) {
    print('Exception when calling PilotApi->pilotControllerInterest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pilotInterestDto** | [**PilotInterestDto**](PilotInterestDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

