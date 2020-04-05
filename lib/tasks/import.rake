require 'csv'
desc "Import data from jsom files"
task :import => [:environment] do

  Category.destroy_all
  Activity.destroy_all

  categories = "db/CategoriesSeedDataTreatYoSelf.csv"
  activites = 'db/ActivitiesSeedDataTreatYoSelf.csv'

  CSV.foreach(categories, headers: true) do |row|
    Category.create( name: row['Type']  )
  end

  CSV.foreach(activites, headers: true) do |row|
    category = Category.where(name: row['Type'])
    activity = Activity.create(name: row['Title'], est_time: row['Time Requirement'])
    activity.categories << category
  end
end
