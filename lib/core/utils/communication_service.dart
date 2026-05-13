import 'package:url_launcher/url_launcher.dart';

class CommunicationService {
  /// Abre WhatsApp con el número especificado.
  static Future<void> openWhatsApp(String celular) async {
    final number = celular.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('https://wa.me/57$number');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error al abrir WhatsApp: $e');
    }
  }

  /// Abre el marcador telefónico con el número especificado.
  static Future<void> callPhone(String celular) async {
    final number = celular.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('tel:$number');
    try {
      await launchUrl(uri);
    } catch (e) {
      print('Error al abrir el marcador telefónico: $e');
    }
  }
}
