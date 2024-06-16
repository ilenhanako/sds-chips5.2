class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    selected_ratings = params[:ratings] ? params[:ratings].keys : @all_ratings
    
    #determine sorting column and direction
    @sort_column = params[:sort] || 'title'
    @sort_direction = params[:direction] || 'asc'

    # Log the selected ratings and sort parameters
    Rails.logger.debug "Selected ratings: #{selected_ratings.inspect}"
    Rails.logger.debug "Sorting by: #{@sort_column} #{@sort_direction}"

    #fetch and sort movies based on selected ratings and sort parameters
    Rails.logger.info("=========")
    Rails.logger.info(@sort_direction)

    @movies = Movie.where(rating: selected_ratings).order("#{@sort_column} #{@sort_direction}")

    #@movies = Movie.all
    #@movies = Movie.where(rating: selected_ratings)
    @ratings_to_show_hash = selected_ratings.to_h { |rating| [rating, "1"]}
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
