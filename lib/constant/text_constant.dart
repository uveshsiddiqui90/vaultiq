class TextConstant {
  //Login Screen
  static const String loginTitle = 'Login Page';
  static const String welcomeBack = 'Welcome\nBack!';
  static const String logintomanageyourexpenses =
      'Login to manage your expenses';
  static const String emailLabel = 'Email';
  static const String emailHint = 'Enter your email';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String login = ' Login';
  static const String signUp = ' Sign Up';

  //Sign Up Screen
  static const String signUpTitle = 'Sign Up';
  static const String createYourAccount = 'Create your Account';
  static const String createAccount = 'Create Account';
  static const String letgetStarted = 'Let\'s get Started';
  static const String nameLabel = 'Name';
  static const String nameHint = 'Enter your name';
  static const String emailSignUpLabel = 'Email';
  static const String emailSignUpHint = 'Enter your email';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password';
  static const String alreadyHaveAccount = 'Already have an account?';

  //Budget Screen
  static const String budgetTitle = 'Budget';
  static const String monthlyBudget = 'Monthly Budget';
  static const String budgetUsage = 'Budget Usage';
  static const String remainingBudget = 'Remaining Budget';
  static const String editBudget = 'Edit Budget';

  //Expense Screen
  static const String addExpenseTitle = 'Add Expense';
  static const String amountLabel = 'Amount';
  static const String categoryLabel = 'CATEGORY';
  static const String dateLabel = 'DATE';
  static const String noteLabel = 'Note(Optional)';
  static const String addExpenseButton = 'Add Expense';
  static const String selectCategoryHint = 'Select category';
  static const String enterAmountHint = 'Enter amount';
  static const String enterDateHint = 'Select date';
  static const String enterNoteHint = 'Add a note about this expense';

  //Transactions Screen
  static const String recentTransactions = 'Recent Transactions';
  static const String recentTransactionsSubtitle =
      'Your latest spending activity';
  static const String thisMonth = 'This Month';
  static const String lastMonth = 'Last Month';
  static const String allTime = 'All Time';
  static const String selectRange = 'Select Range';
  static const String noTransactions = 'No Transactions Found';
  static const String dateTitle = 'Date';
  static const String categoryTitle = 'Category';

  //Profile Screen
  static const String profileTitle = 'Profile Page';
  static const String editProfile = 'Edit Profile';
  static const String darkMode = 'Dark Mode';
  static const String currency = 'Currency';
  static const String logout = 'Logout';
  static const String changePassword = 'Change Password';
  static const String aboutApp = 'About App';

  //Change Password Screen
  static const String changePasswordSubtitle = 'Keep your account secure';
  static const String currentPasswordLabel = 'Current Password';
  static const String currentPasswordHint = 'Enter your current password';
  static const String newPasswordLabel = 'New Password';
  static const String newPasswordHint = 'Enter new password';
  static const String confirmNewPasswordHint = 'Confirm new password';
  static const String passwordStrength = 'Password strength';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String updatePassword = 'Update Password';
  static const String passwordSecureTitle = 'Keep Your Account Safe';
  static const String passwordSecureDesc =
      'Use a strong password with a mix of letters, numbers and symbols.';

  //About App Screen
  static const String aboutAppSubtitle = 'Simple. Smart. Secure.';
  static const String aboutAppTagline = 'Your money, your control.';
  static const String aboutAppNameTagline =
      'Smarter Spending. Brighter Future.';
  static const String aboutAppDescription =
      'VaultIQ is your personal finance companion, designed to help you track '
      'expenses, set budgets and build better money habits. Take control of '
      'your finances, one step at a time.';
  static const String aboutWhatYouCanDo = 'What you can do';
  static const String aboutVersionPrefix = 'Version';
  static const String aboutFooterTitle =
      'Built with \u2764\ufe0f for a better financial you';
  static const String aboutFooterDesc = 'Thank you for choosing VaultIQ!';

  //About App Screen → feature tiles (tile copy is the short summary, the
  //bottom sheet shows the longer description and the bullet points)
  static const String aboutTrackExpenses = 'Track Expenses';
  static const String aboutTrackExpensesSummary =
      'Keep a record of all your transactions in one place.';
  static const String aboutTrackExpensesDetails =
      'Every entry you add is stored with its amount, category, date and note, '
      'so the whole month is always one glance away on the Home and '
      'Transactions tabs.';
  static const List<String> aboutTrackExpensesPoints = [
    'Amount, category, date and note on every entry',
    'Full history with search from the Transactions tab',
    'Monthly totals refresh the moment you add an expense',
  ];

  static const String aboutSetBudgets = 'Set Budgets';
  static const String aboutSetBudgetsSummary =
      'Plan your monthly budget and stay on track.';
  static const String aboutSetBudgetsDetails =
      'Set one monthly budget and VaultIQ measures every expense against it, so '
      'you always know how much room is left before the month ends.';
  static const List<String> aboutSetBudgetsPoints = [
    'Set or edit your monthly budget in a few taps',
    'A usage bar shows exactly how much is already spent',
    'Remaining amount is recalculated after every expense',
  ];

  static const String aboutGetInsights = 'Get Insights';
  static const String aboutGetInsightsSummary =
      'Understand your spending habits with easy-to-read analytics.';
  static const String aboutGetInsightsDetails =
      'The Analytics tab turns raw transactions into simple charts, so you can '
      'see which categories take the biggest share of your money and where you '
      'can save more.';
  static const List<String> aboutGetInsightsPoints = [
    'Category-wise breakdown of your spending',
    'Month-on-month trend of your expenses',
    'Charts that update automatically with your data',
  ];

  static const String aboutDataPriority = 'Your Data, Our Priority';
  static const String aboutDataPrioritySummary =
      'Industry-standard security keeps your data safe and private.';
  static const String aboutDataPriorityDetails =
      'Your account lives behind an authenticated, password-protected backend '
      'and VaultIQ only ever stores the information it needs to work.';
  static const List<String> aboutDataPriorityPoints = [
    'Password-protected, authenticated sessions',
    'Only your name, email and expenses are stored',
    'Edit or remove your details any time from the Profile tab',
  ];

  //Edit Profile Screen
  static const String editProfileSubtitle = 'Update your personal information';
  static const String fullNameLabel = 'Full Name';
  static const String emailAddressLabel = 'Email Address';
  static const String enterFullNameHint = 'Enter your full name';
  static const String profileSecureTitle = 'Your profile is secure';
  static const String profileSecureDesc =
      'This information helps us personalize your experience.';
  static const String saveChanges = 'Save Changes';
  static const String profileJourneyFooter =
      'Your journey to better finances\nstarts with you';

//Profile Picture Screen
  static const String profilePictureTitle = 'Add Profile Photo';
  static const String uploadPhoto = 'Upload your Photo';
  static const String addProfilePhoto = 'Add a profile photo to personalize your account';
  static const String choosefromGallery = 'Choose from Gallery';
  static const String removePhoto = 'Remove Photo';
  static const String choosefromCamera = 'Choose from Camera';
  static const String continueButton = 'Continue';
  static const String skipButton = 'Skip';

  //Set Budget Screen (last onboarding step)
  static const String vaultWordmark = 'Vault';
  static const String iqWordmark = 'IQ';
  static const String setBudgetTitle = 'Set Your\nMonthly Budget';
  static const String setBudgetSubtitle =
      'Plan your expenses, stay in control and achieve your financial goals.';
  static const String setBudgetCardDesc =
      'Enter the amount you want to spend this month.\n'
      'You can always change it later.';
  static const String budgetAmountHint = '0';
  static const String quickTipTitle = 'Quick Tip';
  static const String quickTipDesc =
      'Choose a realistic budget based on your income and spending habits.';
  static const String saveBudget = 'Save Budget';
  static const String allSet = "You're all set! 🎉";
  static const String allSetDesc = "Let's get you to your home screen.";
  static const String budgetEmptyError = 'Please enter your monthly budget';
  static const String budgetInvalidError = 'Please enter a valid amount';
  static const String budgetSaved = 'Monthly budget set successfully!';
  static const String budgetSaveFailed =
      'Could not save your budget. Please try again.';

  //error messages
  static const String error = 'Error';
  static const String invalidCredentials = 'Incorrect email or password';
  static const String nameEmptyError = 'Please enter your name';
  static const String emailEmptyError = 'Please enter your email';
  static const String passwordEmptyError = 'Please enter your password';
  static const String emailPasswordRequired = "Email & Password required";
  static const String confirmPasswordEmptyError ='Please confirm your password';
  static const String userNotFoundError = 'User not found';
  static const String somethingWentWrong = 'Something went wrong';
  static const String loginFailed = 'Login Failed';
  static const String passwordMismatchError = 'Passwords do not match';
  static const String passwordTooShortError =
      'Password must be at least 6 characters';
  static const String accountAlreadyExists =
      'Account already exists. Please login instead.';
  static const String signupFailed = 'Sign up failed. Please try again.';
  static const String signupVerifyEmail =
      'Account created! Please verify your email, then login.';
  static const String signupSuccess = 'Account created successfully!';
}
