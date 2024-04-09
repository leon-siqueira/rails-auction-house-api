# frozen_string_literal: true

task annotate: :environment do
  puts 'Annotating models...'
  system 'bundle exec annotate --models'
end

Rake::Task['db:migrate'].enhance do
  Rake::Task['annotate'].invoke
end

Rake::Task['db:rollback'].enhance do
  Rake::Task['annotate'].invoke
end
