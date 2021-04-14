Rails.application.routes.draw do
  #devise_for :admins
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_scope :admin do
    get "/sign_in" => "devise/sessions#new" # custom path to login/sign_in
    get "/sign_up" => "devise/registrations#new", as: "new_admin_registration" # custom path to sign_up/registration
  end

  devise_for :admins, :skip => [:registrations]
  as :admin do
    get 'admins/edit' => 'devise/registrations#edit', :as => 'edit_admin_registration'
    put 'admins' => 'devise/registrations#update', :as => 'admin_registration'
  end

  root to: "welcome#index"
  get 'result', to: 'welcome#result'
  get 'marathons', to: 'welcome#marathons'
  get 'certificates', to: 'welcome#certificates'
  get 'download_pdf', to: "welcome#download_pdf"
  get 'download_zip', to: "welcome#download_zip"
  get 'zip_zip', to: "welcome#zip_zip"

  #resources :users, only: [:index, :show, :edit], param: :email, :constraints => { :email => /.*/ } do
  #resources :users, param: :email, :constraints => { :email => /.*/ } do
  #  get 'download_pdf', to: "users#download_pdf"
  #  get 'download_zip', to: "users#download_zip"
  #end

  #resources :certificates
  #resources :rus_templates
  #resources :eng_templates


  #get 'download_pdf', to: "users#download_pdf"

  namespace :admin do
    root 'admin#dashboard'
    resources :users

    resources :marathons do
      member do
        patch 'delete_all_users', to: 'marathons#delete_all_users'
      end
    end

    resources :lectures
    resources :certificates
    resources :rus_templates
    resources :eng_templates
    resources :tables do
      member do
        patch 'create_users', to: 'tables#create_users'
        patch 'renew', to: 'tables#renew'
      end
    end
    get 'download_one_pdf', to: "users#download_one_pdf"
    get 'download_all_pdfs', to: "users#download_all_pdfs"
  end

end
