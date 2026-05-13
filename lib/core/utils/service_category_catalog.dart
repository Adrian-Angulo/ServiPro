import 'package:flutter/material.dart';

/// Misma etiqueta que se guarda en `RequestEntity.idTypeService` desde
/// [CreateRequestScreen].
const String kOtrosServiceLabel = 'Otros';

class RequestServiceCategoryDefinition {
  final IconData icon;
  final String label;

  /// Términos en minúsculas **sin tildes**. Si la profesión normalizada
  /// contiene alguno, el trabajador se agrupa bajo [label].
  final Set<String> matchTerms;

  const RequestServiceCategoryDefinition({
    required this.icon,
    required this.label,
    required this.matchTerms,
  });
}

/// Mismo orden e iconos que la pantalla de nueva solicitud. La última entrada
/// es [kOtrosServiceLabel] (sin términos: es el comodín para profesiones
/// fuera del catálogo).
const List<RequestServiceCategoryDefinition> kRequestServiceCategoriesOrdered =
    [
      RequestServiceCategoryDefinition(
        icon: Icons.plumbing,
        label: 'Plomería',
        matchTerms: {
          'plomeria',
          'plomero',
          'plomera',
          'fontanero',
          'fontanera',
          'gasfitero',
          'gasfitera',
        },
      ),
      RequestServiceCategoryDefinition(
        icon: Icons.electric_bolt_rounded,
        label: 'Electricidad',
        matchTerms: {
          'electricidad',
          'electricista',
          'electrico',
          'electrica',
        },
      ),
      RequestServiceCategoryDefinition(
        icon: Icons.carpenter,
        label: 'Carpintería',
        matchTerms: {
          'carpinteria',
          'carpintero',
          'carpintera',
          'ebanista',
        },
      ),
      RequestServiceCategoryDefinition(
        icon: Icons.cleaning_services,
        label: 'Limpieza',
        matchTerms: {
          'limpieza',
          'limpiador',
          'limpiadora',
          'aseo',
          'domestica',
          'domestico',
        },
      ),
      RequestServiceCategoryDefinition(
        icon: Icons.format_paint,
        label: 'Pintura',
        matchTerms: {
          'pintura',
          'pintor',
          'pintora',
        },
      ),
      RequestServiceCategoryDefinition(
        icon: Icons.miscellaneous_services,
        label: kOtrosServiceLabel,
        matchTerms: {},
      ),
    ];

/// Quita tildes comunes en español (entrada ya en minúsculas).
String removeSpanishDiacritics(String input) {
  const from = 'áàäâãåéèëêíìïîóòöôúùüûýÿçñ';
  const to = 'aaaaaaeeeeiiiioooouuuuyycn';
  final b = StringBuffer();
  for (var i = 0; i < input.length; i++) {
    final c = input[i];
    final j = from.indexOf(c);
    b.write(j >= 0 ? to[j] : c);
  }
  return b.toString();
}

/// Profesión lista para comparar: trim, minúsculas y sin tildes.
String normalizeProfessionForMatch(String raw) {
  final trimmed = raw.trim().toLowerCase();
  if (trimmed.isEmpty) return '';
  return removeSpanishDiacritics(trimmed);
}

/// Devuelve una de las etiquetas de servicio de la app, o [kOtrosServiceLabel]
/// si no encaja en ninguna categoría con términos (incluye vacío).
String resolveWorkerProfessionToServiceLabel(String profesion) {
  final n = normalizeProfessionForMatch(profesion);
  if (n.isEmpty) return kOtrosServiceLabel;

  for (final def in kRequestServiceCategoriesOrdered) {
    if (def.label == kOtrosServiceLabel) continue;
    for (final term in def.matchTerms) {
      if (n.contains(term)) return def.label;
    }
  }
  return kOtrosServiceLabel;
}
