class Commodity {

  int commodityId;
  String title;
  String description;
  double price;
  String category;
  String image;
  String account;

  Commodity(this.commodityId, this.title, this.description, this.price,
      this.category, this.image, this.account);

  Commodity.fromJson(Map<String, dynamic> jsonMap) {
    this.commodityId = jsonMap['commodityId'];
    this.title = jsonMap['title'];
    this.description = jsonMap['description'];
    this.price = jsonMap['price'];
    this.category = jsonMap['category'];
    this.image = jsonMap['image'];
    this.account = jsonMap['account'];
  }

  @override
  String toString() {
    return 'Commodity{commodityId: $commodityId, title: $title, description: $description, price: $price, category: $category, image: $image, account: $account}';
  }
}