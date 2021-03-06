module Api
  class TweetsController < ApplicationController
    def index
      token = cookies.signed[:twitter_session_token]
      session = Session.find_by(token: token)
      @current_user = session.user

       @tweets = Tweet.all.order(created_at: :desc)
      render 'api/tweets/index'
     end

     def create
      token = cookies.signed[:twitter_session_token]
      session = Session.find_by(token: token)
      user = session.user

      @tweet = user.tweets.new(tweet_params)

       if @tweet.save
         render 'api/tweets/create'
       end
     end

    def destroy
      token = cookies.signed[:twitter_session_token]
      session = Session.find_by(token: token)

      user = session.user
      tweet = Tweet.find_by(id: params[:id])

      if tweet and tweet.user === user and tweet.destroy
        render json: {
          success: true,
          username: tweet.user.username
        }
      else
        render json: {
          success: false,
        }
      end
    end

    def index_by_user
      user = User.find_by(username: params[:username])
      token = cookies.signed[:twitter_session_token]
      session = Session.find_by(token: token)
      @current_user = session.user

        if user
          @tweets = user.tweets
          render 'api/tweets/index'
        end
    end

    private
    def tweet_params
      params.require(:tweet).permit(:message, :image)

  end
end
end
