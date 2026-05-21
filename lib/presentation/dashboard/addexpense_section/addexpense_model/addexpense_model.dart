class ExpenseModel {

  final String id;
  final double amount;
  final String category;
  final String date;
  final String note;

  ExpenseModel({

    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  factory ExpenseModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return ExpenseModel(

      id: json['id'],

      amount: (json['amount'] as num).toDouble(),

      category: json['category'],

      date: json['date'],

      note: json['note'] ?? '',
    );
  }
}