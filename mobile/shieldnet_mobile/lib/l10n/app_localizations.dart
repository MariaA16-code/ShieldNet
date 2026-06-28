import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ShieldNet'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get navReport;

  /// No description provided for @navTrack.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get navTrack;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get navStats;

  /// No description provided for @navHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get navHelp;

  /// No description provided for @languageSelectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelectorLabel;

  /// No description provided for @homeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Anonymous · Encrypted · Free'**
  String get homeEyebrow;

  /// No description provided for @homeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Report cyber harassment.\nStay protected.'**
  String get homeHeadline;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'ShieldNet gives anyone affected by cyber harassment a safe way forward. Report an incident anonymously, with no account required. Upload evidence through encrypted, verified channels. Track your case anytime using a private token. No names, no exposure, no judgment. Your privacy is never compromised, by design.'**
  String get homeSubtitle;

  /// No description provided for @ourPromiseTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Promise'**
  String get ourPromiseTitle;

  /// No description provided for @ourPromiseAnonymous.
  ///
  /// In en, this message translates to:
  /// **'100%\nAnonymous'**
  String get ourPromiseAnonymous;

  /// No description provided for @ourPromiseSecure.
  ///
  /// In en, this message translates to:
  /// **'Secure &\nEncrypted'**
  String get ourPromiseSecure;

  /// No description provided for @ourPromiseNoData.
  ///
  /// In en, this message translates to:
  /// **'No Personal\nData'**
  String get ourPromiseNoData;

  /// No description provided for @ourPromiseCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community\nDriven'**
  String get ourPromiseCommunity;

  /// No description provided for @needHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Need help right now?'**
  String get needHelpTitle;

  /// No description provided for @needHelpBodyPrefix.
  ///
  /// In en, this message translates to:
  /// **'If you are in danger or need urgent assistance, visit our '**
  String get needHelpBodyPrefix;

  /// No description provided for @needHelpBodyLink.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get needHelpBodyLink;

  /// No description provided for @needHelpBodySuffix.
  ///
  /// In en, this message translates to:
  /// **' page for emergency numbers and resources.'**
  String get needHelpBodySuffix;

  /// No description provided for @reportAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Incident'**
  String get reportAppBarTitle;

  /// No description provided for @reportEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Anonymous · Encrypted · Free'**
  String get reportEyebrow;

  /// No description provided for @reportHeadline.
  ///
  /// In en, this message translates to:
  /// **'Report an incident'**
  String get reportHeadline;

  /// No description provided for @reportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Submit anonymously — no account needed.'**
  String get reportSubtitle;

  /// No description provided for @reportCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get reportCountryLabel;

  /// No description provided for @reportCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get reportCategoryLabel;

  /// No description provided for @reportPlatformLabel.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get reportPlatformLabel;

  /// No description provided for @reportHarasserUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Harasser Username'**
  String get reportHarasserUsernameLabel;

  /// No description provided for @reportHarasserUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'@username of the harasser'**
  String get reportHarasserUsernameHint;

  /// No description provided for @reportHarasserUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Harasser Profile URL (optional)'**
  String get reportHarasserUrlLabel;

  /// No description provided for @reportHarasserUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://instagram.com/username'**
  String get reportHarasserUrlHint;

  /// No description provided for @reportDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get reportDescriptionLabel;

  /// No description provided for @reportDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what happened in detail...'**
  String get reportDescriptionHint;

  /// No description provided for @reportEvidenceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'EVIDENCE (required for this category)'**
  String get reportEvidenceSectionTitle;

  /// No description provided for @reportOriginalImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Original image'**
  String get reportOriginalImageLabel;

  /// No description provided for @reportFakeImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Edited / fake image'**
  String get reportFakeImageLabel;

  /// No description provided for @reportVideoLabel.
  ///
  /// In en, this message translates to:
  /// **'Deepfake video'**
  String get reportVideoLabel;

  /// No description provided for @reportContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Contact (optional)'**
  String get reportContactLabel;

  /// No description provided for @reportContactHint.
  ///
  /// In en, this message translates to:
  /// **'Email or phone for follow-up'**
  String get reportContactHint;

  /// No description provided for @reportSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get reportSubmitButton;

  /// No description provided for @reportServerDelayNotice.
  ///
  /// In en, this message translates to:
  /// **'The server may take 10–15 seconds to respond if it has been idle.'**
  String get reportServerDelayNotice;

  /// No description provided for @reportValidationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get reportValidationRequired;

  /// No description provided for @reportValidationDescribe.
  ///
  /// In en, this message translates to:
  /// **'Please describe what happened'**
  String get reportValidationDescribe;

  /// No description provided for @reportValidationSelect.
  ///
  /// In en, this message translates to:
  /// **'Please select {label}'**
  String reportValidationSelect(String label);

  /// No description provided for @reportValidationFillFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields above.'**
  String get reportValidationFillFields;

  /// No description provided for @reportValidationNeedsImages.
  ///
  /// In en, this message translates to:
  /// **'This category requires both the original and edited image.'**
  String get reportValidationNeedsImages;

  /// No description provided for @reportValidationNeedsVideo.
  ///
  /// In en, this message translates to:
  /// **'Please upload the video for this category.'**
  String get reportValidationNeedsVideo;

  /// No description provided for @reportSubmitGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong submitting your report. Please try again.'**
  String get reportSubmitGenericError;

  /// No description provided for @helpAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpAppBarTitle;

  /// No description provided for @helpEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get helpEyebrow;

  /// No description provided for @helpHeadline.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpHeadline;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Answers to common questions about using ShieldNet. If you don\'t see what you\'re looking for, you can reach out at the bottom of this page.'**
  String get helpSubtitle;

  /// No description provided for @helpEmergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Need Immediate Help?'**
  String get helpEmergencyTitle;

  /// No description provided for @helpEmergencyBody.
  ///
  /// In en, this message translates to:
  /// **'If you are in immediate danger, contact emergency services directly — tap any number below to call.'**
  String get helpEmergencyBody;

  /// No description provided for @helpEmergencyFia.
  ///
  /// In en, this message translates to:
  /// **'FIA Cyber Crime Helpline'**
  String get helpEmergencyFia;

  /// No description provided for @helpEmergencyPolice.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get helpEmergencyPolice;

  /// No description provided for @helpEmergencyAmbulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get helpEmergencyAmbulance;

  /// No description provided for @helpEmergencyWomen.
  ///
  /// In en, this message translates to:
  /// **'Women Helpline'**
  String get helpEmergencyWomen;

  /// No description provided for @helpFaqSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'FREQUENTLY ASKED QUESTIONS'**
  String get helpFaqSectionTitle;

  /// No description provided for @helpFaq1Q.
  ///
  /// In en, this message translates to:
  /// **'I submitted a report but didn\'t get a token. What happened?'**
  String get helpFaq1Q;

  /// No description provided for @helpFaq1A.
  ///
  /// In en, this message translates to:
  /// **'If the connection dropped before the confirmation loaded, your report may not have been saved. Please submit it again — duplicate reports are not a problem on our end.'**
  String get helpFaq1A;

  /// No description provided for @helpFaq2Q.
  ///
  /// In en, this message translates to:
  /// **'I lost my tracking token. Can I get it back?'**
  String get helpFaq2Q;

  /// No description provided for @helpFaq2A.
  ///
  /// In en, this message translates to:
  /// **'If you provided contact info when reporting, the admin team can verify your identity and resend it. Otherwise, since ShieldNet stores no personal data by default, the token cannot be recovered.'**
  String get helpFaq2A;

  /// No description provided for @helpFaq3Q.
  ///
  /// In en, this message translates to:
  /// **'Will the harasser find out I reported them?'**
  String get helpFaq3Q;

  /// No description provided for @helpFaq3A.
  ///
  /// In en, this message translates to:
  /// **'No. Reports are completely anonymous unless you choose to provide contact details, and that information is only ever visible to the admin team — never to the person you reported.'**
  String get helpFaq3A;

  /// No description provided for @helpFaq4Q.
  ///
  /// In en, this message translates to:
  /// **'Is my identity really anonymous?'**
  String get helpFaq4Q;

  /// No description provided for @helpFaq4A.
  ///
  /// In en, this message translates to:
  /// **'Yes. By default we collect no name, account, or device identifier. The contact field is optional and used only for follow-up if you provide it.'**
  String get helpFaq4A;

  /// No description provided for @helpFaq5Q.
  ///
  /// In en, this message translates to:
  /// **'What happens to my evidence after I submit it?'**
  String get helpFaq5Q;

  /// No description provided for @helpFaq5A.
  ///
  /// In en, this message translates to:
  /// **'Evidence is analyzed to help verify the report, then stored securely and used only for the takedown and review process.'**
  String get helpFaq5A;

  /// No description provided for @helpFaq6Q.
  ///
  /// In en, this message translates to:
  /// **'What if I need urgent help right now?'**
  String get helpFaq6Q;

  /// No description provided for @helpFaq6A.
  ///
  /// In en, this message translates to:
  /// **'If you are in immediate danger, contact local emergency services first. For cyber harassment specifically, you can call the FIA Cybercrime Helpline at 1991 — see the emergency numbers above.'**
  String get helpFaq6A;

  /// No description provided for @helpSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Still stuck?'**
  String get helpSupportTitle;

  /// No description provided for @helpSupportBody.
  ///
  /// In en, this message translates to:
  /// **'If your question wasn\'t answered above, you can email us directly and we\'ll do our best to help.'**
  String get helpSupportBody;

  /// No description provided for @helpSupportEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get helpSupportEmailButton;

  /// No description provided for @helpSupportEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open an email app on this device.'**
  String get helpSupportEmailFailed;

  /// No description provided for @helpSupportCallFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start a call to {number}.'**
  String helpSupportCallFailed(String number);

  /// No description provided for @helpFooterTagline.
  ///
  /// In en, this message translates to:
  /// **'Protecting victims. Exposing abusers. Connecting the world.'**
  String get helpFooterTagline;

  /// No description provided for @helpFooterPlatformTitle.
  ///
  /// In en, this message translates to:
  /// **'PLATFORM'**
  String get helpFooterPlatformTitle;

  /// No description provided for @helpFooterEmergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY RESOURCES'**
  String get helpFooterEmergencyTitle;

  /// No description provided for @helpFooterReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get helpFooterReport;

  /// No description provided for @helpFooterTrack.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get helpFooterTrack;

  /// No description provided for @helpFooterStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get helpFooterStatistics;

  /// No description provided for @helpFooterFia.
  ///
  /// In en, this message translates to:
  /// **'FIA Cyber Crime: 1991'**
  String get helpFooterFia;

  /// No description provided for @helpFooterPolice.
  ///
  /// In en, this message translates to:
  /// **'Police: 15'**
  String get helpFooterPolice;

  /// No description provided for @helpFooterWomen.
  ///
  /// In en, this message translates to:
  /// **'Women Helpline: 1099'**
  String get helpFooterWomen;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'fr', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
