class CreatePokemon < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.string :location
      t.string :move

      t.timestamps
    end
  end
end
