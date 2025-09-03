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

  /// `Start`
  String get Start {
    return Intl.message(
      'Start',
      name: 'Start',
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

  /// `All chats`
  String get All_Chats {
    return Intl.message(
      'All chats',
      name: 'All_Chats',
      desc: '',
      args: [],
    );
  }

  /// `Search chats`
  String get Search_Chats {
    return Intl.message(
      'Search chats',
      name: 'Search_Chats',
      desc: '',
      args: [],
    );
  }

  /// `No chats available`
  String get No_Chats {
    return Intl.message(
      'No chats available',
      name: 'No_Chats',
      desc: '',
      args: [],
    );
  }

  /// `Create new chat`
  String get Create_Chat {
    return Intl.message(
      'Create new chat',
      name: 'Create_Chat',
      desc: '',
      args: [],
    );
  }

  /// `Chat Name`
  String get Chat_Name {
    return Intl.message(
      'Chat Name',
      name: 'Chat_Name',
      desc: '',
      args: [],
    );
  }

  /// `User Code`
  String get Codigo_User {
    return Intl.message(
      'User Code',
      name: 'Codigo_User',
      desc: '',
      args: [],
    );
  }

  /// `Write a message...`
  String get Write_Message {
    return Intl.message(
      'Write a message...',
      name: 'Write_Message',
      desc: '',
      args: [],
    );
  }

  /// `Publications`
  String get Publications {
    return Intl.message(
      'Publications',
      name: 'Publications',
      desc: '',
      args: [],
    );
  }

  /// `No publications available`
  String get NoPublications {
    return Intl.message(
      'No publications available',
      name: 'NoPublications',
      desc: '',
      args: [],
    );
  }

  /// `There are no publications available at the moment. Please check back later.`
  String get NoPublicationsMessage {
    return Intl.message(
      'There are no publications available at the moment. Please check back later.',
      name: 'NoPublicationsMessage',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get Codigo {
    return Intl.message(
      'Code',
      name: 'Codigo',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected error`
  String get Unexpected_Error {
    return Intl.message(
      'Unexpected error',
      name: 'Unexpected_Error',
      desc: '',
      args: [],
    );
  }

  /// `User cancelled Google login`
  String get Google_Login_Cancelled {
    return Intl.message(
      'User cancelled Google login',
      name: 'Google_Login_Cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Error saving user`
  String get Error_Saving_User {
    return Intl.message(
      'Error saving user',
      name: 'Error_Saving_User',
      desc: '',
      args: [],
    );
  }

  /// `Google error`
  String get Google_Error {
    return Intl.message(
      'Google error',
      name: 'Google_Error',
      desc: '',
      args: [],
    );
  }

  /// `Register with Google`
  String get Register_With_Google {
    return Intl.message(
      'Register with Google',
      name: 'Register_With_Google',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get Login_With_Google {
    return Intl.message(
      'Sign in with Google',
      name: 'Login_With_Google',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password? Recover account`
  String get Forgot_Password_Recover {
    return Intl.message(
      'Forgot your password? Recover account',
      name: 'Forgot_Password_Recover',
      desc: '',
      args: [],
    );
  }

  /// `Security and Privacy`
  String get Security_Privacy_Title {
    return Intl.message(
      'Security and Privacy',
      name: 'Security_Privacy_Title',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get Privacy_Section {
    return Intl.message(
      'Privacy',
      name: 'Privacy_Section',
      desc: '',
      args: [],
    );
  }

  /// `Visibility`
  String get Visibility_Subsection {
    return Intl.message(
      'Visibility',
      name: 'Visibility_Subsection',
      desc: '',
      args: [],
    );
  }

  /// `Private account`
  String get Private_Account {
    return Intl.message(
      'Private account',
      name: 'Private_Account',
      desc: '',
      args: [],
    );
  }

  /// `Users will not be able to see your personal information, unless you are the platform administrator.`
  String get Private_Account_Description {
    return Intl.message(
      'Users will not be able to see your personal information, unless you are the platform administrator.',
      name: 'Private_Account_Description',
      desc: '',
      args: [],
    );
  }

  /// `Activity status`
  String get Activity_Status {
    return Intl.message(
      'Activity status',
      name: 'Activity_Status',
      desc: '',
      args: [],
    );
  }

  /// `You and users will see their activity status. You must have the option enabled.`
  String get Activity_Status_Description {
    return Intl.message(
      'You and users will see their activity status. You must have the option enabled.',
      name: 'Activity_Status_Description',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get Security_Section {
    return Intl.message(
      'Security',
      name: 'Security_Section',
      desc: '',
      args: [],
    );
  }

  /// `Security alerts`
  String get Security_Alerts {
    return Intl.message(
      'Security alerts',
      name: 'Security_Alerts',
      desc: '',
      args: [],
    );
  }

  /// `Security verification`
  String get Security_Verification {
    return Intl.message(
      'Security verification',
      name: 'Security_Verification',
      desc: '',
      args: [],
    );
  }

  /// `Allow enabling chats through my code`
  String get Allow_Chat_Code {
    return Intl.message(
      'Allow enabling chats through my code',
      name: 'Allow_Chat_Code',
      desc: '',
      args: [],
    );
  }

  /// `Activated`
  String get Activated {
    return Intl.message(
      'Activated',
      name: 'Activated',
      desc: '',
      args: [],
    );
  }

  /// `Save login data`
  String get Save_Login_Data {
    return Intl.message(
      'Save login data',
      name: 'Save_Login_Data',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to SmartSys on this device without entering your data.`
  String get Save_Login_Data_Description {
    return Intl.message(
      'Sign in to SmartSys on this device without entering your data.',
      name: 'Save_Login_Data_Description',
      desc: '',
      args: [],
    );
  }

  /// `Block users`
  String get Block_Users {
    return Intl.message(
      'Block users',
      name: 'Block_Users',
      desc: '',
      args: [],
    );
  }

  /// `Interactions`
  String get Interactions_Subsection {
    return Intl.message(
      'Interactions',
      name: 'Interactions_Subsection',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get Notifications_Toggle {
    return Intl.message(
      'Notifications',
      name: 'Notifications_Toggle',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get Comments_Toggle {
    return Intl.message(
      'Comments',
      name: 'Comments_Toggle',
      desc: '',
      args: [],
    );
  }

  /// `Chat enabled`
  String get Chat_Enabled {
    return Intl.message(
      'Chat enabled',
      name: 'Chat_Enabled',
      desc: '',
      args: [],
    );
  }

  /// `Allow downloading files from publications`
  String get Allow_File_Download {
    return Intl.message(
      'Allow downloading files from publications',
      name: 'Allow_File_Download',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get Help_Center_Title {
    return Intl.message(
      'Help Center',
      name: 'Help_Center_Title',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get Help_Center_Header {
    return Intl.message(
      'Help Center',
      name: 'Help_Center_Header',
      desc: '',
      args: [],
    );
  }

  /// `Hello! How can we help you?`
  String get Help_Center_Subtitle {
    return Intl.message(
      'Hello! How can we help you?',
      name: 'Help_Center_Subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Search help...`
  String get Help_Search_Hint {
    return Intl.message(
      'Search help...',
      name: 'Help_Search_Hint',
      desc: '',
      args: [],
    );
  }

  /// `Popular articles`
  String get Help_Popular_Articles {
    return Intl.message(
      'Popular articles',
      name: 'Help_Popular_Articles',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get Help_No_Results {
    return Intl.message(
      'No results found',
      name: 'Help_No_Results',
      desc: '',
      args: [],
    );
  }

  /// `Try different search terms`
  String get Help_Try_Different_Terms {
    return Intl.message(
      'Try different search terms',
      name: 'Help_Try_Different_Terms',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get Help_Create_Account_Title {
    return Intl.message(
      'Create an account',
      name: 'Help_Create_Account_Title',
      desc: '',
      args: [],
    );
  }

  /// `To create an account on our platform, go to the registration screen where you must provide your full name, valid email address and create a secure password. Once this data is completed, you will receive a verification email that you must confirm to activate your account.`
  String get Help_Create_Account_Content {
    return Intl.message(
      'To create an account on our platform, go to the registration screen where you must provide your full name, valid email address and create a secure password. Once this data is completed, you will receive a verification email that you must confirm to activate your account.',
      name: 'Help_Create_Account_Content',
      desc: '',
      args: [],
    );
  }

  /// `Verify email address`
  String get Help_Verify_Email_Title {
    return Intl.message(
      'Verify email address',
      name: 'Help_Verify_Email_Title',
      desc: '',
      args: [],
    );
  }

  /// `After registering, it is important to verify your email address to activate all the functionalities of your account. Check your inbox and look for the verification email. If you don't find it, check your spam folder. Click the verification link to complete the process.`
  String get Help_Verify_Email_Content {
    return Intl.message(
      'After registering, it is important to verify your email address to activate all the functionalities of your account. Check your inbox and look for the verification email. If you don\'t find it, check your spam folder. Click the verification link to complete the process.',
      name: 'Help_Verify_Email_Content',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get Help_Chat_Title {
    return Intl.message(
      'Chat',
      name: 'Help_Chat_Title',
      desc: '',
      args: [],
    );
  }

  /// `To start a chat with another user, you will need their unique code. Each user has a personal code that they must share with you. Go to the Chat section, enter the unique code of the user you want to chat with and a new private chat will be automatically created between you.`
  String get Help_Chat_Content {
    return Intl.message(
      'To start a chat with another user, you will need their unique code. Each user has a personal code that they must share with you. Go to the Chat section, enter the unique code of the user you want to chat with and a new private chat will be automatically created between you.',
      name: 'Help_Chat_Content',
      desc: '',
      args: [],
    );
  }

  /// `Configure your profile`
  String get Help_Configure_Profile_Title {
    return Intl.message(
      'Configure your profile',
      name: 'Help_Configure_Profile_Title',
      desc: '',
      args: [],
    );
  }

  /// `Customize your profile by accessing settings from the main menu. Here you can add a profile photo, write a biography, update your personal information and configure your privacy preferences. A complete profile will help you connect better with other users.`
  String get Help_Configure_Profile_Content {
    return Intl.message(
      'Customize your profile by accessing settings from the main menu. Here you can add a profile photo, write a biography, update your personal information and configure your privacy preferences. A complete profile will help you connect better with other users.',
      name: 'Help_Configure_Profile_Content',
      desc: '',
      args: [],
    );
  }

  /// `Checking session...`
  String get checking_session {
    return Intl.message(
      'Checking session...',
      name: 'checking_session',
      desc: '',
      args: [],
    );
  }

  /// `Platform`
  String get Platform_Default_Name {
    return Intl.message(
      'Platform',
      name: 'Platform_Default_Name',
      desc: '',
      args: [],
    );
  }

  /// `News`
  String get Publications_Tab_News {
    return Intl.message(
      'News',
      name: 'Publications_Tab_News',
      desc: '',
      args: [],
    );
  }

  /// `Assignments`
  String get Publications_Tab_Assignments {
    return Intl.message(
      'Assignments',
      name: 'Publications_Tab_Assignments',
      desc: '',
      args: [],
    );
  }

  /// `People`
  String get Publications_Tab_People {
    return Intl.message(
      'People',
      name: 'Publications_Tab_People',
      desc: '',
      args: [],
    );
  }

  /// `New announcement`
  String get Publications_New_Announcement {
    return Intl.message(
      'New announcement',
      name: 'Publications_New_Announcement',
      desc: '',
      args: [],
    );
  }

  /// `No news`
  String get Publications_No_News {
    return Intl.message(
      'No news',
      name: 'Publications_No_News',
      desc: '',
      args: [],
    );
  }

  /// `Publications will appear here`
  String get Publications_News_Subtitle {
    return Intl.message(
      'Publications will appear here',
      name: 'Publications_News_Subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Published on`
  String get Publications_Published_On {
    return Intl.message(
      'Published on',
      name: 'Publications_Published_On',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get Publications_Create_Button {
    return Intl.message(
      'Create',
      name: 'Publications_Create_Button',
      desc: '',
      args: [],
    );
  }

  /// `Announce something to the class`
  String get Publications_Title_Hint {
    return Intl.message(
      'Announce something to the class',
      name: 'Publications_Title_Hint',
      desc: '',
      args: [],
    );
  }

  /// `Write your announcement here...`
  String get Publications_Content_Hint {
    return Intl.message(
      'Write your announcement here...',
      name: 'Publications_Content_Hint',
      desc: '',
      args: [],
    );
  }

  /// `Change attachment`
  String get Publications_Change_Attachment {
    return Intl.message(
      'Change attachment',
      name: 'Publications_Change_Attachment',
      desc: '',
      args: [],
    );
  }

  /// `Add attachment`
  String get Publications_Add_Attachment {
    return Intl.message(
      'Add attachment',
      name: 'Publications_Add_Attachment',
      desc: '',
      args: [],
    );
  }

  /// `Title is required`
  String get Publications_Title_Required {
    return Intl.message(
      'Title is required',
      name: 'Publications_Title_Required',
      desc: '',
      args: [],
    );
  }

  /// `Content is required`
  String get Publications_Content_Required {
    return Intl.message(
      'Content is required',
      name: 'Publications_Content_Required',
      desc: '',
      args: [],
    );
  }

  /// `Creating announcement...`
  String get Publications_Creating {
    return Intl.message(
      'Creating announcement...',
      name: 'Publications_Creating',
      desc: '',
      args: [],
    );
  }

  /// `Announcement created successfully!`
  String get Publications_Created_Success {
    return Intl.message(
      'Announcement created successfully!',
      name: 'Publications_Created_Success',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get Publications_View {
    return Intl.message(
      'View',
      name: 'Publications_View',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error creating announcement`
  String get Publications_Create_Error {
    return Intl.message(
      'Unknown error creating announcement',
      name: 'Publications_Create_Error',
      desc: '',
      args: [],
    );
  }

  /// `Request took too long. Try again.`
  String get Publications_Timeout_Error {
    return Intl.message(
      'Request took too long. Try again.',
      name: 'Publications_Timeout_Error',
      desc: '',
      args: [],
    );
  }

  /// `Server response format error.`
  String get Publications_Format_Error {
    return Intl.message(
      'Server response format error.',
      name: 'Publications_Format_Error',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get Publications_Error_Detail {
    return Intl.message(
      'Detail',
      name: 'Publications_Error_Detail',
      desc: '',
      args: [],
    );
  }

  /// `Attach file`
  String get Publications_Attach_File {
    return Intl.message(
      'Attach file',
      name: 'Publications_Attach_File',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get Publications_Gallery {
    return Intl.message(
      'Gallery',
      name: 'Publications_Gallery',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get Publications_Camera {
    return Intl.message(
      'Camera',
      name: 'Publications_Camera',
      desc: '',
      args: [],
    );
  }

  /// `Document`
  String get Publications_Document {
    return Intl.message(
      'Document',
      name: 'Publications_Document',
      desc: '',
      args: [],
    );
  }

  /// `Error selecting image`
  String get Publications_Image_Select_Error {
    return Intl.message(
      'Error selecting image',
      name: 'Publications_Image_Select_Error',
      desc: '',
      args: [],
    );
  }

  /// `Error taking photo`
  String get Publications_Photo_Take_Error {
    return Intl.message(
      'Error taking photo',
      name: 'Publications_Photo_Take_Error',
      desc: '',
      args: [],
    );
  }

  /// `Document feature coming soon`
  String get Publications_Document_Soon {
    return Intl.message(
      'Document feature coming soon',
      name: 'Publications_Document_Soon',
      desc: '',
      args: [],
    );
  }

  /// `No assignments`
  String get Publications_No_Assignments {
    return Intl.message(
      'No assignments',
      name: 'Publications_No_Assignments',
      desc: '',
      args: [],
    );
  }

  /// `Tasks and assignments will appear here`
  String get Publications_Assignments_Subtitle {
    return Intl.message(
      'Tasks and assignments will appear here',
      name: 'Publications_Assignments_Subtitle',
      desc: '',
      args: [],
    );
  }

  /// `No people`
  String get Publications_No_People {
    return Intl.message(
      'No people',
      name: 'Publications_No_People',
      desc: '',
      args: [],
    );
  }

  /// `Platform members will appear here`
  String get Publications_People_Subtitle {
    return Intl.message(
      'Platform members will appear here',
      name: 'Publications_People_Subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Error loading publications`
  String get Publications_Load_Error {
    return Intl.message(
      'Error loading publications',
      name: 'Publications_Load_Error',
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
