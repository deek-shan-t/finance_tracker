class DailyLimit {
  double limitAmount;  // User-defined daily spending limit

  DailyLimit({required this.limitAmount});

  Map<String, dynamic> toMap() {
    return {
      'limitAmount': limitAmount,
    };
  }

  factory DailyLimit.fromMap(Map<String, dynamic> map) {
    return DailyLimit(
      limitAmount: map['limitAmount'],
    );
  }
}
