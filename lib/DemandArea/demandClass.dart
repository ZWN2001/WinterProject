class Demand {

  int wantId;
  String account;
  String title;
  String description;

  Demand(this.wantId, this.account, this.title, this.description);

  Demand.fromJson(Map<String, dynamic> jsonMap) {
    this.wantId = jsonMap['wantId'];
    this.account = jsonMap['account'];
    this.title = jsonMap['title'];
    this.description = jsonMap['description'];
  }

  @override
  String toString() {
    return 'Demand{wantId: $wantId, account: $account, title: $title, description: $description}';
  }
}