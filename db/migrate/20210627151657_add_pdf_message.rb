MESSAGE = """
Dies sind die Zugangsdaten, um die für Sie zur Verfügung gestellten
Dokumente abrufen zu können.
""".chomp.strip

class AddPdfMessage < ActiveRecord::Migration[6.1]
  def change
    unless Preference.find_by_key 'pdf_message'
      Preference.create! key: 'pdf_message', value: MESSAGE, group: 'appearance',
                         is_textarea: true
    end
  end
end
