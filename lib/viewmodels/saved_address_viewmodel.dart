import 'package:flutter/material.dart';

import '../domain/address_repository.dart';
import '../model/address_model.dart';

class AddressViewModel extends ChangeNotifier {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final AddressRepository _repository = AddressRepository();

  List<Address> _addresses = [];

  List<Address> get addresses => _addresses;

  Future<void> loadAddresses() async {
    _addresses = await _repository.getAddresses();
    notifyListeners();
  }

  Future<void> addAddress(Address address) async {
    await _repository.addAddress(address);
    await loadAddresses();
  }

  Future<void> updateAddress(Address oldAddress, Address newAddress) async {
    await _repository.updateAddress(oldAddress, newAddress);
    await loadAddresses();
  }

  Future<void> deleteAddress(Address address) async {
    await _repository.deleteAddress(address);
    await loadAddresses();
  }
}
