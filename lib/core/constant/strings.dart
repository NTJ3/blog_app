class Strings {
  static ScreenTitle screenTitle = ScreenTitle();
  static HintString hint = HintString();
  static LabelString label = LabelString();
  static ButtonTitleString button = ButtonTitleString();
  static MessageString message = MessageString();
}

class APIs {
  static const String authenticate = "/authenticate";
  static const String forgetPassword = "/account/reset-password/init";
  static const String profile = "/user";
  static const String userListing = "/sfl-users";
  static const String register = "/register";
}

class ScreenTitle {
  final String kForgotPassword = "Forgot Password";
  final String kLogin = "Login";
  final String kRegister = "Register";
  final String kHome = "Home";
  final String kSearch = "Search";
  final String kProfile = "Profile";
  final String kCreateBlogScreen = "Create Blog Screen";
}

class HintString {
  final String kEnterRequiredValue = "Enter required value";
  final String kUsername = "Username";
  final String kPassword = "Password";
  final String kConfirmPassword = "Confirm Password";
  final String kFirstName = "First Name";
  final String kLastName = "Last Name";
  final String kPhone = "Phone";
  final String kEmail = "Email";
  final String kUserName = "User Name";
  final String kBlogTitle = "Enter Blog Title";
  final String kBlogDescription = "Enter Blog Description";
}

class LabelString {
  final String kForgotYourPassword = "Forgot password?";
  final String kAlreadyMember = "Already having an account";
  final String kBackToLogin = "Back to Login";
  final String kRegister = "Don't have an account?";
  final String kSelectBlogCategory = 'Select blog category';
  final String kBlogTitle = "Blog Title";
  final String kBlogDescription = "Blog Description";
  final String kBlogCategory = "Blog Category";
}

class ButtonTitleString {
  final String kLogin = "Login";
  final String kLoginWithGoogle = "Login with Google";
  final String kRegisterWithGoogle = "Register with Google";
  final String kLogout = "Logout";
  final String kRegister = "Register";
  final String kSendMyPassword = "Send me my password";
  final String kSend = "Send";
  final String kCancel = "Cancel";
  final String kUpdate = "Update";
  final String kSubmit = "Submit";
}

class SignUpLogInMethods {
  static const String kEmail = "EMAIL";
  static const String kPhone = "PHONE";
  static const String kGoogle = "GOOGLE";
}

class MessageString {
  final String kEnterEmail = "Please enter an email";
  final String kEnterValidEmail = "Please enter a valid email";
  final String kEnterUsername = "Please enter username";
  final String kEnterPassword = "Please enter password";
  final String kPasswordDoNotMatch = "Passwords do not match";
  final String kEnterValidPassword = "Password must be more than 4 char";
  final String kEmailNotRegistered = "Email is not registered.";
  final String kAPIResponseNotAvailable = "Server busy for now. Try later.";
  final String kForgetPasswordEmailSent = "Email has been sent.";
  final String kUserListEmptyNoUserFound = "No User found. List if empty. :(";
  final String kNoInternet =
      'No Internet.. Please check your internet connectivity';
  final String kEnterFirstName = "Please enter First Name";
  final String kEnterName = "Please enter Name";
  final String kEnterLastName = "Please enter Last Name";
  final String kEnterPhoneNumber = "Please enter Phone Number";
  final String kEnterValidPhoneNumber = "Please enter a valid Phone Number";
  final String kEnterBlogTitle = "Please enter title";
  final String kEnterBlogDes = "Please enter des";
  final String kSelectBlogCategory = "Please select category";

  final String kRegistrationSuccess = "Registration Successful!!";
  final String kLoginSuccess = "Loged in Successful!!";
  final String kUserRegisteredSuccessfully = "User registered successfully";
  final String kRegisterCrashReport = "Report Experienced Crash";
  final String kHelpUsUnderstandError =
      "Help us understand the error!\nSpecify details like feature you're about to access.";
  final String kNoInputFromUser = "(Manual) No Input from user";
  final String kReportSentSuccessfully = "Report sent Successfully";
  final String kSomethingWentWrong = "Something went wrong, Please try again";
  final String kLProfileUpdateSuccess = "Profile Updated Successfully";
  final String kCreateBlogSuccess = "Blog Created Successful!!";
}
