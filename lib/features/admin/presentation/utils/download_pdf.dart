import 'package:frontend_emi_sistema/core/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> downloadPdf(String documentoUrl) async {
  try {
    final url =
        "${Constants.baseUrl}api/docente/estudios-academicos/$documentoUrl/pdf";
    // 'http://localhost:3000/api/docente/estudios-academicos/$documentoUrl/pdf';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir la URL';
    }
  } catch (e) {
    print('Error al descargar PDF: $e');
    // Aquí podrías mostrar un snackbar o dialog con el error
  }
}
