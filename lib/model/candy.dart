
class Candy {
  final String name;
  final String price;
  final String imgUrl;
  final String rep;

  Candy(this.name, this.price, this.imgUrl, this.rep);

  /// Convert from JSON response stream to Favorite object
  Candy.fromJson( Map<String, dynamic> json)
    : name = json["name"],
    price = json["price"],
    imgUrl = json["imgUrl"],
    rep = json["rep"];

  /// Convert an in-memory representation of a Favorite object to a Map<String, dynamic>
  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'imgUrl': imgUrl,
    'rep': rep
  };
}


