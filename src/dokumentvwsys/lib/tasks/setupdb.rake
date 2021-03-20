desc "Drop, create, migrate Database and load fixtures"

task :setupdb do
  Rake::Task["db:drop"].execute
  Rake::Task["db:create"].execute
  Rake::Task["db:migrate"].execute
  Rake::Task["db:fixtures:load"].execute
end
