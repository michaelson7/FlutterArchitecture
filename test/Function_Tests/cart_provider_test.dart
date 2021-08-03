import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/cart_provider.dart';
import 'package:virtual_ggroceries/provider/category_provider.dart';

main() {
  CartProvider _cartProvider = CartProvider();

  test('Adding To Cart', () async {
    //create dummy data
    ProductsModelList modelList = ProductsModelList(
      id: 1,
      categoryId: 2,
      quantity: 3,
      price: 4,
      rating: 5,
      name: 'name',
      imgPath: 'imgPath',
      description: 'description',
      status: 'status',
      timestamp: 'timestamp',
    );

    _cartProvider.addToCart(modelList);

    expect(modelList.name, 'name');
  });
}
