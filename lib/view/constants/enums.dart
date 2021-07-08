enum DialogTerms {
  FAQ,
  Problem,
  Contact,
}

enum ProductFilters {
  recommendation,
  new_arrival,
  all_products,
  cat_prod,
  user_purchase,
  subProducts,
  wish_list,
  search_term,
  mostPopular
}

enum WishListFilters {
  add_wish,
  remove_wish,
}

enum UserDetails {
  userName,
  userEmail,
  userId,
}

String getEnumValue(var enumValue) {
  String data =
      enumValue.toString().substring(enumValue.toString().indexOf('.') + 1);
  return data;
}
