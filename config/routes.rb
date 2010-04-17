ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'site', :action => 'index'

  map.resources :cities, :as => 'ciudades'

  map.connect ':id', :controller => 'cities', :action => 'versus'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
