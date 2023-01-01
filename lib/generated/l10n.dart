// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Start date`
  String get startDate {
    return Intl.message(
      'Start date',
      name: 'startDate',
      desc: '',
      args: [],
    );
  }

  /// `Start time`
  String get startTime {
    return Intl.message(
      'Start time',
      name: 'startTime',
      desc: '',
      args: [],
    );
  }

  /// `Select date`
  String get selectDate {
    return Intl.message(
      'Select date',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  /// `Select time`
  String get selectTime {
    return Intl.message(
      'Select time',
      name: 'selectTime',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message(
      'Duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `Select duration`
  String get selectDuration {
    return Intl.message(
      'Select duration',
      name: 'selectDuration',
      desc: '',
      args: [],
    );
  }

  /// `Select price`
  String get selectPrice {
    return Intl.message(
      'Select price',
      name: 'selectPrice',
      desc: '',
      args: [],
    );
  }

  /// `Create offer`
  String get createOffer {
    return Intl.message(
      'Create offer',
      name: 'createOffer',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get complete {
    return Intl.message(
      'Complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Modify`
  String get modify {
    return Intl.message(
      'Modify',
      name: 'modify',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Dog`
  String get dog {
    return Intl.message(
      'Dog',
      name: 'dog',
      desc: '',
      args: [],
    );
  }

  /// `Add new dog`
  String get addNewDog {
    return Intl.message(
      'Add new dog',
      name: 'addNewDog',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get signOut {
    return Intl.message(
      'Sign out',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Modify profile`
  String get modifyProfile {
    return Intl.message(
      'Modify profile',
      name: 'modifyProfile',
      desc: '',
      args: [],
    );
  }

  /// `Finalize`
  String get finalize {
    return Intl.message(
      'Finalize',
      name: 'finalize',
      desc: '',
      args: [],
    );
  }

  /// `Max price`
  String get maxPrice {
    return Intl.message(
      'Max price',
      name: 'maxPrice',
      desc: '',
      args: [],
    );
  }

  /// `Add filter`
  String get addFilter {
    return Intl.message(
      'Add filter',
      name: 'addFilter',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Generic error`
  String get genericError {
    return Intl.message(
      'Generic error',
      name: 'genericError',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password`
  String get wrongPassword {
    return Intl.message(
      'Wrong password',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `for`
  String get fOr {
    return Intl.message(
      'for',
      name: 'fOr',
      desc: '',
      args: [],
    );
  }

  /// `No filter`
  String get noFilter {
    return Intl.message(
      'No filter',
      name: 'noFilter',
      desc: '',
      args: [],
    );
  }

  /// `Insert valid price`
  String get insertValidPrice {
    return Intl.message(
      'Insert valid price',
      name: 'insertValidPrice',
      desc: '',
      args: [],
    );
  }

  /// `Select at least one activity`
  String get selectAtLeastOneActivity {
    return Intl.message(
      'Select at least one activity',
      name: 'selectAtLeastOneActivity',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Dog profile`
  String get dogProfile {
    return Intl.message(
      'Dog profile',
      name: 'dogProfile',
      desc: '',
      args: [],
    );
  }

  /// `Name cannot be empty`
  String get nameCannotBeEmpty {
    return Intl.message(
      'Name cannot be empty',
      name: 'nameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Delete dog`
  String get deleteDog {
    return Intl.message(
      'Delete dog',
      name: 'deleteDog',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enterYourName {
    return Intl.message(
      'Enter your name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Name is required`
  String get nameIsRequired {
    return Intl.message(
      'Name is required',
      name: 'nameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `km`
  String get km {
    return Intl.message(
      'km',
      name: 'km',
      desc: '',
      args: [],
    );
  }

  /// `Show activities`
  String get showActivities {
    return Intl.message(
      'Show activities',
      name: 'showActivities',
      desc: '',
      args: [],
    );
  }

  /// `Hide activities`
  String get hideActivities {
    return Intl.message(
      'Hide activities',
      name: 'hideActivities',
      desc: '',
      args: [],
    );
  }

  /// `Add activity`
  String get addActivity {
    return Intl.message(
      'Add activity',
      name: 'addActivity',
      desc: '',
      args: [],
    );
  }

  /// `Enter message`
  String get enterMessage {
    return Intl.message(
      'Enter message',
      name: 'enterMessage',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Select dogs`
  String get selectDogs {
    return Intl.message(
      'Select dogs',
      name: 'selectDogs',
      desc: '',
      args: [],
    );
  }

  /// `Select at least a dog`
  String get selectAtLeastADog {
    return Intl.message(
      'Select at least a dog',
      name: 'selectAtLeastADog',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `My offers`
  String get myOffers {
    return Intl.message(
      'My offers',
      name: 'myOffers',
      desc: '',
      args: [],
    );
  }

  /// `Accepted offers`
  String get acceptedOffers {
    return Intl.message(
      'Accepted offers',
      name: 'acceptedOffers',
      desc: '',
      args: [],
    );
  }

  /// `Selected dogs`
  String get selectedDogs {
    return Intl.message(
      'Selected dogs',
      name: 'selectedDogs',
      desc: '',
      args: [],
    );
  }

  /// `Order summary`
  String get orderSummary {
    return Intl.message(
      'Order summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Walk the dog`
  String get walkTheDog {
    return Intl.message(
      'Walk the dog',
      name: 'walkTheDog',
      desc: '',
      args: [],
    );
  }

  /// `Activities`
  String get activities {
    return Intl.message(
      'Activities',
      name: 'activities',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Offer summary`
  String get offerSummary {
    return Intl.message(
      'Offer summary',
      name: 'offerSummary',
      desc: '',
      args: [],
    );
  }

  /// `Delete offer`
  String get deleteOffer {
    return Intl.message(
      'Delete offer',
      name: 'deleteOffer',
      desc: '',
      args: [],
    );
  }

  /// `Biography`
  String get biography {
    return Intl.message(
      'Biography',
      name: 'biography',
      desc: '',
      args: [],
    );
  }

  /// `Enter biography`
  String get enterBiography {
    return Intl.message(
      'Enter biography',
      name: 'enterBiography',
      desc: '',
      args: [],
    );
  }

  /// `Email or password error`
  String get emailOrPasswordError {
    return Intl.message(
      'Email or password error',
      name: 'emailOrPasswordError',
      desc: '',
      args: [],
    );
  }

  /// `Email already registered`
  String get emailAlreadyRegistered {
    return Intl.message(
      'Email already registered',
      name: 'emailAlreadyRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Password too weak`
  String get passwordTooWeak {
    return Intl.message(
      'Password too weak',
      name: 'passwordTooWeak',
      desc: '',
      args: [],
    );
  }

  /// `Max distance`
  String get maxDistance {
    return Intl.message(
      'Max distance',
      name: 'maxDistance',
      desc: '',
      args: [],
    );
  }

  /// `m`
  String get m {
    return Intl.message(
      'm',
      name: 'm',
      desc: '',
      args: [],
    );
  }

  /// `View live location`
  String get viewLiveLocation {
    return Intl.message(
      'View live location',
      name: 'viewLiveLocation',
      desc: '',
      args: [],
    );
  }

  /// `Live location`
  String get liveLocation {
    return Intl.message(
      'Live location',
      name: 'liveLocation',
      desc: '',
      args: [],
    );
  }

  /// `Share live location`
  String get shareLiveLocation {
    return Intl.message(
      'Share live location',
      name: 'shareLiveLocation',
      desc: '',
      args: [],
    );
  }

  /// `Live location is not available`
  String get liveLocationIsNotAvailable {
    return Intl.message(
      'Live location is not available',
      name: 'liveLocationIsNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Can't share location yet`
  String get cantShareLocationYet {
    return Intl.message(
      'Can\'t share location yet',
      name: 'cantShareLocationYet',
      desc: '',
      args: [],
    );
  }

  /// `Pick a location`
  String get pickALocation {
    return Intl.message(
      'Pick a location',
      name: 'pickALocation',
      desc: '',
      args: [],
    );
  }

  /// `Delete order`
  String get deleteOrder {
    return Intl.message(
      'Delete order',
      name: 'deleteOrder',
      desc: '',
      args: [],
    );
  }

  /// `As offeror`
  String get asOfferor {
    return Intl.message(
      'As offeror',
      name: 'asOfferor',
      desc: '',
      args: [],
    );
  }

  /// `As client`
  String get asClient {
    return Intl.message(
      'As client',
      name: 'asClient',
      desc: '',
      args: [],
    );
  }

  /// `Run`
  String get run {
    return Intl.message(
      'Run',
      name: 'run',
      desc: '',
      args: [],
    );
  }

  /// `Swim`
  String get swim {
    return Intl.message(
      'Swim',
      name: 'swim',
      desc: '',
      args: [],
    );
  }

  /// `Park`
  String get park {
    return Intl.message(
      'Park',
      name: 'park',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
