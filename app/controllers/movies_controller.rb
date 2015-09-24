class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    unless session[:redirect]
      if params[:order].is_a?(String)
         @hilite = params[:order] 
         session[:order] = @hilite
         session[:redirect] = true
      elsif params[:order].is_a?(Hash)
      	 @hilite = params[:order].keys.first
         session[:order] = @hilite
         session[:redirect] = true
      end
      if params[:ratings]
         session[:ratings] = params[:ratings]
         session[:redirect] = true 
      end
    else
      session[:redirect] = false
    end  
       
    @all_ratings = Movie.ratings
    if session[:order] and session[:ratings]
      @movies = Movie.where(rating: session[:ratings].keys).order("#{session[:order]} ASC") 
      @hilite = session[:order] 
    elsif session[:ratings]
      @movies = Movie.where(rating: session[:ratings].keys)
    elsif session[:order]
      @movies = Movie.all(order: "#{session[:order]} ASC") 
      @hilite = session[:order]
    else
      @movies = Movie.all
    end
    if session[:redirect]
       redirect_to movies_path(:order => session[:order], :ratings => session[:ratings])
       return
    end        
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
