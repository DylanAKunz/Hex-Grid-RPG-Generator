class GridController < ApplicationController
  def view
    #Checks if there are parameters set, if so create a new grid
    if defined? params[:dimension][:commit]
      generate(params[:dimension][:dimensionx], params[:dimension][:dimensiony])
    end
  end

  #generates a random number
  def randomIndex(num)
    index = rand(num)
    return index
  end

  def generate(dimensionx, dimensiony)
    #generates a grid based on
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

    base_type = Terrain.order("RANDOM()").first.generation_type
    Tile.delete_all
    (1..dimensionx.to_i).each do |x|
      (1..dimensiony.to_i).each do |y|
        grid = Tile.new
        grid.x = x
        grid.y = y
        grid.name = Prefix.order("RANDOM()").first.prefix << Suffix.order("RANDOM()").first.suffix
        grid.terrain = Terrain.where(generation_type: 'plain').order("RANDOM()").first.terrain
        grid.affinity = Affinity.order("RANDOM()").first.affinity
        grid.height = 1
        grid.threat = (x.to_i + (y.to_i - dimensiony.to_i / 2).floor.abs) / 2 + rand(-1...1)
        grid.save
      end
    end
    mountain_amount = (dimensionx.to_i * dimensiony.to_i).floor / 150 + 1
    mountain(mountain_amount)
  end

  #Generates the mountain seed tiles.
  def mountain(occurence)
    grid = Tile.order("RANDOM()").limit(occurence)
    grid.each do |mountain|
      mountain.terrain = Terrain.where(generation_type: 'mountain').order("RANDOM()").first.terrain
      mountain.height = 6
      mountain_chain(mountain.x, mountain.y, 1, mountain.terrain)
      mountain.save
    end
  end

  #Generates smaller mountains in a chain, iterating several times.
  def mountain_chain(tilex, tiley, count, terrain)
    if count <= 6
      count += 1
      grid = Tile.where(x: tilex + randomIndex(0..1) * 2 - 1, y: tiley)
      grid.each do |chain|
        i = 0
        newx = chain.x
        newy = chain.y
        ydirection = randomIndex(0..1) * 2 - 1
        until randomIndex(1...100) <= i * 7
          mountain = Tile.where(x: newx, y:newy)
          mountain.each do |mountain|
            mountain.terrain = terrain
            mountain.height = 5
            mountain.save
            newx += randomIndex(0..1)
            newy += ydirection
            i += 1
          end
        end
      end
      mountain_chain(tilex, tiley, count, terrain)
    end
  end

  def river

  end

  def city

  end
end
