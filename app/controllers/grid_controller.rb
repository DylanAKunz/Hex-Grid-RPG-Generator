class GridController < ApplicationController
  def view
    #Checks if there are parameters set, if so create a new grid
    if defined? params[:dimension][:dimensiony]




      Tile.delete_all
      (1..params[:dimension][:dimensionx].to_i).each do |x|
        (1..params[:dimension][:dimensiony].to_i).each do |y|
          @grid = Tile.new
          @grid.x = x
          @grid.y = y
          @grid.name = Prefix.order("RANDOM()").first.prefix << Suffix.order("RANDOM()").first.suffix
          @grid.terrain = Terrain.order("RANDOM()").first.terrain
          @grid.affinity = Affinity.order("RANDOM()").first.affinity
          @grid.height = rand(1..5)
          @grid.threat = rand(1..20)
          @meme = @grid.terrain
          @grid.save
        end
      end
    end
  end

  def generate

  end
end
