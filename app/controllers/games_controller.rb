require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # TODO: generate random grid of letters
    @grid = []
    counter = 0
    while counter <= 10
      letter = ('A'..'Z').to_a[rand(26)]
      @grid << letter
      counter += 1
    end
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    result = run_game(@word, @grid)
    @message = result[:message]
    @score = result[:score]
  end

  private

  def run_game(attempt, grid)
      # TODO: runs the game and return detailed hash of result
    result = Hash.new(0)
    url = "https://wagon-dictionary.herokuapp.com/" + attempt
    check = open(url).read
    if word_checking?(attempt, grid)
      if JSON.parse(check)["found"]
        result[:message] = "Congratulations! #{attempt.upcase} is a valid English word!"
        result[:score] = ((attempt.length.to_f / grid.length.to_f)*10).round(2)
      else
        result[:message] = "Sorry, but #{attempt.upcase} dose not seem to be a valid english word"
        result[:score] = 0
      end
    else
      result[:message] = "Sorry, but #{attempt.upcase} can't be built out of #{grid}"
      result[:score] = 0
    end
    result
  end

  def word_checking?(attempt, grid)
    attempt_h = array_to_hash(attempt.upcase.split(""))
    grid_h = array_to_hash(grid.split)
    if (attempt_h.keys - grid_h.keys).empty?
      attempt_h.all? do |k, v|
        v <= grid_h[k]
      end
    end
  end

  def array_to_hash(array)
    array.group_by { |l| l }.map { |k, v| [k, v.size] }.to_h
  end
end
