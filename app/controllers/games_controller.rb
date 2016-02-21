class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :add_frame]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @frame = Frame.new
    if @game.finished?
      render 'finished'
    end
  end

  # GET /games/new
  def new
    @game  = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_frame
    @frame = Frame.new(frame_params.merge({:game_id => params[:id]}))
    if @frame.save
        redirect_to @game, notice: 'Frame was successfully created.'
    else
      render 'show'
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
       params.fetch(:game).permit(:name)
    end

    def frame_params
       params.fetch(:frame).permit(:first_roll, :second_roll)
    end
end
