import 'package:flutter/material.dart';

import '../home_screen/home_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  final Function filterHandler;
  Map<String, bool> currentFilters;

  FiltersScreen(this.filterHandler, this.currentFilters);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _gluten = false;
  bool _lactose = false;
  bool _vegan = false;
  bool _vegetarian = false;
  @override
  void initState() {
    super.initState();
    _gluten = widget.currentFilters['gluten']!;
    _lactose = widget.currentFilters['lactose']!;
    _vegan = widget.currentFilters['vegan']!;
    _vegetarian = widget.currentFilters['vegetarian']!;
  }

  Widget buildSwitchListTile(
    String title,
    String description,
    bool currentValue,
    Function changeHandler,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(description),
      value: currentValue,
      onChanged: (newValue) => changeHandler(newValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: HomeDrawer()),
      appBar: AppBar(
        title: const Text('Filters'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => widget.filterHandler({
              "gluten": _gluten,
              "lactose": _lactose,
              "vegan": _vegan,
              'vegetarian': _vegetarian,
            }),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Adjust your meal filters',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
          ),
          buildSwitchListTile(
            'gluten-free',
            "only the meals that don't contain gluten will be displayed",
            _gluten,
            (newValue) {
              setState(
                () {
                  _gluten = newValue;
                },
              );
            },
          ),
          buildSwitchListTile(
            'lactose-free',
            "only the meals that don't contain lactose will be displayed",
            _lactose,
            (newValue) {
              setState(
                () {
                  _lactose = newValue;
                },
              );
            },
          ),
          buildSwitchListTile(
            'vegan',
            "only the meals that are vegan will be displayed",
            _vegan,
            (newValue) {
              setState(
                () {
                  _vegan = newValue;
                },
              );
            },
          ),
          buildSwitchListTile(
            'vegetarian',
            "only the meals that are vegetarian will be displayed",
            _vegetarian,
            (newValue) {
              setState(
                () {
                  _vegetarian = newValue;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
