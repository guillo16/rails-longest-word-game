require 'open-uri'

class GamesController < ApplicationController
  def new
    array = ('a'..'z').to_a.shuffle
    @letters = array[0..9]
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(' ')
    @message = message(@letters, @word)
  end
end

def included?(guess, letters)
  guess.chars.all? { |letter| guess.count(letter) <= letters.count(letter) }
end

def message(letters, word)
  if included?(word.downcase, letters)
    if english_word?(word)
      "Congratulation! #{word.upcase} is a valid English word! "
    else
      "Sorry but #{word.upcase} is not a valid English word .."
    end
  else
    "Sorry but #{word.upcase} can't be built out of #{letters} "
  end
end

def english_word?(word)
  response = open("https://wagon-dictionary.herokuapp.com/#{word}")
  json = JSON.parse(response.read)
  return json['found']
end

