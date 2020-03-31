import 'package:flutter/material.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/viewModels/buy_model.dart';
import 'package:flutter_base/ui/theme.dart';
import 'package:flutter_base/ui/widgets/gallon_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:place_picker/place_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_view.dart';

class BuyView extends StatefulWidget {
  @override
  _BuyViewState createState() => _BuyViewState();
}

class _BuyViewState extends State<BuyView> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<BuyModel>(
      onModelReady: (model) {
        model.tabController = tabController;
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Escolha uma revenda'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _buildAddress(model),
                  Divider(),
                  _buildGallonSelector(model),
                ],
              ),
            ),
            _buildGallonsList(model),
          ],
        ),
      ),
    );
  }

  Widget _buildAddress(BuyModel model) {
    return ListTile(
      onTap: () async {},
      title: Text("Rua Ilha Caiçaras 421"),
      subtitle: Text("San Conrado - Sousas"),
      trailing: Column(
        children: <Widget>[
          IconButton(
            tooltip: 'Alterar',
            icon: Icon(
              Icons.location_on,
              color: AppColors.accent,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildGallonSelector(BuyModel model) {
    return TabBar(
      onTap: (index) => model.setGallonType(
        index == 0 ? GallonType.l20 : GallonType.l10,
      ),
      controller: tabController,
      indicatorColor: AppColors.primary,
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.black38,
      tabs: [
        Tab(text: '20 litros'),
        Tab(text: '10 litros'),
      ],
    );
  }

  Widget _buildGallonsList(BuyModel model) {
    if (model.state == ViewState.busy) {
      return _buildLoading();
    } else {
      Widget child;

      if (model.errorTitle != null)
        child = _buildError(model);
      else if (model.gallons.isEmpty)
        child = _buildEmpty();
      else
        child = ListView.builder(
          itemCount: model.gallons.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: index == 0
                  ? const EdgeInsets.only(top: 24.0)
                  : EdgeInsets.zero,
              child: GallonCard(model.gallons[index]),
            );
          },
        );

      return Expanded(
        child: SmartRefresher(
          controller: model.refreshController,
          onRefresh: () => model.onRefresh(model.gallonType),
          child: child,
        ),
      );
    }
  }

  Expanded _buildLoading() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(BuyModel model) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            model.errorTitle,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 8),
          Text(model.errorMessage ?? 'Houve um erro inesperado.'),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Não há nenhuma loja na sua área :(",
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
