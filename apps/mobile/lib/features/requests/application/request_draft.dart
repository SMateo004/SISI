import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/files/picked_image.dart';
import '../../../core/maps/geo_point.dart';
import '../../../shared/categories/category.dart';
import '../../../shared/money.dart';
import '../domain/service_request.dart';

/// Pasos de "Pedir un servicio".
enum RequestStep {
  category('¿Qué necesitas?'),
  details('Describe el trabajo'),
  location('¿Dónde es?'),
  price('Tu precio'),
  summary('Resumen');

  const RequestStep(this.title);

  final String title;
}

/// Longitudes de la descripción (propuesta; la API valida con su configuración).
const descriptionMin = 20;
const descriptionMax = 1000;
const maxPhotos = 4;

class RequestDraft {
  const RequestDraft({
    this.step = RequestStep.category,
    this.category,
    this.description = '',
    this.photos = const [],
    this.location = santaCruzCenter,
    this.address = '',
    this.addressEdited = false,
    this.price = '',
  });

  final RequestStep step;
  final Category? category;
  final String description;
  final List<PickedImage> photos;
  final GeoPoint location;
  final String address;

  /// El usuario escribió la dirección a mano: ya no se reemplaza con la sugerida.
  final bool addressEdited;
  final String price;

  int? get priceCents => parseBsCents(price);

  /// R3.2: precio por debajo del mínimo de referencia de la categoría.
  bool get priceBelowReference {
    final cents = priceCents;
    final min = category == null ? null : parseBsCents(category!.priceMinBs);
    return cents != null && min != null && cents < min;
  }

  bool get descriptionValid {
    final length = description.trim().length;
    return length >= descriptionMin && length <= descriptionMax;
  }

  bool canContinue() => switch (step) {
    RequestStep.category => category != null,
    RequestStep.details => descriptionValid,
    RequestStep.location => address.trim().length >= 5,
    RequestStep.price => (priceCents ?? 0) > 0,
    RequestStep.summary => true,
  };

  RequestDraft copyWith({
    RequestStep? step,
    Category? category,
    String? description,
    List<PickedImage>? photos,
    GeoPoint? location,
    String? address,
    bool? addressEdited,
    String? price,
  }) => RequestDraft(
    step: step ?? this.step,
    category: category ?? this.category,
    description: description ?? this.description,
    photos: photos ?? this.photos,
    location: location ?? this.location,
    address: address ?? this.address,
    addressEdited: addressEdited ?? this.addressEdited,
    price: price ?? this.price,
  );
}

class RequestDraftController extends Notifier<RequestDraft> {
  @override
  RequestDraft build() => const RequestDraft();

  void selectCategory(Category category) =>
      state = state.copyWith(category: category);

  void setDescription(String value) =>
      state = state.copyWith(description: value);

  void addPhoto(PickedImage image) {
    if (state.photos.length >= maxPhotos) return;
    state = state.copyWith(photos: [...state.photos, image]);
  }

  void removePhoto(int index) {
    final photos = [...state.photos]..removeAt(index);
    state = state.copyWith(photos: photos);
  }

  void setLocation(GeoPoint point) => state = state.copyWith(location: point);

  /// Dirección sugerida por la API: solo si el usuario no la editó.
  void suggestAddress(String? address) {
    if (address == null || state.addressEdited) return;
    state = state.copyWith(address: address);
  }

  void editAddress(String value) =>
      state = state.copyWith(address: value, addressEdited: true);

  void setPrice(String value) => state = state.copyWith(price: value);

  /// Volver a publicar: precarga todo menos la categoría (llega con la lista de la API)
  /// y las fotos (se eligen de nuevo).
  void prefill(RepublishSeed seed) => state = state.copyWith(
    description: seed.description,
    location: seed.location,
    address: seed.address,
    addressEdited: true,
    price: seed.proposedPriceBs.replaceAll('.', ','),
  );

  void next() {
    final i = state.step.index;
    if (i < RequestStep.values.length - 1) {
      state = state.copyWith(step: RequestStep.values[i + 1]);
    }
  }

  void back() {
    final i = state.step.index;
    if (i > 0) state = state.copyWith(step: RequestStep.values[i - 1]);
  }
}

final requestDraftProvider =
    NotifierProvider.autoDispose<RequestDraftController, RequestDraft>(
      RequestDraftController.new,
    );
