import 'dart:math';

class QuotesService {
  static final _quotes = [
    "Practice doesn't make perfect. Perfect practice makes perfect.",
    "Every expert was once a beginner. Keep solving!",
    "The only way to learn a new algorithm is to implement it.",
    "Consistency beats intensity. Solve daily, grow exponentially.",
    "Your streak is your commitment to excellence.",
    "Debug your code, debug your mindset.",
    "Today's hard problem is tomorrow's warmup.",
    "Great coders aren't born, they're made through practice.",
    "Every WA teaches you something new.",
    "Think, code, test, repeat. That's the formula.",
    "Your rating doesn't define you, your effort does.",
    "Small daily improvements lead to stunning long-term results.",
    "The difference between ordinary and extraordinary is practice.",
    "Solve one more. Always one more.",
    "Competitive programming is a marathon, not a sprint.",
    "Edge cases are where champions are made.",
    "Time complexity matters. So does your consistency.",
    "Every problem solved is a step toward mastery.",
    "Don't break the chain. Keep your streak alive!",
    "Code with purpose, solve with passion.",
  ];

  String getRandomQuote() {
    return _quotes[Random().nextInt(_quotes.length)];
  }

  String getDailyQuote() {
    // Same quote for the entire day based on day of year
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return _quotes[dayOfYear % _quotes.length];
  }
}
