class TransactionModel {
  final String title;
  final String date;
  final String amount;
  final bool isExpense;
  final String categoryIcon;

  const TransactionModel({
    required this.title,
    required this.date,
    required this.amount,
    required this.isExpense,
    required this.categoryIcon,
  });
}

class DummyTransactions {
  static const List<TransactionModel> recent = [
    TransactionModel(
      title: "Groceries",
      date: "20 Apr, 2024",
      amount: "₹1,500",
      isExpense: true,
      categoryIcon: "🛒",
    ),
    TransactionModel(
      title: "Transport",
      date: "19 Apr, 2024",
      amount: "₹2,500",
      isExpense: true,
      categoryIcon: "🚌",
    ),
    TransactionModel(
      title: "Shopping",
      date: "18 Apr, 2024",
      amount: "₹1,000",
      isExpense: true,
      categoryIcon: "🛍️",
    ),
    TransactionModel(
      title: "Salary",
      date: "18 Apr, 2024",
      amount: "₹15,000",
      isExpense: false,
      categoryIcon: "💼",
    ),
  ];
}