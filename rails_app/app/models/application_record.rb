class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # The cached sidebar shows counts and latest entries; drop it on any change.
  # (Only the sidebar: the same cache also holds the rate-limit counters.)
  after_commit { Rails.cache.delete_matched(/sidebar/) }
end
