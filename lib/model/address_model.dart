class Address {
  final String address;
  final String pinCode;

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address &&
        other.address == address &&
        other.pinCode == pinCode;
  }

  @override
  int get hashCode => address.hashCode ^ pinCode.hashCode;
}
