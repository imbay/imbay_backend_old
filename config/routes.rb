Rails.application.routes.draw do
    scope :v1 do
        scope :account do
            post '/user', to: 'account#user'
            post '/sign_up', to: 'account#sign_up'
            post '/sign_in', to: 'account#sign_in'
            post '/sign_out', to: 'account#sign_out'
            post '/unactive', to: 'account#unactive'
            post '/active', to: 'account#active'
            post '/recovery', to: 'account#recovery'
            scope :update do
              post '/', to: 'account#update'
              post '/email', to: 'account#update_email'
              post '/username', to: 'account#update_username'
              post '/password', to: 'account#update_password'
              post '/language', to: 'account#update_language'
            end
        end
        scope :dialog do
          scope :user do
            post '/', to: 'dialog#users'
            post '/new', to: 'dialog#new_user'
            post '/delete', to: 'dialog#delete_dialog'
          end
          post '/', to: 'dialog#my_dialogs'
          post '/new', to: 'dialog#new_dialog'
          post '/delete', to: 'dialog#delete_user'
          post '/list', to: 'dialog#dialogs'
          post '/quit', to: 'dialog#quit_dialog'
        end
    end
end
