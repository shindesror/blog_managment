# frozen_string_literal: true

class Post < ApplicationRecord
  include AlgoliaSearch

  MAIN_IMAGE_WIDTH = 1000
  MAIN_IMAGE_HEIGHT = 1500

  algoliasearch per_environment: true, if: :indexable? do
    attributes :title, :tags

    searchableAttributes %w[title tags]
  end

  acts_as_taggable_on :tags

  enum status: %i[draft published], _default: 'draft'

  belongs_to :user
  has_rich_text :description
  has_one_attached :main_image

  validates :title, :description, presence: true
  validates :main_image, content_type: %w[image/png image/jpg image/jpeg],
                         dimension: { width: MAIN_IMAGE_WIDTH, height: MAIN_IMAGE_HEIGHT }

  before_update :write_published_at, if: :will_save_change_to_status?

  scope :own_posts, ->(user) { where(user_id: user.id) }

  def self.algolia_search(query)
    where(id: search(query).pluck(:id))
  end

  private

  def write_published_at
    return if status_in_database.eql?('published')

    self.published_at = Time.now
  end

  def indexable?
    published_at.present?
  end
end
