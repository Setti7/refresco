import 'package:flutter/material.dart';
import 'package:flutter_base/core/models/store.dart';
import 'package:flutter_base/ui/theme.dart';
import 'package:flutter_base/ui/views/store_view.dart';

class StoreCard extends StatelessWidget {
  final Store store;

  const StoreCard({
    @required this.store,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppThemes.storeCardTheme,
      child: Builder(
        builder: (context) => Card(
          margin: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
          child: InkWell(
            borderRadius: AppShapes.cardBorderRadius,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => StoreView(store))),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              Text(
                                  store.rating == null
                                      ? 'Novo!'
                                      : store.rating.toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.headline5),
                              SizedBox(width: 2),
                              Icon(store.getStarIcon(),
                                  color: Colors.yellow, size: 20)
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
