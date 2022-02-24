namespace :dev do
  DEFAULT_PASSWORD = 123_456

  desc 'Configura o ambiente de desenvolvimento'
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Dropping BD...') { `rails db:drop` }
      show_spinner('Creating BD...') { `rails db:create` }
      show_spinner('Migrating BD...') { `rails db:migrate` }
      show_spinner('Add default admin...') { `rails dev:add_default_admin` }
      show_spinner('Add extra admins...') { `rails dev:add_extra_admin` }
      show_spinner('Add default user...') { `rails dev:add_default_user` }
    else
      puts 'Você não está em ambiente de desenvolvimento!'
    end
  end

  desc 'Add default admin'
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc 'Add extra admins'
  task add_extra_admin: :environment do
    10.times do
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc 'Add default user'
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private

  def show_spinner(msg_start, msg_end = 'Concluído!')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
