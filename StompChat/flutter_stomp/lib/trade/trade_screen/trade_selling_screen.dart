import 'dart:convert';
import 'dart:io';
import 'package:flutter_stomp/staticModel/member_info.dart';
import 'package:flutter_stomp/staticModel/url_info.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SellingPage extends StatefulWidget {
  const SellingPage({super.key});

  @override
  _SellingPageState createState() => _SellingPageState();
}

class _SellingPageState extends State<SellingPage> {
  List<File> selectedImages = [];

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage(imageQuality: 60);

    if (pickedFiles.isNotEmpty) {
      setState(() {
        selectedImages =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  Future<void> _uploadImages() async {
    final url = Uri.parse(
        '${UrlList.tradeServiceUrl}/images/new/4'); // Replace with your server URL

    for (var image in selectedImages) {
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed');
      }
    }
  }

  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> _sellProduct() async {
    final url = Uri.parse(
        '${UrlList.tradeServiceUrl}/goods'); // Replace with your server URL

    final Map<String, dynamic> data = {
      'sellerId': MemberInfo.memberId,
      'sellingAreaId': MemberInfo.memberTownAreaId,
      'categoryId': 1,
      'title': productNameController.text,
      'status': 'New',
      'sellPrice': priceController.text,
      'description': productNameController.text,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Product sold successfully');
    } else {
      print('Failed to sell product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Your Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImages,
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == selectedImages.length) {
                      return const Icon(Icons.add_a_photo, color: Colors.grey);
                    }
                    return Image.file(selectedImages[index],
                        height: 100, width: 100, fit: BoxFit.cover);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: productNameController,
              decoration: const InputDecoration(labelText: '제목'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: '가격'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: '내용을 작성해주세요.'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (selectedImages.isNotEmpty) {
                  await _uploadImages();
                  await _sellProduct();
                }
              },
              child: const Text('작성완료'),
            ),
          ],
        ),
      ),
    );
  }
}
