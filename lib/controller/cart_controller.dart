import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/services/cart_services.dart';

final cartLocalServiceProvider = Provider((ref) => CartLocalService());

final localCartItemsProvider = FutureProvider<List<String>>((ref) {
  return ref.read(cartLocalServiceProvider).getCartItems();

});


final cartCountProvider = FutureProvider<int>((ref) async {
  
  final items = await ref.read(cartLocalServiceProvider).getCartItems();
  return items.length;
});
