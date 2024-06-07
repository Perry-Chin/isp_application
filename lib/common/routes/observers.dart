//For route navigation between different pages, 
//maintains a history of route names

// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'routes.dart';

class RouteObservers<R extends Route<dynamic>> extends RouteObserver<R> {
  
  //Adds the name of the pushed route to AppPages.history
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    var name = route.settings.name ?? '';
    if (name.isNotEmpty) AppPages.history.add(name);
    print('didPush');
    print(AppPages.history);
  }

  //Receives the route that was popped and the previousRoute that becomes the top route
  //after the pop. Removes the name of the popped route from AppPages.history
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    AppPages.history.remove(route.settings.name);
    print('didPop');
    print(AppPages.history);
  }


  //This method called when a route is replaced with another route.
  //Updates the route name in AppPages.history if the old route exists in 
  //the history, or adds the new route name if it doesn't exist. 
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      var index = AppPages.history.indexWhere((element) {
        return element == oldRoute?.settings.name;
      });
      var name = newRoute.settings.name ?? '';
      if (name.isNotEmpty) {
        if (index > 0) {
          AppPages.history[index] = name;
        } else {
          AppPages.history.add(name);
        }
      }
    }
    print('didReplace');
    print(AppPages.history);
  }

  //Removes the name of the removed route from AppPages.history
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    AppPages.history.remove(route.settings.name);
    print('didRemove');
    print(AppPages.history);
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
  }
}
