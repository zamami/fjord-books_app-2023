Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :users, :only => [:index, :show]
  resources :books
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
