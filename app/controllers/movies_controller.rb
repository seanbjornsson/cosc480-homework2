# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def index
		@all_ratings = Movie.ratings
		if @checked_ratings == nil
			@checked_ratings = @all_ratings
		end
		@checked_ratings = params[:ratings].keys unless params[:ratings] == nil
		@movies = Movie.find_all_by_rating(@checked_ratings,:order => params[:param])
		@title_hilite = ("hilite" if params[:param]=="title")
		@release_date_hilite = ("hilite" if params[:param]=="release_date")
		
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
    # will render app/views/movies/show.html.haml by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
