namespace :db do
  desc 'Reset the database state and seed'
  task recreate: %i[environment drop create migrate seed]
end
