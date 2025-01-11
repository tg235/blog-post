require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:blog_post) { create(:blog_post, user: user) }
  let(:comment) { create(:comment, blog_post: blog_post, user: user) }
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new, params: { blog_post_id: blog_post.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it "creates a new comment" do
        expect {
          post :create, params: { blog_post_id: blog_post.id, comment: attributes_for(:comment) }
        }.to change(Comment, :count).by(1)
      end

      it "redirects to blog_post_path with success message" do
        post :create, params: { blog_post_id: blog_post.id, comment: attributes_for(:comment) }
        expect(response).to redirect_to(blog_post_path(blog_post))
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { blog_post_id: blog_post.id, id: comment.id }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the comment" do
        patch :update, params: { blog_post_id: blog_post.id, id: comment.id, comment: { content: "New Content" } }
        comment.reload
        expect(comment.content).to eq("New Content")
      end

      it "redirects to the blog post's page with success message" do
        patch :update, params: { blog_post_id: blog_post.id, id: comment.id, comment: { content: "New Content" } }
        expect(response).to redirect_to(blog_post_path(blog_post))
        expect(flash[:notice]).to eq("Comment updated successfully")
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the comment" do
      delete :destroy, params: { blog_post_id: blog_post.id, id: comment.id }
      expect(Comment.exists?(comment.id)).to be_falsy
    end

    it "redirects to blog_post_path with success message" do
      delete :destroy, params: { blog_post_id: blog_post.id, id: comment.id }
      expect(flash[:notice]).to eq("Comment deleted")
    end
  end
end
