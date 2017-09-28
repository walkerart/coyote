# == Schema Information
#
# Table name: representations
#
#  id           :integer          not null, primary key
#  resource_id  :integer          not null
#  text         :text
#  content_uri  :string
#  status       :enum             default("ready_to_review"), not null
#  metum_id     :integer          not null
#  author_id    :integer          not null
#  content_type :string           default("text/plain"), not null
#  language     :string           not null
#  license_id   :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_representations_on_author_id    (author_id)
#  index_representations_on_license_id   (license_id)
#  index_representations_on_metum_id     (metum_id)
#  index_representations_on_resource_id  (resource_id)
#  index_representations_on_status       (status)
#

class Representation < ApplicationRecord
  belongs_to :resource,     :inverse_of => :representations
  belongs_to :metum,        :inverse_of => :representations
  belongs_to :author,       :inverse_of => :representations, :class_name => :User
  belongs_to :license,      :inverse_of => :representations

  has_one :organization, :through => :resource
  
  validates :language, presence: true
  validate :must_have_text_or_content_uri

  delegate :title, :to => :resource, :prefix => true
  delegate :title, :to => :metum,    :prefix => true
  delegate :title, :to => :license,  :prefix => true

  private

  def must_have_text_or_content_uri
    if text.blank? && content_uri.blank? 
      errors.add(:base,:text_and_content_uri_blank,message: 'either text or content URI must be present')
    end
  end
end