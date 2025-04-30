class RemoveBannerUrlFromEventsAndAddBanner < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :banner_url, :string
  end
end
