class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_column = params[:sort_by]
    @all_ratings = Movie.all_ratings.sort
    
    if params.has_key?(:ratings)
        session[:ratings] = params[:ratings]
    elsif session.has_key?(:ratings)
        params[:ratings] = session[:ratings]
        flash.keep
        redirect_to movies_path(params) and return
    end
    
    @filter_ratings = (session[:ratings].keys if session.key?(:ratings)) || @all_ratings
    @movies = Movie.order(params[:sort_by]).where(rating: @filter_ratings)
    
    if params[:sort_by] == 'title'
        session[:sort_by] = params[:sort_by]
        @title_header = 'hilite'
    elsif params[:sort_by] == 'release_date'
        session[:sort_by] = params[:sort_by]
        @release_date_header = 'hilite'
    elsif session.key?(:sort_by)
        params[:sort_by] = session[:sort_by]
        flash.keep
        redirect_to movies_path(params) and return
    end
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

end
