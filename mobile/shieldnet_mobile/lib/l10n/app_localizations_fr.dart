// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ShieldNet';

  @override
  String get navHome => 'Accueil';

  @override
  String get navReport => 'Signaler';

  @override
  String get navTrack => 'Suivre';

  @override
  String get navStats => 'Statistiques';

  @override
  String get navHelp => 'Aide';

  @override
  String get languageSelectorLabel => 'Langue';

  @override
  String get homeEyebrow => 'Anonyme · Chiffré · Gratuit';

  @override
  String get homeHeadline => 'Signalez le cyberharcèlement.\nRestez protégé.';

  @override
  String get homeSubtitle =>
      'ShieldNet offre à toute personne touchée par le cyberharcèlement un moyen sûr d\'agir. Signalez un incident de manière anonyme, sans compte requis. Téléchargez des preuves via des canaux chiffrés et vérifiés. Suivez votre dossier à tout moment grâce à un jeton privé. Aucun nom, aucune exposition, aucun jugement. Votre vie privée n\'est jamais compromise, par conception.';

  @override
  String get ourPromiseTitle => 'Notre engagement';

  @override
  String get ourPromiseAnonymous => '100 %\nAnonyme';

  @override
  String get ourPromiseSecure => 'Sécurisé et\nChiffré';

  @override
  String get ourPromiseNoData => 'Aucune donnée\npersonnelle';

  @override
  String get ourPromiseCommunity => 'Porté par la\ncommunauté';

  @override
  String get needHelpTitle => 'Besoin d\'aide immédiate ?';

  @override
  String get needHelpBodyPrefix =>
      'Si vous êtes en danger ou avez besoin d\'une assistance urgente, consultez notre page ';

  @override
  String get needHelpBodyLink => 'Aide et assistance';

  @override
  String get needHelpBodySuffix =>
      ' pour les numéros d\'urgence et les ressources.';

  @override
  String get reportAppBarTitle => 'Signaler un incident';

  @override
  String get reportEyebrow => 'Anonyme · Chiffré · Gratuit';

  @override
  String get reportHeadline => 'Signaler un incident';

  @override
  String get reportSubtitle =>
      'Soumettez de manière anonyme — aucun compte nécessaire.';

  @override
  String get reportCountryLabel => 'Pays';

  @override
  String get reportCategoryLabel => 'Catégorie';

  @override
  String get reportPlatformLabel => 'Plateforme';

  @override
  String get reportHarasserUsernameLabel => 'Nom d\'utilisateur du harceleur';

  @override
  String get reportHarasserUsernameHint => '@nomdutilisateur du harceleur';

  @override
  String get reportHarasserUrlLabel =>
      'URL du profil du harceleur (facultatif)';

  @override
  String get reportHarasserUrlHint => 'https://instagram.com/username';

  @override
  String get reportDescriptionLabel => 'Description';

  @override
  String get reportDescriptionHint =>
      'Décrivez ce qui s\'est passé en détail...';

  @override
  String get reportEvidenceSectionTitle =>
      'PREUVES (obligatoires pour cette catégorie)';

  @override
  String get reportOriginalImageLabel => 'Image originale';

  @override
  String get reportFakeImageLabel => 'Image modifiée / falsifiée';

  @override
  String get reportVideoLabel => 'Vidéo deepfake';

  @override
  String get reportContactLabel => 'Votre contact (facultatif)';

  @override
  String get reportContactHint => 'E-mail ou téléphone pour le suivi';

  @override
  String get reportSubmitButton => 'Envoyer le signalement';

  @override
  String get reportServerDelayNotice =>
      'Le serveur peut prendre 10 à 15 secondes pour répondre s\'il était inactif.';

  @override
  String get reportValidationRequired => 'Ce champ est obligatoire';

  @override
  String get reportValidationDescribe => 'Veuillez décrire ce qui s\'est passé';

  @override
  String reportValidationSelect(String label) {
    return 'Veuillez sélectionner $label';
  }

  @override
  String get reportValidationFillFields =>
      'Veuillez remplir tous les champs obligatoires ci-dessus.';

  @override
  String get reportValidationNeedsImages =>
      'Cette catégorie nécessite à la fois l\'image originale et l\'image modifiée.';

  @override
  String get reportValidationNeedsVideo =>
      'Veuillez télécharger la vidéo requise pour cette catégorie.';

  @override
  String get reportSubmitGenericError =>
      'Une erreur s\'est produite lors de l\'envoi de votre signalement. Veuillez réessayer.';

  @override
  String get helpAppBarTitle => 'Aide et FAQ';

  @override
  String get helpEyebrow => 'Assistance';

  @override
  String get helpHeadline => 'Aide et FAQ';

  @override
  String get helpSubtitle =>
      'Réponses aux questions fréquentes sur l\'utilisation de ShieldNet. Si vous ne trouvez pas ce que vous cherchez, vous pouvez nous contacter en bas de cette page.';

  @override
  String get helpEmergencyTitle => 'Besoin d\'aide immédiate ?';

  @override
  String get helpEmergencyBody =>
      'Si vous êtes en danger immédiat, contactez directement les services d\'urgence — appuyez sur n\'importe quel numéro ci-dessous pour appeler.';

  @override
  String get helpEmergencyFia => 'Ligne d\'assistance FIA cybercriminalité';

  @override
  String get helpEmergencyPolice => 'Police';

  @override
  String get helpEmergencyAmbulance => 'Ambulance';

  @override
  String get helpEmergencyWomen => 'Ligne d\'assistance pour les femmes';

  @override
  String get helpFaqSectionTitle => 'QUESTIONS FRÉQUEMMENT POSÉES';

  @override
  String get helpFaq1Q =>
      'J\'ai soumis un signalement mais je n\'ai pas reçu de jeton. Que s\'est-il passé ?';

  @override
  String get helpFaq1A =>
      'Si la connexion a été interrompue avant le chargement de la confirmation, votre signalement n\'a peut-être pas été enregistré. Veuillez le soumettre à nouveau — les signalements en double ne posent aucun problème de notre côté.';

  @override
  String get helpFaq2Q =>
      'J\'ai perdu mon jeton de suivi. Puis-je le récupérer ?';

  @override
  String get helpFaq2A =>
      'Si vous avez fourni des coordonnées lors du signalement, l\'équipe d\'administration peut vérifier votre identité et vous le renvoyer. Sinon, comme ShieldNet ne collecte aucune donnée personnelle par défaut, le jeton ne peut pas être récupéré.';

  @override
  String get helpFaq3Q => 'Le harceleur saura-t-il que je l\'ai signalé ?';

  @override
  String get helpFaq3A =>
      'Non. Les signalements sont totalement anonymes, sauf si vous choisissez de fournir des coordonnées, et ces informations ne sont jamais visibles que par l\'équipe d\'administration — jamais par la personne signalée.';

  @override
  String get helpFaq4Q => 'Mon identité est-elle vraiment anonyme ?';

  @override
  String get helpFaq4A =>
      'Oui. Par défaut, nous ne collectons aucun nom, compte ou identifiant d\'appareil. Le champ de contact est facultatif et n\'est utilisé que pour le suivi si vous le fournissez.';

  @override
  String get helpFaq5Q => 'Qu\'advient-il de mes preuves après leur envoi ?';

  @override
  String get helpFaq5A =>
      'Les preuves sont analysées pour aider à vérifier le signalement, puis stockées en toute sécurité et utilisées uniquement pour le processus de retrait et d\'examen.';

  @override
  String get helpFaq6Q =>
      'Que faire si j\'ai besoin d\'une aide urgente immédiate ?';

  @override
  String get helpFaq6A =>
      'Si vous êtes en danger immédiat, contactez d\'abord les services d\'urgence locaux. Pour le cyberharcèlement spécifiquement, vous pouvez appeler la ligne d\'assistance FIA cybercriminalité au 1991 — voir les numéros d\'urgence ci-dessus.';

  @override
  String get helpSupportTitle => 'Toujours bloqué ?';

  @override
  String get helpSupportBody =>
      'Si votre question n\'a pas trouvé de réponse ci-dessus, vous pouvez nous envoyer un e-mail directement et nous ferons notre possible pour vous aider.';

  @override
  String get helpSupportEmailButton => 'Contacter le support par e-mail';

  @override
  String get helpSupportEmailFailed =>
      'Impossible d\'ouvrir une application de messagerie sur cet appareil.';

  @override
  String helpSupportCallFailed(String number) {
    return 'Impossible de lancer un appel vers le $number.';
  }

  @override
  String get helpFooterTagline =>
      'Protéger les victimes. Exposer les agresseurs. Connecter le monde.';

  @override
  String get helpFooterPlatformTitle => 'PLATEFORME';

  @override
  String get helpFooterEmergencyTitle => 'RESSOURCES D\'URGENCE';

  @override
  String get helpFooterReport => 'Signaler';

  @override
  String get helpFooterTrack => 'Suivre';

  @override
  String get helpFooterStatistics => 'Statistiques';

  @override
  String get helpFooterFia => 'FIA cybercriminalité : 1991';

  @override
  String get helpFooterPolice => 'Police : 15';

  @override
  String get helpFooterWomen => 'Ligne d\'assistance pour les femmes : 1099';
}
