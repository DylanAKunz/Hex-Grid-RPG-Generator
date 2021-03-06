# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
mountain = Terrain.create(terrain: 'Mountain', generation_type: 'mountain', color: 'acaebe', hover: '9b9cab')
river = Terrain.create(terrain: 'River', generation_type: 'river', color: '3e4ddd', hover: '3542d4')
plain = Terrain.create(terrain: 'Plains', generation_type: 'plain', color: 'd6dd8a', hover: 'cbd281')
city = Terrain.create(terrain: 'City', generation_type: 'city', color: '717177', hover: '5c5d61')
town = Terrain.create(terrain: 'town', generation_type: 'town', color: '88c57e', hover: '679260')
hill = Terrain.create(terrain: 'hill', generation_type: 'hill', color: 'bc9c76', hover: '9d8161')
demonic = Affinity.create(affinity: 'Demonic')
holy = Affinity.create(affinity: 'Holy')
barbaric = Affinity.create(affinity: 'Barbaric')
urban = Affinity.create(affinity: 'Urban')
ruined = Affinity.create(affinity: 'Ruined')
eldritch = Affinity.create(affinity: 'Eldritch')
ancient = Affinity.create(affinity: 'Ancient')
rural = Affinity.create(affinity: 'Rural')
overgrown = Affinity.create(affinity: 'Overgrown')
green = Prefix.create(prefix: 'green')
hills = Suffix.create(suffix: 'hills')
blue = Prefix.create(prefix: 'blue')
meadows = Suffix.create(suffix: 'meadows')
river_type = Type.create( generate_type: 'river')
mountain_type = Type.create( generate_type: 'mountain')
hill_type = Type.create( generate_type: 'hill')
plains_type = Type.create( generate_type: 'plain')
city_type = Type.create( generate_type: 'city')
town_type = Type.create( generate_type: 'town')