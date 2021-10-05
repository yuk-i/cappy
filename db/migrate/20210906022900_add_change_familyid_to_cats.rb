class AddChangeFamilyidToCats < ActiveRecord::Migration[5.2]
  def change
    remove_reference :cats, :family
    add_reference :cats, :family, foreign_key: true
  end
end
