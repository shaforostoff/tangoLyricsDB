class Song < ActiveRecord::Base
  has_many :translations, dependent: :destroy
  
  default_scope { order('title') }
  
  validates :title,
  presence: true,
  uniqueness: { case_sensitive: false },
  length: { minimum: 4 }
    
  validates :year,
  numericality: {only_integer: true, greater_than_or_equal_to: 1866, less_than_or_equal_to: 2014}
    
  validates :composer,
  presence: true,
  length: { minimum: 4 }
      
  validates :lyricist,
  presence: true,
  length: { minimum: 4 }
    
  before_validation :normalise_title, on: [ :create, :update ]
    
  protected
  def normalise_title
    self.title = self.title.downcase.titleize
  end
  
end
