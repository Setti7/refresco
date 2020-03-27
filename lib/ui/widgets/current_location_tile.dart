import 'package:flutter/material.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/viewModels/current_location_tile.dart';
import 'package:flutter_base/ui/theme.dart';
import 'package:flutter_base/ui/views/base_view.dart';

class CurrentLocationTile extends StatelessWidget {
  final void Function(BuildContext, Address) closeCallback;
  final BuildContext searchContext;

  const CurrentLocationTile({
    Key key,
    @required this.closeCallback,
    @required this.searchContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CurrentLocationTileModel>(
      onModelReady: (model) {
        model.closeCallback = closeCallback;
        model.searchContext = searchContext;
        model.getCurrentAddress();
      },
      builder: (context, model, child) {
        return Ink(
          color: Colors.white,
          child: ListTile(
            onTap: model.selectAddress,
            title: Text(model.state == ViewState.busy
                ? 'Procurando por sua localização'
                : 'Localização atual'),
            subtitle: Text(model.state == ViewState.busy
                ? 'Isso pode demorar um pouco'
                : model.currentAddress.simpleAddress),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                model.state == ViewState.busy
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      )
                    : Icon(
                        Icons.gps_fixed,
                        color: AppColors.primary,
                        size: AppShapes.iconSize,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
