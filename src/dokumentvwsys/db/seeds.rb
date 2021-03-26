PROGRAM_TITLE = 'dokumentvwsys'

FOOTER_DEFAULT_TEXT = <<~EOF
  dokumentvwsys ist ein System zur Bereitstellung von Dokumenten.
EOF

# Add preferences
Preference.create(key: 'title', value: PROGRAM_TITLE, group: 'basic')
Preference.create(key: 'image', is_file: true, group: 'basic') # TODO: Add default image #7
Preference.create(key: 'footer', textarea: FOOTER_DEFAULT_TEXT, is_textarea: true, group: 'appearance')

Role.create(name: 'admin')
Role.create(name: 'uploader')
Role.create(name: 'user')
