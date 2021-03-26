PROGRAM_TITLE = 'dokumentvwsys'

# Add preferences
Preference.create(key: 'title', value: PROGRAM_TITLE, group: 'basic')
Preference.create(key: 'url', value: '', group: 'basic')
Preference.create(key: 'image', is_file: true, group: 'basic') # TODO: Add default image #7

Role.create(name: 'admin')
Role.create(name: 'uploader')
Role.create(name: 'user')
