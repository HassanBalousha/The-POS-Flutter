// ignore_for_file: always_specify_types

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thepos/features/carts/data/models/cart.dart';
import 'package:thepos/features/carts/data/models/cart_item.dart';
import 'package:thepos/features/home/data/models/product.dart';

class CartsController extends GetxController {
  RxList<Cart> listCarts = <Cart>[
    Cart(keyCart: "1", cartItems: []),
    Cart(keyCart: "2", cartItems: []),
    Cart(keyCart: "3", cartItems: []),
    Cart(keyCart: "4", cartItems: []),
    Cart(keyCart: "5", cartItems: []),
    Cart(keyCart: "6", cartItems: []),
    Cart(keyCart: "7", cartItems: []),
    Cart(keyCart: "8", cartItems: []),
    Cart(keyCart: "9", cartItems: []),
  ].obs;
  RxInt selectedCart = 0.obs;

  Future changeCart(int index) async {
    selectedCart.value = index;
    update();
  }

  Future addProduct(Product product) async {
    bool thereIsProductInCart = false;
    listCarts.value[selectedCart.value].cartItems.forEach((elementProduct) {
      if (elementProduct.product.sku == product.sku) {
        elementProduct.quantity = elementProduct.quantity + 1;
        thereIsProductInCart = true;
      }
    });

    if (!thereIsProductInCart) {
      listCarts.value[selectedCart.value].cartItems
          .add(CartItem(product: product, quantity: 1));
    }

    Get.snackbar("تم", "اضافة المنتج للسلة",
        backgroundColor: const Color(0xff178F49).withOpacity(0.5),
        snackPosition: SnackPosition.BOTTOM);
    update();
  }

  Future updateItem(CartItem product) async {
    listCarts.value[selectedCart.value].cartItems.forEach((elementProduct) {
      if (elementProduct.product.sku == product.product.sku) {
        elementProduct.quantity = product.quantity;
        elementProduct.product.price = product.product.price;
      }
    });
    update();
  }

  Future deleteItem(CartItem product) async {
    listCarts.value[selectedCart.value].cartItems.removeWhere(
        (elementProduct) => elementProduct.product.sku == product.product.sku);

    update();
  }

  Future clearCarts() async {
  await  Get.defaultDialog(
        title: "حذف ؟ ",
        titleStyle: GoogleFonts.cairo(
          textStyle: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "هل انت متأكد من حذف جميع العناصر في السلة  -  ${listCarts.value[selectedCart.value].keyCart}",
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),

        
        confirm: GestureDetector(
          onTap: () {
            listCarts.value[selectedCart.value].cartItems.clear();
            Get.back();

            update();
          },
          child: Text(
            "متابعة",
            style: GoogleFonts.cairo(
              textStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
        cancel: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Text(
              "الغاء",
              style: GoogleFonts.cairo(
                textStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            )));
  }
}