class DecksController < ApplicationController
  include FileImportable
  include ApplicationHelper

  before_action :set_deck, only: %i[show edit update destroy import]
  before_action :set_cards, only: %i[show import]

  def index
    @decks = Deck.all.page(params[:page])
  end

  def show
  end

  def new
    @deck = Deck.new
  end

  def edit
  end

  def create
    @deck = Deck.new(deck_params)

    respond_to do |format|
      if @deck.save
        format.html { redirect_to @deck, notice: "Deck was successfully created." }
        format.json { render :show, status: :created, location: @deck }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @deck.update(deck_params)
        format.html { redirect_to @deck, notice: "Deck was successfully updated." }
        format.json { render :show, status: :ok, location: @deck }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @deck.destroy
    respond_to do |format|
      format.html { redirect_to decks_url, notice: "Deck was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    initialize_import
    validate_file_type
    validate_file_size

    return render :show, status: :bad_request if @errors.present?

    @deck.with_import!(@file) do |importer|
      if importer.report.success?
        redirect_to @deck, notice: importer.report.message
      else
        @errors << importer.report.message
        @errors.each { |e| flash_message "alert", e }
        render :show, status: :bad_request, location: @deck
      end
    end
  end

  private

  def set_deck
    @deck = Deck.find(params[:id])
  end

  def set_cards
    @cards = @deck.cards.page(params[:page])
  end

  def deck_params
    params.require(:deck).permit(:name, :difficulty)
  end
end
