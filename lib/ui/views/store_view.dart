import 'package:flutter/material.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/viewModels/views/store_model.dart';
import 'package:refresco/ui/theme.dart';
import 'package:refresco/ui/views/base_view.dart';
import 'package:refresco/ui/widgets/cart_sheet.dart';
import 'package:refresco/ui/widgets/gallon_card.dart';
import 'package:provider/provider.dart';

class StoreView extends StatefulWidget {
  final Store store;

  const StoreView(this.store);

  @override
  _StoreViewState createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<StoreModel>(
      onModelReady: (model) {
        model.tabController = tabController;
        model.getGallons(widget.store);
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.store.name),
          ),
          body: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  _buildStoreHeader(context, model),
                  SizedBox(height: 32),
                  model.state == ViewState.busy
                      ? _buildLoading(context)
                      : _buildItems(context, model),
                ],
              ),
              CartSheet()
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoreHeader(BuildContext context, StoreModel model) {
    return Consumer<User>(
      builder: (context, user, child) {
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.store.name,
                            style: Theme.of(context).textTheme.headline5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(widget.store.rating == null
                                ? 'Novo!'
                                : widget.store.rating.toStringAsFixed(1)),
                            Icon(widget.store.getStarIcon(),
                                color: Colors.yellow, size: 20),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Entrega em ${widget.store.minDeliveryTime}-${widget.store.maxDeliveryTime} min',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          model.getFormattedDistanceFromUser(
                              user.address, widget.store.address),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              _buildTabBar(model),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildItems(BuildContext context, StoreModel model) {
    var gallonCards = <Widget>[];

    gallonCards = model.gallons.map<Widget>((g) {
      return GallonCard(g);
    }).toList();

    if (gallonCards.isEmpty) {
      return _buildEmpty(context);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: gallonCards,
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text('Opa :(', style: Theme.of(context).textTheme.headline5),
          SizedBox(height: 8),
          Text('Houve um erro inesperado.')
        ],
      ),
    );
  }

  Widget _buildTabBar(StoreModel model) {
    return TabBar(
      onTap: (index) {
        var gallonType = index == 0 ? GallonType.l20 : GallonType.l10;
        model.setGallonType(gallonType);
        model.getGallons(widget.store);
      },
      controller: model.tabController,
      indicatorColor: AppColors.primary,
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.black38,
      tabs: [
        Tab(text: '20 litros'),
        Tab(text: '10 litros'),
      ],
    );
  }
}
