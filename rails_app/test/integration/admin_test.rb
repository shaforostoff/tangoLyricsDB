require "test_helper"

class AdminTest < ActionDispatch::IntegrationTest
  setup { sign_in users(:one) }

  test "creates, updates and destroys a song" do
    get new_song_path
    assert_response :success

    assert_difference("Song.count") do
      post songs_path, params: { song: { title: "song title", genre_id: genres(:one).id, year: 1927, composer: "song composer", lyricist: "song lyricist" } }
    end
    song = Song.unscoped.order(:id).last
    assert_redirected_to song_path(song)

    patch song_path(song), params: { song: { year: 1930 } }
    assert_redirected_to song_path(song)
    assert_equal 1930, song.reload.year

    assert_difference("Song.count", -1) { delete song_path(song) }
    assert_redirected_to songs_path
  end

  test "re-renders the form with errors" do
    post songs_path, params: { song: { title: "" } }
    assert_response :unprocessable_content
    assert_select ".alert-danger"
  end

  test "manages genres, languages and translators" do
    post genres_path, params: { genre: { name: "candombe" } }
    assert_redirected_to genre_path(Genre.find_by!(name: "Candombe"))
    post languages_path, params: { language: { name: "german", iso: "de" } }
    assert_redirected_to language_path(Language.find_by!(iso: "de"))
    post translators_path, params: { translator: { name: "Some Translator", site_name: "Some Site", site_link: "http://some-site.example.com/" } }
    assert_redirected_to translator_path(Translator.find_by!(site_link: "http://some-site.example.com/"))

    get edit_genre_path(genres(:one))
    assert_response :success
    patch genre_path(genres(:one)), params: { genre: { name: "" } }
    assert_response :unprocessable_content
  end

  test "edits, rechecks and destroys a translation" do
    translation = translations(:one)
    song = translation.song
    get edit_song_translation_path(song, translation)
    assert_response :success

    put check_link_song_translation_path(song, translation), headers: { "HTTP_REFERER" => song_url(song) }
    assert_redirected_to song_url(song)

    assert_difference("Translation.count", -1) { delete song_translation_path(song, translation) }
    assert_redirected_to song_path(song)
  end

  test "lists inactive translations" do
    translations(:one).update_column(:active, false)
    get inactive_translations_path
    assert_response :success
    assert_select "tbody tr", 1
  end

  test "signs out" do
    delete destroy_user_session_path
    get new_song_path
    assert_redirected_to new_user_session_path
  end
end
