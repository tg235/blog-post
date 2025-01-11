require 'rails_helper'

RSpec.describe BlogPostsController, type: :controller do
  let(:user) { create(:user) }
  let(:blog_post) { create(:blog_post, user: user) }
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end


  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it "creates a new blog post" do
        expect {
          post :create, params: { blog_post: attributes_for(:blog_post) }
        }.to change(BlogPost, :count).by(1)
      end

      it "redirects to blog_posts_path with success message" do
        post :create, params: { blog_post: attributes_for(:blog_post) }
        expect(flash[:notice]).to eq("Post created successfully")
      end
    end

    context "with invalid parameters" do
      it "renders the new template with unprocessable entity status" do
        post :create, params: { blog_post: { title: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: blog_post.id }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it "updates the blog post" do
        patch :update, params: { id: blog_post.id, blog_post: { title: "New Title" } }
        blog_post.reload
        expect(blog_post.title).to eq("New Title")
      end
    end
  end

  describe "DELETE #destroy" do
    context "with current user" do
      before { allow(controller).to receive(:current_user).and_return(user) }
      it "deletes the blog post" do
        delete :destroy, params: { id: blog_post.id }
        expect(BlogPost.exists?(blog_post.id)).to be_falsy
      end
    end

    context "if not current user" do
      it "redirects to blog_posts_path with success message" do
        delete :destroy, params: { id: blog_post.id }
        expect(response).to redirect_to(blog_posts_path)
      end
    end
  end
end
