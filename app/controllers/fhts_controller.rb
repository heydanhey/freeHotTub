# Free Hot Tub Controller
class FhtsController < ApplicationController
  def index
    @fhts = Fht.all
  end
end
