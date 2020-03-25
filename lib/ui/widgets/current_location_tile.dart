import 'package:flutter/material.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/viewModels/current_location_tile.dart';
import 'package:flutter_base/ui/theme.dart';
import 'package:flutter_base/ui/views/base_view.dart';

class CurrentLocationTile extends StatelessWidget {
  const CurrentLocationTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CurrentLocationTileModel>(
      onModelReady: (model) {
        model.getCurrentAddress();
      },
      builder: (context, model, child) {
        return Ink(
          color: Colors.white,
          child: ListTile(
            onTap: () => print("clic"),
            title: Text(model.state == ViewState.busy
                ? 'Procurando por sua localização'
                : 'Localização atual'),
            subtitle: Text(model.state == ViewState.busy
                ? "Isso pode demorar um pouco"
                : model.address),
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
                    : Icon(Icons.gps_fixed, color: AppColors.primary, size: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
