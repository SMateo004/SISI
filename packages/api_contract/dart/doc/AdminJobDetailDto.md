# sisi_api.model.AdminJobDetailDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**requestId** | **String** |  | 
**status** | **String** |  | 
**category** | [**JobCategoryDto**](JobCategoryDto.md) |  | 
**description** | **String** |  | 
**address** | **String** |  | 
**proposedPriceBs** | **String** |  | 
**finalPriceBs** | **String** |  | 
**commissionPct** | **String** |  | 
**commissionBs** | **String** |  | 
**worker** | [**AdminJobPartyDto**](AdminJobPartyDto.md) |  | 
**employer** | [**AdminJobPartyDto**](AdminJobPartyDto.md) |  | 
**disputedAt** | [**DateTime**](DateTime.md) |  | 
**disputeNote** | **String** |  | 
**timeline** | [**List&lt;AdminJobEventDto&gt;**](AdminJobEventDto.md) | job_events | 
**chat** | [**List&lt;AdminJobMessageDto&gt;**](AdminJobMessageDto.md) | Todo el chat | 
**offers** | [**List&lt;AdminJobOfferDto&gt;**](AdminJobOfferDto.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


