Rails.application.routes.draw do
  scope :api do
    scope :v1 do
        scope :account do
            get '/user', to: 'account#user'
            post '/sign_up', to: 'account#sign_up'
            post '/sign_in', to: 'account#sign_in'
            get '/sign_out', to: 'account#sign_out'
            post '/unactive', to: 'account#unactive'
            post '/active', to: 'account#active'
            post '/recovery', to: 'account#recovery'
            get '/blacklist', to: 'account#blacklist'
            scope :update do
              post '/', to: 'account#update'
              post '/email', to: 'account#update_email'
              post '/username', to: 'account#update_username'
              post '/password', to: 'account#update_password'
              post '/language', to: 'account#update_language'
            end
        end
        scope :dialog do
          get '/', to: 'dialog#my_dialogs'
          post '/new', to: 'dialog#new_dialog'
          post '/delete', to: 'dialog#delete_dialog'
          get '/list', to: 'dialog#dialogs'
          post '/quit', to: 'dialog#quit_dialog'
          get '/dialog', to: 'dialog#dialog'
          post '/read', to: 'dialog#read'
          scope :user do
            get '/', to: 'dialog#users'
            post '/new', to: 'dialog#new_user'
            post '/delete', to: 'dialog#delete_user'
          end
          scope :message do
            get '/', to: 'dialog#messages'
            post '/new', to: 'dialog#new_message'
          end
        end
        scope :user do
          get '/', to: 'user#search'
          get '/:id', to: 'user#profile'
          post '/block', to: 'user#block'
          post '/unblock', to: 'user#unblock'
        end
    end
  end
end
