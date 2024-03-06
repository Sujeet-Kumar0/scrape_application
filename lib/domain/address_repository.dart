import 'package:shared_preferences/shared_preferences.dart';

import '../model/address_model.dart';

class AddressRepository {
  static const String _keyAddresses = 'addresses';

  Future<void> saveAddresses(List<Address> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = addresses.map((address) => address.toJson()).toList();
    await prefs.setStringList(_keyAddresses, addressesJson.cast<String>());
  }

  Future<List<Address>> getAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = prefs.getStringList(_keyAddresses) ?? [];
    return addressesJson.map((json) => Address.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> addAddress(Address address) async {
    final List<Address> addresses = await getAddresses();
    addresses.add(address);
    await saveAddresses(addresses);
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
    await saveAddresses(addresses);
  }
}
