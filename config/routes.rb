Rails.application.routes.draw do
    scope :v1 do
        root 'main#index'
        scope :account do
            post '/user', to: 'account#user'
            post '/sign_up', to: 'account#sign_up'
            post '/sign_in', to: 'account#sign_in'
            post '/sign_out', to: 'account#sign_out'
            post '/update', to: 'account#update'
            post '/update_email', to: 'account#update_email'
            post '/update_username', to: 'account#update_username'
            post '/update_password', to: 'account#update_password'
            post '/update_language', to: 'account#update_language'
            post '/unactive', to: 'account#unactive'
            post '/active', to: 'account#active'
            post '/update', to: 'account#update'
            post '/recovery', to: 'account#recovery'
        end
    end
end
