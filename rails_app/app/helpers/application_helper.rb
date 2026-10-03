module ApplicationHelper
  SEARCH_PARAMS = %w[title_has genre_is composer_has lyricist_has year_min year_max translation_num language_is translator_is].freeze

  # The sidebar only varies with the search form values
  def sidebar_cache_key
    [ "sidebar", request.query_parameters.slice(*SEARCH_PARAMS).sort ]
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def display_count(model_class, resultsCount)
  	content_for(:display_count) { "Displaying #{resultsCount} / #{model_class.count.nil? ? 0 : model_class.count}" }
  end
end
