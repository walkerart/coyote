# == Schema Information
#
# Table name: representations
#
#  id           :bigint(8)        not null, primary key
#  resource_id  :bigint(8)        not null
#  text         :text
#  content_uri  :string
#  status       :enum             default("ready_to_review"), not null
#  metum_id     :bigint(8)        not null
#  author_id    :bigint(8)        not null
#  content_type :string           default("text/plain"), not null
#  language     :string           not null
#  license_id   :bigint(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  notes        :text
#  endpoint_id  :bigint(8)        not null
#  ordinality   :integer
#
# Indexes
#
#  index_representations_on_author_id    (author_id)
#  index_representations_on_endpoint_id  (endpoint_id)
#  index_representations_on_license_id   (license_id)
#  index_representations_on_metum_id     (metum_id)
#  index_representations_on_resource_id  (resource_id)
#  index_representations_on_status       (status)
#

FactoryBot.define do
  factory :representation do
    text { <<~TEXT }
      This painted portrait depicts a young woman with jet-black skin holding a long, thin paintbrush up to a colorful, messy painter’s
      palette. She is shown in a three-quarter pose, gazing directly at the viewer. Her face, which is central to the square composition,
      stands out against a large, white, canvas, almost blending into the pitch-black background to her right. Closer inspection reveals,
      however, that her skin is subtly rendered, with various shades of contours and highlights. She wears two large hoop earrings, three
      small hoop earrings, and an oversized, boxy, high-collared jacket made of stiff fabric. Her voluminous hair—black with an ochre
      sheen—rises in thick coils on top of her head. The canvas to her left shows a partly finished paint-by-number self-portrait; in it,
      her likeness is broken up into smaller segments with pale-blue outlines and numbers. She has outlined many of the segments and filled
      them in with colors from her palette: orange, blue, yellow, pink, brown, and a few shades of green. The paint-by-number canvas does
      not accurately represent the color and pattern of the jacket she wears, which features mustard yellow sleeves and collar and deep
      blue and maroon and light yellow stripes.
    TEXT

    language { 'en' }

    trait :audio do
      content_type { 'audio/mp3' }
      content_uri { 'http://cdn.example.com/speech.mp3' }
    end

    trait :ready_to_review do
      status { :ready_to_review }
    end

    trait :approved do
      status { :approved }
    end

    trait :not_approved do
      status { :not_approved }
    end

    transient do
      resource { nil }
      metum { nil }
      author { nil }
      license { nil }
      endpoint { nil }
      organization { build(:organization) }
    end

    before(:create) do |representation, evaluator|
      representation.resource  = evaluator.resource     || build(:resource, organization: evaluator.organization)
      representation.metum     = evaluator.metum        || build(:metum, organization: evaluator.organization)
      representation.author    = evaluator.author       || build(:user, organization: evaluator.organization)
      representation.license   = evaluator.license      || build(:license)
      representation.endpoint  = evaluator.endpoint     || build(:endpoint)
    end
  end
end
