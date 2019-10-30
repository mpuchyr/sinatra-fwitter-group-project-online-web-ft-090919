class UsersController < ApplicationController

    get '/signup' do

        if session[:errors]
            @errors = session[:errors]
            session.delete(:errors)
        end
        if !logged_in?
            erb :'/users/signup'
        else
            redirect '/tweets'
        end
    end

    post '/signup' do
        user = User.new(params)
        if user.save
            session[:user_id] = user.id
            redirect '/tweets'
        else
            session[:errors] = user.errors.full_messages
            redirect '/signup'
        end
    end

    get '/login' do
        if session[:errors]
            @errors = session[:errors]
            session.delete(:errors)
        end
        if !logged_in?
            erb :'/users/login'
        else
            redirect '/tweets'
        end
    end

    post '/login' do
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect '/tweets'
        else
            session[:errors] = ["Username or password was incorrect. Please try again."]
            redirect '/login'
        end
    end

    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        @tweets = @user.tweets
        erb :'/users/show'
    end

    get '/logout' do
        session.clear
        redirect '/login'
    end

end
