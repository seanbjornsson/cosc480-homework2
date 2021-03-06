# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def arr_to_hash array
		hash = Hash.new()
		array.each do |elt|
			hash.store(elt,1)
		end
		hash
	end

	def index
		#update session info if it there are new filter/sort parameters
		if params[:param] != nil
			session[:param] = params[:param]
		end
		if params[:ratings] != nil
			session[:ratings] = params[:ratings]
		end
		@current_session = session
		#check if the sort parameter is valid
		@sort = session[:param] unless !((session[:param] == 'title') | (session[:param] == 'release_date'))
		@all_ratings = Movie.ratings
		@all_ratings_hash = arr_to_hash(@all_ratings)
		
		#this ensures that the first time someone visits the page all the boxes are checked
		if @checked_ratings == nil
			@checked_ratings = @all_ratings
		end
		@checked_ratings_hash = session[:ratings] unless session[:ratings] == nil
		@checked_ratings = @checked_ratings_hash.keys unless @checked_ratings_hash == nil

		#fill movie variable for view, sorted if there is a sort parameter
		@movies = Movie.find_all_by_rating(@checked_ratings,:order => @sort)
		@title_hilite = ("hilite" if @sort=="title")
		@release_date_hilite = ("hilite" if @sort=="release_date")
		#redirect if there are no ratings in the URL.
		if params[:ratings]==nil
			@checked_ratings_hash = arr_to_hash(@checked_ratings)
			flash.keep
			redirect_to :action => 'index', :ratings => @checked_ratings_hash, :param => @sort
		end
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
