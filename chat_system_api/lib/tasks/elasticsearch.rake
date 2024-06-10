namespace :elasticsearch do
    desc "Create Elasticsearch index for Message model"
    task create_index: :environment do
      Message.__elasticsearch__.create_index!(force: true)
      puts "Elasticsearch index for Message model created successfully."
    end
  
    desc "Import data into Elasticsearch index for Message model"
    task import: :environment do
      Message.import(force: true)
      puts "Data imported into Elasticsearch index for Message model successfully."
    end
end
  