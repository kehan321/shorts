class FetchingModel {
    FetchingModel({
        required this.id,
        required this.name,
        required this.username,
        required this.email,
        required this.address,
        required this.phone,
        required this.website,
        required this.company,
    });

    final int id;
    final String name;
    final String username;
    final String email;
    final Address? address;
    final String phone;
    final String website;
    final Company? company;

    FetchingModel copyWith({
        int? id,
        String? name,
        String? username,
        String? email,
        Address? address,
        String? phone,
        String? website,
        Company? company,
    }) {
        return FetchingModel(
            id: id ?? this.id,
            name: name ?? this.name,
            username: username ?? this.username,
            email: email ?? this.email,
            address: address ?? this.address,
            phone: phone ?? this.phone,
            website: website ?? this.website,
            company: company ?? this.company,
        );
    }

    factory FetchingModel.fromJson(Map<String, dynamic> json){ 
        return FetchingModel(
            id: json["id"] ?? 0,
            name: json["name"] ?? "",
            username: json["username"] ?? "",
            email: json["email"] ?? "",
            address: json["address"] == null ? null : Address.fromJson(json["address"]),
            phone: json["phone"] ?? "",
            website: json["website"] ?? "",
            company: json["company"] == null ? null : Company.fromJson(json["company"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "address": address?.toJson(),
        "phone": phone,
        "website": website,
        "company": company?.toJson(),
    };

    @override
    String toString(){
        return "$id, $name, $username, $email, $address, $phone, $website, $company, ";
    }

}

class Address {
    Address({
        required this.street,
        required this.suite,
        required this.city,
        required this.zipcode,
        required this.geo,
    });

    final String street;
    final String suite;
    final String city;
    final String zipcode;
    final Geo? geo;

    Address copyWith({
        String? street,
        String? suite,
        String? city,
        String? zipcode,
        Geo? geo,
    }) {
        return Address(
            street: street ?? this.street,
            suite: suite ?? this.suite,
            city: city ?? this.city,
            zipcode: zipcode ?? this.zipcode,
            geo: geo ?? this.geo,
        );
    }

    factory Address.fromJson(Map<String, dynamic> json){ 
        return Address(
            street: json["street"] ?? "",
            suite: json["suite"] ?? "",
            city: json["city"] ?? "",
            zipcode: json["zipcode"] ?? "",
            geo: json["geo"] == null ? null : Geo.fromJson(json["geo"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "street": street,
        "suite": suite,
        "city": city,
        "zipcode": zipcode,
        "geo": geo?.toJson(),
    };

    @override
    String toString(){
        return "$street, $suite, $city, $zipcode, $geo, ";
    }

}

class Geo {
    Geo({
        required this.lat,
        required this.lng,
    });

    final String lat;
    final String lng;

    Geo copyWith({
        String? lat,
        String? lng,
    }) {
        return Geo(
            lat: lat ?? this.lat,
            lng: lng ?? this.lng,
        );
    }

    factory Geo.fromJson(Map<String, dynamic> json){ 
        return Geo(
            lat: json["lat"] ?? "",
            lng: json["lng"] ?? "",
        );
    }

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };

    @override
    String toString(){
        return "$lat, $lng, ";
    }

}

class Company {
    Company({
        required this.name,
        required this.catchPhrase,
        required this.bs,
    });

    final String name;
    final String catchPhrase;
    final String bs;

    Company copyWith({
        String? name,
        String? catchPhrase,
        String? bs,
    }) {
        return Company(
            name: name ?? this.name,
            catchPhrase: catchPhrase ?? this.catchPhrase,
            bs: bs ?? this.bs,
        );
    }

    factory Company.fromJson(Map<String, dynamic> json){ 
        return Company(
            name: json["name"] ?? "",
            catchPhrase: json["catchPhrase"] ?? "",
            bs: json["bs"] ?? "",
        );
    }

    Map<String, dynamic> toJson() => {
        "name": name,
        "catchPhrase": catchPhrase,
        "bs": bs,
    };

    @override
    String toString(){
        return "$name, $catchPhrase, $bs, ";
    }

}

/*
{
	"id": 1,
	"name": "Leanne Graham",
	"username": "Bret",
	"email": "Sincere@april.biz",
	"address": {
		"street": "Kulas Light",
		"suite": "Apt. 556",
		"city": "Gwenborough",
		"zipcode": "92998-3874",
		"geo": {
			"lat": "-37.3159",
			"lng": "81.1496"
		}
	},
	"phone": "1-770-736-8031 x56442",
	"website": "hildegard.org",
	"company": {
		"name": "Romaguera-Crona",
		"catchPhrase": "Multi-layered client-server neural-net",
		"bs": "harness real-time e-markets"
	}
}*/