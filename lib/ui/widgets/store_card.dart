import 'package:flutter/material.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/models/store.dart';
import 'package:flutter_base/ui/theme.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final GallonType gallonType;

  const StoreCard({
    @required this.store,
    @required this.gallonType,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lowestPriceGallon = store.lowestPrice(gallonType);

    return Theme(
      data: AppThemes.storeCardTheme,
      child: Builder(
        builder: (context) => Card(
          margin: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
          child: InkWell(
            borderRadius: AppShapes.cardBorderRadius,
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(store.name,
                      style: Theme.of(context).textTheme.headline6),
                  Divider(),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Nota',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              Text(store.rating.toString(),
                                  style: Theme.of(context).textTheme.headline5),
                              SizedBox(width: 2),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 20,
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Tempo médio',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText2,
                              children: [
                                TextSpan(
                                    text:
                                        '${store.minDeliveryTime}-${store.maxDeliveryTime}',
                                    style:
                                        Theme.of(context).textTheme.headline5),
                                TextSpan(text: 'min'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // TODO: remove this
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Preço',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText2,
                              children: [
                                TextSpan(text: 'desde R\$'),
                                TextSpan(
                                    text:
                                        '${lowestPriceGallon.priceIntegers.toString()}',
                                    style:
                                        Theme.of(context).textTheme.headline5),
                                TextSpan(
                                    text:
                                        ",${lowestPriceGallon.priceDecimals.toString().padRight(2, '0')}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
