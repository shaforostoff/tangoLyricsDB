require "test_helper"

class PublicPagesTest < ActionDispatch::IntegrationTest
  test "lists songs on the home page" do
    get root_path
    assert_response :success
    assert_select "td a", songs(:one).reload.title
  end

  test "filters songs" do
    get songs_path, params: { composer_has: "arienzo", genre_is: genres(:one).id, page: 1 }
    assert_response :success
    assert_select "tbody tr", 1
  end

  test "filters songs by language and translator" do
    get songs_path, params: { language_is: languages(:one).id, translator_is: translators(:two).id }
    assert_response :success
  end

  test "shows a song with its translations" do
    get song_path(songs(:one))
    assert_response :success
    assert_select "h2", "Translations"
  end

  test "lists translations filtered by language" do
    get translations_path, params: { language_is: languages(:two).id }
    assert_response :success
    assert_select "tbody tr", 1
  end

  test "shows the reference lists and info pages" do
    [ genres_path, languages_path, translators_path, about_path, usage_path, stats_path,
      genre_path(genres(:one)), language_path(languages(:one)), translator_path(translators(:one)),
      song_translation_path(songs(:one), translations(:one)), new_user_session_path, rails_health_check_path ].each do |path|
      get path
      assert_response :success, path
    end
  end

  test "serves JSON" do
    get songs_path(format: :json)
    assert_response :success
    get translators_path(format: :json)
    assert_equal translators(:one).site_name, response.parsed_body.first["site_name"]
  end

  test "anyone can add a translation" do
    assert_difference("Translation.count") do
      post song_translations_path(songs(:one)), params: { translation: { link: "http://someblog.com/a-new-translation.html", language_id: languages(:one).id } }
    end
    assert_redirected_to song_path(songs(:one))
  end

  test "editing requires signing in" do
    get new_song_path
    assert_redirected_to new_user_session_path
    get inactive_translations_path
    assert_redirected_to new_user_session_path
    delete song_path(songs(:one))
    assert_redirected_to new_user_session_path
    assert Song.exists?(songs(:one).id)
  end
end
