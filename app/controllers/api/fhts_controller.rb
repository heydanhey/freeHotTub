# Free Hot Tub Controller
class Api::FhtsController < ApplicationController
  def index
    @fhts = Fht.all
    render json: @fhts
  end
end
