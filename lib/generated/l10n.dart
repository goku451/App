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

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get Welcome {
    return Intl.message(
      'Welcome',
      name: 'Welcome',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to\nSmartSys`
  String get welcome {
    return Intl.message(
      'Welcome to\nSmartSys',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `SmartSys is your trusted app to join our community of platforms. Discover all the incredible platforms we have for you!`
  String get description {
    return Intl.message(
      'SmartSys is your trusted app to join our community of platforms. Discover all the incredible platforms we have for you!',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Star`
  String get Star {
    return Intl.message(
      'Star',
      name: 'Star',
      desc: '',
      args: [],
    );
  }

  /// `Create an Account\non SmartSys`
  String get Create_Acoount {
    return Intl.message(
      'Create an Account\non SmartSys',
      name: 'Create_Acoount',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get Register {
    return Intl.message(
      'Register',
      name: 'Register',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with us to discover all our platforms`
  String get Register_text {
    return Intl.message(
      'Sign up with us to discover all our platforms',
      name: 'Register_text',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Name {
    return Intl.message(
      'Name',
      name: 'Name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Email {
    return Intl.message(
      'Email',
      name: 'Email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message(
      'Password',
      name: 'Password',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get Last_Name {
    return Intl.message(
      'Last Name',
      name: 'Last_Name',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get Create_Account_Buttom {
    return Intl.message(
      'Create Account',
      name: 'Create_Account_Buttom',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? Log In`
  String get Have_Account {
    return Intl.message(
      'Already have an account? Log In',
      name: 'Have_Account',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get Error_Name {
    return Intl.message(
      'Please enter your name',
      name: 'Error_Name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your last name`
  String get Error_Last_Name {
    return Intl.message(
      'Please enter your last name',
      name: 'Error_Last_Name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get Error_Email {
    return Intl.message(
      'Please enter your email',
      name: 'Error_Email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get Error_Password {
    return Intl.message(
      'Please enter your password',
      name: 'Error_Password',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 2 characters`
  String get Error_Name2 {
    return Intl.message(
      'Name must be at least 2 characters',
      name: 'Error_Name2',
      desc: '',
      args: [],
    );
  }

  /// `Last name must be at least 2 characters`
  String get Error_Last_Name2 {
    return Intl.message(
      'Last name must be at least 2 characters',
      name: 'Error_Last_Name2',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get Error_Email2 {
    return Intl.message(
      'Please enter a valid email',
      name: 'Error_Email2',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get Error_Password2 {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'Error_Password2',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get Login_Success {
    return Intl.message(
      'Welcome',
      name: 'Login_Success',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back!`
  String get Messages_login {
    return Intl.message(
      'Welcome back!',
      name: 'Messages_login',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get Login {
    return Intl.message(
      'Log In',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Log in to discover the new content we offer you.`
  String get Login_text {
    return Intl.message(
      'Log in to discover the new content we offer you.',
      name: 'Login_text',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get Remember_me {
    return Intl.message(
      'Remember me',
      name: 'Remember_me',
      desc: '',
      args: [],
    );
  }

  /// `Feature coming soon`
  String get Message_Future {
    return Intl.message(
      'Feature coming soon',
      name: 'Message_Future',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get Forgot_Password {
    return Intl.message(
      'Forgot your password?',
      name: 'Forgot_Password',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get Not_Have_Account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'Not_Have_Account',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get Details {
    return Intl.message(
      'View Details',
      name: 'Details',
      desc: '',
      args: [],
    );
  }

  /// `Report Platform`
  String get Report {
    return Intl.message(
      'Report Platform',
      name: 'Report',
      desc: '',
      args: [],
    );
  }

  /// `Leave Platform`
  String get Out_Plataform {
    return Intl.message(
      'Leave Platform',
      name: 'Out_Plataform',
      desc: '',
      args: [],
    );
  }

  /// `Description:`
  String get Description {
    return Intl.message(
      'Description:',
      name: 'Description',
      desc: '',
      args: [],
    );
  }

  /// `Privacy:`
  String get Privacy {
    return Intl.message(
      'Privacy:',
      name: 'Privacy',
      desc: '',
      args: [],
    );
  }

  /// `Join Date:`
  String get Date {
    return Intl.message(
      'Join Date:',
      name: 'Date',
      desc: '',
      args: [],
    );
  }

  /// `Role:`
  String get Rol {
    return Intl.message(
      'Role:',
      name: 'Rol',
      desc: '',
      args: [],
    );
  }

  /// `Status:`
  String get State {
    return Intl.message(
      'Status:',
      name: 'State',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get Close {
    return Intl.message(
      'Close',
      name: 'Close',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to leave `
  String get Message_Out {
    return Intl.message(
      'Are you sure you want to leave ',
      name: 'Message_Out',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Leave`
  String get Out {
    return Intl.message(
      'Leave',
      name: 'Out',
      desc: '',
      args: [],
    );
  }

  /// `You have left `
  String get Out_Success {
    return Intl.message(
      'You have left ',
      name: 'Out_Success',
      desc: '',
      args: [],
    );
  }

  /// `Search in SmartSys`
  String get Search {
    return Intl.message(
      'Search in SmartSys',
      name: 'Search',
      desc: '',
      args: [],
    );
  }

  /// `My Platforms`
  String get MyPlataform {
    return Intl.message(
      'My Platforms',
      name: 'MyPlataform',
      desc: '',
      args: [],
    );
  }

  /// `You don't have platforms yet`
  String get NotPlataform {
    return Intl.message(
      'You don\'t have platforms yet',
      name: 'NotPlataform',
      desc: '',
      args: [],
    );
  }

  /// `Explore and join new platforms!`
  String get MessageInto {
    return Intl.message(
      'Explore and join new platforms!',
      name: 'MessageInto',
      desc: '',
      args: [],
    );
  }

  /// `Session closed successfully`
  String get Message_Correct_Out_Sesion {
    return Intl.message(
      'Session closed successfully',
      name: 'Message_Correct_Out_Sesion',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get Close_Session {
    return Intl.message(
      'Log Out',
      name: 'Close_Session',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get Message_Close_Session {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'Message_Close_Session',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get Account {
    return Intl.message(
      'Account',
      name: 'Account',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get My_Account {
    return Intl.message(
      'My Account',
      name: 'My_Account',
      desc: '',
      args: [],
    );
  }

  /// `Security and Privacy`
  String get Setting_Privacy {
    return Intl.message(
      'Security and Privacy',
      name: 'Setting_Privacy',
      desc: '',
      args: [],
    );
  }

  /// `Main Content`
  String get Main_Content {
    return Intl.message(
      'Main Content',
      name: 'Main_Content',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Policies`
  String get Terms_and_Policies {
    return Intl.message(
      'Terms and Policies',
      name: 'Terms_and_Policies',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get Help {
    return Intl.message(
      'Help',
      name: 'Help',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get About {
    return Intl.message(
      'About',
      name: 'About',
      desc: '',
      args: [],
    );
  }

  /// `Help and Information`
  String get Help_Info {
    return Intl.message(
      'Help and Information',
      name: 'Help_Info',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get Only_Welcome {
    return Intl.message(
      'Welcome',
      name: 'Only_Welcome',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get Edit {
    return Intl.message(
      'Edit Profile',
      name: 'Edit',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get En {
    return Intl.message(
      'English',
      name: 'En',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get Es {
    return Intl.message(
      'Spanish',
      name: 'Es',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get Dark_Mode {
    return Intl.message(
      'Dark Mode',
      name: 'Dark_Mode',
      desc: '',
      args: [],
    );
  }

  /// `Light Mode`
  String get Light_Mode {
    return Intl.message(
      'Light Mode',
      name: 'Light_Mode',
      desc: '',
      args: [],
    );
  }

  /// `Loading profile data...`
  String get Message_Load {
    return Intl.message(
      'Loading profile data...',
      name: 'Message_Load',
      desc: '',
      args: [],
    );
  }

  /// `Change Photo`
  String get Change_Photo {
    return Intl.message(
      'Change Photo',
      name: 'Change_Photo',
      desc: '',
      args: [],
    );
  }

  /// `About Me`
  String get About_me {
    return Intl.message(
      'About Me',
      name: 'About_me',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get Phone {
    return Intl.message(
      'Phone',
      name: 'Phone',
      desc: '',
      args: [],
    );
  }

  /// `No Phone`
  String get OutPhone {
    return Intl.message(
      'No Phone',
      name: 'OutPhone',
      desc: '',
      args: [],
    );
  }

  /// `No bio yet`
  String get OutBio {
    return Intl.message(
      'No bio yet',
      name: 'OutBio',
      desc: '',
      args: [],
    );
  }

  /// `Change Profile Photo`
  String get Change_Photo_Message {
    return Intl.message(
      'Change Profile Photo',
      name: 'Change_Photo_Message',
      desc: '',
      args: [],
    );
  }

  /// `Choose from Gallery`
  String get Chose_galery {
    return Intl.message(
      'Choose from Gallery',
      name: 'Chose_galery',
      desc: '',
      args: [],
    );
  }

  /// `Profile photo updated successfully`
  String get Message_Edit_Photo {
    return Intl.message(
      'Profile photo updated successfully',
      name: 'Message_Edit_Photo',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get Save {
    return Intl.message(
      'Save',
      name: 'Save',
      desc: '',
      args: [],
    );
  }

  /// `Tell us your name`
  String get IntoName {
    return Intl.message(
      'Tell us your name',
      name: 'IntoName',
      desc: '',
      args: [],
    );
  }

  /// `Write a short bio about yourself`
  String get Message_Bio {
    return Intl.message(
      'Write a short bio about yourself',
      name: 'Message_Bio',
      desc: '',
      args: [],
    );
  }

  /// `Name cannot be empty`
  String get Error_Name3 {
    return Intl.message(
      'Name cannot be empty',
      name: 'Error_Name3',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get Error_Phone {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'Error_Phone',
      desc: '',
      args: [],
    );
  }

  /// `Take a Picture`
  String get Take_a_Pictura {
    return Intl.message(
      'Take a Picture',
      name: 'Take_a_Pictura',
      desc: '',
      args: [],
    );
  }

  /// `Insert to `
  String get Insert_to {
    return Intl.message(
      'Insert to ',
      name: 'Insert_to',
      desc: '',
      args: [],
    );
  }

  /// `Connection error`
  String get Connection_Error {
    return Intl.message(
      'Connection error',
      name: 'Connection_Error',
      desc: '',
      args: [],
    );
  }

  /// `Search error`
  String get Search_Error {
    return Intl.message(
      'Search error',
      name: 'Search_Error',
      desc: '',
      args: [],
    );
  }

  /// `No description`
  String get No_Description {
    return Intl.message(
      'No description',
      name: 'No_Description',
      desc: '',
      args: [],
    );
  }

  /// `Report Platform`
  String get Report_Platform {
    return Intl.message(
      'Report Platform',
      name: 'Report_Platform',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get Information {
    return Intl.message(
      'Information',
      name: 'Information',
      desc: '',
      args: [],
    );
  }

  /// `Join Platform`
  String get Join_Platform {
    return Intl.message(
      'Join Platform',
      name: 'Join_Platform',
      desc: '',
      args: [],
    );
  }

  /// `Reporting`
  String get Reporting {
    return Intl.message(
      'Reporting',
      name: 'Reporting',
      desc: '',
      args: [],
    );
  }

  /// `No description available`
  String get No_Description_Available {
    return Intl.message(
      'No description available',
      name: 'No_Description_Available',
      desc: '',
      args: [],
    );
  }

  /// `Capacity:`
  String get Capacity {
    return Intl.message(
      'Capacity:',
      name: 'Capacity',
      desc: '',
      args: [],
    );
  }

  /// `members`
  String get Members {
    return Intl.message(
      'members',
      name: 'Members',
      desc: '',
      args: [],
    );
  }

  /// `Error: User not found`
  String get User_Not_Found_Error {
    return Intl.message(
      'Error: User not found',
      name: 'User_Not_Found_Error',
      desc: '',
      args: [],
    );
  }

  /// `You have joined`
  String get Joined_Platform {
    return Intl.message(
      'You have joined',
      name: 'Joined_Platform',
      desc: '',
      args: [],
    );
  }

  /// `Error joining`
  String get Join_Error {
    return Intl.message(
      'Error joining',
      name: 'Join_Error',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get Join_To {
    return Intl.message(
      'Join',
      name: 'Join_To',
      desc: '',
      args: [],
    );
  }

  /// `This platform is private. Enter the access code:`
  String get Private_Platform_Message {
    return Intl.message(
      'This platform is private. Enter the access code:',
      name: 'Private_Platform_Message',
      desc: '',
      args: [],
    );
  }

  /// `Access code`
  String get Access_Code {
    return Intl.message(
      'Access code',
      name: 'Access_Code',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get Join {
    return Intl.message(
      'Join',
      name: 'Join',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid code`
  String get Valid_Code_Required {
    return Intl.message(
      'Please enter a valid code',
      name: 'Valid_Code_Required',
      desc: '',
      args: [],
    );
  }

  /// `Search platform`
  String get Search_Platform {
    return Intl.message(
      'Search platform',
      name: 'Search_Platform',
      desc: '',
      args: [],
    );
  }

  /// `Active Platforms`
  String get Active_Platforms {
    return Intl.message(
      'Active Platforms',
      name: 'Active_Platforms',
      desc: '',
      args: [],
    );
  }

  /// `Search Results`
  String get Search_Results {
    return Intl.message(
      'Search Results',
      name: 'Search_Results',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get Retry {
    return Intl.message(
      'Retry',
      name: 'Retry',
      desc: '',
      args: [],
    );
  }

  /// `No platforms available`
  String get No_Platforms_Available {
    return Intl.message(
      'No platforms available',
      name: 'No_Platforms_Available',
      desc: '',
      args: [],
    );
  }

  /// `No results found for`
  String get No_Results_Found {
    return Intl.message(
      'No results found for',
      name: 'No_Results_Found',
      desc: '',
      args: [],
    );
  }

  /// `Create platform functionality`
  String get Create_Platform_Feature {
    return Intl.message(
      'Create platform functionality',
      name: 'Create_Platform_Feature',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get Calendar {
    return Intl.message(
      'Calendar',
      name: 'Calendar',
      desc: '',
      args: [],
    );
  }

  /// `Today's Events`
  String get Today_Events {
    return Intl.message(
      'Today\'s Events',
      name: 'Today_Events',
      desc: '',
      args: [],
    );
  }

  /// `No events for this day`
  String get No_Events_This_Day {
    return Intl.message(
      'No events for this day',
      name: 'No_Events_This_Day',
      desc: '',
      args: [],
    );
  }

  /// `Add Event`
  String get Add_Event {
    return Intl.message(
      'Add Event',
      name: 'Add_Event',
      desc: '',
      args: [],
    );
  }

  /// `Event Title`
  String get Event_Title {
    return Intl.message(
      'Event Title',
      name: 'Event_Title',
      desc: '',
      args: [],
    );
  }

  /// `Time (e.g: 10:00 AM)`
  String get Event_Time {
    return Intl.message(
      'Time (e.g: 10:00 AM)',
      name: 'Event_Time',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get Add {
    return Intl.message(
      'Add',
      name: 'Add',
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
      Locale.fromSubtags(languageCode: 'es'),
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
