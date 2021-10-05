# frozen_string_literal: true

class PostsController < ApplicationController
  expose :posts, lambda {
                   all_posts.includes(:user, :tags, :rich_text_description)
                            .paginate(page: params[:page], per_page: 12)
                 }
  expose :post

  before_action :authenticate_user!, except: %i[index show]
  before_action only: %i[edit update destroy] do
    authorize post
  end

  def create
    post.user = current_user
    if post.save
      redirect_to posts_path(own_posts: true), notice: t('.new_post_created')
    else
      render :new
    end
  end

  def destroy
    post.destroy
    redirect_to posts_path(own_posts: true), notice: t('.deleted_successfully')
  end

  def update
    if post.update(post_params)
      redirect_to post_path(post.id), notice: t('.post_updated')
    else
      render :edit
    end
  end

  def show
    @post = Post.find_by(id: params[:id])

    redirect_to root_path, alert: t('.not_found') unless @post
  end

  def publish
    if post.draft? && post.published!
      redirect_to post_path(post.id), notice: t('.post_published_successfully')
    else
      flash.now[:alert] = t('.already published')
      render :edit
    end
  end

  def delete_main_image_attachment
    image = ActiveStorage::Attachment.find_by(id: params[:id])
    image&.purge
    redirect_back fallback_location: request.referer, alert: t('.image_deleted_successfully')
  end

  private

  def all_posts
    return Post.algolia_search(params[:query]) if params[:query]

    params[:own_posts] ? current_user.posts : Post.published
  end

  def post_params
    params.require(:post)
          .permit(:title, :description, :main_image, :remove_main_image, :tag_list)
  end
end
