class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  get "/" do
    { message: "Good luck with your project!" }.to_json
  end

  get "/pokemon" do
    pokemon = Pokemon.all
    pokemon.to_json(include: :reviews )
  end

  get "/pokemon/:id" do
    pokemon = Pokemon.find(params[:id])
    pokemon.to_json(include: :reviews)
  end

  get "/pokemon/:id/reviews" do
    pokemon = Pokemon.find(params[:id])
    pokemon.to_json(only: [], include: :reviews
    )
  end

  get "/reviews" do 
    reviews = Review.all
    reviews.to_json
  end

  post "/reviews" do
    review = Review.create(
      rating: params[:rating],
      text: params[:text],
      pokemon_id: params[:pokemon_id]
    )
    review.to_json
  end

  delete "/reviews/:id" do
    review = Review.find(params[:id])
    review.destroy
    review.to_json
  end

  patch "/reviews/:id" do
    review = Review.find(params[:id])
    review.update(
      rating: params[:rating],
      text: params[:text]
    )
    review.to_json
  end

end
