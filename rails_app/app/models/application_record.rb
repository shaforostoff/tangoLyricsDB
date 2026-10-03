class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Cached fragments (the sidebar) show counts and latest entries; drop them on any change.
  after_commit { Rails.cache.clear }
end
