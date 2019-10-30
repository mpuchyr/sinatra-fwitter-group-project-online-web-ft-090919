class TweetsController < ApplicationController

    get '/tweets' do
        @tweets = Tweet.all
        if logged_in?
            erb :'/tweets/index'
        else
            redirect '/login'
        end
    end

    get '/tweets/new' do
        if session[:errors]
            @errors = session[:errors]
            session.delete(:errors)
        end
        if logged_in?
            erb :'/tweets/new'
        else
            redirect '/login'
        end
    end

    post '/tweets' do

        tweet = Tweet.new(params)
        if tweet.save
            current_user.tweets << tweet
            redirect "tweets/#{tweet.id}"
        else
            session[:errors] = tweet.errors.full_messages
            redirect '/tweets/new'
        end
    end

    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            erb :'/tweets/show'
        else
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do
        @tweet = Tweet.find_by_id(params[:id])
        if logged_in? && current_user.id == @tweet.user_id
            erb :'/tweets/edit'
        else
            redirect '/login'
        end
    end

    post '/tweets/:id/edit' do
        tweet = Tweet.find_by_id(params[:id])
        if tweet.update(params)
            redirect '/tweets'
        else
            redirect "/tweets/#{tweet.id}/edit"
        end
    end

    delete '/tweets/:id' do
        @tweet = Tweet.find_by_id(params[:id])
        if logged_in? && current_user.id == @tweet.user_id
            @tweet.delete
            redirect '/tweets'
        else
            redirect '/login'
        end
    end

end
