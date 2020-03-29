import 'package:flutter/material.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/models/user.dart';
import 'package:flutter_base/core/viewModels/buy_model.dart';
import 'package:flutter_base/ui/theme.dart';
import 'package:flutter_base/ui/widgets/store_card.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'address_view.dart';
import 'base_view.dart';
import 'login_view.dart';

class BuyView extends StatefulWidget {
  @override
  _BuyViewState createState() => _BuyViewState();
}

class _BuyViewState extends State<BuyView> with SingleTickerProviderStateMixin {
  TabController tabController;
  Logger logger = getLogger('BuyView');

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        return BaseView<BuyModel>(
          onModelReady: (model) {
            model.tabController = tabController;
          },
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Escolha uma revenda'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                        user.isAnonymous ? Icons.vpn_key : Icons.exit_to_app),
                    onPressed: user.isAnonymous
                        ? () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => LoginView()))
                        : model.logout,
                  ),
                ],
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Ink(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        _buildAddress(user),
                        Divider(),
                        _buildGallonSelector(model, user),
                      ],
                    ),
                  ),
                  _buildStoresList(model, user),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddress(User user) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AddressView()));
      },
      title: Text(
        user.address == null ? 'Endereço' : user.address.streetAndNumber,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        user.address == null
            ? 'Escolha um endereço para entrega.'
            : user.address.districtAndCity,
        style: Theme.of(context).textTheme.subtitle1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.location_on,
        color: AppColors.accent,
      ),
    );
  }

  Widget _buildGallonSelector(BuyModel model, User user) {
    return TabBar(
      onTap: (index) {
        var gallonType = index == 0 ? GallonType.l20 : GallonType.l10;
        model.setGallonType(gallonType);
        model.getStores(address: user.address);
      },
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

  Widget _buildStoresList(BuyModel model, User user) {
    if (model.state == ViewState.busy) {
      return _buildLoading();
    } else {
      Widget child;

      if (model.errorTitle != null) {
        child = _buildError(model);
      } else if (model.stores.isEmpty) {
        child = _buildEmpty();
      } else {
        child = ListView.builder(
          itemCount: model.stores.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32, bottom: 8),
                child: Text(
                  'As mais próximas:',
                  style: AppThemes.boldPlainHeadline6,
                ),
              );
            }

            return StoreCard(store: model.stores[index - 1]);
          },
        );
      }

      return Expanded(
        child: SmartRefresher(
          controller: model.refreshController,
          onRefresh: () => model.onRefresh(address: user.address),
          child: child,
        ),
      );
    }
  }

  Widget _buildLoading() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(BuyModel model) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
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
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Não há nenhuma loja na sua área :(',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
