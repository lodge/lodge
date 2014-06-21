require 'test_helper'

class UpdateHistoriesControllerTest < ActionController::TestCase
  setup do
    @update_history = update_histories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:update_histories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create update_history" do
    assert_difference('UpdateHistory.count') do
      post :create, update_history: { article_id: @update_history.article_id, new_body: @update_history.new_body, new_tags: @update_history.new_tags, new_title: @update_history.new_title, old_body: @update_history.old_body, old_tags: @update_history.old_tags, old_title: @update_history.old_title }
    end

    assert_redirected_to update_history_path(assigns(:update_history))
  end

  test "should show update_history" do
    get :show, id: @update_history
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @update_history
    assert_response :success
  end

  test "should update update_history" do
    patch :update, id: @update_history, update_history: { article_id: @update_history.article_id, new_body: @update_history.new_body, new_tags: @update_history.new_tags, new_title: @update_history.new_title, old_body: @update_history.old_body, old_tags: @update_history.old_tags, old_title: @update_history.old_title }
    assert_redirected_to update_history_path(assigns(:update_history))
  end

  test "should destroy update_history" do
    assert_difference('UpdateHistory.count', -1) do
      delete :destroy, id: @update_history
    end

    assert_redirected_to update_histories_path
  end
end
