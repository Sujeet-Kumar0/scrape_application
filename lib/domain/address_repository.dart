import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/address_model.dart';

class AddressRepository {
  static const String _keyAddresses = 'addresses';

  Future<void> clearAllSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveAddresses(List<Address> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson =
        addresses.map((address) => json.encode(address.toJson())).toList();
    await prefs.setStringList(_keyAddresses, addressesJson);
  }

  Future<List<Address>> getAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = prefs.getStringList(_keyAddresses) ?? [];
    print(addressesJson);
    return addressesJson
        .map((json) => Address.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> addAddress(Address address) async {
    final List<Address> addresses = await getAddresses();
    if (!addresses.contains(address)) {
      addresses.add(address);
      await saveAddresses(addresses);
    }
  }

  Future<void> updateAddress(Address oldAddress, Address newAddress) async {
    final List<Address> addresses = await getAddresses();
    final index = addresses.indexWhere((addr) => addr == oldAddress);
    if (index != -1) {
      addresses[index] = newAddress;
      await saveAddresses(addresses);
    }
  }

  Future<void> deleteAddress(Address address) async {
    final List<Address> addresses = await getAddresses();
    addresses.removeWhere((addr) => addr == address);
    await clearAllSharedPreferences();
    await saveAddresses(addresses);
  }
}
