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

  @override
  String toString() {
    return 'Commodity{commodityId: $commodityId, title: $title, description: $description, price: $price, category: $category, image: $image, account: $account}';
  }
}