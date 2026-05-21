

class AuthErrorHandler {

  static String getMessage(dynamic e) {

    final error = e.toString().toLowerCase();
     print("AuthErrorHandler: $error");
    // 🔐 Invalid credentials
    if (error.contains('invalid login credentials')) {
      return "Incorrect email or password";
    }

    // 📧 Email not verified
    if (error.contains('email not confirmed')) {
      return "Please verify your email";
    }

    // 👤 Already registered
    if (error.contains('user already registered')) {
      return "Account already exists";
    }

    // 🌐 Network errors
    if (error.contains('socketexception') ||
        error.contains('failed host lookup')) {
      return "No internet connection";
    }

    // 🔒 Weak password
    if (error.contains('password should be at least')) {
      return "Password is too weak";
    }

    // ❌ Fallback
    return "Something went wrong";
  }
}