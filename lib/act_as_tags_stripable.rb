module ActAsTagsStripable
  extend ActiveSupport::Concern
  module ClassMethods
    def act_as_tags_stripable options = {}
      include ActionView::Helpers::SanitizeHelper
      
      class << self; attr_reader :tag_strip_columns end
      @tag_strip_columns = options[:columns] || []
      
      before_save :strip_tags_from_columns
    end
  end
  module InstanceMethods
    def strip_tags_from_columns
      attributes = {}
      self.class.tag_strip_columns.each do |column|
        attributes[column.to_s] = sanitize(self.attributes[column.to_s],:tags=>[])
      end
      self.attributes = attributes
    end
  end
end