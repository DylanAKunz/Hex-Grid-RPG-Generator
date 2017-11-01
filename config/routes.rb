Rails.application.routes.draw do
  get 'grid/view'

  root 'grid#view'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
