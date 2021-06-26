PROGRAM_TITLE = 'dokumentvwsys'

FOOTER_DEFAULT_TEXT = <<~EOF
  dokumentvwsys ist ein System zur Bereitstellung von Dokumenten.
EOF

class Addpreferences < ActiveRecord::Migration[6.1]
  def change
    change_column :preferences, :value, :string, null: true

    unless Preference.find_by_key 'title'
      Preference.create! key: 'title', value: PROGRAM_TITLE, group: 'basic'
    end

    unless Preference.find_by_key 'url'
      Preference.create! key: 'url', value: '', group: 'basic'
    end

    unless Preference.find_by_key 'image'
      Preference.create! key: 'image', is_file: true, group: 'appearance'
    end

    unless Preference.find_by_key 'footer'
      Preference.create! key: 'footer', value: FOOTER_DEFAULT_TEXT,
                         is_textarea: true, group: 'appearance'
    end

    unless Preference.find_by_key 'message'
      Preference.create! key: 'message', value: 'test', is_textarea: true,
                         group: 'appearance'
    end

    unless Preference.find_by_key 'imprint'
      Preference.create! key: 'imprint', value: 'Test Imprint',
                         is_textarea: true, group: 'legal'
    end

    unless Preference.find_by_key 'privacy_policy'
      Preference.create! key: 'privacy_policy', value: 'Test Privacy Policy',
                         is_textarea: true, group: 'legal'
    end

    unless Role.find_by_name 'admin'
      Role.create! name: 'admin'
    end

    unless Role.find_by_name 'uploader'
      Role.create! name: 'uploader'
    end

    unless Role.find_by_name 'user'
      Role.create! name: 'user'
    end
  end
end
