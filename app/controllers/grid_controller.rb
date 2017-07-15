class GridController < ApplicationController
  def view
    #Checks if there are parameters set, if so create a new grid
    if defined? params[:dimension][:dimensiony]
      Grid.delete_all
      (1..params[:dimension][:dimensionx].to_i).each do |x|
        (1..params[:dimension][:dimensiony].to_i).each do |y|
          @grid = Grid.new
          @grid.x = x
          @grid.y = y
          @grid.save
        end
      end
    end
  end

  def generate

  end
end
