class GreetingHelper {
  GreetingHelper._();

  /// Time-of-day greeting shown on the Home header.
  ///
  /// The old version ended the day with "Good Night", which reads like a
  /// *goodbye* — odd on a screen the user has just opened. Late night (10 PM
  /// onwards) now greets the night owls with a plain, always-appropriate
  /// "Hello" instead.
  static String greeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 17) return "Good Afternoon";

    // 5 PM – 4:59 AM. The old version ended the day with "Good Night", which
    // reads like a *goodbye* on a screen the user has just opened, so the whole
    // evening + night stretch stays a greeting instead.
    return "Good Evening";
  }
}