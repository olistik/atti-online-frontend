configure :development do
  activate :livereload
end

configure :build do
  activate :minify_css
  activate :minify_javascript
end

activate :directory_indexes

ignore "/templates/*"

module CustomHelpers
  def slugify(s)
    "/" + s.strip.downcase.gsub(/\s/, "-")
  end
end

module ConfigHelpers
  extend CustomHelpers
end

helpers do
  include CustomHelpers
end

data.database.each do |section, years|
  slug_section = ConfigHelpers.slugify(section)
  proxy "#{slug_section}", "/templates/section.html", locals: {section: section, years: years}, layout: "layout"
  years.each do |year, records|
    proxy "#{slug_section}/#{year}", "/templates/year.html", locals: {section: section, year: year, records: records}, layout: "layout"
    records.each do |number, record|
      proxy "#{slug_section}/#{year}/#{number}", "/templates/record.html", locals: {section: section, year: year, record: record}, layout: "layout"
    end
  end
end
