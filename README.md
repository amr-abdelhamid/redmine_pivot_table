# Redmine PivotTable


## About

This Redmine plugin allows you to generate pivot table for issue analysis.

It uses [PivotTable.js](http://nicolas.kruchten.com/pivottable/examples/) as a user interface.

With this plugin you can:
* Analyze issues and activities by dynamically creating pivot tables and graphs

![Image](https://raw.github.com/wiki/deecay/redmine_pivot_table/images/table_simple.jpg)

Requieres IE8 and above.
PivotTable.js version included: 2015-09-08


## Installation

0. Follow the Redmine plugin installation steps at: http://www.redmine.org/wiki/redmine/Plugins

1. Enable Pivot module for your project.

2. Allow permission to view pivottables from Administration -> Roles and permissions

3. Go to Pivot tab of your project.

No migration required.


## How to use

Drag and drop attributes to dynamically create your own pivot table.

For more information on usage, visit [PivotTable.js Home page](http://nicolas.kruchten.com/pivottable/examples/).

You can save the pivot table configuration when you save a query from the Pivot page.

## Other screenshots

![Image](https://raw.github.com/wiki/deecay/redmine_pivot_table/images/heatmap.jpg)

![Image](https://raw.github.com/wiki/deecay/redmine_pivot_table/images/line.jpg)

![Image](https://raw.github.com/wiki/deecay/redmine_pivot_table/images/bar.jpg)

![Image](https://raw.github.com/wiki/deecay/redmine_pivot_table/images/scatter.jpg)
First attribute of both vertical and horizontal attribute must be a numeric attribute. Append some other attributes to horizontal, to see colorized scatter plot.

![Image](https://raw.github.com/wiki/deecay/redmine_pivot_table/images/activity.jpg)

## Todo

* Add "edit pivot query".
* Some clean-ups of code and locale after recent changes.
* Add workaround for dropped HTML support in pivottable.js.
* i18n of renderers and aggregators.


## Keywords

Pivot Table, Graphs, Analysis, Redmine, Plugin


## Support

Support will only be given to the following versions or above:

* Redmine version                2.6.0.stable
* Ruby version                   ruby 2.1.5p273
* Rails version                  3.2.19


## License

This plugin is licensed under the MIT license.



