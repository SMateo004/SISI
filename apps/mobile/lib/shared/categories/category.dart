import 'package:flutter/material.dart';

/// Categoría activa en la ciudad del usuario, con su rango de referencia (R2.2).
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.priceMinBs,
    required this.priceMaxBs,
    this.slug = '',
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] as String,
    slug: (json['slug'] as String?) ?? '',
    name: json['name'] as String,
    description: json['description'] as String?,
    priceMinBs: json['priceMinBs'] as String,
    priceMaxBs: json['priceMaxBs'] as String,
  );

  final String id;
  final String slug;
  final String name;
  final String? description;
  final String priceMinBs;
  final String priceMaxBs;

  IconData get icon => categoryIcon(slug);
}

/// Ícono por slug (las categorías vienen de la API; el ícono se elige aquí).
IconData categoryIcon(String slug) => switch (slug) {
  'plomeria' => Icons.plumbing,
  'electricidad' => Icons.electrical_services,
  'limpieza' => Icons.cleaning_services,
  'cuidado-hogar' => Icons.home_repair_service,
  'eventos' => Icons.celebration,
  'mudanzas-carga' => Icons.local_shipping,
  _ => Icons.handyman,
};
