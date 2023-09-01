class GoodsDataParse {
  final int id, sellerId, sellingAreaId, categoryId, sellPrice;
  final String title, status, description, thumbNail, createAt;

  GoodsDataParse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sellerId = json['sellerId'],
        sellingAreaId = json['sellingAreaId'],
        categoryId = json['categoryId'],
        sellPrice = json['sellPrice'],
        title = json['title'],
        status = json['status'],
        description = json['description'],
        thumbNail = json['thumbNail'],
        createAt = json['createAt'];

  GoodsDataParse({
    required this.id,
    required this.sellerId,
    required this.sellingAreaId,
    required this.categoryId,
    required this.sellPrice,
    required this.title,
    required this.status,
    required this.description,
    required this.thumbNail,
    required this.createAt,
  });
}
