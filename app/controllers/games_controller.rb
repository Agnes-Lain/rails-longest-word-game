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
    @score = run_game(@word, @grid)
  end

  private

  def run_game(attempt, grid)
      # TODO: runs the game and return detailed hash of result
    result = Hash.new(0)
    url = "https://wagon-dictionary.herokuapp.com/" + attempt
    check = open(url).read
    if word_checking?(attempt, grid)
      if JSON.parse(check)["found"]
        result[:message] = "well done"
        result[:score] = ((attempt.length.to_f / grid.length.to_f)*10).round(2)
      else
        result[:message] = "not an english word"
        result[:score] = 0
      end
    else
      result[:message] = "not in the grid"
      result[:score] = 0
    end
    result
  end

  def word_checking?(attempt, grid)
    attempt_h = array_to_hash(attempt.upcase.split(""))
    grid_h = array_to_hash(grid)
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
