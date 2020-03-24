import 'package:flutter/material.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/viewModels/buy_view_model.dart';
import 'package:flutter_base/ui/theme.dart';
import 'package:flutter_base/ui/widgets/gallon_card.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BuyView extends StatefulWidget {
  @override
  _BuyViewState createState() => _BuyViewState();
}

class _BuyViewState extends State<BuyView> with SingleTickerProviderStateMixin {
  TabController tabController;
  BuyViewModel viewModel;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    viewModel = Provider.of<BuyViewModel>(context);
    viewModel.tabController = tabController;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                _buildAddress(),
                Divider(),
                _buildGallonSelector(),
              ],
            ),
          ),
          _buildGallonsList(),
        ],
      ),
    );
  }

  Widget _buildAddress() {
    return ListTile(
      onTap: () {},
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

  Widget _buildGallonSelector() {
    return TabBar(
      onTap: (index) => viewModel.setGallonType(
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

  Widget _buildGallonsList() {
    if (viewModel.status == ViewStatus.loading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (viewModel.status == ViewStatus.completed) {
      if (viewModel.gallons.isEmpty) return _buildEmpty();
      return Expanded(
        child: SmartRefresher(
          controller: viewModel.refreshController,
          onRefresh: () => viewModel.onRefresh(GallonType.l20),
          child: ListView.builder(
            itemCount: viewModel.gallons.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: index == 0
                    ? const EdgeInsets.only(top: 24.0)
                    : EdgeInsets.zero,
                child: GallonCard(viewModel.gallons[index]),
              );
            },
          ),
        ),
      );
    } else {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Erro de conexão :(",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text("Verifique que você está conectado com a internet."),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildEmpty() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Não há nenhuma loja na sua área :(",
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
