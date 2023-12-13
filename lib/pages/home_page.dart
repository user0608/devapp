import 'package:devapp/provider/licence_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const path = "/home";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ListItemValuesProvider>(context);
    final toolBarIcons = <IconButton>[];

    if (provider.selecteds.isNotEmpty) {
      toolBarIcons.add(
        IconButton(
          onPressed: () {
            if (provider.selecteds.length == provider.values.length) {
              provider.unSelectAllItems();
              return;
            }
            provider.selectAllItems();
          },
          icon: const Icon(Icons.select_all),
        ),
      );
      toolBarIcons.add(
        IconButton(
          onPressed: () => provider.removeItems(context, provider.selecteds),
          icon: const Icon(Icons.delete),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Values Manager"),
        actions: toolBarIcons,
      ),
      body: const LicencesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          provider.unSelectAllItems();
          await provider.createValueDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> enviasSolicitud(BuildContext context) async {}
}

class LicencesList extends StatefulWidget {
  const LicencesList({super.key});

  @override
  State<LicencesList> createState() => _LicencesListState();
}

class _LicencesListState extends State<LicencesList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListItemValuesProvider>(
        context,
        listen: false,
      ).loadValues(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ListItemValuesProvider>(context, listen: true);
    const cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    );
    return RefreshIndicator(
      onRefresh: () async => provider.loadValues(context),
      child: ListView.builder(
        itemCount: provider.values.length,
        itemBuilder: (context, index) {
          final value = provider.values[index];
          final isSelected = provider.isSelected(value);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Card(
              shape: cardShape,
              child: ClipRRect(
                child: ListTile(
                  selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.8),
                  selectedColor: Colors.white,
                  selected: isSelected,
                  shape: cardShape,
                  onTap: () async {
                    if (provider.selecteds.isNotEmpty) {
                      if (isSelected) {
                        provider.unSelectItem(value);
                      } else {
                        provider.selectItem(value);
                      }
                      return;
                    }
                    await provider.updateValueDialog(context, value);
                  },
                  onLongPress: () {
                    provider.selectItem(value);
                  },
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value.description ?? "", style: const TextStyle(height: 1, fontSize: 18)),
                      Text(value.name ?? "", style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                  subtitle: Text(value.value ?? ""),
                  trailing: Switch(
                    value: value.state ?? false,
                    onChanged: (state) async {
                      value.state = state;
                      await provider.replaceItem(context, value);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
