PROGRAM_TITLE = 'dokumentvwsys'

FOOTER_DEFAULT_TEXT = <<~EOF
  dokumentvwsys ist ein System zur Bereitstellung von Dokumenten.
EOF

# Add preferences
Preference.create(key: 'title', value: PROGRAM_TITLE, group: 'basic')
Preference.create(key: 'url', value: '', group: 'basic')
Preference.create(key: 'image', is_file: true, group: 'basic') # TODO: Add default image #7
Preference.create(key: 'footer', textarea: FOOTER_DEFAULT_TEXT, is_textarea: true, group: 'appearance')
Preference.create(key: 'imprint', value: 'Test Imprint', is_textarea: true, group: 'legal')
Preference.create(key: 'privacy_policy', value: 'Test Privacy Policy', is_textarea: true, group: 'legal')

Role.create(name: 'admin')
Role.create(name: 'uploader')
Role.create(name: 'user')
