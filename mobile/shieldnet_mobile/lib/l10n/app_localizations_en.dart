// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ShieldNet';

  @override
  String get navHome => 'Home';

  @override
  String get navReport => 'Report';

  @override
  String get navTrack => 'Track';

  @override
  String get navStats => 'Statistics';

  @override
  String get navHelp => 'Help';

  @override
  String get languageSelectorLabel => 'Language';

  @override
  String get homeEyebrow => 'Anonymous · Encrypted · Free';

  @override
  String get homeHeadline => 'Report cyber harassment.\nStay protected.';

  @override
  String get homeSubtitle =>
      'ShieldNet gives anyone affected by cyber harassment a safe way forward. Report an incident anonymously, with no account required. Upload evidence through encrypted, verified channels. Track your case anytime using a private token. No names, no exposure, no judgment. Your privacy is never compromised, by design.';

  @override
  String get ourPromiseTitle => 'Our Promise';

  @override
  String get ourPromiseAnonymous => '100%\nAnonymous';

  @override
  String get ourPromiseSecure => 'Secure &\nEncrypted';

  @override
  String get ourPromiseNoData => 'No Personal\nData';

  @override
  String get ourPromiseCommunity => 'Community\nDriven';

  @override
  String get needHelpTitle => 'Need help right now?';

  @override
  String get needHelpBodyPrefix =>
      'If you are in danger or need urgent assistance, visit our ';

  @override
  String get needHelpBodyLink => 'Help & Support';

  @override
  String get needHelpBodySuffix => ' page for emergency numbers and resources.';

  @override
  String get reportAppBarTitle => 'Report Incident';

  @override
  String get reportEyebrow => 'Anonymous · Encrypted · Free';

  @override
  String get reportHeadline => 'Report an incident';

  @override
  String get reportSubtitle => 'Submit anonymously — no account needed.';

  @override
  String get reportCountryLabel => 'Country';

  @override
  String get reportCategoryLabel => 'Category';

  @override
  String get reportPlatformLabel => 'Platform';

  @override
  String get reportHarasserUsernameLabel => 'Harasser Username';

  @override
  String get reportHarasserUsernameHint => '@username of the harasser';

  @override
  String get reportHarasserUrlLabel => 'Harasser Profile URL (optional)';

  @override
  String get reportHarasserUrlHint => 'https://instagram.com/username';

  @override
  String get reportDescriptionLabel => 'Description';

  @override
  String get reportDescriptionHint => 'Describe what happened in detail...';

  @override
  String get reportEvidenceSectionTitle =>
      'EVIDENCE (required for this category)';

  @override
  String get reportOriginalImageLabel => 'Original image';

  @override
  String get reportFakeImageLabel => 'Edited / fake image';

  @override
  String get reportVideoLabel => 'Deepfake video';

  @override
  String get reportContactLabel => 'Your Contact (optional)';

  @override
  String get reportContactHint => 'Email or phone for follow-up';

  @override
  String get reportSubmitButton => 'Submit Report';

  @override
  String get reportServerDelayNotice =>
      'The server may take 10–15 seconds to respond if it has been idle.';

  @override
  String get reportValidationRequired => 'This field is required';

  @override
  String get reportValidationDescribe => 'Please describe what happened';

  @override
  String reportValidationSelect(String label) {
    return 'Please select $label';
  }

  @override
  String get reportValidationFillFields =>
      'Please fill in all required fields above.';

  @override
  String get reportValidationNeedsImages =>
      'This category requires both the original and edited image.';

  @override
  String get reportValidationNeedsVideo =>
      'Please upload the video for this category.';

  @override
  String get reportSubmitGenericError =>
      'Something went wrong submitting your report. Please try again.';

  @override
  String get helpAppBarTitle => 'Help & FAQ';

  @override
  String get helpEyebrow => 'Support';

  @override
  String get helpHeadline => 'Help & FAQ';

  @override
  String get helpSubtitle =>
      'Answers to common questions about using ShieldNet. If you don\'t see what you\'re looking for, you can reach out at the bottom of this page.';

  @override
  String get helpEmergencyTitle => 'Need Immediate Help?';

  @override
  String get helpEmergencyBody =>
      'If you are in immediate danger, contact emergency services directly — tap any number below to call.';

  @override
  String get helpEmergencyFia => 'FIA Cyber Crime Helpline';

  @override
  String get helpEmergencyPolice => 'Police';

  @override
  String get helpEmergencyAmbulance => 'Ambulance';

  @override
  String get helpEmergencyWomen => 'Women Helpline';

  @override
  String get helpFaqSectionTitle => 'FREQUENTLY ASKED QUESTIONS';

  @override
  String get helpFaq1Q =>
      'I submitted a report but didn\'t get a token. What happened?';

  @override
  String get helpFaq1A =>
      'If the connection dropped before the confirmation loaded, your report may not have been saved. Please submit it again — duplicate reports are not a problem on our end.';

  @override
  String get helpFaq2Q => 'I lost my tracking token. Can I get it back?';

  @override
  String get helpFaq2A =>
      'If you provided contact info when reporting, the admin team can verify your identity and resend it. Otherwise, since ShieldNet stores no personal data by default, the token cannot be recovered.';

  @override
  String get helpFaq3Q => 'Will the harasser find out I reported them?';

  @override
  String get helpFaq3A =>
      'No. Reports are completely anonymous unless you choose to provide contact details, and that information is only ever visible to the admin team — never to the person you reported.';

  @override
  String get helpFaq4Q => 'Is my identity really anonymous?';

  @override
  String get helpFaq4A =>
      'Yes. By default we collect no name, account, or device identifier. The contact field is optional and used only for follow-up if you provide it.';

  @override
  String get helpFaq5Q => 'What happens to my evidence after I submit it?';

  @override
  String get helpFaq5A =>
      'Evidence is analyzed to help verify the report, then stored securely and used only for the takedown and review process.';

  @override
  String get helpFaq6Q => 'What if I need urgent help right now?';

  @override
  String get helpFaq6A =>
      'If you are in immediate danger, contact local emergency services first. For cyber harassment specifically, you can call the FIA Cybercrime Helpline at 1991 — see the emergency numbers above.';

  @override
  String get helpSupportTitle => 'Still stuck?';

  @override
  String get helpSupportBody =>
      'If your question wasn\'t answered above, you can email us directly and we\'ll do our best to help.';

  @override
  String get helpSupportEmailButton => 'Email Support';

  @override
  String get helpSupportEmailFailed =>
      'Could not open an email app on this device.';

  @override
  String helpSupportCallFailed(String number) {
    return 'Could not start a call to $number.';
  }

  @override
  String get helpFooterTagline =>
      'Protecting victims. Exposing abusers. Connecting the world.';

  @override
  String get helpFooterPlatformTitle => 'PLATFORM';

  @override
  String get helpFooterEmergencyTitle => 'EMERGENCY RESOURCES';

  @override
  String get helpFooterReport => 'Report';

  @override
  String get helpFooterTrack => 'Track';

  @override
  String get helpFooterStatistics => 'Statistics';

  @override
  String get helpFooterFia => 'FIA Cyber Crime: 1991';

  @override
  String get helpFooterPolice => 'Police: 15';

  @override
  String get helpFooterWomen => 'Women Helpline: 1099';
}
