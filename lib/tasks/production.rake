namespace :production do
  desc "Import users"
  task import_users: :environment do
    filename = ENV['FILENAME']

    users = nil

    begin
      users = YAML.load_file filename
    rescue Errno::ENOENT => e
      puts "File not found! - #{filename}"
    end

    users.each do |user|
      puts "Processing user '#{user['first_name']} #{user['last_name']}'"

      begin
        check_duplicate = User.where(first_name: user['first_name'],
                                     last_name: user['last_name'],
                                     birth: Date.parse(user['birth']),
                                    )

        if check_duplicate.count > 1
          puts "User #{user['first_name']} #{user['last_name']} already exists"
        end

        u = User.new
        u.first_name = user['first_name']
        u.last_name = user['last_name']
        u.username = "#{u.first_name}_#{u.last_name}"
        u.email = "#{u.first_name.split(" ").join("_")}.#{u.last_name.split(" ").join("_")}@dr-brey.de"
        u.birth = Date.parse user['birth']
        u.password = Devise.friendly_token.first(8)
        u.password_confirmation = u.password
        u.role = Role.find_by_name 'user'

        u.save!
      rescue Date::Error => e
        puts "User '#{u.full_name}' has wrong birthdate: #{user['birth']}"
      rescue ActiveRecord::RecordInvalid => e
        puts "Invalid: #{user} - #{e}"
      end
    end
  end

  desc "Add admin user"
  task add_admin_user: :environment do
    admin_pw = ENV['PASSWORD']

    User.create! first_name: 'Admin', last_name: 'User', birth: Date.today,
                 username: 'admin', role: Role.find_by_name('admin'),
                 password: admin_pw, password_confirmation: admin_pw,
                 email: "admin@localhost.de"
  end
end
