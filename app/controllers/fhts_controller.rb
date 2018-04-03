# Free Hot Tub Controller
class FhtsController < ApplicationController
  def index
    @fhts = Fht.where(is_active: true)
  end

  def analytics
  end
end
