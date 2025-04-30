class RenameOrganiserIdToOrganizerIdInEvents < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :organiser_id, :organizer_id
  end
end
