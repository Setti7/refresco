import 'package:random_string/random_string.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/coordinate.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/operating_time.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/models/time.dart';

class SampleData {
  static final store1 = Store(
    id: randomAlphaNumeric(20),
    name: 'Água Clara',
    description: 'Entrega de água e gás.',
    rating: 3.7,
    minDeliveryTime: 15,
    maxDeliveryTime: 30,
    phone: 19991408787,
    operatingTime: OperatingTime(opening: Time(8), closing: Time(22)),
    address: Address(
      streetName: 'Av. Dr. Antônio Carlos Couto de Barros',
      number: 1206,
      city: 'Campinas',
      state: 'São Paulo',
      district: 'Vila Sônia (Sousas)',
      coordinate: Coordinate(-22.886228, -46.975293),
      postalCode: '13105-000',
    ),
  );

  static final store2 = Store(
    id: randomAlphaNumeric(20),
    name: 'Água Azul',
    description: 'Entrega de água e gás.',
    rating: 4.6,
    minDeliveryTime: 10,
    maxDeliveryTime: 20,
    phone: 19991408787,
    operatingTime: OperatingTime(opening: Time(8), closing: Time(22)),
    address: Address(
      streetName: 'R. Antônio Cardinale',
      number: 63,
      city: 'Campinas',
      state: 'São Paulo',
      district: 'Vila Bourbon (Sousas)',
      coordinate: Coordinate(-22.885731, -46.974652),
      postalCode: '13105-554',
    ),
  );

  static final store3 = Store(
    id: randomAlphaNumeric(20),
    name: 'Água e Gás Campinas',
    description: 'Entrega de água e gás.',
    rating: 4.0,
    minDeliveryTime: 30,
    maxDeliveryTime: 40,
    phone: 19991408787,
    operatingTime: OperatingTime(opening: Time(8), closing: Time(22)),
    address: Address(
      streetName: 'Av. Dr. Antônio Carlos Couto de Barros',
      number: 937,
      city: 'Campinas',
      state: 'São Paulo',
      district: 'Jardim Conceição',
      coordinate: Coordinate(-22.884748, -46.973241),
      postalCode: '13105-000',
    ),
  );

  static final store4 = Store(
    id: randomAlphaNumeric(20),
    name: 'Água Azul São Carlos',
    description: 'Entrega de água e gás.',
    rating: 4.7,
    minDeliveryTime: 10,
    maxDeliveryTime: 20,
    phone: 19991408787,
    operatingTime: OperatingTime(opening: Time(8), closing: Time(22)),
    address: Address(
      streetName: 'R. São Pio X',
      number: 466,
      city: 'São Carlos',
      state: 'São Paulo',
      district: 'Vila Prado',
      coordinate: Coordinate(-22.029353, -47.898187),
      postalCode: '13574-260',
    ),
  );

  static final l20gallon1 = Gallon(
    type: GallonType.l20,
    price: 960,
    company: 'Bonafont',
    store: store1,
  );

  static final l20gallon2 = Gallon(
    type: GallonType.l20,
    price: 875,
    company: 'Serra Negra',
    store: store1,
  );

  static final l20gallon3 = Gallon(
    type: GallonType.l20,
    price: 920,
    company: 'Bonafont',
    store: store2,
  );

  static final l10gallon1 = Gallon(
    type: GallonType.l10,
    price: 840,
    company: 'Dufont',
    store: store3,
  );

  static final l10gallon2 = Gallon(
    type: GallonType.l10,
    price: 825,
    company: 'Bonafont',
    store: store2,
  );
}
