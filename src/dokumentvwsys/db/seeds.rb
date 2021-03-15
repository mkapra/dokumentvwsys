PROGRAM_TITLE = 'dokumentvwsys'

# Add preferences
title = Preference.new(key: 'title', value: PROGRAM_TITLE, description: 'preferences.description.title', group: 'basic')
title.save
