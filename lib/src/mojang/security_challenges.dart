/// Represents a single security challenge that a
/// authenticated user needs to answer to verify
/// their location.
class SecurityChallenge {
  final int _answerId;

  final int _questionId;

  final String _questionString;

  String? _answer;

  SecurityChallenge.fromJson(Map<String, dynamic> map)
      : _answerId = map['answer']['id'],
        _questionId = map['question']['id'],
        _questionString = map['question']['question'];

  /// Get the ID of the question. This will be the
  /// index of the question in the pre-defined list
  /// of 39 questions.
  int get questionId => _questionId;

  /// Get the question string.
  String get question => _questionString;

  /// Set the answer to [answer].
  set answer(String answer) => _answer = answer;

  /// Get this security challenge as a JSON for answering.
  Map<String, dynamic> get asAnswerJson => {
        'id': _answerId,
        'answer': _answer,
      };

  /// The 39 pre-defined questions of which a user
  /// chooses 3 when setting up these seceuryity
  /// challenges.
  static const List<String> questions = <String>[
    "What is your favorite pet's name?",
    'What is your favorite movie?',
    "What is your favorite author's last name?",
    "What is your favorite artist's last name?",
    "What is your favorite actor's last name?",
    'What is your favorite activity?',
    'What is your favorite restaurant?',
    'What is the name of your favorite cartoon?',
    'What is the name of the first school you attended?',
    'What is the last name of your favorite teacher?',
    "What is your best friend's first name?",
    "What is your favorite cousin's name?",
    'What was the first name of your first girl/boyfriend?',
    'What was the name of your first stuffed animal?',
    "What is your mother's middle name?",
    "What is your father's middle name?",
    "What is your oldest sibling's middle name?",
    'In what city did your parents meet?',
    'In what hospital were you born?',
    'What is your favorite team?',
    'How old were you when you got your first computer?',
    'How old were you when you got your first gaming console?',
    'What was your first video game?',
    'What is your favorite card game?',
    'What is your favorite board game?',
    'What was your first gaming console?',
    'What was the first book you ever read?',
    'Where did you go on your first holiday?',
    'In what city does your grandmother live?',
    'In what city does your grandfather live?',
    "What is your grandmother's first name?",
    "What is your grandfather's first name?",
    'What is your least favorite food?',
    'What is your favorite ice cream flavor?',
    'What is your favorite ice cream flavor?',
    'What is your favorite place to visit?',
    'What is your dream job?',
    'What color was your first pet?',
    'What is your lucky number?',
  ];
}
