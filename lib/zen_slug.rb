require "zen_slug/version"

module ZenSlug
  module Overrides
    def normalize_friendly_id(input)
      output=input.to_s.to_slug.normalize(transliterations: :russian).to_s
      #if output =~ /\A\d/
      #  "-#{output}"
      #end
    end
    def should_generate_new_friendly_id?
      slug.blank?
    end
  end

  extend ActiveSupport::Concern
  module ClassMethods
    def has_a_slug_from(attribute_name)
      include FriendlyId
      friendly_id attribute_name.to_sym, :use=>:slugged
      validates :slug, :presence => true, :uniqueness => true
      #, :format => {:with => /\A[^0-9].*/}
      class_eval <<-EOV
        include SlugableMixin::Overrides
      EOV
    end
  end
end
