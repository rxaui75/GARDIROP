import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'GARDIROP'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your wardrobe. Smarter.'**
  String get tagline;

  /// No description provided for @heroLine.
  ///
  /// In en, this message translates to:
  /// **'A more you, in every outfit.'**
  String get heroLine;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get alreadyHaveAccount;

  /// No description provided for @styleBrighterYou.
  ///
  /// In en, this message translates to:
  /// **'Style a brighter you'**
  String get styleBrighterYou;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your style journey today.'**
  String get signupSubtitle;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get fullNameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreated;

  /// No description provided for @termsAgreement.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy.'**
  String get termsAgreement;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get emailAlreadyRegistered;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection.'**
  String get networkError;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @whoAreWeStylingTitle.
  ///
  /// In en, this message translates to:
  /// **'Who are we styling?'**
  String get whoAreWeStylingTitle;

  /// No description provided for @whoAreWeStylingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us a little about you so we can personalize your style experience.'**
  String get whoAreWeStylingSubtitle;

  /// No description provided for @stylingWomen.
  ///
  /// In en, this message translates to:
  /// **'Woman'**
  String get stylingWomen;

  /// No description provided for @stylingMen.
  ///
  /// In en, this message translates to:
  /// **'Man'**
  String get stylingMen;

  /// No description provided for @stylingBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get stylingBoth;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @styleSwipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Which style feels most like you?'**
  String get styleSwipeTitle;

  /// No description provided for @styleSwipeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Swipe right for yes, left for no.'**
  String get styleSwipeSubtitle;

  /// No description provided for @styleSwipeYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get styleSwipeYes;

  /// No description provided for @styleSwipeNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get styleSwipeNo;

  /// No description provided for @styleSwipeOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get styleSwipeOf;

  /// No description provided for @styleSwipeComplete.
  ///
  /// In en, this message translates to:
  /// **'Great! We’re learning your style.'**
  String get styleSwipeComplete;

  /// No description provided for @preferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'A few final touches'**
  String get preferencesTitle;

  /// No description provided for @preferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us understand what feels right for you.'**
  String get preferencesSubtitle;

  /// No description provided for @favoriteColors.
  ///
  /// In en, this message translates to:
  /// **'Colors you love'**
  String get favoriteColors;

  /// No description provided for @colorsToAvoid.
  ///
  /// In en, this message translates to:
  /// **'Colors you avoid'**
  String get colorsToAvoid;

  /// No description provided for @preferredFits.
  ///
  /// In en, this message translates to:
  /// **'How do you like your clothes to fit?'**
  String get preferredFits;

  /// No description provided for @fitSlim.
  ///
  /// In en, this message translates to:
  /// **'Slim'**
  String get fitSlim;

  /// No description provided for @fitRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get fitRegular;

  /// No description provided for @fitRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get fitRelaxed;

  /// No description provided for @fitOversized.
  ///
  /// In en, this message translates to:
  /// **'Oversized'**
  String get fitOversized;

  /// No description provided for @preferredOccasions.
  ///
  /// In en, this message translates to:
  /// **'What do you dress for most?'**
  String get preferredOccasions;

  /// No description provided for @occasionEveryday.
  ///
  /// In en, this message translates to:
  /// **'Everyday'**
  String get occasionEveryday;

  /// No description provided for @occasionUniversity.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get occasionUniversity;

  /// No description provided for @occasionWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get occasionWork;

  /// No description provided for @occasionEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get occasionEvents;

  /// No description provided for @occasionGoingOut.
  ///
  /// In en, this message translates to:
  /// **'Going out'**
  String get occasionGoingOut;

  /// No description provided for @occasionSport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get occasionSport;

  /// No description provided for @preferencesContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get preferencesContinue;

  /// No description provided for @preferencesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Any preferences?'**
  String get preferencesScreenTitle;

  /// No description provided for @preferencesScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us more about your style and lifestyle.'**
  String get preferencesScreenSubtitle;

  /// No description provided for @styleVibe.
  ///
  /// In en, this message translates to:
  /// **'Style Vibe'**
  String get styleVibe;

  /// No description provided for @vibeMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get vibeMinimal;

  /// No description provided for @vibeChic.
  ///
  /// In en, this message translates to:
  /// **'Chic'**
  String get vibeChic;

  /// No description provided for @vibeCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get vibeCasual;

  /// No description provided for @vibeTrendy.
  ///
  /// In en, this message translates to:
  /// **'Trendy'**
  String get vibeTrendy;

  /// No description provided for @vibeClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get vibeClassic;

  /// No description provided for @vibeEdgy.
  ///
  /// In en, this message translates to:
  /// **'Edgy'**
  String get vibeEdgy;

  /// No description provided for @occasions.
  ///
  /// In en, this message translates to:
  /// **'Occasions'**
  String get occasions;

  /// No description provided for @occasionTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get occasionTravel;

  /// No description provided for @occasionSpecialEvent.
  ///
  /// In en, this message translates to:
  /// **'Special Event'**
  String get occasionSpecialEvent;

  /// No description provided for @occasionAtHome.
  ///
  /// In en, this message translates to:
  /// **'At Home'**
  String get occasionAtHome;

  /// No description provided for @fitSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Help us get the details right.'**
  String get fitSizeTitle;

  /// No description provided for @fitSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This ensures better fit and more accurate recommendations.'**
  String get fitSizeSubtitle;

  /// No description provided for @mySize.
  ///
  /// In en, this message translates to:
  /// **'My size'**
  String get mySize;

  /// No description provided for @fitPreference.
  ///
  /// In en, this message translates to:
  /// **'Fit preference'**
  String get fitPreference;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weightOptional.
  ///
  /// In en, this message translates to:
  /// **'Weight (optional)'**
  String get weightOptional;

  /// No description provided for @selectSize.
  ///
  /// In en, this message translates to:
  /// **'Select size'**
  String get selectSize;

  /// No description provided for @selectFit.
  ///
  /// In en, this message translates to:
  /// **'Select fit'**
  String get selectFit;

  /// No description provided for @enterHeight.
  ///
  /// In en, this message translates to:
  /// **'Enter height'**
  String get enterHeight;

  /// No description provided for @enterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter weight'**
  String get enterWeight;

  /// No description provided for @centimeters.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get centimeters;

  /// No description provided for @kilograms.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kilograms;

  /// No description provided for @styleDnaTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Style DNA'**
  String get styleDnaTitle;

  /// No description provided for @styleDnaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quick look at your style profile so far.'**
  String get styleDnaSubtitle;

  /// No description provided for @styleDnaContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get styleDnaContinue;

  /// No description provided for @highlightMinimal.
  ///
  /// In en, this message translates to:
  /// **'Clean and effortless styling'**
  String get highlightMinimal;

  /// No description provided for @highlightClassic.
  ///
  /// In en, this message translates to:
  /// **'Timeless and refined pieces'**
  String get highlightClassic;

  /// No description provided for @highlightPolished.
  ///
  /// In en, this message translates to:
  /// **'Polished and elevated looks'**
  String get highlightPolished;

  /// No description provided for @highlightCasual.
  ///
  /// In en, this message translates to:
  /// **'Comfortable everyday outfits'**
  String get highlightCasual;

  /// No description provided for @highlightExpressive.
  ///
  /// In en, this message translates to:
  /// **'Expressive looks with personality'**
  String get highlightExpressive;

  /// No description provided for @highlightBold.
  ///
  /// In en, this message translates to:
  /// **'Confident statement styling'**
  String get highlightBold;

  /// No description provided for @highlightSporty.
  ///
  /// In en, this message translates to:
  /// **'Practical looks built for movement'**
  String get highlightSporty;

  /// No description provided for @highlightRomantic.
  ///
  /// In en, this message translates to:
  /// **'Soft and feminine details'**
  String get highlightRomantic;

  /// No description provided for @highlightRugged.
  ///
  /// In en, this message translates to:
  /// **'Strong textures and practical pieces'**
  String get highlightRugged;

  /// No description provided for @highlightVersatile.
  ///
  /// In en, this message translates to:
  /// **'Versatile across different occasions'**
  String get highlightVersatile;

  /// No description provided for @highlightSlimFit.
  ///
  /// In en, this message translates to:
  /// **'Prefers a more fitted silhouette'**
  String get highlightSlimFit;

  /// No description provided for @highlightRegularFit.
  ///
  /// In en, this message translates to:
  /// **'Prefers a balanced regular fit'**
  String get highlightRegularFit;

  /// No description provided for @highlightRelaxedFit.
  ///
  /// In en, this message translates to:
  /// **'Prefers comfortable relaxed fits'**
  String get highlightRelaxedFit;

  /// No description provided for @highlightOversizedFit.
  ///
  /// In en, this message translates to:
  /// **'Enjoys oversized silhouettes'**
  String get highlightOversizedFit;

  /// No description provided for @highlightMixMatch.
  ///
  /// In en, this message translates to:
  /// **'Easy to mix and match'**
  String get highlightMixMatch;

  /// No description provided for @highlightComfortStyle.
  ///
  /// In en, this message translates to:
  /// **'A balance of comfort and style'**
  String get highlightComfortStyle;

  /// No description provided for @highlightPersonalized.
  ///
  /// In en, this message translates to:
  /// **'Personalized around your preferences'**
  String get highlightPersonalized;

  /// No description provided for @addFirstItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first items'**
  String get addFirstItemsTitle;

  /// No description provided for @addFirstItemsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with 5–8 pieces to get personalized recommendations.'**
  String get addFirstItemsSubtitle;

  /// No description provided for @takePhotos.
  ///
  /// In en, this message translates to:
  /// **'Take Photos'**
  String get takePhotos;

  /// No description provided for @takePhotosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Snap your clothes now'**
  String get takePhotosSubtitle;

  /// No description provided for @uploadFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Upload from Gallery'**
  String get uploadFromGallery;

  /// No description provided for @uploadFromGallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose from your photos'**
  String get uploadFromGallerySubtitle;

  /// No description provided for @browseCatalog.
  ///
  /// In en, this message translates to:
  /// **'Browse Catalog'**
  String get browseCatalog;

  /// No description provided for @browseCatalogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add items from our catalog'**
  String get browseCatalogSubtitle;

  /// No description provided for @doThisLater.
  ///
  /// In en, this message translates to:
  /// **'Do This Later'**
  String get doThisLater;

  /// No description provided for @allSetTitle.
  ///
  /// In en, this message translates to:
  /// **'You’re all set!'**
  String get allSetTitle;

  /// No description provided for @allSetWithItemsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We’ll now create your first outfits based on your style and items.'**
  String get allSetWithItemsSubtitle;

  /// No description provided for @allSetWithoutItemsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your style profile is ready. Add a few items anytime to unlock personalized outfits.'**
  String get allSetWithoutItemsSubtitle;

  /// No description provided for @seeFirstOutfits.
  ///
  /// In en, this message translates to:
  /// **'See My First Outfits'**
  String get seeFirstOutfits;

  /// No description provided for @startExploring.
  ///
  /// In en, this message translates to:
  /// **'Start Exploring'**
  String get startExploring;

  /// No description provided for @exploreTheApp.
  ///
  /// In en, this message translates to:
  /// **'Explore the App'**
  String get exploreTheApp;

  /// No description provided for @exploreGardiropTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore GARDIROP'**
  String get exploreGardiropTitle;

  /// No description provided for @exploreGardiropSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here’s what you can do.'**
  String get exploreGardiropSubtitle;

  /// No description provided for @aiStylist.
  ///
  /// In en, this message translates to:
  /// **'AI Stylist'**
  String get aiStylist;

  /// No description provided for @aiStylistDescription.
  ///
  /// In en, this message translates to:
  /// **'Get personalized outfits and advice.'**
  String get aiStylistDescription;

  /// No description provided for @myCloset.
  ///
  /// In en, this message translates to:
  /// **'My Closet'**
  String get myCloset;

  /// No description provided for @myClosetDescription.
  ///
  /// In en, this message translates to:
  /// **'Organize and manage your wardrobe.'**
  String get myClosetDescription;

  /// No description provided for @styleFeature.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get styleFeature;

  /// No description provided for @styleFeatureDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover new looks for any occasion.'**
  String get styleFeatureDescription;

  /// No description provided for @shouldIBuyThis.
  ///
  /// In en, this message translates to:
  /// **'Should I Buy This?'**
  String get shouldIBuyThis;

  /// No description provided for @shouldIBuyThisDescription.
  ///
  /// In en, this message translates to:
  /// **'Make smarter choices before you buy.'**
  String get shouldIBuyThisDescription;

  /// No description provided for @closetGaps.
  ///
  /// In en, this message translates to:
  /// **'Closet Gaps'**
  String get closetGaps;

  /// No description provided for @closetGapsDescription.
  ///
  /// In en, this message translates to:
  /// **'See what’s missing from your wardrobe.'**
  String get closetGapsDescription;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your style journey.'**
  String get signInSubtitle;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createAccountLink.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountLink;

  /// No description provided for @invalidEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get invalidEmailOrPassword;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get signInFailed;

  /// No description provided for @gardiCamera.
  ///
  /// In en, this message translates to:
  /// **'Gardi Camera'**
  String get gardiCamera;

  /// No description provided for @cameraScanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Position one clothing item inside the frame'**
  String get cameraScanInstruction;

  /// No description provided for @cameraAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get cameraAuto;

  /// No description provided for @cameraManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get cameraManual;

  /// No description provided for @cameraClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get cameraClose;

  /// No description provided for @cameraFlash.
  ///
  /// In en, this message translates to:
  /// **'Flash'**
  String get cameraFlash;

  /// No description provided for @aiResultTitle.
  ///
  /// In en, this message translates to:
  /// **'AI RESULT'**
  String get aiResultTitle;

  /// No description provided for @itemDetected.
  ///
  /// In en, this message translates to:
  /// **'Item detected'**
  String get itemDetected;

  /// No description provided for @detectedByGardi.
  ///
  /// In en, this message translates to:
  /// **'Detected by Gardi'**
  String get detectedByGardi;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @material.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @fit.
  ///
  /// In en, this message translates to:
  /// **'Fit'**
  String get fit;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get season;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @occasion.
  ///
  /// In en, this message translates to:
  /// **'Occasion'**
  String get occasion;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @notDetected.
  ///
  /// In en, this message translates to:
  /// **'Not detected'**
  String get notDetected;

  /// No description provided for @saveToMyCloset.
  ///
  /// In en, this message translates to:
  /// **'Save to My Closet'**
  String get saveToMyCloset;

  /// No description provided for @reviewEditDetails.
  ///
  /// In en, this message translates to:
  /// **'Review & Edit Details'**
  String get reviewEditDetails;

  /// No description provided for @couldNotSaveItem.
  ///
  /// In en, this message translates to:
  /// **'Could not save this item. Please try again.'**
  String get couldNotSaveItem;

  /// No description provided for @styleMeTitle.
  ///
  /// In en, this message translates to:
  /// **'STYLE ME'**
  String get styleMeTitle;

  /// No description provided for @styleMeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create, style, and save looks from your wardrobe.'**
  String get styleMeSubtitle;

  /// No description provided for @styleLooksTab.
  ///
  /// In en, this message translates to:
  /// **'Looks'**
  String get styleLooksTab;

  /// No description provided for @styleItemsTab.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get styleItemsTab;

  /// No description provided for @styleItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an item to style'**
  String get styleItemsTitle;

  /// No description provided for @styleItemsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick something from your closet and Gardi will build a look around it.'**
  String get styleItemsSubtitle;

  /// No description provided for @styleItemsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your closet is waiting'**
  String get styleItemsEmptyTitle;

  /// No description provided for @styleItemsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a few items to your closet first, then come back to style them.'**
  String get styleItemsEmptySubtitle;

  /// No description provided for @styleItemsLoadingError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your closet right now.'**
  String get styleItemsLoadingError;

  /// No description provided for @styleAnOutfit.
  ///
  /// In en, this message translates to:
  /// **'Style an Outfit'**
  String get styleAnOutfit;

  /// No description provided for @styleAnOutfitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose pieces from your closet and let Gardi help bring the look together.'**
  String get styleAnOutfitSubtitle;

  /// No description provided for @myLooks.
  ///
  /// In en, this message translates to:
  /// **'My Looks'**
  String get myLooks;

  /// No description provided for @myLooksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Outfits you\'ve created and saved.'**
  String get myLooksSubtitle;

  /// No description provided for @noSavedLooksTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved looks yet'**
  String get noSavedLooksTitle;

  /// No description provided for @noSavedLooksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Style your first outfit and save it here.'**
  String get noSavedLooksSubtitle;

  /// No description provided for @selectOutfitItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Your Pieces'**
  String get selectOutfitItemsTitle;

  /// No description provided for @selectOutfitItemsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the pieces you want to style together.'**
  String get selectOutfitItemsSubtitle;

  /// No description provided for @outfitItemsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String outfitItemsSelected(int count);

  /// No description provided for @continueOutfit.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueOutfit;

  /// No description provided for @selectAtLeastTwoItems.
  ///
  /// In en, this message translates to:
  /// **'Select at least 2 pieces to create an outfit.'**
  String get selectAtLeastTwoItems;

  /// No description provided for @outfitClosetEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your closet is empty'**
  String get outfitClosetEmptyTitle;

  /// No description provided for @outfitClosetEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add some pieces to your closet before styling an outfit.'**
  String get outfitClosetEmptySubtitle;

  /// No description provided for @outfitClosetLoadError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your closet right now.'**
  String get outfitClosetLoadError;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @outfitBuilderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Outfit'**
  String get outfitBuilderTitle;

  /// No description provided for @outfitBuilderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review the pieces you\'ve chosen before Gardi styles the look.'**
  String get outfitBuilderSubtitle;

  /// No description provided for @selectedPieces.
  ///
  /// In en, this message translates to:
  /// **'Selected Pieces'**
  String get selectedPieces;

  /// No description provided for @analyzeWithGardi.
  ///
  /// In en, this message translates to:
  /// **'Analyze with Gardi'**
  String get analyzeWithGardi;

  /// No description provided for @gardiAnalyzingItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Gardi is analyzing\nyour item...'**
  String get gardiAnalyzingItemTitle;

  /// No description provided for @gardiAnalyzingOutfitTitle.
  ///
  /// In en, this message translates to:
  /// **'Gardi is styling\nyour outfit...'**
  String get gardiAnalyzingOutfitTitle;

  /// No description provided for @gardiAnalyzingWait.
  ///
  /// In en, this message translates to:
  /// **'Just a few seconds ✦'**
  String get gardiAnalyzingWait;

  /// No description provided for @gardiItemStepIdentify.
  ///
  /// In en, this message translates to:
  /// **'Identifying item'**
  String get gardiItemStepIdentify;

  /// No description provided for @gardiItemStepColor.
  ///
  /// In en, this message translates to:
  /// **'Detecting color'**
  String get gardiItemStepColor;

  /// No description provided for @gardiItemStepMaterial.
  ///
  /// In en, this message translates to:
  /// **'Analyzing material'**
  String get gardiItemStepMaterial;

  /// No description provided for @gardiItemStepStyle.
  ///
  /// In en, this message translates to:
  /// **'Finding style'**
  String get gardiItemStepStyle;

  /// No description provided for @gardiItemStepSeason.
  ///
  /// In en, this message translates to:
  /// **'Checking season & occasion'**
  String get gardiItemStepSeason;

  /// No description provided for @gardiOutfitStepColor.
  ///
  /// In en, this message translates to:
  /// **'Checking color harmony'**
  String get gardiOutfitStepColor;

  /// No description provided for @gardiOutfitStepStyle.
  ///
  /// In en, this message translates to:
  /// **'Matching styles'**
  String get gardiOutfitStepStyle;

  /// No description provided for @gardiOutfitStepFit.
  ///
  /// In en, this message translates to:
  /// **'Reviewing fit & balance'**
  String get gardiOutfitStepFit;

  /// No description provided for @gardiOutfitStepOccasion.
  ///
  /// In en, this message translates to:
  /// **'Checking occasion & season'**
  String get gardiOutfitStepOccasion;

  /// No description provided for @gardiOutfitStepFinish.
  ///
  /// In en, this message translates to:
  /// **'Putting the look together'**
  String get gardiOutfitStepFinish;

  /// No description provided for @gardiAnalyzingItemProgress.
  ///
  /// In en, this message translates to:
  /// **'Gardi is getting to know this piece.'**
  String get gardiAnalyzingItemProgress;

  /// No description provided for @gardiAnalyzingOutfitProgress.
  ///
  /// In en, this message translates to:
  /// **'Gardi is bringing your pieces together.'**
  String get gardiAnalyzingOutfitProgress;

  /// No description provided for @gardiAnalyzingAlmostDone.
  ///
  /// In en, this message translates to:
  /// **'Almost there ✦'**
  String get gardiAnalyzingAlmostDone;

  /// No description provided for @gardiOutfitErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Gardi needs a moment'**
  String get gardiOutfitErrorTitle;

  /// No description provided for @gardiOutfitErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Gardi couldn\'t analyze this outfit right now. Please try again in a moment.'**
  String get gardiOutfitErrorMessage;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @gardiTakeTitle.
  ///
  /// In en, this message translates to:
  /// **'Gardi’s Take'**
  String get gardiTakeTitle;

  /// No description provided for @gardiTakeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here’s how your pieces work together.'**
  String get gardiTakeSubtitle;

  /// No description provided for @gardiWorksWell.
  ///
  /// In en, this message translates to:
  /// **'Works Well'**
  String get gardiWorksWell;

  /// No description provided for @gardiAlmostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost There'**
  String get gardiAlmostThere;

  /// No description provided for @gardiNeedsAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Needs a Little Adjustment'**
  String get gardiNeedsAdjustment;

  /// No description provided for @gardiColorHarmony.
  ///
  /// In en, this message translates to:
  /// **'Color Harmony'**
  String get gardiColorHarmony;

  /// No description provided for @gardiStyleHarmony.
  ///
  /// In en, this message translates to:
  /// **'Style Harmony'**
  String get gardiStyleHarmony;

  /// No description provided for @gardiFitBalance.
  ///
  /// In en, this message translates to:
  /// **'Fit & Balance'**
  String get gardiFitBalance;

  /// No description provided for @gardiOccasionMatch.
  ///
  /// In en, this message translates to:
  /// **'Occasion'**
  String get gardiOccasionMatch;

  /// No description provided for @gardiSeasonMatch.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get gardiSeasonMatch;

  /// No description provided for @gardiWhyItWorks.
  ///
  /// In en, this message translates to:
  /// **'Why It Works'**
  String get gardiWhyItWorks;

  /// No description provided for @gardiThingsToConsider.
  ///
  /// In en, this message translates to:
  /// **'Something to Consider'**
  String get gardiThingsToConsider;

  /// No description provided for @gardiSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Gardi Suggests'**
  String get gardiSuggestions;

  /// No description provided for @continueStyling.
  ///
  /// In en, this message translates to:
  /// **'Continue Styling'**
  String get continueStyling;

  /// No description provided for @saveLook.
  ///
  /// In en, this message translates to:
  /// **'Save Look'**
  String get saveLook;

  /// No description provided for @completeTheLookTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete the Look'**
  String get completeTheLookTitle;

  /// No description provided for @completeTheLookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pieces from your closet that could work with this look.'**
  String get completeTheLookSubtitle;

  /// No description provided for @fromYourCloset.
  ///
  /// In en, this message translates to:
  /// **'From Your Closet'**
  String get fromYourCloset;

  /// No description provided for @greatMatch.
  ///
  /// In en, this message translates to:
  /// **'Great Match'**
  String get greatMatch;

  /// No description provided for @noClosetMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'No close matches found'**
  String get noClosetMatchesTitle;

  /// No description provided for @noClosetMatchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gardi couldn’t find a close match in your closet for this suggestion.'**
  String get noClosetMatchesSubtitle;

  /// No description provided for @gardiRecommends.
  ///
  /// In en, this message translates to:
  /// **'Gardi Recommends'**
  String get gardiRecommends;

  /// No description provided for @recommendedColors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get recommendedColors;

  /// No description provided for @recommendedStyles.
  ///
  /// In en, this message translates to:
  /// **'Styles'**
  String get recommendedStyles;

  /// No description provided for @recommendedFits.
  ///
  /// In en, this message translates to:
  /// **'Fits'**
  String get recommendedFits;

  /// No description provided for @savingLook.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingLook;

  /// No description provided for @lookSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get lookSaved;

  /// No description provided for @lookSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Look saved!'**
  String get lookSavedTitle;

  /// No description provided for @lookSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your look is now saved to My Looks.'**
  String get lookSavedMessage;

  /// No description provided for @viewMyLooks.
  ///
  /// In en, this message translates to:
  /// **'View My Looks'**
  String get viewMyLooks;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @saveLookErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your look'**
  String get saveLookErrorTitle;

  /// No description provided for @saveLookErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while saving your look. Please try again.'**
  String get saveLookErrorMessage;

  /// No description provided for @savedLookPieces.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 piece} other{{count} pieces}}'**
  String savedLookPieces(int count);

  /// No description provided for @savedLooksLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your saved looks. Please try again.'**
  String get savedLooksLoadError;

  /// No description provided for @savedLookMissingPieces.
  ///
  /// In en, this message translates to:
  /// **'Some pieces are no longer in your closet.'**
  String get savedLookMissingPieces;

  /// No description provided for @deleteLook.
  ///
  /// In en, this message translates to:
  /// **'Delete Look'**
  String get deleteLook;

  /// No description provided for @deleteLookConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this look?'**
  String get deleteLookConfirmTitle;

  /// No description provided for @deleteLookConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This look will be removed from My Looks. Your wardrobe pieces won\'t be deleted.'**
  String get deleteLookConfirmMessage;

  /// No description provided for @deleteLookError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete this look. Please try again.'**
  String get deleteLookError;

  /// No description provided for @deletingLook.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deletingLook;

  /// No description provided for @styleThisItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let Gardi create a look around this piece using your wardrobe.'**
  String get styleThisItemSubtitle;

  /// No description provided for @styleItForMe.
  ///
  /// In en, this message translates to:
  /// **'Style It For Me'**
  String get styleItForMe;

  /// No description provided for @styleThisItem.
  ///
  /// In en, this message translates to:
  /// **'Style This Item'**
  String get styleThisItem;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
