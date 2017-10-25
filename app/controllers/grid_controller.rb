class GridController < ApplicationController
  #Values used to determine whether a tile is directly touching another tile, with the first being even rows, and the second being for odd rows.  First coordinate in the series corresponds to top left tile and works its way clockwise.
  GRID_TOUCHING = [[[-1], [-1]], [[0], [-1]], [[-1], [0]], [[1], [0]], [[0], [1]], [[-1], [1]]], [[[0], [-1]], [[1], [-1]], [[1], [0]], [[-1], [0]], [[0], [1]], [[1], [1]]]
  #This controller is designed to accept user input in the form of two positive integers and create a map through several stages of generation(Mountain, river, forest, city)
  def view
    #Checks if there are parameters set, if so create a new grid
    if defined? params[:dimension][:commit]
      #Dimensionx is the users input for the x dimensions of the map, dimension y for the y
      generate(params[:dimension][:dimensionx], params[:dimension][:dimensiony])
    end
  end

  #generates a random number
  def random_index(num)
    index = rand(num)
    return index
  end

  #generates a grid based on user provided dimensions
  def generate(dimensionx, dimensiony)
    #Temporary location for creating the color of a tile based on its color in the database and writing it to a stylesheet.  In the future will allow for custom created tiles
    directory = 'app/assets/stylesheets/'
    File.truncate(directory + 'grid_color.scss', 0)
    File.open(File.join(directory, 'grid_color.scss'), 'w') do |f|
      f.puts '/* Styles for the colors in the map grid */'
      Terrain.all.each do |terrain|
        f.puts '.' + terrain.terrain.to_s + '{'
        f.puts '  background-color: #' + terrain.color.to_s
        f.puts '}'
        f.puts '.' + terrain.terrain.to_s + ':hover{'
        f.puts '  background-color: #' + terrain.hover.to_s
        f.puts '}'
      end
     f.close
    end

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
    mountain_occurrence = (dimensionx.to_i * dimensiony.to_i).floor / 150 + 1
    river_occurrence = (dimensionx.to_i * dimensiony.to_i).floor / 150 + 1
    city_occurrence = (dimensionx.to_i * dimensiony.to_i).floor / 150 + 1
    mountain_chain(mountain_occurrence)
    height
    river_chain(river_occurrence)
    city(city_occurrence)
  end

  #Generates the mountain seed tiles.
  def mountain_chain(mountain_occurrence)
    grid = Tile.order("RANDOM()").limit(mountain_occurrence)
    grid.each do |mountain|
      mountain.terrain = Terrain.where(generation_type: 'mountain').order("RANDOM()").first.terrain
      mountain.height = 6
      mountain(mountain.x, mountain.y, 1, mountain.terrain)
      mountain.save
    end
  end

  #Generates smaller mountains in a chain, iterating several times.
  def mountain(tilex, tiley, count, terrain)
    (1..6).each do
      count += 1
      grid = Tile.where(x: tilex + random_index(0..1) * 2 - 1, y: tiley)
      grid.each do |chain|
        i = 0
        newx = chain.x
        newy = chain.y
        ydirection = random_index(0..1) * 2 - 1
        until random_index(1...100) <= i * 7
          mountain = Tile.where(x: newx, y:newy)
          mountain.each do |mountain|
            mountain.terrain = terrain
            if mountain.height < 6
              mountain.height = 5
            end
            mountain.save
            newx += random_index(0..1)
            newy += ydirection
            i += 1
          end
        end
      end
    end
  end

  #Generates the height for tiles based on their distance from a mountain with a one tile to one height ratio
  #not entirely satisfied with this height generation, seems slow, and unnatural looking on map.  will revisit in future
  def height
    type = Terrain.where(generation_type: 'mountain')
    type.each do |category|
      grid = Tile.where(terrain: category.terrain)
      grid.each do |mountain|
        (-4..4).each do |xpos|
          (-4..4).each do |ypos|
            tile = Tile.where(x: xpos + mountain.x, y: ypos + mountain.y)
            tile.each do |height|
              distance = (((xpos.abs) / 2).floor - 3).abs + (((ypos.abs) / 2).floor - 3).abs / 2
              if distance > height.height
                height.height = distance.abs
                height.save
              end
            end
          end
        end
      end
    end
  end

  #Selects the different types of mountains and rivers then generates a seed tile for a river calling "river" to send the river towards either the top of the grid or the bottom of the grid.
  def river_chain(river_occurrence)
    (1..river_occurrence).each do
      mountain_select = Terrain.where(generation_type: 'mountain')
      mountain_types = Array.new
      mountain_select.each do |select|
        mountain_types << select.terrain
      end
      river_select = Terrain.where(generation_type: 'river')
      river_types = Array.new
      river_select.each do |select|
        river_types << select.terrain
      end
      type = Terrain.where(terrain: [river_types.sample]).order("RANDOM()").first
      river_seed = Tile.where(terrain: [mountain_types.sample]).order("RANDOM()").first
      river_seed.terrain = type.terrain
      river_seed.height -= 1
      #Determines wether to send the river up or down, with 0 being up, and 1 being down
      if river_seed.y >= params[:dimension][:dimensiony].to_i / 2
        direction = 0
      else
        direction = 1
      end
      #passes the x, and y coordinates as well as the height of the seed tile and whether or not to send the river to the bottom or the top of the grid
      river(river_seed.x, river_seed.y, river_seed.height, direction, type.terrain)
      river_seed.save
    end
  end

  #Check wether the row is even or odd, grab the entries to select northern tiles or southern tiles based on direction, check for valid river tiles within that range,
  def river(x, y, height, direction, type)
    tile_height = height
    tile_x, tile_y = x, y
    valid = Array.new
    count = 0
    #Start that will break when river has reached the edge of the map, or count exceeds reasonable numbers
    until tile_x == params[:dimension][:dimensionx].to_i || tile_y == params[:dimension][:dimensiony].to_i && count > 1 || count >= params[:dimension][:dimensionx].to_i * params[:dimension][:dimensiony].to_i
      valid.clear
      count += 1
      #determines wether the y coordinate is odd or even for determining whether or not a grid square is touching another
      if tile_y % 2 == 0
        parity = 1
      else
        parity = 0
      end
      #Assigns a range for determining whether or not a grid square is touching another based on the direction parameter.  0-3 is the grids on top as well as the sides with 2-5 being the sides and bottom.
      if direction == 0
        range = (0..3).to_a
      else
        range = (2..5).to_a
      end
      #Grabs the grid squares that are touching the existing tile based on previous previous parameters and checks if they are a valid tile for a new river tile, if so adds it to an array of valid tiles.
      range.each do |check_list|
        check_x = GRID_TOUCHING[parity][check_list][0]
        check_y = GRID_TOUCHING[parity][check_list][1]
        tile = Tile.where(x: tile_x + check_x[0], y: tile_y + check_y[0])
        tile.each do |check|
          if check.terrain != type && check.height >= tile_height && check.x != tile_x || check.y != tile_y
            valid << check.id
          end
        end
      end
      #if there is a valid tile within the valid array it creates a river tile from a random one, if not it breaks the loop.
      if !valid.blank?
        rivers = Tile.where(id: valid.sample).order("RANDOM()").first
        rivers.terrain = type
        rivers.height -= 1
        rivers.save
        tile_x = rivers.x
        tile_y = rivers.y
      else
      break
      end
    end
  end

  #selects several random tiles from within and then changes their type to city.
  def city(city_occurrence)
    #selects any terrain types that generate as a city and creates an array from them
    type_select = Terrain.where(generation_type: 'city')
    city_types = Array.new
    type_select.each do |select|
      city_types << select.terrain
    end
    #selects a tile and then changes it to a random city type
    grid = Tile.order("RANDOM()").limit(city_occurrence)
    grid.each do |city|
      city.terrain = city_types.sample
      city.save
    end
  end
end
