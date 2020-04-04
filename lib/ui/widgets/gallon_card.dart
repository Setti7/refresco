import 'package:flutter/material.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/viewModels/views/store_model.dart';
import 'package:refresco/ui/theme.dart';
import 'package:refresco/ui/views/base_view.dart';

class GallonCard extends StatelessWidget {
  const GallonCard(this.gallon, this.store);

  final Gallon gallon;
  final Store store;

  @override
  Widget build(BuildContext context) {
    return BaseView<StoreModel>(builder: (context, model, child) {
      return Card(
        child: InkWell(
          onTap: () => model.addToCart(gallon, store),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${gallon.company} - ${gallon.typeAsString}',
                    textAlign: TextAlign.left,
                    style: AppThemes.boldPlainHeadline6),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    children: [
                      TextSpan(text: 'R\$'),
                      TextSpan(
                        text: gallon.priceIntegers,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      TextSpan(text: ',${gallon.priceDecimals}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
