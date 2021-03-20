PROGRAM_TITLE = 'dokumentvwsys'

# Add preferences
Preference.create(key: 'title', value: PROGRAM_TITLE, description: 'preferences.description.title', group: 'basic')

Role.create(name: 'admin')
Role.create(name: 'uploader')
Role.create(name: 'user')
