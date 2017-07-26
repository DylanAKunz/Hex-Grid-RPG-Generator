class GridController < ApplicationController
  def view
    #Checks if there are parameters set, if so create a new grid
    if defined? params[:dimension][:dimensiony]
      #Temporary location for creating the color of a tile based on its color in the database.  In the future will allow for custom created tiles
      directory = 'app/assets/stylesheets/'
      File.truncate(directory + 'grid.scss', 0)
      File.open(File.join(directory, 'grid.scss'), 'w') do |f|

        Terrain.all.each do |terrain|
          f.puts "." + terrain.terrain.to_s + "{"
          f.puts 'background-color: #' + terrain.color.to_s
          f.puts '}'
          f.puts "." + terrain.terrain.to_s + ':hover{'
          f.puts 'background-color: #' + terrain.hover.to_s
          f.puts '}'
        end
      end



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
          @grid.save
        end
      end
    end
  end

  def generate

  end
end
