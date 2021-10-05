# frozen_string_literal: true

module PostsHelper
  def tag_list(post)
    post.tags.pluck(:name).join(', ')
  end
end
