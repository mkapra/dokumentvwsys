desc "Drop, create, migrate Database and load fixtures"

task :setupdb do
  Rake::Task["db:drop"].execute
  Rake::Task["db:create"].execute
  Rake::Task["db:migrate"].execute
  # We need this twice that also the documents get loaded correctly
  Rake::Task["db:fixtures:load"].execute
  Rake::Task["db:fixtures:load"].execute
  Rake::Task["db:seed"].execute
end