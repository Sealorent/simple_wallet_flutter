class Activity {
  final int? idActivity;
  final int idWallet;
  final int type;
  final String description;
  final int amount;

  Activity(
      {this.idActivity,
      required this.idWallet,
      required this.type,
      required this.description,
      required this.amount});

  Activity.fromMap(Map<String, dynamic> res)
      : idActivity = res["id_activity"],
        idWallet = res["id_wallet"],
        type = res["type"],
        description = res["description"],
        amount = res["amount"];

  Map<String, Object?> toMap() {
    return {
      'id_activity': idActivity,
      'id_wallet': idWallet,
      'type': type,
      'description': description,
      'amount': amount
    };
  }
}
