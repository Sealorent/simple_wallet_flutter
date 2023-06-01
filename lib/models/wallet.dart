class Wallet {
  final int? idWallet;
  final int? idUser;
  final String name;
  final int? amount;

  Wallet({
    this.idWallet,
    required this.idUser,
    required this.name,
    required this.amount,
  });

  Wallet.fromMap(Map<String, dynamic> res)
      : idWallet = res["id_wallet"],
        idUser = res["id_user"],
        name = res["name"],
        amount = res["amount"];

  Map<String, Object?> toMap() {
    return {
      'id_wallet': idWallet,
      'id_user': idUser,
      'name': name,
      'amount': amount,
    };
  }
}
