class Address {
  String address;
  String pinCode;

  Address(this.address, this.pinCode);

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      json['address'] as String,
      json['pinCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'pinCode': pinCode,
    };
  }
}
