Rails.application.routes.draw do
  resources :shortened_urls, path: "/", only: [:index, :show, :create]
end
