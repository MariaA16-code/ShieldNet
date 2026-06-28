// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'ShieldNet';

  @override
  String get navHome => 'Inicio';

  @override
  String get navReport => 'Reportar';

  @override
  String get navTrack => 'Seguimiento';

  @override
  String get navStats => 'Estadísticas';

  @override
  String get navHelp => 'Ayuda';

  @override
  String get languageSelectorLabel => 'Idioma';

  @override
  String get homeEyebrow => 'Anónimo · Cifrado · Gratis';

  @override
  String get homeHeadline =>
      'Denuncia el acoso cibernético.\nMantente protegido.';

  @override
  String get homeSubtitle =>
      'ShieldNet ofrece a cualquier persona afectada por el acoso cibernético una forma segura de avanzar. Denuncia un incidente de forma anónima, sin necesidad de cuenta. Sube pruebas a través de canales cifrados y verificados. Haz seguimiento de tu caso en cualquier momento usando un token privado. Sin nombres, sin exposición, sin juicios. Tu privacidad nunca se ve comprometida, por diseño.';

  @override
  String get ourPromiseTitle => 'Nuestra promesa';

  @override
  String get ourPromiseAnonymous => '100 %\nAnónimo';

  @override
  String get ourPromiseSecure => 'Seguro y\nCifrado';

  @override
  String get ourPromiseNoData => 'Sin datos\npersonales';

  @override
  String get ourPromiseCommunity => 'Impulsado por la\ncomunidad';

  @override
  String get needHelpTitle => '¿Necesitas ayuda urgente?';

  @override
  String get needHelpBodyPrefix =>
      'Si estás en peligro o necesitas asistencia urgente, visita nuestra página de ';

  @override
  String get needHelpBodyLink => 'Ayuda y Soporte';

  @override
  String get needHelpBodySuffix =>
      ' para ver números de emergencia y recursos.';

  @override
  String get reportAppBarTitle => 'Reportar un incidente';

  @override
  String get reportEyebrow => 'Anónimo · Cifrado · Gratis';

  @override
  String get reportHeadline => 'Reportar un incidente';

  @override
  String get reportSubtitle =>
      'Envía tu reporte de forma anónima — no se necesita cuenta.';

  @override
  String get reportCountryLabel => 'País';

  @override
  String get reportCategoryLabel => 'Categoría';

  @override
  String get reportPlatformLabel => 'Plataforma';

  @override
  String get reportHarasserUsernameLabel => 'Nombre de usuario del acosador';

  @override
  String get reportHarasserUsernameHint => '@usuario del acosador';

  @override
  String get reportHarasserUrlLabel => 'URL del perfil del acosador (opcional)';

  @override
  String get reportHarasserUrlHint => 'https://instagram.com/username';

  @override
  String get reportDescriptionLabel => 'Descripción';

  @override
  String get reportDescriptionHint => 'Describe lo que ocurrió en detalle...';

  @override
  String get reportEvidenceSectionTitle =>
      'EVIDENCIA (obligatoria para esta categoría)';

  @override
  String get reportOriginalImageLabel => 'Imagen original';

  @override
  String get reportFakeImageLabel => 'Imagen editada / falsa';

  @override
  String get reportVideoLabel => 'Video deepfake';

  @override
  String get reportContactLabel => 'Tu contacto (opcional)';

  @override
  String get reportContactHint => 'Correo o teléfono para seguimiento';

  @override
  String get reportSubmitButton => 'Enviar reporte';

  @override
  String get reportServerDelayNotice =>
      'El servidor puede tardar de 10 a 15 segundos en responder si ha estado inactivo.';

  @override
  String get reportValidationRequired => 'Este campo es obligatorio';

  @override
  String get reportValidationDescribe => 'Por favor describe lo que ocurrió';

  @override
  String reportValidationSelect(String label) {
    return 'Por favor selecciona $label';
  }

  @override
  String get reportValidationFillFields =>
      'Por favor completa todos los campos obligatorios anteriores.';

  @override
  String get reportValidationNeedsImages =>
      'Esta categoría requiere tanto la imagen original como la editada.';

  @override
  String get reportValidationNeedsVideo =>
      'Por favor sube el video requerido para esta categoría.';

  @override
  String get reportSubmitGenericError =>
      'Algo salió mal al enviar tu reporte. Por favor intenta de nuevo.';

  @override
  String get helpAppBarTitle => 'Ayuda y preguntas frecuentes';

  @override
  String get helpEyebrow => 'Soporte';

  @override
  String get helpHeadline => 'Ayuda y preguntas frecuentes';

  @override
  String get helpSubtitle =>
      'Respuestas a preguntas frecuentes sobre el uso de ShieldNet. Si no encuentras lo que buscas, puedes contactarnos al final de esta página.';

  @override
  String get helpEmergencyTitle => '¿Necesitas ayuda inmediata?';

  @override
  String get helpEmergencyBody =>
      'Si estás en peligro inmediato, contacta directamente a los servicios de emergencia — toca cualquier número de abajo para llamar.';

  @override
  String get helpEmergencyFia => 'Línea de ayuda de ciberdelitos FIA';

  @override
  String get helpEmergencyPolice => 'Policía';

  @override
  String get helpEmergencyAmbulance => 'Ambulancia';

  @override
  String get helpEmergencyWomen => 'Línea de ayuda para mujeres';

  @override
  String get helpFaqSectionTitle => 'PREGUNTAS FRECUENTES';

  @override
  String get helpFaq1Q =>
      'Envié un reporte pero no recibí un token. ¿Qué pasó?';

  @override
  String get helpFaq1A =>
      'Si la conexión se interrumpió antes de que cargara la confirmación, es posible que tu reporte no se haya guardado. Por favor envíalo de nuevo — los reportes duplicados no son un problema de nuestro lado.';

  @override
  String get helpFaq2Q => 'Perdí mi token de seguimiento. ¿Puedo recuperarlo?';

  @override
  String get helpFaq2A =>
      'Si proporcionaste información de contacto al reportar, el equipo de administración puede verificar tu identidad y reenviártelo. De lo contrario, como ShieldNet no almacena datos personales por defecto, el token no se puede recuperar.';

  @override
  String get helpFaq3Q => '¿El acosador sabrá que lo reporté?';

  @override
  String get helpFaq3A =>
      'No. Los reportes son completamente anónimos a menos que elijas proporcionar datos de contacto, y esa información solo es visible para el equipo de administración — nunca para la persona reportada.';

  @override
  String get helpFaq4Q => '¿Mi identidad realmente permanece anónima?';

  @override
  String get helpFaq4A =>
      'Sí. Por defecto no recopilamos nombre, cuenta ni identificador de dispositivo alguno. El campo de contacto es opcional y solo se usa para seguimiento si lo proporcionas.';

  @override
  String get helpFaq5Q => '¿Qué pasa con mi evidencia después de enviarla?';

  @override
  String get helpFaq5A =>
      'La evidencia se analiza para ayudar a verificar el reporte, luego se almacena de forma segura y se usa únicamente para el proceso de retirada y revisión.';

  @override
  String get helpFaq6Q => '¿Qué hago si necesito ayuda urgente ahora mismo?';

  @override
  String get helpFaq6A =>
      'Si estás en peligro inmediato, contacta primero a los servicios de emergencia locales. Para el acoso cibernético específicamente, puedes llamar a la línea de ayuda de ciberdelitos FIA al 1991 — consulta los números de emergencia arriba.';

  @override
  String get helpSupportTitle => '¿Sigues atascado?';

  @override
  String get helpSupportBody =>
      'Si tu pregunta no fue respondida arriba, puedes enviarnos un correo directamente y haremos todo lo posible por ayudarte.';

  @override
  String get helpSupportEmailButton => 'Enviar correo a soporte';

  @override
  String get helpSupportEmailFailed =>
      'No se pudo abrir una aplicación de correo en este dispositivo.';

  @override
  String helpSupportCallFailed(String number) {
    return 'No se pudo iniciar una llamada al $number.';
  }

  @override
  String get helpFooterTagline =>
      'Protegiendo a las víctimas. Exponiendo a los agresores. Conectando al mundo.';

  @override
  String get helpFooterPlatformTitle => 'PLATAFORMA';

  @override
  String get helpFooterEmergencyTitle => 'RECURSOS DE EMERGENCIA';

  @override
  String get helpFooterReport => 'Reportar';

  @override
  String get helpFooterTrack => 'Seguimiento';

  @override
  String get helpFooterStatistics => 'Estadísticas';

  @override
  String get helpFooterFia => 'Ciberdelitos FIA: 1991';

  @override
  String get helpFooterPolice => 'Policía: 15';

  @override
  String get helpFooterWomen => 'Línea de ayuda para mujeres: 1099';
}
