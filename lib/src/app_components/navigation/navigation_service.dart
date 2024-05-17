import 'package:linux_system_migrator/src/app_components/navigation/navigation_model.dart';
import 'package:fluent_ui/fluent_ui.dart';

class NavigationService{
  const NavigationService();

  static List<NavigationModel> getSideNavigationItems(){
    const List<NavigationModel> navItems =  [
      NavigationModel(shortName: 'Projects', toolTip: 'List migration projects', iconData: FluentIcons.project_collection),
      NavigationModel(shortName: 'Tools', toolTip: 'Migration tools a la carte', iconData: FluentIcons.toolbox)
    ];


    return navItems;
  }
}