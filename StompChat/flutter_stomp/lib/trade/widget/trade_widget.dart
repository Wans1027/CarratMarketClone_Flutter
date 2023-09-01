import 'package:flutter/material.dart';
import 'package:flutter_stomp/trade/data/trade_data.dart';

class GoodsWidget extends StatelessWidget {
  const GoodsWidget({
    super.key,
    required this.goods,
  });

  final GoodsDataParse goods;

  @override
  Widget build(BuildContext context) {
    // Uint8List bytes = base64Decode(goods.goodsThumbnail);
    //Image image = Image.memory(bytes);
    Image image = Image.network(
      'https://blog.kakaocdn.net/dn/bhEXuC/btqS3IlVDCm/O0WutWQTrEWdFtwxoAX5Rk/img.jpg',
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: const BoxDecoration(
        //border: Border.all(color: Colors.green, width: 3),
        border: Border(bottom: BorderSide(color: Colors.black)),
        //borderRadius: BorderRadius.circular(20),
        //color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                'https://imagebucket0828.s3.ap-northeast-2.amazonaws.com/${goods.thumbNail}',
                width: 100,
                height: 100,
                scale: 0.5,
                fit: BoxFit.cover,
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goods.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '반송동',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    '${addComma(goods.sellPrice)}원',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String addComma(int price) {
    var stringPrice = price.toString();
    String formattedPrice = stringPrice.replaceAllMapped(
      //정규식
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
    return formattedPrice;
  }
}
