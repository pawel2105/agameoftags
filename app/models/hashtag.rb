# == Schema Information
#
# Table name: hashtags
#
#  id                   :integer          not null, primary key
#  image_id             :integer
#  label                :string
#  raw_related_hashtags :text             default("{}"), is an Array
#  related_hashtags     :text             default("{}"), is an Array
#  related_hashtag_ids  :text             default("{}"), is an Array
#  total_count_on_ig    :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Hashtag < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :image
  has_many :timeslots

  after_create :add_timeslots

  def self.update_or_create name, count
    if existing = self.where(label: name).first
      existing.update(total_count_on_ig: count)
    else
      create(label: name, total_count_on_ig: count)
    end
  end

  def establish_hashtag_mix tag, object
    tag_in_question       = Hashtag.where(label: tag).first
    current_related_tags  = tag_in_question.related_hashtags
    possibly_related_tags = object[:tags]
    [current_related_tags,possibly_related_tags].flatten.uniq.compact
  end

  def self.update_siblings tag, object
    tags         = establish_hashtag_mix(tag, object)
    best_related = Hashtag.where(label: tags).sort_by(&:total_count_on_ig).first(50)
    best_labels  = best_related.map(&:label)
    best_ids     = best_related.map(&:id)
    tag_in_question.update(related_hashtags: best_labels, raw_related_hashtags: best_labels, related_hashtag_ids: best_ids)
  end

  private

  def add_timeslots
    TIMESLOT_LABELS.each { |slot| self.timeslots.create(slot_name: slot) }
  end
end

# Hashtag.import
# @articles = Hashtag.search('foobar').records